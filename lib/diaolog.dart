import 'package:flutter/material.dart';

class DialogContainer extends StatefulWidget {
  DialogContainer({Key? key}) : super(key: key);

  @override
  State<DialogContainer> createState() => _DialogContainerState();
}

class _DialogContainerState extends State<DialogContainer> {
  final titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 200,
        child: Column(
          children: [
            Text('search'),
            TextField(
              controller: titleController,
              decoration: InputDecoration(hintText: 'Title'),
            ),
            FlatButton(onPressed: () {}, child: Text('search'))
          ],
        ),
      ),
    );
  }
}
