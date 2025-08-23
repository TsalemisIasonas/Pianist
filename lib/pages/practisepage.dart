import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pianist/components/dialog_box.dart';

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
  final List<String> _SelectedChords = [];
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
      final dir = await getApplicationDocumentsDirectory();
      final localFile = File('${dir.path}/${widget.practiseVal}.json');
      String jsonString;
      if (await localFile.exists()) {
        jsonString = await localFile.readAsString();
        print('Loading local file: ${localFile.path}');
      } else {
        jsonString = await rootBundle.loadString('assets/data/${widget.practiseVal}.json');
        print('Loading asset: assets/data/${widget.practiseVal}.json');
      }
      final decoded = json.decode(jsonString) as Map<String, dynamic>;

      final String prettyKey = widget.practiseVal.isNotEmpty
          ? widget.practiseVal[0].toUpperCase() + widget.practiseVal.substring(1).toLowerCase()
          : widget.practiseVal;

      List<String> chords = [];
      List<String> positions = [];

      if (decoded.containsKey(prettyKey) && decoded[prettyKey] is List) {
        chords = List<String>.from(decoded[prettyKey] as List);
      } else if (decoded.containsKey('Chords') && decoded['Chords'] is List) {
        chords = List<String>.from(decoded['Chords'] as List);
      } else {
        final possibleChordKeys = decoded.keys.where((k) => decoded[k] is List).toList();
        if (possibleChordKeys.isNotEmpty) {
          chords = List<String>.from(possibleChordKeys.map((e) => e.toString()));
        }
      }

      if (decoded.containsKey('Positions') && decoded['Positions'] is List) {
        positions = List<String>.from(decoded['Positions'] as List);
      }

      setState(() {
        jsonData = decoded;
        chordList = chords;
        positionList = positions;
      });
    } catch (e, st) {
      print('Error loading/parsing ${widget.practiseVal}.json: $e');
      print(st);
      setState(() {
        jsonData = null;
        chordList = [];
        positionList = [];
      });
    }
  }

  Future<File> _localFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/${widget.practiseVal}.json');
  }

  Future<void> _saveJsonToLocal() async {
    try {
      final file = await _localFile();
      if (jsonData != null) {
        await file.writeAsString(json.encode(jsonData));
        print('Saved json to ${file.path}');
      }
    } catch (e) {
      print('Error saving local json: $e');
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
      if (_SelectedChords.isNotEmpty && _selectedPositions.isNotEmpty) {
        selectedKey = _SelectedChords[_random.nextInt(_SelectedChords.length)];
        selectedValue = _selectedPositions[_random.nextInt(_selectedPositions.length)];
      } else {
        selectedKey = 'No ${widget.practiseVal} selected';
        selectedValue = '';
      }
    });
  }

  void addElements() async {
    // Open dialog which returns the list of added entries (or null if cancelled)
    final added = await showDialog<List<String>?>(
      context: context,
      builder: (context) => DialogBox(practiseVal: widget.practiseVal),
    );

    if (added != null && added.isNotEmpty) {
      // apply changes in parent state and persist
      setState(() {
        // append to UI list
        chordList.addAll(added);

        // update jsonData according to detected shape
        if (jsonData != null) {
          final String prettyKey = widget.practiseVal.isNotEmpty
              ? widget.practiseVal[0].toUpperCase() + widget.practiseVal.substring(1).toLowerCase()
              : widget.practiseVal;

          if (jsonData!.containsKey(prettyKey) && jsonData![prettyKey] is List) {
            (jsonData![prettyKey] as List).addAll(added);
          } else if (jsonData!.containsKey('Chords') && jsonData!['Chords'] is List) {
            (jsonData!['Chords'] as List).addAll(added);
          } else {
            for (var e in added) {
              if (!jsonData!.containsKey(e)) jsonData![e] = <dynamic>[];
            }
          }
        } else {
          final String prettyKey = widget.practiseVal.isNotEmpty
              ? widget.practiseVal[0].toUpperCase() + widget.practiseVal.substring(1).toLowerCase()
              : widget.practiseVal;
          jsonData = {prettyKey: List.from(added)};
        }
      });

      await _saveJsonToLocal();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    bool canStart = _SelectedChords.isNotEmpty && _selectedPositions.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.practiseVal.toUpperCase(), style: const TextStyle(letterSpacing: 8)),
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
              : IconButton(
                  onPressed: addElements,
                  icon: const Icon(Icons.add, size: 30),
                )
        ],
      ),
      body: _chordsSelected
          ? SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    selectedKey,
                    style: const TextStyle(color: Colors.white, fontSize: 65),
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
                          child: SizedBox(
                            width: double.infinity,
                            height: 80, // Make it square (height = width)
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: TextButton(
                                onPressed: newChord,
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 55, 52, 52),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0), // Square
                                  ),
                                ),
                                child: const Text(
                                  "Next",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
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
                        const SizedBox(height: 30),
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
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    minimumSize: const Size(80, 80), // Make square
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
                            '${widget.practiseVal[0].toUpperCase()}' '${widget.practiseVal.substring(1).toLowerCase()}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 30),
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
                            bool isSelected = _SelectedChords.contains(chordItem);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_SelectedChords.contains(chordItem)) {
                                    _SelectedChords.remove(chordItem);
                                  } else {
                                    _SelectedChords.add(chordItem);
                                  }
                                });
                              },
                              onLongPress: () async {
                                final TextEditingController editController = TextEditingController(text: chordItem);
                                final action = await showDialog<String?>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Edit or Delete'),
                                    content: TextField(
                                      controller: editController,
                                      decoration: const InputDecoration(hintText: 'Edit chord name'),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop('delete'),
                                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(null),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(editController.text.trim()),
                                        child: const Text('Save'),
                                      ),
                                    ],
                                  ),
                                );

                                if (action != null) {
                                  if (action == 'delete') {
                                    setState(() {
                                      chordList.removeAt(index);
                                      _SelectedChords.remove(chordItem);
                                      if (jsonData != null) {
                                        final String prettyKey = widget.practiseVal.isNotEmpty
                                            ? widget.practiseVal[0].toUpperCase() + widget.practiseVal.substring(1).toLowerCase()
                                            : widget.practiseVal;
                                        if (jsonData!.containsKey(prettyKey) && jsonData![prettyKey] is List) {
                                          (jsonData![prettyKey] as List).remove(chordItem);
                                        } else if (jsonData!.containsKey('Chords') && jsonData!['Chords'] is List) {
                                          (jsonData!['Chords'] as List).remove(chordItem);
                                        } else {
                                          jsonData!.remove(chordItem);
                                        }
                                      }
                                    });
                                    await _saveJsonToLocal();
                                  } else {
                                    final edited = action;
                                    if (edited != chordItem && edited.isNotEmpty) {
                                      setState(() {
                                        chordList[index] = edited;
                                        if (_SelectedChords.remove(chordItem)) {
                                          _SelectedChords.add(edited);
                                        }
                                        final String prettyKey = widget.practiseVal.isNotEmpty
                                            ? widget.practiseVal[0].toUpperCase() + widget.practiseVal.substring(1).toLowerCase()
                                            : widget.practiseVal;
                                        if (jsonData != null) {
                                          if (jsonData!.containsKey(prettyKey) && jsonData![prettyKey] is List) {
                                            final List list = jsonData![prettyKey] as List;
                                            final idx = list.indexOf(chordItem);
                                            if (idx != -1) list[idx] = edited;
                                          } else if (jsonData!.containsKey('Chords') && jsonData!['Chords'] is List) {
                                            final List list = jsonData!['Chords'] as List;
                                            final idx = list.indexOf(chordItem);
                                            if (idx != -1) list[idx] = edited;
                                          } else if (jsonData!.containsKey(chordItem)) {
                                            final value = jsonData!.remove(chordItem);
                                            jsonData![edited] = value;
                                          }
                                        }
                                      });
                                      await _saveJsonToLocal();
                                    }
                                  }
                                }
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
