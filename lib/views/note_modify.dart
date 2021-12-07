import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:note_restapi/models/create_note.dart';
import 'package:note_restapi/models/note.dart';
import 'package:note_restapi/services/note_service.dart';

class NoteModify extends StatefulWidget {
  final String noteID;
  NoteModify({this.noteID});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteID != null;

  NoteService get noteService => GetIt.I<NoteService>();

  String errorMessage;
  Note note;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      setState(() {
        _isLoading = true;
      });
      noteService.getNote(widget.noteID).then((response) {
        setState(() {
          _isLoading = false;
        });

        if (response.error) {
          errorMessage = response.errorMessage ?? 'An error occured';
        }
        note = response.data;
        _titleController.text = note.noteTitle;
        _contentController.text = note.noteContent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Note' : 'create Note',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Note title',
              ),
            ),
            Container(
              height: 8,
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: 'Note content',
              ),
            ),
            Container(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                if (isEditing) {
                  setState(() {
                    _isLoading = true;
                  });

                  final note = NoteManipulation(
                    noteContent: _contentController.text,
                    noteTitle: _titleController.text,
                  );
                  final result =
                      await noteService.updateNote(widget.noteID, note);

                  setState(() {
                    _isLoading = false;
                  });

                  if (result.error) {
                    final title = 'Error!';
                    final text = (result.errorMessage ?? 'An error occured');

                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text(title),
                              content: Text(text),
                              actions: [
                                TextButton(
                                  child: Text('Try again'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ));
                  } else {
                    Navigator.pop(context);
                  }
                } else {
                  setState(() {
                    _isLoading = true;
                  });

                  final note = NoteManipulation(
                    noteContent: _contentController.text,
                    noteTitle: _titleController.text,
                  );
                  final result = await noteService.createNote(note);

                  setState(() {
                    _isLoading = false;
                  });

                  if (result.error) {
                    final title = 'Error!';
                    final text = (result.errorMessage ?? 'An error occured');

                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text(title),
                              content: Text(text),
                              actions: [
                                TextButton(
                                  child: Text('Try again'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ));
                  } else {
                    Navigator.pop(context);
                  }
                }
              },
              child: Container(
                color: Colors.blue,
                height: 50,
                width: double.infinity,
                child: Center(
                  child: _isLoading
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              strokeWidth: 2,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              isEditing
                                  ? 'please wait while we load your note'
                                  : 'please wait...',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                          ),
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
