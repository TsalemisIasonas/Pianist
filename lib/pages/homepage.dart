import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pianist/pages/selectpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    final double circleSize = min(screenSize.width, screenSize.height) * 0.85;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("PIANIST", style: TextStyle(letterSpacing: 8.0)),
        elevation: 1,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shadowColor: Colors.white,
      ),
      body: Stack(
        children: [
          //Image.asset('assets/images/background.png', fit: BoxFit.cover),
          Center(
            child: SizedBox(
              width: circleSize,
              height: circleSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Image clipped to circle
                  ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                      width: circleSize,
                      height: circleSize,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const SelectPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tween = Tween(
                                  begin: begin,
                                  end: end,
                                ).chain(CurveTween(curve: curve));

                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                        ),
                      );
                    },
                  ),


                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
