import 'dart:io';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gl/flutter_gl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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

import 'package:share_plus/share_plus.dart';
//import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
//import 'package:share/share.dart';
import 'package:native_screenshot/native_screenshot.dart';
//import 'package:screenshot_share_image/screenshot_share_image.dart';

import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

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
  late three.Vector2 pointerDown = three.Vector2();
  late three.Vector2 pointerMove = three.Vector2();

  Size? screenSize;

  late three.BoxGeometry geometry;
  late three.MeshLambertMaterial material;
  late three.Mesh cube;

  late bool loaded = false;
  late bool disposed = false;
  String? labelMolecule;
  dynamic sourceTexture;
  dynamic mesh;
  dynamic targetRotationX = 0.0;
  dynamic targetRotationY = 0.0;
  dynamic targetRotationOnPointerDownX = 0.0;
  dynamic targetRotationOnPointerDownY = 0.0;
  //thomas
  BottomDrawerController bottomController = BottomDrawerController();
  late Uint8List _imageFile;
  GlobalKey globalKey = GlobalKey();

  Future<void> initPlatformState() async {
    width = screenSize!.width;
    height = screenSize!.height - 76; // safe area

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
    if (renderer == null) initPlatformState();
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
    var ambientLight = three.AmbientLight(0xcccccc, 0.4);
    scene.add(ambientLight);
    var light = three.DirectionalLight(0xffffff, null);
    light.position.set(4, 4, 1);
    light.castShadow = true;
    light.shadow!.camera!.zoom = 1; // tighter shadow map
    scene.add(light);
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
      print("animation stopped");
      return;
    }

    if (!loaded) {
      return;
    }

    molecule.rotation.y += (targetRotationX - molecule.rotation.y) * 0.05;
    molecule.rotation.x += (targetRotationY - molecule.rotation.x) * 0.05;
    // molecule.rotation.x += 0.01;
    // molecule.rotation.y += 0.01;
    render();
    Future.delayed(const Duration(milliseconds: 16), () {
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

  _rotateMolecule(PointerEvent details) async {
    pointerMove.x = details.position.dx - width / 2;
    pointerMove.y = details.position.dy - height / 2;
    targetRotationX =
        targetRotationOnPointerDownX + (pointerMove.x - pointerDown.x) * 0.02;
    targetRotationY =
        targetRotationOnPointerDownY + (pointerMove.y - pointerDown.y) * 0.02;
  }

  _getLocations(PointerEvent details) async {
    print("getLocationCalled");
    pointerDown.x = details.position.dx - width / 2;
    pointerDown.y = details.position.dy - height / 2;
    targetRotationOnPointerDownX = targetRotationX;
    targetRotationOnPointerDownY = targetRotationY;

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
        setState(() {
          labelMolecule = getAtomNameFromColor(
              intersects[i].object.material.color.getHex());
        });
      }
    }
  }

  // Future<String> saveImage(Uint8List bytes) async {
  //   await [Permission.storage].request();
  //   final result = await ImageGallerySaver.saveImage(bytes);
  //   return result['filePath'];
  // }

  // Future<void> _capturePng() {
  //   return Future.delayed(const Duration(milliseconds: 2000), () async {
  //     RenderRepaintBoundary? boundary = globalKey.currentContext
  //         ?.findRenderObject() as RenderRepaintBoundary?;
  //     ui.Image image = await boundary!.toImage();
  //     ByteData? byteData =
  //         await image.toByteData(format: ui.ImageByteFormat.png);
  //     Uint8List pngBytes = byteData!.buffer.asUint8List();
  //     saveImage(pngBytes);
  //   });
  // }

  Widget _build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        color: Colors.blue,
        child: Container(child: Builder(
          builder: (BuildContext context) {
            print(three3dRender);
            return Listener(
                onPointerMove: _rotateMolecule,
                onPointerDown: _getLocations,
                child: three3dRender.isInitialized
                    ? Texture(textureId: three3dRender.textureId!)
                    : Container(color: Colors.yellow));
          },
        )));
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
        key: globalKey,
        child: Scaffold(
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
                ),
                 IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: () async {
                      await [Permission.manageExternalStorage].request();
                      await [Permission.storage].request();
                      var status = await Permission.manageExternalStorage.status;
                      var status1 = await Permission.storage.status;
                      String? path = await NativeScreenshot.takeScreenshot();
                      //show toast to notify screen succesfully
                    }),
                IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () async {
                      await [Permission.manageExternalStorage].request();
                      await [Permission.storage].request();
                      var status = await Permission.manageExternalStorage.status;
                      var status1 = await Permission.storage.status;
                      String? path = await NativeScreenshot.takeScreenshot();
                      if (path != null){
                        await Share.shareXFiles([XFile(path)], text: 'Great picture');
                        await File(path).delete();
                      }
                    }),
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
                                      child:
                                          Center(child: Text(baselist[index])),
                                    ));
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: baselist.length))),
                ],
              ),
            ),
            body: Builder(builder: (BuildContext context) {
              initSize(context);
              return Stack(
                children: [_build(context), buildBottomDrawer(context)],
              );
            })));
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
              children: [
                const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                ),
                const Text(
                  "Info",
                  style: TextStyle(color: Colors.white),
                ),
                const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                ),
                labelMolecule != null
                    ? Text(labelMolecule!)
                    : SizedBox.shrink(),
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
