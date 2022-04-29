import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_practice_app/home_page.dart';

class EditNote extends StatefulWidget {
  late DocumentSnapshot docEdit;
  EditNote({required this.docEdit});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  @override
  Widget build(BuildContext context) {
    final titleController =
        TextEditingController(text: widget.docEdit['title']);
    final contentController =
        TextEditingController(text: widget.docEdit['content']);

    CollectionReference dataCollection =
        FirebaseFirestore.instance.collection('notes');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.pink),
        elevation: 0,
        actions: [
          FlatButton(
              onPressed: () {
                widget.docEdit.reference.update({
                  'title': titleController.text,
                  'content': contentController.text
                });
                Navigator.pop(context);

                // dataCollection.add({
                //   'title': titleController.text,
                //   'content': contentController.text
                // }).whenComplete(() => Navigator.pop(context));
              },
              child: Text(
                'SAVE',
                style: TextStyle(color: Colors.pink),
              )),
          FlatButton(
              onPressed: () {
                widget.docEdit.reference.delete();
                // .whenComplete(() => Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => HomePage(),
                //     )));
                Navigator.pop(context);

                // dataCollection.add({
                //   'title': titleController.text,
                //   'content': contentController.text
                // }).whenComplete(() => Navigator.pop(context));
              },
              child: Text(
                'DELETE',
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
