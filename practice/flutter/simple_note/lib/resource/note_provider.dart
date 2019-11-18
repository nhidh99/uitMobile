import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_note/api/Api.dart';
import '../model/note_model.dart';

class NoteApiProvider {

  Api api = Api('notes', 'nhidh99');

  Future<List<NoteModel>> getNoteList() async {
    final response = await api.getDataCollection();
    final notes = response.documents
        .map((doc) => NoteModel.fromMap(doc.data, doc.documentID)).toList();
    return notes;
  }

  Stream<QuerySnapshot> getNoteListAsStream() {
      return api.streamDataCollection();
  }

  Future<NoteModel> getNoteById(String id) async {
      final doc = await api.getDocumentById(id);
      return NoteModel.fromMap(doc.data, doc.documentID);
  }

  Future deleteNote(String id) async {
      await api.removeDocument(id);
      return;
  }

  Future updateNote(NoteModel data, String id) async {
      await api.updateDocument(data.toJson(), id);
      return;
  }

  Future insertNote(NoteModel data) async {
      await api.addDocument(data.toJson());
      return;
  }
}
