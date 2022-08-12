import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:intl/locale.dart';
import 'package:my_story/services/storage_service.dart';
import 'package:my_story/services/story_data_service.dart';
import 'package:my_story/services/user.dart';
import 'package:http/http.dart' as http;
import 'package:my_story/services/user_local_data.dart';

import '../generated/l10n.dart';

class FirestoreService {
  Future getUserName() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        UserData.userName = documentSnapshot.get('name').toString();
      }
    });
  }

  Future checkVerification() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      UserData.isVerifiedAccount = documentSnapshot.get('verification');
    });
  }

  Future getMyDeviceToken() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc('${FirebaseAuth.instance.currentUser?.uid}')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      UserData.myToken = documentSnapshot.get('deviceToken');
    });
  }

  Future getUserCountSubscribers() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Subscribers')
        .get()
        .then((QuerySnapshot value) {
      UserData.subscribersCount = getCompactNumber(value.docs.length);
    });
  }

  String getCompactNumber(int value) {
    return NumberFormat.compact(locale: "en_US").format(value);
  }

  Future getAllMyData() async {
    await getUserName();
    await getMyDeviceToken();
    await getUserCountSubscribers();
    await checkVerification();

    UserData.userImage =
        await getAvatarImage(FirebaseAuth.instance.currentUser!.uid);
  }

  Future getAvatarImage(String id) async {
    try {
      return await StorageService().getUserImage(id);
    } catch (e) {
      return;
    }
  }

  Future setStoryLike() async {
    if (!StoryDataService.isLiked) {
      await FirebaseFirestore.instance
          .collection('Storys')
          .doc(StoryDataService.storyId)
          .update({"likes": FieldValue.increment(1)});

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Likes')
          .doc(StoryDataService.storyId)
          .set({
        'storyId': StoryDataService.storyId,
        'title': StoryDataService.title
      });
      StoryDataService.isLiked = true;

      sendPushMessage(
          title: 'Misteri',
          body:
              '${UserData.userName} liked your story "${StoryDataService.title}"',
          token: StoryDataService.userToken,
          screen: 'Story',
          storyId: StoryDataService.storyId);
    } else {
      await FirebaseFirestore.instance
          .collection('Storys')
          .doc(StoryDataService.storyId)
          .update({"likes": FieldValue.increment(-1)});

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Likes')
          .doc(StoryDataService.storyId)
          .delete();
      StoryDataService.isLiked = false;
    }
  }

  Future subscribe(String userId) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Subscriptions')
        .doc(userId)
        .set({userId: userId});

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Subscribers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      FirebaseAuth.instance.currentUser!.uid:
          FirebaseAuth.instance.currentUser!.uid
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .update({"subscribers": FieldValue.increment(1)});

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"subscriptions": FieldValue.increment(1)});

    sendPushMessage(
        title: 'Misteri',
        body: '${UserData.userName} subscribed to you!',
        token: StoryDataService.userToken,
        screen: 'Profile');
  }

  Future unsubscribe(String userId) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Subscriptions')
        .doc(userId)
        .delete();

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Subscribers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .update({"subscribers": FieldValue.increment(-1)});

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"subscriptions": FieldValue.increment(-1)});
  }

  Future publishComment(String comment, String commentId,
      {bool isReply = false, String subcommentId = ''}) async {
    String dateTimeString = DateTime.now().toString();
    final dateTime = DateTime.parse(dateTimeString);

    final format = DateFormat('MM.dd.yyyy HH:mm');
    final clockString = format.format(dateTime);

    DocumentReference<Map<String, dynamic>> doc;

    if (commentId.isEmpty) {
      doc = FirebaseFirestore.instance
          .collection('Storys')
          .doc(StoryDataService.storyId)
          .collection('Comments')
          .doc();

      await doc.set({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'comment': comment,
        'commentId': doc.id,
        'date': clockString,
        'likes': 0,
        'answers': 0
      });

      await FirebaseFirestore.instance
          .collection('Storys')
          .doc(StoryDataService.storyId)
          .update({"comments": FieldValue.increment(1)});

      sendPushMessage(
          title: 'Misteri',
          body:
              '${UserData.userName} left a comment under your story "${StoryDataService.title}"',
          token: StoryDataService.userToken,
          screen: 'Story',
          storyId: StoryDataService.storyId);
    } else {
      if (isReply) {
        doc = FirebaseFirestore.instance
            .collection('Storys')
            .doc(StoryDataService.storyId)
            .collection('Comments')
            .doc(commentId)
            .collection('Subcomments')
            .doc();

        doc.set({
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'comment': comment,
          'commentId': doc.id,
          'date': clockString,
          'likes': 0,
        });

        await FirebaseFirestore.instance
            .collection('Storys')
            .doc(StoryDataService.storyId)
            .collection('Comments')
            .doc(commentId)
            .update({"answers": FieldValue.increment(1)});

        await FirebaseFirestore.instance
            .collection('Storys')
            .doc(StoryDataService.storyId)
            .update({"comments": FieldValue.increment(1)});
      } else {
        if (subcommentId.isEmpty) {
          doc = FirebaseFirestore.instance
              .collection('Storys')
              .doc(StoryDataService.storyId)
              .collection('Comments')
              .doc(commentId);
        } else {
          doc = FirebaseFirestore.instance
              .collection('Storys')
              .doc(StoryDataService.storyId)
              .collection('Comments')
              .doc(commentId)
              .collection('Subcomments')
              .doc(subcommentId);
        }

        await doc.update({'comment': comment});
      }
    }
  }

  void sendPushMessage(
      {String body = '',
      String title = '',
      String token = '',
      String screen = '',
      String storyId = ''}) async {
    if (token == UserData.myToken) {
      return;
    }

    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAy2QLTHM:APA91bGA7hfZqHjDDIASzZYxSftvumm0agq7h7f4cjZndk1yhWMQzizg3smwpatzmFqqF5wt9ni-wyEV6AeQwLu4m88y4PgyskUNeWAn3usuyDh5WnTt1Hh2FDDa7wveD3lSpq9z0FpX',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
              /*'screen': screen,
              'story_id': storyId*/
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('ErrorPushNotification');
      }
    }
  }
}
