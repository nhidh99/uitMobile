import 'package:cloud_firestore/cloud_firestore.dart';

class DocHelper {
  final Firestore db = Firestore.instance;
  CollectionReference ref;

  DocHelper(String path) {
    ref = db.collection(path);
  }
}
