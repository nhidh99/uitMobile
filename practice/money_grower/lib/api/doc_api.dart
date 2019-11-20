import 'package:cloud_firestore/cloud_firestore.dart';

class Document {
  final Firestore db = Firestore.instance;
  CollectionReference ref;

  Document(String path) {
    ref = db.collection(path);
  }
}
