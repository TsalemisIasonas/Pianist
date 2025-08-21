import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class PractisePage extends StatefulWidget {
  final String practiseVal;
  const PractisePage({super.key, required this.practiseVal});

  @override
  State<PractisePage> createState() => _PractisePageState();
}

class _PractisePageState extends State<PractisePage> {
  final Random _random = Random();
  late String selectedKey;
  late String selectedValue;
  Map<String, dynamic>? jsonData;
  List<String> chordList = [];
  List<String> positionList = [];
  String userInput = '';
  final List<String> _selectedChords = [];
  final List<String> _selectedPositions = [];
  bool _chordsSelected = false;

  @override
  void initState() {
    super.initState();
    selectedKey = '';
    selectedValue = 'Press Next';
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/data/${widget.practiseVal}.json');
      final decoded = json.decode(jsonString) as Map<String, dynamic>;
      setState(() {
        jsonData = decoded;
        chordList = List<String>.from(decoded['${widget.practiseVal[0].toUpperCase()} + ${widget.practiseVal.substring(1).toLowerCase()}']);
        positionList = List<String>.from(decoded['Positions'] as List);
      });
    } catch (e) {
      setState(() {
        jsonData = null;
        chordList = [];
        positionList = [];
      });
    }
  }

  Future<String?> getUserInput(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Time...'),
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

  void startProcess() async {
    String? result = await getUserInput(context);
    if (result != null) {
      newChord();
      int res = int.tryParse(result) ?? 0;
      Timer.periodic(Duration(seconds: res), (timer) {
        newChord();
      });
    }
  }

  void newChord() {
    setState(() {
      if (_selectedChords.isNotEmpty && _selectedPositions.isNotEmpty) {
        selectedKey = _selectedChords[_random.nextInt(_selectedChords.length)];
        selectedValue = _selectedPositions[_random.nextInt(_selectedPositions.length)];
      } else {
        selectedKey = 'No ${widget.practiseVal} selected';
        selectedValue = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    bool canStart = _selectedChords.isNotEmpty && _selectedPositions.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.practiseVal, style: const TextStyle(letterSpacing: 8)),
        elevation: 1,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shadowColor: Colors.white,
        actions: [
          _chordsSelected
              ? IconButton(
                  onPressed: startProcess,
                  icon: const Icon(Icons.timer),
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: _chordsSelected
          ? SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    selectedKey,
                    style: const TextStyle(color: Colors.white, fontSize: 60),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    selectedValue,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 2 * screenSize.height / 6),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40, right: 40),
                          child: TextButton(
                            onPressed: newChord,
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 55, 52, 52),
                              minimumSize: Size(
                                screenSize.width * 0.2,
                                screenSize.height / 6,
                              ),
                            ),
                            child: const Text("Next"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : (jsonData == null)
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Positions",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: positionList.length,
                            itemBuilder: (context, index) {
                              final positionItem = positionList[index];
                              bool isSelected = _selectedPositions.contains(positionItem);
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      if (isSelected) {
                                        _selectedPositions.remove(positionItem);
                                      } else {
                                        _selectedPositions.add(positionItem);
                                      }
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.black.withOpacity(0.5),
                                    side: BorderSide(
                                      color: isSelected ? Colors.red : Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    positionItem,
                                    style: TextStyle(
                                      color: isSelected ? Colors.red : Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            '${widget.practiseVal[0].toUpperCase()} + ${widget.practiseVal.substring(1).toLowerCase()}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 2.0,
                          ),
                          itemCount: chordList.length,
                          itemBuilder: (context, index) {
                            final chordItem = chordList[index];
                            bool isSelected = _selectedChords.contains(chordItem);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_selectedChords.contains(chordItem)) {
                                    _selectedChords.remove(chordItem);
                                  } else {
                                    _selectedChords.add(chordItem);
                                  }
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(
                                    color: isSelected ? Colors.red : Colors.white,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    chordItem,
                                    style: TextStyle(
                                      color: isSelected ? Colors.red : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: TextButton(
                            onPressed: canStart
                                ? () {
                                    setState(() {
                                      _chordsSelected = true;
                                    });
                                  }
                                : null,
                            style: TextButton.styleFrom(
                              backgroundColor: canStart ? Colors.white : Colors.grey[800],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                            ),
                            child: Text(
                              "Go",
                              style: TextStyle(
                                color: canStart ? Colors.black : Colors.grey,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
