import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gl/flutter_gl.dart';
import 'package:swifty_proteins/utils/draw_helper.dart';
import 'package:three_dart/three_dart.dart' as three;
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../model/atom.dart';

class HelloWorld extends StatefulWidget {
  final List<Atom> atomList;
  HelloWorld(this.atomList);

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
    DrawHelper().drawMolecule(widget.atomList, molecule);
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
          title: const Text('Hello world!'),
        ),
        body: Builder(builder: (BuildContext context) {
          initSize(context);
          return SingleChildScrollView(
            child: _build(context),
          );
        }));
  }
}
