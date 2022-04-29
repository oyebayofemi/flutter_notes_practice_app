import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_practice_app/database.dart';

class AddNote extends StatelessWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    CollectionReference dataCollection =
        FirebaseFirestore.instance.collection('notes');

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.pink),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          FlatButton(
              onPressed: () async {
                // dataCollection.add({
                //   'title': titleController.text,
                //   'content': contentController.text
                // });

                await databaseService()
                    .addNote(titleController.text, contentController.text)
                    .whenComplete(() => Navigator.pop(context));
                // Navigator.pop(context);
                // .whenComplete(() => Navigator.pop(context));
              },
              child: Text(
                'SAVE',
                style: TextStyle(color: Colors.pink),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.pink)),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(hintText: 'Title'),
                )),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.pink)),
                  child: TextField(
                    controller: contentController,
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(hintText: 'Content'),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
