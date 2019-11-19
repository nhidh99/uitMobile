import 'package:cloud_firestore/cloud_firestore.dart';

class Api {
  final Firestore db = Firestore.instance;
  final String path;
  final String username;
  CollectionReference ref;

  Api(this.path, this.username) {
    ref = db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.where('user', isEqualTo: username).getDocuments();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.where('user', isEqualTo: username).snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }

  Future<void> removeDocument(String id) {
    return ref.document(id).delete();
  }

  Future<DocumentReference> addDocument(Map data) {
    return ref.add(data);
  }

  Future<void> updateDocument(Map data, String id) {
    return ref.document(id).updateData(data);
  }
}
