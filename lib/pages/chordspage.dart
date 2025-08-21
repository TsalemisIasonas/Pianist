import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class ChordsPage extends StatefulWidget {
  const ChordsPage({Key? key}) : super(key: key);

  @override
  State<ChordsPage> createState() => _ChordsPageState();
}

class _ChordsPageState extends State<ChordsPage> {
  final Random _random = Random();
  late String selectedKey;
  late String selectedValue;
  late Map<String, dynamic> jsonData;
  late List<String> keys;
  late String userInput;

  @override
  void initState() {
    super.initState();

    // Initialize selectedKey with an empty string
    selectedKey = '';
    selectedValue = 'Press Next';

    // Load JSON data from assets at runtime
    loadJsonData();
  }

  // Function to load JSON data from assets at runtime
  Future<void> loadJsonData() async {
    String jsonString = await rootBundle.loadString('assets/data/chords.json');
    jsonData = json.decode(jsonString);
    keys = jsonData.keys.toList();
  }

  // Function to present a dialog box and get user input
  Future<String?> getUserInput(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Time in seconds...'),
          content: TextField(
            onChanged: (value) {
              userInput = value;
            },
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(userInput);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to start the process
  void startProcess() async {
    // Get user input
    String? result = await getUserInput(context);
    // Check if user pressed OK in the dialog
    if (result != null) {
      // Call the executeFunction immediately
      newChord();
      int res = int.tryParse(result) ?? 0;

      // Schedule the executeFunction to be called every x seconds
      Timer.periodic(Duration(seconds: res), (timer) {
        newChord();
      });
    }
  }

  void newChord() {
    setState(() {
      selectedKey = keys.isNotEmpty
          ? keys[_random.nextInt(keys.length)]
          : 'No chords available';

      // Initialize selectedValue accordingly
      selectedValue = selectedKey != 'No chords available'
          ? (jsonData[selectedKey][_random.nextInt(jsonData[selectedKey].length)])
          : 'No value available';
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("C H O R D S"),
        elevation: 1,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shadowColor: Colors.white,
        actions: [IconButton(onPressed: startProcess, icon: const Icon(Icons.timer))],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            selectedKey,
            style: const TextStyle(color: Colors.white, fontSize: 60,),
          ),
          const SizedBox(height: 30,),
          Text(
            selectedValue,
            style: const TextStyle(color: Colors.white, fontSize: 30, fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 2*screenSize.height/6), // Adjust the spacing as needed
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: TextButton(
                    onPressed: newChord,
                    child: const Text("Next"),
                    style: TextButton.styleFrom(
                      backgroundColor: const  Color.fromARGB(255, 55, 52, 52),
                      //primary: Colors.orange,
                      minimumSize: Size(screenSize.width *0.2, screenSize.height/6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
