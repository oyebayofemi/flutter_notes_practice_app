import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:notes_practice_app/notes.dart';

class databaseService {
  CollectionReference dataCollection =
      FirebaseFirestore.instance.collection('notes');

  Future addNote(String title, String content) async {
    return await dataCollection.add({'title': title, 'content': content});
  }
}
