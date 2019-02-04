import 'package:flutter/material.dart';
import 'package:note_keeper/screens/note_list.dart';
import 'dart:async';
import 'package:note_keeper/models/node.dart';
import 'package:note_keeper/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  String appBarTitle;

  DatabaseHelper helper = DatabaseHelper();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  Note note;

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = note.title;
    descController.text = note.description;

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen(appBarTitle);
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0),
            child: AppBar(
              bottom: PreferredSize(
                  child: Container(
                    color: Colors.white10,
                    height: 0.8,
                  ),
                  preferredSize: null),
              backgroundColor: Colors.black,
              title: Text(
                '',
                style: TextStyle(color: Colors.white),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 30.0,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    debugPrint("post deleted");
                    _delete();
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.check,
                    size: 30.0,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    debugPrint("post added");
                    _save();
                  },
                ),
              ],
              leading: IconButton(
                  color: Colors.white,
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30.0,
                  ),
                  onPressed: () {
                    moveToLastScreen(appBarTitle);
                  }),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint("Something changed in Title Text Field");
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(fontSize: 35.0),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 25.0, bottom: 10.0, left: 5.0, right: 5.0),
                  child: TextField(
                    controller: descController,
                    style: TextStyle(fontSize: 15.0),
                    onChanged: (value) {
                      debugPrint("Something changed in Description Text Field");
                      updateDescription();
                    },
                    decoration: InputDecoration(
                      labelText: "Description",
                      hintStyle: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen(String title) {
    Navigator.pop(context, true);
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descController.text;
  }

  void _save() async {

    moveToLastScreen(appBarTitle);
    note.date = DateFormat.yMMMd().format(DateTime.now());

    if (note.id != null) {
      //update
      await helper.updateNote(note);
    } else {
      //insert
      await helper.insertNote(note);
    }

  }

  void _delete() async{

    moveToLastScreen(appBarTitle);
    await helper.deleteNote(note.id);
  }
}
