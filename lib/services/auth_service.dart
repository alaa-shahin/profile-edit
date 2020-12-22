import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  Future<dynamic> createUserDocument(
      String uid, Map<String, dynamic> userMap) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(userMap);
    } catch (error) {
      return error;
    }
  }
}
