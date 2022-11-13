import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gl/flutter_gl.dart';
import 'package:three_dart/three_dart.dart' as three;
import 'package:flutter/material.dart';

class HelloWorld extends StatefulWidget {
  const HelloWorld({super.key});

  @override
  State<HelloWorld> createState() => _HelloWorldState();
}

class _HelloWorldState extends State<HelloWorld> {
  late FlutterGlPlugin three3dRender;
  three.WebGLRenderer? renderer;
  late three.Scene scene;
  late three.PerspectiveCamera camera;
  late three.WebGLRenderTarget renderTarget;
  late three.Group objects;
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

    objects = three.Group();
    geometry = three.BoxGeometry(1, 1, 1);
    material = three.MeshBasicMaterial({"color": 0x000066});
    mesh = three.Mesh(geometry, material);
    // scene.add(mesh);

    var sphere = three.SphereGeometry(5);

    var couille = three.Mesh(sphere, material);
    couille.position.set(0, 0, 0);
    objects.add(couille);

    var couille2 = three.Mesh(sphere, material);
    couille2.position.set(10, 0, 0);
    objects.add(couille2);

    var curve = three.QuadraticBezierCurve(
      three.Vector2(
        -10.5,
        0,
      ),
      three.Vector2(
        0,
        15,
      ),
      three.Vector2(
        0,
        0,
      ),
    );
    var tube = three.CylinderGeometry(5, 5, 20);
    var phallus = three.Mesh(tube, material);
    phallus.position.set(5, -10, 0);
    objects.add(phallus);
    scene.add(objects);

    var gland = three.Mesh(sphere, material);
    gland.position.set(5, -20, 0);
    objects.add(gland);

    camera.lookAt(scene.position);
    camera.position.z = 50;
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

    objects.rotation.x += 0.02;
    objects.rotation.y += 0.02;

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
