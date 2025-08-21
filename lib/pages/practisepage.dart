import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pianist/pages/arpeggiospage.dart';
import 'package:pianist/pages/chordspage.dart';
import 'package:pianist/components/hex_glass_button.dart';

class PractisePage extends StatefulWidget {
  const PractisePage({Key? key}) : super(key: key);

  @override
  State<PractisePage> createState() => _PractisePageState();
}

class _PractisePageState extends State<PractisePage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("S E L E C T"),
        elevation: 1,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shadowColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Container(
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(colors: [
          //       Colors.black.withOpacity(0.9),
          //       Colors.black.withOpacity(0.8),
          //       Colors.black.withOpacity(0.6),
          //       Colors.black.withOpacity(0.4),
          //       Colors.black.withOpacity(0.1),
          //     ], begin: Alignment.topLeft, end: Alignment.bottomRight,
          //     stops: [0.3,0.5,0.7,0.8,0.9]),
          //   ),
          // ),
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                childAspectRatio: 1.1,
                children: [
                  HexGlassButton(
                    label: 'Chords',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChordsPage()),
                      );
                    },
                    size: min(screenSize.width, screenSize.height) * 0.8,
                  ),
                  const SizedBox.shrink(),
                  const SizedBox.shrink(),
                  HexGlassButton(
                    label: 'Arpeggios',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ArpeggiosPage()),
                      );
                    },
                    size: min(screenSize.width, screenSize.height) * 0.7,
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


