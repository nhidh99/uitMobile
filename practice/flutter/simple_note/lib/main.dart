import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_note/blocs/note_bloc.dart';
import 'package:simple_note/ui/note_card.dart';

import 'model/note_model.dart';

void main() => runApp(SimpleNoteApp());

class SimpleNoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Simple Note",
      home: new NoteScreen(),
    );
  }
}

class NoteScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NoteScreenState();
}

class NoteScreenState extends State<NoteScreen> {
  List<NoteModel> notes;

  handleInsertNote(NoteModel note) async {
    final noteBloc = NoteBloc();
    await noteBloc.insertNote(note);
  }

  createInsertPopUp() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    final dialog = new CupertinoAlertDialog(
      title: const Text('Thêm ghi chú'),
      content: Card(
          color: Colors.transparent,
          elevation: 0.0,
          child: Column(
            children: <Widget>[
              TextField(
                autofocus: true,
                controller: titleController,
                decoration: InputDecoration(
                    labelText: "Tiêu đề",
                    filled: true,
                    fillColor: Colors.grey.shade50),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                    labelText: "Nội dung",
                    filled: true,
                    fillColor: Colors.grey.shade50),
              ),
            ],
          )),
      actions: <Widget>[
        new FlatButton(
          // ignore: missing_return
          onPressed: () async {
            final newTitle = titleController.text.trim();
            final newContent = contentController.text.trim();

            if (newTitle.isNotEmpty) {
              final newNote = NoteModel(null, 'nhidh99', newTitle, newContent);
              await handleInsertNote(newNote);
              setState(() => notes.add(newNote));
              Navigator.of(context).pop();
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return new CupertinoAlertDialog(
                        title: const Text("Lỗi"),
                        content: const Text("Tiêu đề không được để trống"));
                  });
            }
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Thêm'),
        ),
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Huỷ bỏ'),
        ),
      ],
    );

    showDialog(
        context: context,
        builder: (context) {
          return dialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: const Text("Title")),
      body: Container(
          child: StreamBuilder(
              stream: NoteBloc().getNoteListAsStream(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  notes = snapshot.data.documents
                      .map((doc) => NoteModel.fromMap(doc.data, doc.documentID))
                      .toList();

                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (buildContext, index) =>
                        NoteCard(notes[index]),
                  );
                } else {
                  return Text('fetching');
                }
              })),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          createInsertPopUp();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
