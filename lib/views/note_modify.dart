// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pages_and_popups/services/notes_service.dart';

import '../models/note.dart';
import '../models/note_insert.dart';

class NoteModify extends StatefulWidget {
  final String? noteID;
  const NoteModify({Key? key, this.noteID}) : super(key: key);

  @override
  State<NoteModify> createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteID != null;

  NotesService get notesService => GetIt.I<NotesService>();

  String? errorMessage;
  late Note note;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      setState(() {
        _isLoading = true;
      });
      notesService.getNote(widget.noteID!).then((response) {
        setState(() {
          _isLoading = false;
        });

        if (response.error) {
          errorMessage = response.errorMessage ?? 'An error occured';
        }
        note = response.data!;
        _titleController.text = note.noteTitle!;
        _contentController.text = note.noteContent!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit note' : 'Create note')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(hintText: 'Note title'),
                  ),
                  Container(
                    height: 8,
                  ),
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(hintText: 'Note content'),
                  ),
                  Container(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: RaisedButton(
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: () async {
                        if (isEditing) {
                          final note = NoteManipulation(
                              noteTitle: _titleController.text,
                              noteContent: _contentController.text);
                          final result = await notesService.updateNote(widget.noteID!, note);

                          setState(() {
                            _isLoading = false;
                          });

                          const title = 'Done';
                          final text = result.error
                              ? (result.errorMessage ?? 'An error occured')
                              : 'Your note was updated';

                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text(title),
                                    content: Text(text),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  )).then((data) {
                            if (result.data!) {
                              Navigator.of(context).pop();
                            }
                          });
                        } else {
                          final note = NoteManipulation(
                              noteTitle: _titleController.text,
                              noteContent: _contentController.text);
                          final result = await notesService.createNote(note);

                          setState(() {
                            _isLoading = false;
                          });

                          const title = 'Done';
                          final text = result.error
                              ? (result.errorMessage ?? 'An error occured')
                              : 'Your note was created';

                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text(title),
                                    content: Text(text),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  )).then((data) {
                            if (result.data!) {
                              Navigator.of(context).pop();
                            }
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
