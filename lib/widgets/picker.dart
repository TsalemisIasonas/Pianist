import 'package:flutter/material.dart';
import 'package:pianist/components/edit_delete_dialog_box.dart';

class Picker extends StatefulWidget {
  final String practiseVal;
  final List<String> chordList; // source list (parent owns persistence)
  final List<String> positionList;
  final List<String> selectedPositions; // parent-owned mutable list
  final List<String> selectedChords; // parent-owned mutable list
  final bool canStart;
  final VoidCallback onStart; // called when user taps Go
  final Future<void> Function(String action, int index)? onEditDelete; // parent handles edit/delete persistence

  const Picker({
    super.key,
    required this.practiseVal,
    required this.chordList,
    required this.positionList,
    required this.selectedPositions,
    required this.selectedChords,
    required this.canStart,
    required this.onStart,
    this.onEditDelete,
  });

  @override
  State<Picker> createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  String get prettyTitle {
    if (widget.practiseVal.isEmpty) return '';
    return widget.practiseVal[0].toUpperCase() + widget.practiseVal.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
  final bool localCanStart = widget.selectedChords.isNotEmpty && widget.selectedPositions.isNotEmpty;

  return Center(
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
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.positionList.length,
                itemBuilder: (context, index) {
                  final positionItem = widget.positionList[index];
                  final isSelected = widget.selectedPositions.contains(positionItem);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          if (isSelected) {
                            widget.selectedPositions.remove(positionItem);
                          } else {
                            widget.selectedPositions.add(positionItem);
                          }
                // debug
                // ignore: avoid_print
                print('Picker.position toggle - selectedPositions: ${widget.selectedPositions}');
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
                        minimumSize: const Size(80, 80),
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                prettyTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 2.0,
              ),
              itemCount: widget.chordList.length,
              itemBuilder: (context, index) {
                final chordItem = widget.chordList[index];
                final isSelected = widget.selectedChords.contains(chordItem);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (widget.selectedChords.contains(chordItem)) {
                        widget.selectedChords.remove(chordItem);
                      } else {
                        widget.selectedChords.add(chordItem);
                      }
                          // debug
                          // ignore: avoid_print
                          print('Picker.onTap - selectedChords: ${widget.selectedChords}');
                    });
                  },
                  onLongPress: () async {
                    final editController = TextEditingController(text: chordItem);
                    final action = await showDialog<String?>(
                      context: context,
                      builder: (context) => EditDeleteDialogBox(editController: editController),
                    );

                    if (action != null) {
                      if (widget.onEditDelete != null) {
                        await widget.onEditDelete!(action, index);
                        setState(() {});
                      } else {
                        // local fallback behavior if parent didn't provide a handler
                        setState(() {
                          if (action == 'delete') {
                            widget.chordList.removeAt(index);
                            widget.selectedChords.remove(chordItem);
                          } else {
                            final edited = action;
                            if (edited != chordItem && edited.isNotEmpty) {
                              widget.chordList[index] = edited;
                              if (widget.selectedChords.remove(chordItem)) widget.selectedChords.add(edited);
                            }
                          }
                        });
                      }
                    }
                    editController.dispose();
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
                onPressed: localCanStart ? widget.onStart : null,
                style: TextButton.styleFrom(
                  backgroundColor: localCanStart ? Colors.white : Colors.grey[800],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: Text(
                  "Go",
                  style: TextStyle(
                    color: localCanStart ? Colors.black : Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
