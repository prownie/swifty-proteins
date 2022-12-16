import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gl/flutter_gl.dart';
import 'package:swifty_proteins/pages/homepage.dart';
import 'package:swifty_proteins/utils/draw_helper.dart';
import 'package:three_dart/three_dart.dart' as three;
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../model/atom.dart';
import '../style/style.dart' as s;
import '../model/base_list.dart';
import '../model/molecule.dart';
import 'package:bottom_drawer/bottom_drawer.dart';

import '../widget/moleculeCard.dart';

class HelloWorld extends StatefulWidget {
  HelloWorld(this.moleculeClass);
  final Molecule moleculeClass;

  @override
  State<HelloWorld> createState() => _HelloWorldState();
}

class _HelloWorldState extends State<HelloWorld> {
  late FlutterGlPlugin three3dRender;
  three.WebGLRenderer? renderer;
  late three.Scene scene;
  late three.PerspectiveCamera camera;
  late three.WebGLRenderTarget renderTarget;
  late three.Group molecule;
  three.Mesh? atomLabel;
  late double dpr = 1.0; //devicePixelRatio
  late double width;
  late double height;
  late three.Vector2 pointer = three.Vector2();

  Size? screenSize;

  late three.BoxGeometry geometry;
  late three.MeshBasicMaterial material;
  late three.Mesh cube;

  late bool loaded = false;
  late bool disposed = false;

  dynamic sourceTexture;
  dynamic mesh;

  //thomas
  BottomDrawerController bottomController = BottomDrawerController();

  Future<void> initPlatformState() async {
    width = screenSize!.width;
    height = screenSize!.height;

    camera = three.PerspectiveCamera(60, width / height, 0.1, 1000);
    three3dRender = FlutterGlPlugin();
    Map<String, dynamic> options = {
      "antialias": true,
      "alpha": false,
      "width": width.toInt(),
      "height": height.toInt(),
      "dpr": dpr
    };
    await three3dRender.initialize(options: options);

    setState(() {});

    Future.delayed(const Duration(milliseconds: 200), () async {
      await three3dRender.prepareContext();

      initScene();
    });
  }

  initSize(BuildContext context) {
    if (screenSize != null) {
      return;
    }

    final mqd = MediaQuery.of(context);
    screenSize = mqd.size;
    dpr = mqd.devicePixelRatio;

    initPlatformState();
  }

  initRenderer() {
    Map<String, dynamic> options = {
      "width": width,
      "height": height,
      "gl": three3dRender.gl,
      "antialias": true,
      "canvas": three3dRender.element
    };

    // print('initRenderer  dpr: $dpr _options: $options');

    renderer = three.WebGLRenderer(options);
    renderer!.setPixelRatio(dpr);
    renderer!.setSize(width, height, false);
    renderer!.shadowMap.enabled = false;

    if (!false) {
      var pars = three.WebGLRenderTargetOptions({"format": three.RGBAFormat});
      renderTarget = three.WebGLRenderTarget(
          (width * dpr).toInt(), (height * dpr).toInt(), pars);
      renderTarget.samples = 4;
      renderer!.setRenderTarget(renderTarget);

      sourceTexture = renderer!.getRenderTargetGLTexture(renderTarget);
    }
  }

  initImage() {
    scene = three.Scene();
    molecule = three.Group();
    List<Atom> atomList = [];
    // var ambientLight = three.AmbientLight(0xcccccc, 0.4);
    // scene.add(ambientLight);
    // var light = three.DirectionalLight(0xffffff, null);
    // light.position.set(4, 4, 1);
    // light.castShadow = true;
    // light.shadow!.camera!.zoom = 1; // tighter shadow map
    // scene.add(light);
    DrawHelper().drawMolecule(widget.moleculeClass.atomList, molecule);
    scene.add(molecule);

    camera.lookAt(scene.position);
    camera.position.z = 20;
    // mesh.rotation.x = 5;
    loaded = true;
    animate();
  }

  initScene() {
    initRenderer();
    initImage();
  }

  animate() {
    if (!mounted || disposed) {
      return;
    }

    if (!loaded) {
      return;
    }

    molecule.rotation.x += 0.01;
    molecule.rotation.y += 0.01;
    // moleculeLabels.forEach((label) {
    if (atomLabel != null) atomLabel!.lookAt(camera.position);
    // });
    render();
    Future.delayed(const Duration(milliseconds: 25), () {
      animate();
    });
  }

