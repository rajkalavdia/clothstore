import 'package:cloud_firestore/cloud_firestore.dart';

class AutoGenerateUID {
  Future<String> getAutogenerateUIDForOrder() async {
    DocumentReference orderDoc = FirebaseFirestore.instance.collection('orders').doc();
    return orderDoc.id;
  }
}
