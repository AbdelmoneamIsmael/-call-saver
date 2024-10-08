import 'package:cloud_firestore/cloud_firestore.dart';

class ActicvateDb {
  static Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> getActivationKey() async {
   return  FirebaseFirestore.instance.collection("activation_key").doc("kLn3IhhLAeWJqWpYbMgL").snapshots();
  }

  static Future<void> setActivationKey(String key) async {
    await FirebaseFirestore.instance.collection("activation_key").doc("kLn3IhhLAeWJqWpYbMgL").set({"activation_key": key});
  }
}
