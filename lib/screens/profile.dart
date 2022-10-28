import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_story/screens/profile_draft.dart';
import 'package:my_story/screens/profile_likes.dart';
import 'package:my_story/screens/settings.dart' as _settings;
import 'package:my_story/screens/story.dart';
import 'package:my_story/services/firestore_service.dart';
import 'package:my_story/services/storage_service.dart';
import 'package:my_story/services/story_data_service.dart';
import 'package:my_story/services/user.dart';
import 'package:shimmer/shimmer.dart';

import '../generated/l10n.dart';

class Profile extends StatefulWidget {
  const Profile(
      {Key? key,
      this.isMyProfile = true,
      this.isActiveBackButton = false,
      this.userId = '',
      this.userName = ''})
      : super(key: key);

  final bool isMyProfile;
  final bool isActiveBackButton;
  final String userId;
  final String userName;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = false;
  bool isLoadingImage = false;
  bool isLoadingSubscribe = false;
  bool sortByDate = true;

  String? pathImage;

  @override
  void initState() {
    super.initState();

    if (widget.isMyProfile) {
      FirestoreService().getAllMyData();
    } else {
      FirebaseFirestore.instance
          .collection(
              'Users/${FirebaseAuth.instance.currentUser?.uid}/Subscriptions/')
          .doc(widget.userId)
          .get()
          .then((DocumentSnapshot value) {
        setState(() {
          StoryDataService.imSubscribedOnThisUser = value.exists;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              elevation: 0,
              toolbarHeight: 76,
              backgroundColor: Colors.transparent,
              title: Row(
                children: [
                  widget.isActiveBackButton
                      ? IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.black87.withOpacity(0.7),
                            size: 30,
                          ))
                      : Container(),
                  widget.isActiveBackButton
                      ? const SizedBox(
                          width: 20,
                        )
                      : Container(),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: widget.isMyProfile
                              ? Text(
                                  UserData.userName,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87.withOpacity(0.7),
                                  )),
                                )
                              : FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(widget.userId)
                                      .get(),
                                  builder: (cont,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    return Text(
                                      snapshot.data?.get('name') ?? '',
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87.withOpacity(0.7),
                                      )),
                                    );
                                  }),
                        ),
                        //const SizedBox(width: 5.0),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                widget.isMyProfile
                    ? Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 15.0),
                            child: CircleAvatar(
                              radius: 25,
                              child: Material(
                                borderRadius: BorderRadius.circular(100.0),
                                clipBehavior: Clip.antiAlias,
                                color: Colors.redAccent,
                                child: SizedBox(
                                  width: 100,
                                  height: 50,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MyLikesScreen()));
                                    },
                                    child: const Icon(
                                      Icons.favorite_rounded,
                                      size: 25,
                                    ),
                                  ),
                                ),
                                shadowColor: Colors.black,
                                elevation: 5,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 15.0),
                            child: CircleAvatar(
                              radius: 25,
                              child: Material(
                                borderRadius: BorderRadius.circular(100.0),
                                clipBehavior: Clip.antiAlias,
                                color: Colors.blue,
                                child: SizedBox(
                                  width: 100,
                                  height: 50,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MyDraftScreen()));
                                    },
                                    child: const Icon(
                                      Icons.drafts_rounded,
                                      size: 25,
                                    ),
                                  ),
                                ),
                                shadowColor: Colors.black,
                                elevation: 5,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 15.0),
                            child: CircleAvatar(
                              radius: 25,
                              child: Material(
                                borderRadius: BorderRadius.circular(100.0),
                                clipBehavior: Clip.antiAlias,
                                color: Colors.blueGrey,
                                child: SizedBox(
                                  width: 100,
                                  height: 50,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const _settings.Settings()));
                                    },
                                    child: const Icon(
                                      Icons.settings_rounded,
                                      size: 25,
                                    ),
                                  ),
                                ),
                                shadowColor: Colors.black,
                                elevation: 5,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        margin: const EdgeInsets.all(15.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(15.0),
                          clipBehavior: Clip.antiAlias,
                          color: !StoryDataService.imSubscribedOnThisUser
                              ? Colors.redAccent
                              : Colors.blueGrey,
                          child: InkWell(
                            onTap: () async {
                              if (isLoadingSubscribe) return;
                              setState(() {
                                isLoadingSubscribe = true;
                              });
                              if (!StoryDataService.imSubscribedOnThisUser) {
                                await FirestoreService().subscribe(
                                    widget.isMyProfile
                                        ? FirebaseAuth.instance.currentUser!.uid
                                        : widget.userId);
                                setState(() {
                                  StoryDataService.imSubscribedOnThisUser =
                                      true;
                                });
                                await FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(widget.userId)
                                    .collection('Subscribers')
                                    .get()
                                    .then((QuerySnapshot value) {
                                  StoryDataService.subscribersCount =
                                      FirestoreService()
                                          .getCompactNumber(value.docs.length);
                                });
                              } else {
                                await FirestoreService().unsubscribe(
                                    widget.isMyProfile
                                        ? FirebaseAuth.instance.currentUser!.uid
                                        : widget.userId);
                                setState(() {
                                  StoryDataService.imSubscribedOnThisUser =
                                      false;
                                });
                                await FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(widget.userId)
                                    .collection('Subscribers')
                                    .get()
                                    .then((QuerySnapshot value) {
                                  StoryDataService.subscribersCount =
                                      FirestoreService()
                                          .getCompactNumber(value.docs.length);
                                });
                              }
                              setState(() {
                                isLoadingSubscribe = false;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                  right: 14.0,
                                  left: 14.0),
                              child: Center(
                                child: isLoadingSubscribe
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3.5,
                                        ),
                                      )
                                    : Text(
                                        StoryDataService.imSubscribedOnThisUser
                                            ? S
                                                .of(context)
                                                .profile_buttonUnsubscribe
                                            : S
                                                .of(context)
                                                .profile_buttonSubscribe,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                          letterSpacing: 0.5,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        )),
                                      ),
                              ),
                            ),
                          ),
                          shadowColor: Colors.black,
                          elevation: 5,
                        ),
                      ),
              ],
            ),
            body: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 65,
                          child: Material(
                            borderRadius: BorderRadius.circular(100.0),
                            clipBehavior: Clip.antiAlias,
                            shadowColor: Colors.black,
                            elevation: 5,
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: isLoadingImage
                                    ? const Center(
                                        child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 6.0,
                                          color: Colors.blue,
                                        ),
                                      ))
                                    : widget.isMyProfile
                                        ? InkWell(
                                            onTap: () async {
                                              final results = await FilePicker
                                                  .platform
                                                  .pickFiles(
                                                      allowMultiple: false,
                                                      type: FileType.custom,
                                                      allowedExtensions: [
                                                    'jpg',
                                                    'png'
                                                  ]);

                                              if (results == null) {
                                                return;
                                              }

                                              if (results.files.first.path!
                                                  .isNotEmpty) {
                                                setState(() {
                                                  isLoadingImage = true;
                                                  pathImage = results
                                                      .files.first.path
                                                      .toString();
                                                  UserData.userImageFile = File(
                                                      results.files.first.path
                                                          .toString());
                                                });

                                                await StorageService()
                                                    .uploadImage(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        UserData
                                                            .userImageFile!.path
                                                            .toString());

                                                setState(() {
                                                  isLoadingImage = false;
                                                });
                                              }
                                            },
                                            child: FutureBuilder(
                                                future: FirestoreService()
                                                    .getAvatarImage(FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Shimmer.fromColors(
                                                        baseColor:
                                                            Colors.grey[300]!,
                                                        highlightColor:
                                                            Colors.grey[100]!,
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              Colors.grey[300],
                                                        ));
                                                  }

                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    return ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      child: snapshot.data !=
                                                              null
                                                          ? snapshot.data
                                                              as CachedNetworkImage
                                                          : const Icon(
                                                              Icons.person,
                                                              size: 50,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                    );
                                                  }

                                                  return const Center(
                                                      child: SizedBox(
                                                    width: 40,
                                                    height: 40,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 6.0,
                                                      color: Colors.blue,
                                                    ),
                                                  ));
                                                }))
                                        : FutureBuilder(
                                            future: FirestoreService()
                                                .getAvatarImage(widget.userId),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey[300]!,
                                                    highlightColor:
                                                        Colors.grey[100]!,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.grey[300],
                                                    ));
                                              }

                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                return ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  child: snapshot.data != null
                                                      ? snapshot.data
                                                          as CachedNetworkImage
                                                      : const Icon(
                                                          Icons.person,
                                                          size: 50,
                                                          color: Colors.blue,
                                                        ),
                                                );
                                              }

                                              return const Center(
                                                  child: SizedBox(
                                                width: 40,
                                                height: 40,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 6.0,
                                                  color: Colors.blue,
                                                ),
                                              ));
                                            }),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(20.0),
                            clipBehavior: Clip.antiAlias,
                            shadowColor: Colors.black,
                            child: InkWell(
                              onTap: () {},
                              child: SizedBox(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.people_rounded,
                                          color: Colors.blue,
                                          size: 30,
                                        ),
                                        const SizedBox(width: 10.0),
                                        FutureBuilder<DocumentSnapshot>(
                                            future: FirebaseFirestore.instance
                                                .collection('Users')
                                                .doc(widget.isMyProfile
                                                    ? FirebaseAuth.instance
                                                        .currentUser?.uid
                                                    : widget.userId)
                                                .get(),
                                            builder: (context,
                                                AsyncSnapshot<DocumentSnapshot>
                                                    snapshot) {
                                              return Text(
                                                FirestoreService()
                                                    .getCompactNumber(
                                                        snapshot.data?.get(
                                                                'subscribers') ??
                                                            0),
                                                style: GoogleFonts.roboto(
                                                    textStyle: TextStyle(
                                                  letterSpacing: 0.5,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black87
                                                      .withOpacity(0.7),
                                                )),
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Material(
                            borderRadius: BorderRadius.circular(20.0),
                            clipBehavior: Clip.antiAlias,
                            shadowColor: Colors.black,
                            child: InkWell(
                              onTap: () {},
                              child: SizedBox(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.library_books_rounded,
                                          color: Colors.blue,
                                          size: 30,
                                        ),
                                        const SizedBox(width: 10.0),
                                        FutureBuilder<DocumentSnapshot>(
                                            future: FirebaseFirestore.instance
                                                .collection('Users')
                                                .doc(widget.isMyProfile
                                                    ? FirebaseAuth.instance
                                                        .currentUser?.uid
                                                    : widget.userId)
                                                .get(),
                                            builder: (context,
                                                AsyncSnapshot<DocumentSnapshot>
                                                    snapshot) {
                                              return Text(
                                                FirestoreService()
                                                    .getCompactNumber(snapshot
                                                            .data
                                                            ?.get('stories') ??
                                                        0),
                                                style: GoogleFonts.roboto(
                                                    textStyle: TextStyle(
                                                  letterSpacing: 0.5,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black87
                                                      .withOpacity(0.7),
                                                )),
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10.0),
                      FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('Users')
                              .doc(widget.isMyProfile
                                  ? FirebaseAuth.instance.currentUser!.uid
                                  : widget.userId)
                              .get(),
                          builder:
                              (cont, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            return snapshot.data?.get('verification') == true
                                ? Icon(Icons.star_rounded,
                                    color: Colors.yellow.shade700,
                                    size: 50,
                                    shadows: [
                                        BoxShadow(
                                            color: Colors.yellow.shade700,
                                            blurRadius: 8,
                                            blurStyle: BlurStyle.inner)
                                      ])
                                : Container();
                          }),
                    ],
                  ),
                ),
                showMyStorys()
              ],
            )),
      ),
    );
  }

  Widget showMyStorys() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Storys')
            .where('userId',
                isEqualTo: widget.isMyProfile
                    ? FirebaseAuth.instance.currentUser!.uid
                    : widget.userId)
            .orderBy('date', descending: sortByDate)
            .snapshots(),
        builder: (cont, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                S.of(context).notification_titleError,
                style: TextStyle(
                  color: Colors.black87.withOpacity(0.5),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 6.0,
              ),
            ));
          }

          return snapshot.data!.docs.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 20.0),
                    child: Text(
                      widget.isMyProfile
                          ? S.of(context).profile_iDontHaveStories
                          : S.of(context).profile_userHasNoStories,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                        letterSpacing: 0.5,
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87.withOpacity(0.5),
                      )),
                    ),
                  ),
                )
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (cont2, int index) {
                    bool isNew = false;
                    String date = '';

                    final format = DateFormat('MM.dd.yyyy HH:mm:ss');

                    DateTime dt1 =
                        format.parse(snapshot.data?.docs[index].get('date'));
                    DateTime dt2 = format.parse(
                        '${DateTime.now().month}.${DateTime.now().day}.${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}');

                    if ((dt2.difference(dt1).inHours).abs() < 24) {
                      isNew = true;
                    }

                    switch ((dt2.difference(dt1).inDays).abs()) {
                      case 0:
                        date = S.of(context).story_dateToday;
                        break;
                      case 1:
                        date = S.of(context).story_dateYesterday;
                        break;
                      case 2:
                        date = S.of(context).story_dateDayBeforeYesterday;
                        break;
                      case 3:
                        date = S.of(context).story_dateThreeDaysAgo;
                        break;
                      case 4:
                        date = S.of(context).story_dateFourDaysAgo;
                        break;
                      case 5:
                        date = S.of(context).story_dateFiveDaysAgo;
                        break;
                      case 6:
                        date = S.of(context).story_dateSixDaysAgo;
                        break;
                    }

                    if (((dt2.difference(dt1).inHours / 24).abs()).round() >=
                            7 &&
                        ((dt2.difference(dt1).inHours / 24).abs()).round() <
                            14) {
                      date = S.of(context).story_dateWeekAgo;
                    }

                    if (((dt2.difference(dt1).inHours / 24).abs()).round() >=
                            14 &&
                        ((dt2.difference(dt1).inHours / 24).abs()).round() <
                            21) {
                      date = S.of(context).story_dateTwoWeeksAgo;
                    }

                    if (((dt2.difference(dt1).inHours / 24).abs()).round() >=
                            21 &&
                        ((dt2.difference(dt1).inHours / 24).abs()).round() <
                            28) {
                      date = S.of(context).story_dateThreeWeeksAgo;
                    }

                    if (((dt2.difference(dt1).inHours / 24).abs()).round() >=
                        28) {
                      date = snapshot.data?.docs[index].get('date');
                    }

                    return Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15.0)),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.3),
                                blurStyle: BlurStyle.outer)
                          ]),
                      margin: const EdgeInsets.only(
                          left: 15.0, right: 15.0, bottom: 15.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(15.0),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(cont2).push(MaterialPageRoute(
                                builder: (context) => Story(
                                    isActiveBackButton: true,
                                    specificStory: snapshot.data?.docs[index]
                                        .get('storyId'))));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      date,
                                      style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                        letterSpacing: 0.5,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87.withOpacity(0.7),
                                      )),
                                    ),
                                    if (isNew)
                                      Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 10,
                                                  color: Colors.redAccent
                                                      .withOpacity(0.8),
                                                  blurStyle: BlurStyle.normal)
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: Colors.redAccent),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            S.of(context).story_newStoryText,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.roboto(
                                                textStyle: const TextStyle(
                                              letterSpacing: 0.5,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            )),
                                          ),
                                        ),
                                      )
                                    else
                                      Container(),
                                  ],
                                ),
                                const SizedBox(height: 5.0),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    snapshot.data?.docs[index].get('title'),
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                      letterSpacing: 0.5,
                                      fontSize: 21,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87.withOpacity(0.7),
                                    )),
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        snapshot.data!.docs[index]
                                                    .get('forAdults') ==
                                                true
                                            ? Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10.0),
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 10,
                                                          color: Colors
                                                              .redAccent
                                                              .withOpacity(0.8),
                                                          blurStyle:
                                                              BlurStyle.normal)
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    color: Colors.redAccent),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '18+',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.roboto(
                                                        textStyle:
                                                            const TextStyle(
                                                      letterSpacing: 0.5,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white,
                                                    )),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        const Icon(Icons.favorite_rounded,
                                            color: Colors.redAccent, size: 20),
                                        const SizedBox(width: 5.0),
                                        Text(
                                          FirestoreService().getCompactNumber(
                                              snapshot.data!.docs[index]
                                                  .get('likes')),
                                          style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                            letterSpacing: 0.5,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color:
                                                Colors.black87.withOpacity(0.7),
                                          )),
                                        )
                                      ],
                                    ),
                                    const SizedBox(width: 10.0),
                                    Row(
                                      children: [
                                        const Icon(Icons.remove_red_eye_rounded,
                                            color: Colors.blueGrey, size: 20),
                                        const SizedBox(width: 5.0),
                                        Text(
                                          FirestoreService().getCompactNumber(
                                              snapshot.data!.docs[index]
                                                  .get('views')),
                                          style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                            letterSpacing: 0.5,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color:
                                                Colors.black87.withOpacity(0.7),
                                          )),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 10.0),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time_filled_rounded,
                                            color: Colors.blue.withOpacity(0.8),
                                            size: 20),
                                        const SizedBox(width: 5.0),
                                        Text(
                                          '~${(snapshot.data!.docs[index].get('story').toString().length / 190).round()} ${S.of(context).story_readTimeMinutes}',
                                          style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                            letterSpacing: 0.5,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color:
                                                Colors.black87.withOpacity(0.7),
                                          )),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
        });
  }
}
