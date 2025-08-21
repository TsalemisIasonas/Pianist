import 'dart:ui';
import 'package:flutter/material.dart';

class HexGlassButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final double size;

  const HexGlassButton({super.key, required this.label, required this.onTap, required this.size});

  @override
  Widget build(BuildContext context) {
    final double btnSize = size;
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: btnSize,
          height: btnSize * 0.85,
          child: ClipPath(
            clipper: HexagonClipper(),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 19.0, sigmaY: 19.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                
                  border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final a = w * 0.25;
    Path path = Path();
    path.moveTo(a, 0);
    path.lineTo(w - a, 0);
    path.lineTo(w, h / 2);
    path.lineTo(w - a, h);
    path.lineTo(a, h);
    path.lineTo(0, h / 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}