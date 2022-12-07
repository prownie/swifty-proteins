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
  late List<three.Mesh> moleculeLabels;
  late double dpr = 1.0; //devicePixelRatio
  late double width;
  late double height;

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
    moleculeLabels = [];
    List<Atom> atomList = [];
    // Atom atom1 = Atom(0, 0, 0, 'CU', [1, 2]);
    // Atom atom2 = Atom(0, 0, -1.860, 'CL', [0]);
    // Atom atom3 = Atom(0, 0, 1.860, 'CL', [0]);
    // atomList.addAll([atom1, atom2, atom3]);
    // Atom atom1 = Atom(1.922, 0.004, -0.565, 'C', [1, 7, 8, 9]);
    // Atom atom2 = Atom(2.635, -0.003, 0.673, 'O', [0, 10]);
    // Atom atom3 = Atom(-0.240, 1.198, -0.159, 'C', [3, 7, 11]);
    // Atom atom4 = Atom(-1.600, 1.196, 0.092, 'C', [2, 4, 12]);
    // Atom atom5 = Atom(-2.278, -0.002, 0.217, 'C', [3, 5, 13]);
    // Atom atom6 = Atom(-1.597, -1.198, 0.090, 'C', [4, 6, 14]);
    // Atom atom7 = Atom(-0.237, -1.196, -0.161, 'C', [5, 7, 15]);
    // Atom atom8 = Atom(0.440, 0.002, -0.291, 'C', [0, 2, 6]);
    // Atom atom9 = Atom(2.185, 0.897, -1.131, 'H', [0]);
    // Atom atom10 = Atom(2.186, -0.883, -1.141, 'H', [0]);
    // Atom atom11 = Atom(3.597, -0.002, 0.573, 'H', [1]);
    // Atom atom12 = Atom(0.290, 2.134, -0.256, 'H', [2]);
    // Atom atom13 = Atom(-2.132, 2.131, 0.192, 'H', [3]);
    // Atom atom14 = Atom(-3.340, -0.003, 0.413, 'H', [4]);
    // Atom atom15 = Atom(-2.126, -2.134, 0.188, 'H', [5]);
    // Atom atom16 = Atom(0.295, -2.131, -0.260, 'H', [6]);
    // atomList.addAll([
    //   atom1,
    //   atom2,
    //   atom3,
    //   atom4,
    //   atom5,
    //   atom6,
    //   atom7,
    //   atom8,
    //   atom9,
    //   atom10,
    //   atom11,
    //   atom12,
    //   atom13,
    //   atom14,
    //   atom15,
    //   atom16
    // ]);
    var ambientLight = three.AmbientLight(0xcccccc, 0.4);
    scene.add(ambientLight);
    var light = three.DirectionalLight(0xffffff, null);
    light.position.set(4, 4, 1);
    light.castShadow = true;
    light.shadow!.camera!.zoom = 1; // tighter shadow map
    scene.add(light);
    DrawHelper().drawMolecule(widget.atomList, molecule, moleculeLabels);
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
    moleculeLabels.forEach((label) {
      label.lookAt(camera.position);
    });
    render();
    Future.delayed(const Duration(milliseconds: 10), () {
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

  Widget _build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        color: Colors.red,
        child: Builder(
          builder: (BuildContext context) {
            print(three3dRender);
            return three3dRender.isInitialized
                ? Texture(textureId: three3dRender.textureId!)
                : Container(color: Colors.yellow);
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
