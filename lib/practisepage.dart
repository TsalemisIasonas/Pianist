import 'package:flutter/material.dart';
import 'package:pianist/arpeggiospage.dart';
import 'package:pianist/chordspage.dart';


class PractisePage extends StatefulWidget {
  const PractisePage({Key? key}) : super(key: key);

  @override
  State<PractisePage> createState() => _PractisePageState();
}

class _PractisePageState extends State<PractisePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("S E L E C T"),
          elevation: 1,
          backgroundColor: Colors.black,
          foregroundColor: Colors.orange,
          shadowColor: Colors.white,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Color.fromARGB(255, 235, 181, 100)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.4, 0.9],
            ),
          ),
          child: GridView.count(
            crossAxisCount: 1,
            children: [
              Padding(
                padding: const EdgeInsets.all(35),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const ChordsPage()));
                    });
                  },
                  child: const Text("Chords"),
                  style: TextButton.styleFrom(
                      side: const BorderSide(width: 1, color: Colors.white)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(35.0),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const ArpeggiosPage()));
                    });
                  },
                  child: const Text("Arpeggios"),
                  style: TextButton.styleFrom(
                      side: const BorderSide(width: 1, color: Colors.white)),
                ),
              ),
            ],
          ),
        ));
  }
}
