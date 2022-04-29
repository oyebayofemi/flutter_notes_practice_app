import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:notes_practice_app/add_note.dart';

import 'package:notes_practice_app/edit_note.dart';
import 'package:notes_practice_app/notes.dart';
import 'package:notes_practice_app/search.dart';
import 'database.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? firstHalf, secondHalf;

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
                if (dsnapshot['content'].length > 80) {
                  firstHalf = dsnapshot['content'].substring(0, 80);
                  secondHalf = dsnapshot['content']
                      .substring(80, dsnapshot['content'].length);
                } else {
                  firstHalf = dsnapshot['content'];
                  secondHalf = "";
                }
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditNote(docEdit: dsnapshot),
                        ));
                  },
                  child: Card(
                    color: Colors
                        .primaries[Random().nextInt(Colors.primaries.length)],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(
                            dsnapshot['title'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: secondHalf!.isEmpty
                                ? Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '$firstHalf ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  )
                                : Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '$firstHalf ...',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSearch(context: context, delegate: searchDelegate());
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
