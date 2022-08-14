import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:my_story/screens/interests.dart';
import 'package:my_story/services/firestore_service.dart';
import 'package:my_story/services/story_data_service.dart';
import 'package:my_story/services/user.dart';

class StoryService {
  Future publishStory(
      {required String title,
      required String story,
      String storyId = '',
      String draftId = '',
      String storyLanguage = '',
      bool commentsAccess = true,
      bool forAdults = false}) async {
    List<String> splitList = title.split(' ');
    List<String> indexList = [];

    for (int i = 0; i < splitList.length; i++) {
      for (int y = 1; y < splitList[i].length + 1; y++) {
        indexList.add(splitList[i].substring(0, y).toLowerCase());
      }
    }

    String dateTimeString = DateTime.now().toString();
    final dateTime = DateTime.parse(dateTimeString);

    final format = DateFormat('MM.dd.yyyy HH:mm:ss');
    final clockString = format.format(dateTime);

    final data =
        FirebaseFirestore.instance.collection('Storys').doc(storyId.isNotEmpty
            ? storyId
            : draftId.isNotEmpty
                ? draftId
                : null);

    if (storyId.isEmpty || draftId.isNotEmpty) {
      await data.set({
        'storyId': data.id,
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'title': title,
        'story': story,
        'searchIndex': indexList,
        'date': clockString,
        'storyLanguage': storyLanguage,
        'commentsAccess': commentsAccess,
        'forAdults': forAdults,
        'userName': UserData.userName,
        'views': 0,
        'likes': 0,
        'comments': 0,
        'interests': Interests.myInterests
      }).whenComplete(() async {
        if (draftId.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(StoryDataService.userId)
              .collection('Draft')
              .doc(draftId)
              .delete();
        }
      });

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"stories": FieldValue.increment(1)});
    } else {
      await data.update({
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'title': title,
        'story': story,
        'searchIndex': indexList,
        'storyLanguage': storyLanguage,
        'commentsAccess': commentsAccess,
        'userName': UserData.userName,
      });
    }
  }

  Future publishStoryToDraft(
      {required String title,
      required String story,
      String draftId = ''}) async {
    final data = FirebaseFirestore.instance
        .collection('Users/${FirebaseAuth.instance.currentUser!.uid}/Draft')
        .doc(draftId.isNotEmpty ? draftId : null);
    await data.set({'draftId': data.id, 'title': title, 'story': story});
  }

  Future loadAdditionalInfoStory() async {
    await FirebaseFirestore.instance
        .collection('Storys')
        .where('userId', isEqualTo: StoryDataService.userId)
        .get()
        .then((QuerySnapshot value) {
      StoryDataService.storysCount =
          FirestoreService().getCompactNumber(value.docs.length);
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Likes')
        .doc(StoryDataService.storyId)
        .get()
        .then((value) => StoryDataService.isLiked = value.exists);

    await FirebaseFirestore.instance
        .collection(
            'Users/${FirebaseAuth.instance.currentUser?.uid}/Subscriptions/')
        .doc(StoryDataService.userId)
        .get()
        .then((DocumentSnapshot value) {
      StoryDataService.imSubscribedOnThisUser = value.exists;
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(StoryDataService.userId)
        .get()
        .then((DocumentSnapshot doc) {
      StoryDataService.userToken = doc.get('deviceToken');
    });

    await FirebaseFirestore.instance
        .collection('Users/${StoryDataService.userId}/Subscribers/')
        .get()
        .then((QuerySnapshot value) {
      StoryDataService.subscribersCount =
          FirestoreService().getCompactNumber(value.docs.length);
    });

    await FirebaseFirestore.instance
        .collection('Storys')
        .doc(StoryDataService.storyId)
        .get()
        .then((value) {
      StoryDataService.commentsCount = value.get('comments');
    });

    await FirebaseFirestore.instance
        .collection('Storys')
        .doc(StoryDataService.storyId)
        .get()
        .then((value) {
      StoryDataService.likes = value.get('likes');
    });

    await FirebaseFirestore.instance
        .collection('Storys')
        .doc(StoryDataService.storyId)
        .get()
        .then((value) {
      StoryDataService.views = value.get('views');
    });
  }
}
