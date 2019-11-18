import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_note/model/note_model.dart';
import 'package:simple_note/resource/repository.dart';

class NoteBloc {
    final repository = Repository();

    Stream<QuerySnapshot> getNoteListAsStream() => repository.getNoteListAsStream();
    Future<List<NoteModel>> getNoteList() => repository.getNoteList();
    Future<NoteModel> getNoteById(String id) => repository.getNoteById(id);
    Future insertNote(NoteModel data) => repository.insertNote(data);
    Future deleteNote(String id) => repository.deleteNote(id);
    Future updateNote(NoteModel data, String id) => repository.updateNote(data, id);
}