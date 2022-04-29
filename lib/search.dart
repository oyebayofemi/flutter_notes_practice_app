import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_practice_app/edit_note.dart';

import 'package:provider/provider.dart';

class searchDelegate extends SearchDelegate {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('notes');

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
          primaryTextTheme:
              Theme.of(context).primaryTextTheme.apply(bodyColor: Colors.white),
          appBarTheme: super.appBarTheme(context).appBarTheme.copyWith(
              elevation: 0.0,
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.green),
        );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: collectionReference
          .orderBy('title', descending: false)
          .snapshots()
          .asBroadcastStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: [
              ...snapshot.data!.docs
                  .where((QueryDocumentSnapshot<Object?> element) =>
                      element['title']
                          .toString()
                          .toLowerCase()
                          .contains(query.toLowerCase()) ||
                      element['content']
                          .toString()
                          .toLowerCase()
                          .contains(query.toLowerCase()))
                  .map((QueryDocumentSnapshot<Object?> data) {
                final String title = data.get('title');
                final String content = data.get('content');
                //DocumentSnapshot dsnapshot = snapshot.data!.docs[index];
                String? firstHalf, secondHalf;
                if (content.length > 80) {
                  firstHalf = content.substring(0, 80);
                  secondHalf = content.substring(80, content.length);
                } else {
                  firstHalf = content;
                  secondHalf = "";
                }

                return title == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Card(
                        color: Colors.primaries[
                            Random().nextInt(Colors.primaries.length)],
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: secondHalf.isEmpty
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
                      );
              })
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('Search for note'),
    );
  }
}
