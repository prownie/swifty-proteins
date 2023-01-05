import 'dart:math' as math;

import 'package:flutter/material.dart';

class PortalAnimator extends StatefulWidget {
  const PortalAnimator({super.key});
  @override
  _PortalAnimator createState() => _PortalAnimator();
}

class _PortalAnimator extends State<PortalAnimator>
    with TickerProviderStateMixin {
 
 
 late final AnimationController _controller = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();


  @override
  dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150.0,
        width: 150.0,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * math.pi,
              child: child,
            );
          },
          child: const Image(
                      image: AssetImage('assets/portal.png'), width: 150,height: 150),
        ),
    );
  }
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
  // late AnimationController animationController;

  // @override
  // void initState() {
  //   super.initState();
  //   animationController = AnimationController(
  //     vsync: this,
  //     duration: const Duration(milliseconds: 5000),
  //   );
  //   animationController.forward();
  //   animationController.addListener(() {
  //     setState(() {
  //       if (animationController.status == AnimationStatus.completed) {
  //         animationController.repeat();
  //       }
  //     });
  //   });
  // }

  // @override
  // void dispose() {
  //   animationController.dispose();
  //   super.dispose();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     alignment: Alignment.center,
  //     color: Colors.white,
  //     child: Column(
  //         // animation: animationController,
  //         children: [
  //           RotationTransition(
  //             turns: Tween(begin: 0.0, end: 1.0).animate(animationController),
  //             child: Container(
  //               height: 80.0,
  //               width: 80.0,
  //               child: Image.asset('assets/portal.png'),
  //             ),
  //           ),
  //         ]
  //         //builder: (BuildContext context, Widget _widget) {
  //         //  return  Transform.rotate(
  //         //    angle: animationController.value,
  //         //    child: _widget,
  //         //  );
  //         //},
  //         ),
  //   );
  // }
}
