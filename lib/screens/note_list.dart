import 'package:flutter/material.dart';
import 'package:note_keeper/screens/note_detail.dart';
import 'dart:async';
import 'package:note_keeper/models/node.dart';
import 'package:note_keeper/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:note_keeper/models/GradientAppBar.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: GradientAppBar('Notes'),
      ),
      body: getNoteListView(),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF760000),
        onPressed: () {
          debugPrint("FAB clicked!");
          navigateToDetail(Note('', ''), 'Add Note');
        },
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Container(
//            decoration: BoxDecoration(
//              color: Colors.white,
//              shape: BoxShape.rectangle,
//              borderRadius: new BorderRadius.circular(8.0),
//            ),

          height: 75.0,
          margin:
              EdgeInsets.only(top: 10.0, bottom: 2.0, left: 10.0, right: 10.0),
          child: ListTile(
            title: Text(
              this.noteList[position].title,
              style: titleStyle,
            ),
            subtitle: Text(this.noteList[position].date),
            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.white),
              onTap: () {
                _delete(context, noteList[position]);
              },
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.noteList[position], "Edit Note");
            },
          ),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color(0xFFA51A1A),
            borderRadius: BorderRadius.circular(8.0),
//            gradient: SweepGradient(colors: [
//              const Color(0xFFFE2121),
//              const Color(0xFFA51A1A),
//            ]),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.white10,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0))
            ],
          ),
        );
      },
    );
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
