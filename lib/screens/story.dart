import 'dart:async';
import 'dart:math';

import 'package:appodeal_flutter/appodeal_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_story/screens/new_story.dart';
import 'package:my_story/screens/profile.dart';
import 'package:my_story/services/story_data_service.dart';
import 'package:my_story/services/user_local_data.dart';

import '../generated/l10n.dart';
import '../services/user.dart';
import 'comments.dart';
import '../models/popup.dart';
import '../services/firebase_story_service.dart';
import '../services/firestore_service.dart';

class Story extends StatefulWidget {
  const Story(
      {Key? key, this.specificStory = '', this.isActiveBackButton = false})
      : super(key: key);

  final String specificStory;
  final bool isActiveBackButton;

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {
  bool acceptReadStory = false;
  bool isLoading = false;
  bool isLoadingLikeStory = false;
  bool isLoadedAd = false;
  bool isLoadedStory = false;
  bool isLikedStory = false;
  bool isNoMoreStorys = false;
  bool isReadedStory = false;
  bool isSearchingStory = true;
  String lastStory = '';

  FontWeight fontWeight = FontWeight.w700;

  ScrollController storyScrollController = ScrollController();

  Future initAppodeal() async {
    await Appodeal.initialize(hasConsent: true, adTypes: [AdType.nonSkippable]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future initStorySettings() async {
    await UserLocalData().getTextSettings();

    switch (UserLocalData.textFontWeight) {
      case '':
        setState(() {
          fontWeight = FontWeight.w700;
        });
        break;
      case 'w900':
        setState(() {
          fontWeight = FontWeight.w900;
        });
        break;
      case 'w800':
        setState(() {
          fontWeight = FontWeight.w800;
        });
        break;
      case 'w700':
        setState(() {
          fontWeight = FontWeight.w700;
        });
        break;
      case 'w600':
        setState(() {
          fontWeight = FontWeight.w600;
        });
        break;
      case 'w500':
        setState(() {
          fontWeight = FontWeight.w500;
        });
        break;
      case 'w400':
        setState(() {
          fontWeight = FontWeight.w400;
        });
        break;
      case 'w300':
        setState(() {
          fontWeight = FontWeight.w300;
        });
        break;
      case 'w200':
        setState(() {
          fontWeight = FontWeight.w200;
        });
        break;
      case 'w100':
        setState(() {
          fontWeight = FontWeight.w100;
        });
        break;
    }

    await UserLocalData().getStorysLanguage().whenComplete(() async {
      await UserLocalData().getUserInterests().whenComplete(() async {
        await loadStory();
      });
    });
    await initAppodeal();
  }

  @override
  void initState() {
    super.initState();
    initStorySettings();
  }

  showAd() async {
    var isready = await Appodeal.isReadyForShow(AdType.nonSkippable);
    if (!isready) {
      return;
    } else {
      await Appodeal.show(AdType.nonSkippable);
    }
  }

  @override
  Widget build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: widget.isActiveBackButton || acceptReadStory
            ? AppBar(
                elevation: 0,
                toolbarHeight: 76,
                backgroundColor: Colors.transparent,
                title: widget.isActiveBackButton
                    ? isLoading
                        ? Container()
                        : IconButton(
                            onPressed: () {
                              if (!acceptReadStory) {
                                Navigator.of(context).pop();
                              } else {
                                setStateIfMounted(() {
                                  acceptReadStory = false;
                                });
                              }
                            },
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.black87.withOpacity(0.7),
                              size: 30,
                            ))
                    : acceptReadStory
                        ? IconButton(
                            onPressed: () {
                              setStateIfMounted(() {
                                acceptReadStory = false;
                              });
                            },
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.black87.withOpacity(0.7),
                              size: 30,
                            ))
                        : Container(),
                actions: isLoading || !acceptReadStory
                    ? [Container()]
                    : [
                        Visibility(
                          visible: StoryDataService.userId ==
                                  FirebaseAuth.instance.currentUser?.uid
                              ? true
                              : false,
                          child: Container(
                            margin: const EdgeInsets.only(right: 15.0),
                            child: CircleAvatar(
                              radius: 25,
                              child: Material(
                                borderRadius: BorderRadius.circular(100.0),
                                clipBehavior: Clip.antiAlias,
                                color: Colors.orange,
                                child: SizedBox(
                                  width: 100,
                                  height: 50,
                                  child: InkWell(
                                    onTap: () => showBottomSheetAuthorTools(),
                                    child: const Icon(
                                      Icons.settings,
                                      size: 25,
                                    ),
                                  ),
                                ),
                                shadowColor: Colors.black,
                                elevation: 5,
                              ),
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
                                  onTap: () => showBottomSheetMoreTools(),
                                  child: const Icon(
                                    Icons.more_horiz,
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
                              color: const Color.fromARGB(255, 89, 192, 93),
                              child: SizedBox(
                                width: 100,
                                height: 50,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CommentsScreen()));
                                  },
                                  child: const Icon(
                                    Icons.comment_rounded,
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
                              color: Colors.redAccent,
                              child: SizedBox(
                                width: 100,
                                height: 50,
                                child: InkWell(
                                  onTap: () async {
                                    if (isLoadingLikeStory) return;
                                    setStateIfMounted(() {
                                      isLoadingLikeStory = true;
                                    });
                                    await FirestoreService().setStoryLike();
                                    setStateIfMounted(() {
                                      isLikedStory = StoryDataService.isLiked;
                                      isLoadingLikeStory = false;
                                    });
                                  },
                                  child: isLoadingLikeStory
                                      ? const Center(
                                          child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 3.5,
                                              color: Colors.white),
                                        ))
                                      : Icon(
                                          isLikedStory ||
                                                  StoryDataService.isLiked
                                              ? Icons.favorite_rounded
                                              : Icons.favorite_outline_rounded,
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
            : null,
        body: isLoading
            ? const Center(
                child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 6.0,
                ),
              ))
            : acceptReadStory
                ? NotificationListener<ScrollUpdateNotification>(
                    onNotification: (notification) {
                      if (!isReadedStory) {
                        if (notification.metrics.pixels + 30 <
                            storyScrollController.position.maxScrollExtent) {
                          UserLocalData().saveCurrentStoryId(
                              '${StoryDataService.storyId} ${notification.metrics.pixels}');
                        } else {
                          isReadedStory = true;
                          UserLocalData().removeLastStoryId();
                        }
                      }
                      return true;
                    },
                    child: ListView(
                      controller: storyScrollController,
                      children: [
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(
                              left: 15.0, right: 15.0, bottom: 15.0, top: 15.0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15.0)),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.3),
                                    blurStyle: BlurStyle.outer)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                                top: 15.0,
                                bottom: 15.0),
                            child: Text(
                              StoryDataService.story,
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                letterSpacing:
                                    UserLocalData.storyTextLetterSpacing,
                                wordSpacing: UserLocalData.storyTextWordSpacing,
                                fontSize: UserLocalData.storyTextSize,
                                fontWeight: fontWeight,
                                color: Color.fromARGB(
                                    UserLocalData.storyTextColorA,
                                    UserLocalData.storyTextColorR,
                                    UserLocalData.storyTextColorG,
                                    UserLocalData.storyTextColorB),
                              )),
                            ),
                          ),
                        ),
                        widget.specificStory.isNotEmpty
                            ? Container()
                            : Container(
                                height: 60,
                                margin: const EdgeInsets.only(
                                    left: 15.0, right: 15.0, bottom: 15.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(15.0),
                                  clipBehavior: Clip.antiAlias,
                                  color: const Color.fromARGB(255, 89, 192, 93),
                                  child: InkWell(
                                    onTap: () {
                                      setStateIfMounted(() {
                                        acceptReadStory = false;
                                      });
                                      loadStory();
                                    },
                                    child: Center(
                                      child: Text(
                                        S.of(context).register_buttonNext,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                          letterSpacing: 0.5,
                                          fontSize: 23,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        )),
                                      ),
                                    ),
                                  ),
                                  shadowColor: Colors.black,
                                  elevation: 5,
                                ),
                              ),
                      ],
                    ),
                  )
                : !isNoMoreStorys
                    ? SafeArea(
                        child: Center(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 30.0, bottom: 30.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(
                                        left: 30.0, right: 30.0),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15.0)),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 10,
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              blurStyle: BlurStyle.outer)
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                          top: 20.0,
                                          bottom: 15.0),
                                      child: Column(
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10.0),
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      child: Text(
                                                        '${StoryDataService.userName} • ${StoryDataService.date.split(' ')[0]}',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style:
                                                            GoogleFonts.roboto(
                                                                textStyle:
                                                                    TextStyle(
                                                          letterSpacing: 0.5,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.black87
                                                              .withOpacity(0.7),
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20.0),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Text(
                                                        StoryDataService.title,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.roboto(
                                                                textStyle:
                                                                    TextStyle(
                                                          letterSpacing: 0.5,
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.black87
                                                              .withOpacity(0.7),
                                                        )),
                                                      )),
                                                ],
                                              )),
                                          const SizedBox(height: 5.0),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0,
                                                right: 10.0,
                                                top: 15.0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            blurRadius: 10,
                                                            color: Colors
                                                                .redAccent
                                                                .withOpacity(
                                                                    0.3),
                                                            blurStyle:
                                                                BlurStyle.outer)
                                                      ],
                                                      border: Border.all(
                                                          color: Colors
                                                              .redAccent
                                                              .withOpacity(0.5),
                                                          width: 5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: storyDetail(
                                                        valueName: S
                                                            .of(context)
                                                            .story_textLikes,
                                                        icon: Icons
                                                            .favorite_rounded,
                                                        value: FirestoreService()
                                                            .getCompactNumber(
                                                                StoryDataService
                                                                    .likes),
                                                        iconColor:
                                                            Colors.redAccent),
                                                  ),
                                                ),
                                                const SizedBox(height: 20.0),
                                                Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 10,
                                                          color: Colors
                                                              .orangeAccent
                                                              .withOpacity(0.3),
                                                          blurStyle:
                                                              BlurStyle.outer)
                                                    ],
                                                    border: Border.all(
                                                        color: Colors
                                                            .orangeAccent
                                                            .withOpacity(0.5),
                                                        width: 5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: storyDetail(
                                                        valueName: S
                                                            .of(context)
                                                            .story_textViewed,
                                                        icon: Icons
                                                            .remove_red_eye_rounded,
                                                        value: FirestoreService()
                                                            .getCompactNumber(
                                                                StoryDataService
                                                                    .views),
                                                        iconColor:
                                                            Colors.orange),
                                                  ),
                                                ),
                                                const SizedBox(height: 20.0),
                                                Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            blurRadius: 10,
                                                            color: Colors
                                                                .blueAccent
                                                                .withOpacity(
                                                                    0.3),
                                                            blurStyle:
                                                                BlurStyle.outer)
                                                      ],
                                                      border: Border.all(
                                                          color: Colors
                                                              .blueAccent
                                                              .withOpacity(0.5),
                                                          width: 5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: storyDetail(
                                                        valueName: S
                                                            .of(context)
                                                            .story_textTime,
                                                        icon: Icons
                                                            .access_time_filled_rounded,
                                                        value:
                                                            '~${StoryDataService.readTime.round().toString()} ${S.of(context).story_readTimeMinutes}',
                                                        iconColor:
                                                            Colors.blueAccent),
                                                  ),
                                                ),
                                                const SizedBox(height: 5.0),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 60,
                                            margin: const EdgeInsets.only(
                                                left: 10.0,
                                                right: 10.0,
                                                bottom: 10.0,
                                                top: 15.0),
                                            child: Material(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              clipBehavior: Clip.antiAlias,
                                              color: const Color.fromARGB(
                                                  255, 89, 192, 93),
                                              child: InkWell(
                                                onTap: () async {
                                                  setStateIfMounted(() {
                                                    acceptReadStory = true;
                                                  });

                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('Storys')
                                                      .doc(StoryDataService
                                                          .storyId)
                                                      .collection('Readers')
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                      .get()
                                                      .then((value) async {
                                                    if (!value.exists) {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('Storys')
                                                          .doc(StoryDataService
                                                              .storyId)
                                                          .collection('Readers')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .set({
                                                        'userId': FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid,
                                                      }).whenComplete(() {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'Storys')
                                                            .doc(
                                                                StoryDataService
                                                                    .storyId)
                                                            .update({
                                                          "views": FieldValue
                                                              .increment(1)
                                                        });
                                                      });
                                                    }
                                                  });
                                                },
                                                child: Center(
                                                  child: Text(
                                                    S
                                                        .of(context)
                                                        .story_buttonReadStory,
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.roboto(
                                                        textStyle:
                                                            const TextStyle(
                                                      letterSpacing: 0.5,
                                                      fontSize: 23,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white,
                                                    )),
                                                  ),
                                                ),
                                              ),
                                              shadowColor: Colors.black,
                                              elevation: 5,
                                            ),
                                          ),
                                          widget.specificStory.isNotEmpty
                                              ? Container()
                                              : Container(
                                                  height: 60,
                                                  margin: const EdgeInsets.only(
                                                      left: 10.0,
                                                      right: 10.0,
                                                      bottom: 10.0,
                                                      top: 10.0),
                                                  child: Material(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    color: Colors.red,
                                                    child: InkWell(
                                                      onTap: () {
                                                        loadStory();
                                                      },
                                                      child: Center(
                                                        child: Text(
                                                          S
                                                              .of(context)
                                                              .register_buttonNext,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  textStyle:
                                                                      const TextStyle(
                                                            letterSpacing: 0.5,
                                                            fontSize: 23,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.white,
                                                          )),
                                                        ),
                                                      ),
                                                    ),
                                                    shadowColor: Colors.black,
                                                    elevation: 5,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  lastStory.isNotEmpty
                                      ? Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(
                                              left: 30.0,
                                              right: 30.0,
                                              top: 20.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(15.0)),
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 10,
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    blurStyle: BlurStyle.outer)
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0,
                                                right: 15.0,
                                                top: 15.0,
                                                bottom: 15.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  S.of(context).story_lastStory,
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                    letterSpacing: 0.5,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black87
                                                        .withOpacity(0.7),
                                                  )),
                                                ),
                                                const SizedBox(height: 15.0),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Material(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        shadowColor:
                                                            Colors.black,
                                                        color: Colors.redAccent,
                                                        elevation: 5,
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              lastStory = '';
                                                            });
                                                            UserLocalData()
                                                                .removeLastStoryId();
                                                          },
                                                          child: SizedBox(
                                                            child: Center(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        12.0),
                                                                child: Text(
                                                                  S
                                                                      .of(context)
                                                                      .notification_buttonNo,
                                                                  style: GoogleFonts
                                                                      .roboto(
                                                                          textStyle:
                                                                              const TextStyle(
                                                                    letterSpacing:
                                                                        0.5,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 15.0),
                                                    Expanded(
                                                      child: Material(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        shadowColor:
                                                            Colors.black,
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 89, 192, 93),
                                                        elevation: 5,
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.of(context).push(MaterialPageRoute(
                                                                builder: (context) => Story(
                                                                    specificStory:
                                                                        lastStory.split(' ')[
                                                                            0],
                                                                    isActiveBackButton:
                                                                        true)));
                                                          },
                                                          child: SizedBox(
                                                            child: Center(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        12.0),
                                                                child: Text(
                                                                  S
                                                                      .of(context)
                                                                      .notification_buttonYes,
                                                                  style: GoogleFonts
                                                                      .roboto(
                                                                          textStyle:
                                                                              const TextStyle(
                                                                    letterSpacing:
                                                                        0.5,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Text(
                              S.of(context).story_noStorysTitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                letterSpacing: 0.5,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87.withOpacity(0.7),
                              )),
                            ),
                          ),
                          Container(
                            height: 60,
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                bottom: 20.0,
                                top: 20.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(15.0),
                              clipBehavior: Clip.antiAlias,
                              color: const Color.fromARGB(255, 89, 192, 93),
                              child: InkWell(
                                onTap: () async {
                                  setStateIfMounted(() {
                                    acceptReadStory = false;
                                    lastStory = '';
                                  });
                                  await loadStory();
                                },
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.refresh_rounded,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      const SizedBox(width: 10.0),
                                      Text(
                                        S
                                            .of(context)
                                            .story_noStorysButtonUpdate,
                                        style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                          letterSpacing: 0.5,
                                          fontSize: 23,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              shadowColor: Colors.black,
                              elevation: 5,
                            ),
                          ),
                          Container(
                            height: 60,
                            margin: const EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 20.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(15.0),
                              clipBehavior: Clip.antiAlias,
                              color: Colors.blue,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const NewStory(
                                          isActiveBackButton: true)));
                                },
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.add_rounded,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      const SizedBox(width: 10.0),
                                      Text(
                                        S
                                            .of(context)
                                            .story_noStorysButtonNewStory,
                                        style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                          letterSpacing: 0.5,
                                          fontSize: 23,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              shadowColor: Colors.black,
                              elevation: 5,
                            ),
                          ),
                        ],
                      ),
      ),
    );
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  Future loadStory() async {
    try {
      setStateIfMounted(() {
        isLoading = true;
      });

      if (widget.specificStory.isEmpty && lastStory.isEmpty) {
        isSearchingStory = true;

        //while (isSearchingStory) {
        QuerySnapshot collection = await FirebaseFirestore.instance
            .collection('Storys')
            .where('storyLanguage', isEqualTo: UserData.storysLanguage)
            .where('interests', arrayContainsAny: UserData.myInterests)
            .get();

        if (collection.docs.isEmpty) {
          setStateIfMounted(() {
            isLoading = false;
            isNoMoreStorys = true;
          });
          return;
        }

        var random = Random().nextInt(collection.docs.length);
        DocumentSnapshot currentStoryDoc = collection.docs[random];

        await FirebaseFirestore.instance
            .collection('Storys')
            .doc(currentStoryDoc.get('storyId'))
            .get()
            .then((value) {
          StoryDataService.storyId = value.get('storyId');
          StoryDataService.title = value.get('title');
          StoryDataService.story = value.get('story');
          StoryDataService.userId = value.get('userId');
          StoryDataService.date = value.get('date');
          StoryDataService.userName = value.get('userName');
          StoryDataService.commentsAccess = value.get('commentsAccess');
          StoryDataService.forAdults = value.get('forAdults');
          StoryDataService.interests = value.get('interests');
          StoryDataService.storyLanguage = value.get('storyLanguage');
        });

        /*await FirebaseFirestore.instance
            .collection('Storys')
            .doc(currentStoryDoc.get('storyId'))
            .collection('Readers')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get()
            .then((value) async {
          if (!value.exists) {
            await FirebaseFirestore.instance
                .collection('Storys')
                .doc(currentStoryDoc.get('storyId'))
                .get()
                .then((value) {
              StoryDataService.storyId = value.get('storyId');
              StoryDataService.title = value.get('title');
              StoryDataService.story = value.get('story');
              StoryDataService.userId = value.get('userId');
              StoryDataService.date = value.get('date');
              StoryDataService.userName = value.get('userName');
              StoryDataService.commentsAccess = value.get('commentsAccess');

              /*await FirebaseFirestore.instance
                    .collection('Storys')
                    .doc(StoryDataService.storyId)
                    .collection('Readers')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .set({
                  'userId': FirebaseAuth.instance.currentUser!.uid,
                });*/
            });
          }
        });*/
        //}
      } else {
        Stream<DocumentSnapshot> story = FirebaseFirestore.instance
            .collection('Storys')
            .doc(widget.specificStory)
            .snapshots();

        story.forEach((element) async {
          StoryDataService.userId = await element.get('userId');
          StoryDataService.title = await element.get('title');
          StoryDataService.story = await element.get('story');
          StoryDataService.storyId = await element.get('storyId');
          StoryDataService.date = await element.get('date');
          StoryDataService.commentsAccess = await element.get('commentsAccess');
          StoryDataService.forAdults = await element.get('forAdults');
          StoryDataService.userName = await element.get('userName');
          StoryDataService.interests = await element.get('interests');
          StoryDataService.storyLanguage = await element.get('storyLanguage');
        });
      }

      await StoryService().loadAdditionalInfoStory();

      await UserLocalData().getLastStoryId().then((value) {
        if (value.isNotEmpty) {
          setStateIfMounted(() {
            lastStory = value;
            storyScrollController = ScrollController(
                initialScrollOffset: double.parse(lastStory.split(' ')[1]));
          });
        }
      });

      setStateIfMounted(() {
        isLoading = false;
        isNoMoreStorys = false;
      });

      StoryDataService.readTime = StoryDataService.story.length / 190;

      if (!kDebugMode) {
        if (StoryDataService.clicksToAd > 1) {
          StoryDataService.clicksToAd--;
        } else {
          StoryDataService.clicksToAd = 15;
          showAd();
        }
      }

      if (lastStory.split(' ')[0] == StoryDataService.storyId) {
        setStateIfMounted(() {
          lastStory = '';
        });
      }
    } on FirebaseException catch (e) {
      print('FIREBASE EXCEPTION: ${e.message}');
      popUpDialog(
          context: context,
          title: S.of(context).notification_titleError,
          content: S.of(context).notification_titleError,
          buttons: [
            SizedBox(
              height: 50,
              width: 70,
              child: Material(
                borderRadius: BorderRadius.circular(15.0),
                clipBehavior: Clip.antiAlias,
                color: Colors.blue,
                child: InkWell(
                  onTap: () => Navigator.of(context, rootNavigator: true),
                  child: Center(
                    child: Text(
                      S.of(context).notification_buttonOK,
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
                shadowColor: Colors.black,
                elevation: 5,
              ),
            ),
          ]);
    }
    setStateIfMounted(() {
      isLoading = false;
    });
  }

  Future showBottomSheetMoreTools() async {
    await showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (cont) {
          return SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: double.infinity,
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25.0),
                        onTap: () {
                          Navigator.of(cont).pop();
                          Navigator.of(cont).push(MaterialPageRoute(
                              builder: (BuildContext context) => Profile(
                                  isActiveBackButton: true,
                                  isMyProfile: StoryDataService.userId ==
                                      FirebaseAuth.instance.currentUser!.uid,
                                  userId: StoryDataService.userId,
                                  userName: StoryDataService.userName)));
                        },
                        child: Center(
                          child: Text(
                            S.of(context).story_buttonGoToAuthor,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            )),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future showBottomSheetAuthorTools() async {
    await showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (cont) {
          return SizedBox(
            height: 170,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: double.infinity,
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25.0),
                        onTap: () {
                          Navigator.of(cont).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => NewStory(
                                  isActiveBackButton: true,
                                  isEditStory: true,
                                  title: StoryDataService.title,
                                  story: StoryDataService.story,
                                  storyId: StoryDataService.storyId)));
                        },
                        child: Center(
                          child: Text(
                            S.of(context).newStory_editStoryTitle,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            )),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        left: 10.0, right: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25.0),
                        onTap: () {
                          Navigator.of(cont).pop();
                          deleteStoryPopUp(context);
                        },
                        child: Center(
                          child: Text(
                            S.of(context).story_buttonDeleteStory,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            )),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future deleteStoryPopUp(BuildContext context) async {
    popUpDialog(
        title: S.of(context).notification_titleNotification,
        content: S.of(context).story_deleteStoryConfirmation,
        context: context,
        buttons: [
          SizedBox(
            height: 50,
            width: 70,
            child: Material(
              borderRadius: BorderRadius.circular(15.0),
              clipBehavior: Clip.antiAlias,
              color: Colors.blue,
              child: InkWell(
                onTap: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  setState(() {
                    isLoading = true;
                  });
                  try {
                    CollectionReference<Map<String, dynamic>> collection;
                    QuerySnapshot<Map<String, dynamic>> snapshots;

                    collection = FirebaseFirestore.instance
                        .collection('Storys')
                        .doc(StoryDataService.storyId)
                        .collection('Readers');
                    snapshots = await collection.get();
                    for (var doc in snapshots.docs) {
                      await doc.reference.delete();
                    }

                    collection = FirebaseFirestore.instance
                        .collection('Storys')
                        .doc(StoryDataService.storyId)
                        .collection('Comments');
                    snapshots = await collection.get();
                    for (var doc in snapshots.docs) {
                      await doc.reference.delete();
                    }

                    collection = FirebaseFirestore.instance
                        .collection('Storys')
                        .doc(StoryDataService.storyId)
                        .collection('Likes');
                    snapshots = await collection.get();
                    for (var doc in snapshots.docs) {
                      await doc.reference.delete();
                    }

                    await FirebaseFirestore.instance
                        .collection('Storys')
                        .doc(StoryDataService.storyId)
                        .delete()
                        .whenComplete(() {
                      if (widget.specificStory.isNotEmpty) {
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.of(context).pop();
                      } else {
                        setState(() {
                          acceptReadStory = false;
                          isLoading = false;
                          loadStory();
                        });
                      }
                    });

                    await FirebaseFirestore.instance
                        .collection('Users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({"stories": FieldValue.increment(-1)});
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    popUpDialog(
                        title: S.of(context).notification_titleError,
                        content: S.of(context).notification_titleError,
                        context: context,
                        buttons: [
                          SizedBox(
                            height: 50,
                            width: 70,
                            child: Material(
                              borderRadius: BorderRadius.circular(15.0),
                              clipBehavior: Clip.antiAlias,
                              color: Colors.blue,
                              child: InkWell(
                                onTap: () =>
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(),
                                child: Center(
                                  child: Text(
                                    S.of(context).notification_buttonOK,
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
                              shadowColor: Colors.black,
                              elevation: 5,
                            ),
                          ),
                        ]);
                  }
                },
                child: Center(
                  child: Text(
                    S.of(context).notification_buttonYes,
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
              shadowColor: Colors.black,
              elevation: 5,
            ),
          ),
          const SizedBox(width: 20.0),
          SizedBox(
            height: 50,
            width: 70,
            child: Material(
              borderRadius: BorderRadius.circular(15.0),
              clipBehavior: Clip.antiAlias,
              color: Colors.blue,
              child: InkWell(
                onTap: () => Navigator.of(context, rootNavigator: true).pop(),
                child: Center(
                  child: Text(
                    S.of(context).notification_buttonNo,
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
              shadowColor: Colors.black,
              elevation: 5,
            ),
          ),
        ]);
  }

  Widget storyDetail(
      {String valueName = '',
      String value = '',
      IconData icon = Icons.abc,
      Color iconColor = Colors.white}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 30,
          color: iconColor,
        ),
        const SizedBox(width: 10.0),
        Text(
          value,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
            letterSpacing: 0.5,
            fontSize: 23,
            fontWeight: FontWeight.w700,
            color: Colors.black87.withOpacity(0.7),
          )),
        ),
      ],
    );
  }
}
