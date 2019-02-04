import 'package:flutter/material.dart';
import 'package:note_keeper/screens/note_list.dart';
import 'package:note_keeper/screens/note_detail.dart';

void main() => runApp(NoteKeeper());

class NoteKeeper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteKeeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        brightness: Brightness.dark,
      ),
      home: NoteList(),
    );
  }
}
