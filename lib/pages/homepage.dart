import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pianist/pages/practisepage.dart';

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
        title: const Text("P I A N I S T"),
        elevation: 1,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shadowColor: Colors.white,
      ),
      body: Stack(
        children: [
          Image.asset('assets/images/background.png', fit: BoxFit.cover),
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
                      'assets/images/piano.jfif',
                      fit: BoxFit.cover,
                      width: circleSize,
                      height: circleSize,
                    ),
                  ),
                  // Backdrop blur (applies to image beneath)
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  // Circular overlay (translucent) on top of blurred image
                  Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.12),
                        width: 2.0,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.06),
                          Colors.white.withOpacity(0.03),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // Icon on top of image
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const PractisePage(),
                          transitionsBuilder:
                              (
                                context,
                                animation,
                                secondaryAnimation,
                                child,
                              ) {
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
                    icon: const Icon(
                      Icons.music_note,
                      size: 100,
                      color: Colors.white,
                    ),
                    tooltip: 'Start practice',
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
