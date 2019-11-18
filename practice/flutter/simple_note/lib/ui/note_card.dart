import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_note/blocs/note_bloc.dart';
import 'package:simple_note/model/note_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class NoteCard extends StatefulWidget {
  NoteCard(this.note);
  NoteModel note;

  @override
  State<StatefulWidget> createState() => NoteCardState();
}

class NoteCardState extends State<NoteCard> {
  handleUpdateNote(NoteModel note) async {
    final noteBloc = NoteBloc();
    await noteBloc.updateNote(note, note.id);
  }

  handleDeleteNote(String id) async {
    final noteBloc = NoteBloc();
    await noteBloc.deleteNote(id);
  }

  createUpdatePopUp(NoteModel note) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    titleController.text = note.title;
    contentController.text = note.content;

    final dialog = new CupertinoAlertDialog(
      title: const Text('Sửa ghi chú'),
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
                    hintText: note.content,
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
              final newNote =
                  NoteModel(note.id, 'nhidh99', newTitle, newContent);
              handleUpdateNote(newNote);
              setState(() => widget.note = newNote);
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
          child: const Text('Cập nhật'),
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
    return new Slidable(
      actionPane: new SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: new Container(
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          color: Colors.black12,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(widget.note.title,
                  style:
                      new TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              new SizedBox(height: 10),
              new Text(widget.note.content,
                  textAlign: TextAlign.justify,
                  style: new TextStyle(fontSize: 16))
            ],
          )),
      secondaryActions: <Widget>[
        // Update a note
        IconSlideAction(
            caption: 'UPDATE',
            color: Colors.green,
            icon: Icons.create,
            onTap: () => createUpdatePopUp(widget.note)),

        // Delete a note
        IconSlideAction(
            caption: 'DELETE',
            color: Colors.redAccent,
            icon: Icons.delete,
            onTap: () async {
              await handleDeleteNote(widget.note.id);
              this.deactivate();
            })
      ],
    );
  }
}
