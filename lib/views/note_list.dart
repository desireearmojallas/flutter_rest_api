import 'package:flutter/material.dart';
import 'package:pages_and_popups/models/note_for_listing.dart';
import 'package:pages_and_popups/views/note_delete.dart';
import 'package:pages_and_popups/views/note_modify.dart';

class NoteList extends StatelessWidget {
  final notes = [
    NoteForListing(
        noteID: '1',
        createDateTime: DateTime.now(),
        latestEditDateTime: DateTime.now(),
        noteTitle: 'Note 1'),
    NoteForListing(
        noteID: '2',
        createDateTime: DateTime.now(),
        latestEditDateTime: DateTime.now(),
        noteTitle: 'Note 2'),
    NoteForListing(
        noteID: '3',
        createDateTime: DateTime.now(),
        latestEditDateTime: DateTime.now(),
        noteTitle: 'Note 3'),
  ];

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('List of notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NoteModify(),
          ));
        },
        child: Icon(Icons.add),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) =>
            Divider(height: 1, color: Colors.green),
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(notes[index].noteID),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {

            },
            confirmDismiss: (direction) async {
              final result = await showDialog(
                context: context,
                builder: (context) => NoteDelete()
              );
              return result;
            },
            background: Container(
              color: Colors.red,
              padding: EdgeInsets.only(left: 16),
              child: Align(child: Icon(Icons.delete, color: Colors.white), alignment: Alignment.centerLeft,),
            ),
            child: ListTile(
              title: Text(
                notes[index].noteTitle,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              subtitle: Text(
                  'Last edited on ${formatDateTime(notes[index].latestEditDateTime)}'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => NoteModify(noteID: notes[index].noteID)));
              },
            ),
          );
        },
        itemCount: notes.length,
      ),
    );
  }
}
