import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:my_story/services/firestore_service.dart';

class FirebaseAuthService {
  String errorText = '';
  String? deviceToken = '';

  Future signUp(
      {required String name, String email = '', String password = ''}) async {
    List<String> splitList = name.split(' ');
    List<String> indexList = [];

    for (int i = 0; i < splitList.length; i++) {
      for (int y = 1; y < splitList[i].length + 1; y++) {
        indexList.add(splitList[i].substring(0, y).toLowerCase());
      }
    }

    /* await FirebaseMessaging.instance.getToken().then((token) {
      deviceToken = token;
    });*/

    if (email.isNotEmpty) {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    }

    final data = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid);
    await data.set({
      'id': data.id,
      'name': name,
      'verification': false,
      'nameIndex': indexList,
      //'deviceToken': deviceToken,
      'subscribers': 0,
      'stories': 0,
      'subscriptions': 0
    });
  }

  Future signIn({required String email, required String password}) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    FirestoreService().getUserName();
  }
}
