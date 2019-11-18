import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_note/resource/note_provider.dart';

import '../model/note_model.dart';

class Repository {

    final noteApiProvider = NoteApiProvider();

    Future<List<NoteModel>> getNoteList() => noteApiProvider.getNoteList();
    Stream<QuerySnapshot> getNoteListAsStream() => noteApiProvider.getNoteListAsStream();
    Future<NoteModel> getNoteById(String id) => noteApiProvider.getNoteById(id);
    Future insertNote(NoteModel data) => noteApiProvider.insertNote(data);
    Future deleteNote(String id) => noteApiProvider.deleteNote(id);
    Future updateNote(NoteModel data, String id) => noteApiProvider.updateNote(data, id);
}