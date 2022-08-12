import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_story/screens/new_comments.dart';
import 'package:my_story/screens/profile.dart';
import 'package:shimmer/shimmer.dart';

import '../generated/l10n.dart';
import '../services/firestore_service.dart';
import '../services/story_data_service.dart';

class CommentReplies extends StatefulWidget {
  const CommentReplies({Key? key, this.commentId = ''}) : super(key: key);

  final String commentId;

  @override
  State<CommentReplies> createState() => _CommentRepliesState();
}

class _CommentRepliesState extends State<CommentReplies> {
  bool sortByDate = true;
  bool isLoadingLike = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoading
          ? const Scaffold(
              body: Center(
                  child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 6.0,
              ),
            )))
          : Scaffold(
              appBar: AppBar(
                elevation: 0,
                toolbarHeight: 76,
                backgroundColor: Colors.transparent,
                title: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 20.0),
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.black87.withOpacity(0.7),
                            size: 30,
                          )),
                    ),
                    Text(
                      S.of(context).answers_title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87.withOpacity(0.7),
                      )),
                    ),
                  ],
                ),
              ),
              body: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Storys')
                      .doc(StoryDataService.storyId)
                      .collection('Comments')
                      .doc(widget.commentId)
                      .collection('Subcomments')
                      .orderBy('date', descending: sortByDate)
                      .snapshots(),
                  builder: (cont, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        S.of(context).notification_titleError,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
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

                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (cont2, int index) {
                          return Container(
                            margin: const EdgeInsets.only(
                                left: 15.0, right: 15.0, bottom: 15.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(15.0),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () {
                                  if (snapshot.data?.docs[index]
                                          .get('userId')
                                          .toString() ==
                                      FirebaseAuth.instance.currentUser!.uid) {
                                    bottomModalSheetForMyComment(
                                        snapshot.data?.docs[index]
                                            .get('commentId'),
                                        snapshot.data?.docs[index]
                                            .get('comment'));
                                  } else {
                                    FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(snapshot.data?.docs[index]
                                            .get('userId'))
                                        .get()
                                        .then((value) {
                                      bottomModalSheetForOtherComment(
                                          value.get('name'),
                                          snapshot.data?.docs[index]
                                              .get('comment'),
                                          snapshot.data?.docs[index]
                                              .get('commentId'));
                                    });
                                  }
                                },
                                child: ListTile(
                                  minVerticalPadding: 15,
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Material(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            clipBehavior: Clip.antiAlias,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) => Profile(
                                                            isActiveBackButton:
                                                                true,
                                                            isMyProfile: snapshot
                                                                    .data
                                                                    ?.docs[
                                                                        index]
                                                                    .get(
                                                                        'userId') ==
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid,
                                                            userId: snapshot
                                                                .data
                                                                ?.docs[index]
                                                                .get(
                                                                    'userId'))));
                                              },
                                              child: FutureBuilder(
                                                  future: FirestoreService()
                                                      .getAvatarImage(snapshot
                                                          .data?.docs[index]
                                                          .get('userId')),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Shimmer.fromColors(
                                                        baseColor:
                                                            Colors.grey[300]!,
                                                        highlightColor:
                                                            Colors.grey[100]!,
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              Colors.grey
                                                                  .withOpacity(
                                                                      0.3),
                                                          child: const SizedBox(
                                                              width: 40,
                                                              height: 40),
                                                        ),
                                                      );
                                                    }

                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState.done) {
                                                      return SizedBox(
                                                        width: 40,
                                                        height: 40,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100.0),
                                                          child: snapshot
                                                                      .data !=
                                                                  null
                                                              ? snapshot.data
                                                                  as Image
                                                              : const Icon(
                                                                  Icons.person,
                                                                  size: 40,
                                                                ),
                                                        ),
                                                      );
                                                    }

                                                    return Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey[300]!,
                                                      highlightColor:
                                                          Colors.grey[100]!,
                                                      child: CircleAvatar(
                                                        backgroundColor: Colors
                                                            .grey
                                                            .withOpacity(0.3),
                                                        child: const SizedBox(
                                                            width: 40,
                                                            height: 40),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ),
                                          const SizedBox(width: 15.0),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) => Profile(
                                                          isActiveBackButton:
                                                              true,
                                                          isMyProfile: snapshot
                                                                  .data
                                                                  ?.docs[index]
                                                                  .get(
                                                                      'userId') ==
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                          userId: snapshot
                                                              .data?.docs[index]
                                                              .get('userId'))));
                                            },
                                            child: FutureBuilder<
                                                    DocumentSnapshot>(
                                                future: FirebaseFirestore
                                                    .instance
                                                    .collection('Users')
                                                    .doc(snapshot
                                                        .data?.docs[index]
                                                        .get('userId'))
                                                    .get(),
                                                builder: (cont3,
                                                    AsyncSnapshot<
                                                            DocumentSnapshot>
                                                        snapshot) {
                                                  return RichText(
                                                      text: TextSpan(children: [
                                                    TextSpan(
                                                        text:
                                                            '${snapshot.data?.get('name') ?? ''}',
                                                        style:
                                                            GoogleFonts.roboto(
                                                          textStyle: TextStyle(
                                                              fontSize: 21,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: Colors
                                                                  .black87
                                                                  .withOpacity(
                                                                      0.7)),
                                                        )),
                                                    StoryDataService.userId ==
                                                            snapshot.data
                                                                ?.get('id')
                                                        ? TextSpan(
                                                            text:
                                                                ' (${S.of(context).comments_authorText})',
                                                            style: GoogleFonts.roboto(
                                                                textStyle: const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .redAccent)))
                                                        : const TextSpan()
                                                  ]));
                                                }),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          FutureBuilder(
                                              future: FirebaseFirestore.instance
                                                  .collection('Storys')
                                                  .doc(StoryDataService.storyId)
                                                  .collection('Comments')
                                                  .doc(widget.commentId)
                                                  .collection('Subcomments')
                                                  .doc(snapshot
                                                      .data?.docs[index]
                                                      .get('commentId'))
                                                  .get(),
                                              builder: (context,
                                                  AsyncSnapshot<
                                                          DocumentSnapshot>
                                                      snapshot) {
                                                return Text(
                                                  '${snapshot.data?.get('likes') ?? '0'}',
                                                  style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.7),
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                );
                                              }),
                                          IconButton(
                                            padding: const EdgeInsets.all(0.0),
                                            onPressed: () async {
                                              await setCommentLike(snapshot
                                                  .data?.docs[index]
                                                  .get('commentId'));
                                            },
                                            icon: StreamBuilder<
                                                    DocumentSnapshot>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('Storys')
                                                    .doc(StoryDataService
                                                        .storyId)
                                                    .collection('Comments')
                                                    .doc(widget.commentId)
                                                    .collection('Subcomments')
                                                    .doc(snapshot
                                                        .data?.docs[index]
                                                        .get('commentId'))
                                                    .collection('Likes')
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                    .snapshots(),
                                                builder: (context,
                                                    AsyncSnapshot<
                                                            DocumentSnapshot>
                                                        snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Icon(
                                                      Icons
                                                          .favorite_outline_rounded,
                                                      size: 25,
                                                      color: Colors.redAccent,
                                                    );
                                                  }
                                                  return Icon(
                                                    !snapshot.data!.exists
                                                        ? Icons
                                                            .favorite_outline_rounded
                                                        : Icons
                                                            .favorite_rounded,
                                                    size: 25,
                                                    color: Colors.redAccent,
                                                  );
                                                }),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Text(
                                            snapshot.data?.docs[index]
                                                .get('comment'),
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87
                                                  .withOpacity(0.7),
                                            )),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Text(
                                            snapshot.data?.docs[index]
                                                .get('date'),
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87
                                                  .withOpacity(0.5),
                                            )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              shadowColor: Colors.black,
                              elevation: 5,
                            ),
                          );
                        });
                  }),
            ),
    );
  }

  Future setCommentLike(String commentId) async {
    if (isLoadingLike) return;

    isLoadingLike = true;

    await FirebaseFirestore.instance
        .collection('Storys')
        .doc(StoryDataService.storyId)
        .collection('Comments')
        .doc(widget.commentId)
        .collection('Subcomments')
        .doc(commentId)
        .collection('Likes')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot value) {
      if (!value.exists) {
        FirebaseFirestore.instance
            .collection('Storys')
            .doc(StoryDataService.storyId)
            .collection('Comments')
            .doc(widget.commentId)
            .collection('Subcomments')
            .doc(commentId)
            .collection('Likes')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'userId': FirebaseAuth.instance.currentUser!.uid,
        }).whenComplete(() async {
          await FirebaseFirestore.instance
              .collection('Storys')
              .doc(StoryDataService.storyId)
              .collection('Comments')
              .doc(widget.commentId)
              .collection('Subcomments')
              .doc(commentId)
              .update({"likes": FieldValue.increment(1)}).whenComplete(() {
            isLoadingLike = false;
          });
        });
      } else {
        FirebaseFirestore.instance
            .collection('Storys')
            .doc(StoryDataService.storyId)
            .collection('Comments')
            .doc(widget.commentId)
            .collection('Subcomments')
            .doc(commentId)
            .collection('Likes')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .delete()
            .whenComplete(() async {
          await FirebaseFirestore.instance
              .collection('Storys')
              .doc(StoryDataService.storyId)
              .collection('Comments')
              .doc(widget.commentId)
              .collection('Subcomments')
              .doc(commentId)
              .update({"likes": FieldValue.increment(-1)}).whenComplete(() {
            isLoadingLike = false;
          });
        });
      }
    });
  }

  Future bottomModalSheetForOtherComment(
      String userName, String comment, String commentId) async {
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
                        color: const Color.fromARGB(255, 89, 192, 93),
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25.0),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NewCommentScreen(
                                  reply: userName, commentId: commentId)));
                        },
                        child: Center(
                          child: Text(
                            S.of(context).comments_buttonReplyToUser,
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
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25.0),
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: comment));
                          Navigator.of(cont).pop();
                        },
                        child: Center(
                          child: Text(
                            S.of(context).comments_buttonCopyComment,
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

  Future bottomModalSheetForMyComment(String commentId, String comment) async {
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
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NewCommentScreen(
                                    comment: comment,
                                    commentId: widget.commentId,
                                    subcommentId: commentId,
                                  )));
                        },
                        child: Center(
                          child: Text(
                            S.of(context).comments_buttonEditComment,
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
                        onTap: () async {
                          Navigator.of(cont).pop();
                          await FirebaseFirestore.instance
                              .collection('Storys')
                              .doc(StoryDataService.storyId)
                              .collection('Comments')
                              .doc(widget.commentId)
                              .collection('Subcomments')
                              .doc(commentId)
                              .delete()
                              .whenComplete(() async {
                            await FirebaseFirestore.instance
                                .collection('Storys')
                                .doc(StoryDataService.storyId)
                                .collection('Comments')
                                .doc(widget.commentId)
                                .update({"answers": FieldValue.increment(-1)});
                            await FirebaseFirestore.instance
                                .collection('Storys')
                                .doc(StoryDataService.storyId)
                                .update({"comments": FieldValue.increment(-1)});
                          });
                        },
                        child: Center(
                          child: Text(
                            S.of(context).comments_buttonDeleteComment,
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
}
