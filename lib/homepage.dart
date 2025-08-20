import 'package:flutter/material.dart';
import 'package:pianist/practisepage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("P I A N I S T"),
        elevation: 1,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shadowColor: Colors.white,
      ),
      body: Stack(
        children: [
          Image.asset('assets/images/piano.jfif', fit: BoxFit.cover),
          Center(
            child: Container(
              width: 3 * screenSize.width / 4,
              height: 3 * screenSize.height / 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.white,
                  width: 3.0,
                ),
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                const PractisePage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;
          
                          var tween = Tween(begin: begin, end: end).chain(
                            CurveTween(curve: curve),
                          );
          
                          var offsetAnimation = animation.drive(tween);
          
                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  });
                },
                icon: const Icon(
                  Icons.music_note,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