  render() {
    final gl = three3dRender.gl;
    renderer!.render(scene, camera);
    gl.finish();
    three3dRender.updateTexture(sourceTexture);
  }

  dispose() {
    disposed = true;
    super.dispose();
  }

  _getLocations(PointerEvent details) async {
    pointer.x = (details.position.dx / width) * 2 - 1;
    pointer.y = -((details.position.dy - 80) / height) * 2 + 1;
    print('width:${width}, height:${height}');
    print('x:${details.position.dx}, y: ${details.position.dy}');
    print('pointerx:${pointer.x}, y: ${pointer.y}');
    var raycaster = three.Raycaster();
    raycaster.setFromCamera(pointer, camera);

    // calculate objects intersecting the picking ray
    var intersects = raycaster.intersectObjects(scene.children, true);

    print('interscetlength: ${intersects.length}');
    for (var i = 0; i < intersects.length; i++) {
      if (intersects[i].object.geometry!.type == 'SphereGeometry') {
        if (atomLabel != null) {
          molecule.remove(atomLabel!);
          atomLabel!.dispose();
          atomLabel = null;
        }
        //print('hello${intersects[i].object.material.color.getHex()}');
        atomLabel = await DrawHelper().dispAtomName(
            intersects[i].object.position.x,
            intersects[i].object.position.y,
            intersects[i].object.position.z,
            getAtomNameFromColor(intersects[i].object.material.color.getHex()),
            molecule);
      }
    }
  }

  Widget _build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        color: Colors.red,
        child: Builder(
          builder: (BuildContext context) {
            print(three3dRender);
            return Listener(
                onPointerDown: _getLocations,
                child: three3dRender.isInitialized
                    ? Texture(textureId: three3dRender.textureId!)
                    : Container(color: Colors.yellow));
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(widget.moleculeClass.name),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_rounded),
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) =>
                      buildCard(context, widget.moleculeClass)),
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // exit drawer
                  Navigator.pop(context); // return to homepage
                },
                child: Container(
                    color: Colors.red,
                    height: 50,
                    child: const Center(child: Text("return"))),
              ),
              TextField(
                onSubmitted: (value) {
                  //---------------------------------------//
                  //
                  //
                  //    HERRRRRRRREEEEEEE utilise value
                  //
                  //
                  //---------------------------------------//
                },
                decoration: const InputDecoration(
                  hintText: "search another one",
                ),
              ),
              SizedBox(
                  height: 400,
                  width: 20,
                  child: Scrollbar(
                      child: ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                                onTap: () {
                                  print(baselist[index]);
                                  //---------------------------------------//
                                  //
                                  //
                                  //    HERRRRRRRREEEEEEE au bout mon petit
                                  //
                                  //
                                  //---------------------------------------//
                                },
                                child: SizedBox(
                                  height: 30,
                                  child: Center(child: Text(baselist[index])),
                                ));
                          },
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: baselist.length))),
            ],
          ),
        ),
        body: Builder(builder: (BuildContext context) {
          initSize(context);
          return Stack(
            children: [
              SingleChildScrollView(
                child: _build(context),
              ),
              buildBottomDrawer(context)
            ],
          );
        }));
  }

  Widget buildBottomDrawer(BuildContext context) {
    return BottomDrawer(
      //followTheBody: false,
      /// your customized drawer header.
      header: GestureDetector(
          onTap: () => (bottomController.open()),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                ),
                Text(
                  "Info",
                  style: TextStyle(color: Colors.white),
                ),
                Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                )
              ],
            ),
          )),

      /// your customized drawer body.
      body: GestureDetector(
        onTap: () => (bottomController.close()),
        child: Container(
          width: 300,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text("formula: ${widget.moleculeClass.formula}\n"),
              Text("name: ${widget.moleculeClass.name}\n"),
              Text("type: ${widget.moleculeClass.type}\n"),
              Text("letter code: ${widget.moleculeClass.letterCode}\n"),
              //Text(mol.weight),
            ],
          ),
        ),
      ),

      /// your customized drawer header height.
      headerHeight: 35.0,

      /// your customized drawer body height.
      drawerHeight: 180.0,

      /// drawer background color.
      color: Colors.black, //.shade800,

      /// drawer controller.
      controller: bottomController,
    );
  }
}
