import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_practice_app/add_note.dart';
import 'package:notes_practice_app/diaolog.dart';
import 'package:notes_practice_app/edit_note.dart';
import 'package:notes_practice_app/notes.dart';
import 'database.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List colorData = [
    {"color": Color(0xffff6968)},
    {"color": Color(0xff7a54ff)},
    {"color": Color(0xffff8f61)},
    {"color": Color(0xff2ac3ff)},
    {"color": Color(0xff5a65ff)},
    {"color": Color(0xff96da45)},
  ];

  @override
  Widget build(BuildContext context) {
    final brew = Provider.of<List<Note>?>(context) ?? [];

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('notes');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NOTE LIST',
          style: TextStyle(color: Colors.pink),
        ),
        actions: [
          FlatButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNote(),
                  ));
            },
            icon: Icon(Icons.add, color: Colors.pink),
            label: Text(
              'Add',
              style: TextStyle(color: Colors.pink),
            ),
            //color: Colors.pink,
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: collectionReference.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot dsnapshot = snapshot.data!.docs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditNote(docEdit: dsnapshot),
                        ));
                  },
                  child: Card(
                    color: colorData[index]['color'],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Text(dsnapshot['title']),
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogContainer();
              });
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
