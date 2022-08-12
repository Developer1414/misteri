import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_story/screens/story.dart';

import '../generated/l10n.dart';
import '../models/popup.dart';

class MyLikesScreen extends StatefulWidget {
  const MyLikesScreen({Key? key}) : super(key: key);

  @override
  State<MyLikesScreen> createState() => _MyLikesScreenState();
}

class _MyLikesScreenState extends State<MyLikesScreen> {
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
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.black87.withOpacity(0.7),
                          size: 30,
                        )),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Text(
                          S.of(context).likes_title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87.withOpacity(0.7),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('Likes')
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

                    return snapshot.data!.docs.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: Text(
                                S.of(context).likes_noStorysText,
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
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (listContext, int index) {
                              FirebaseFirestore.instance
                                  .collection('Storys')
                                  .doc(
                                      snapshot.data?.docs[index].get('storyId'))
                                  .get()
                                  .then((value) {
                                if (!value.exists) {
                                  FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .collection('Likes')
                                      .doc(snapshot.data?.docs[index]
                                          .get('storyId'))
                                      .delete();
                                }
                              });

                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15.0)),
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
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      FirebaseFirestore.instance
                                          .collection('Storys')
                                          .doc(snapshot.data?.docs[index]
                                              .get('storyId'))
                                          .get()
                                          .then((value) {
                                        if (!value.exists) {
                                          popUpDialog(
                                              title: S
                                                  .of(listContext)
                                                  .notification_titleError,
                                              content: S
                                                  .of(cont)
                                                  .likes_storyNotExist,
                                              context: listContext,
                                              buttons: [
                                                SizedBox(
                                                  height: 50,
                                                  width: 70,
                                                  child: Material(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    color: Colors.blue,
                                                    child: InkWell(
                                                      onTap: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('Users')
                                                            .doc(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid)
                                                            .collection('Likes')
                                                            .doc(snapshot.data
                                                                ?.docs[index]
                                                                .get('storyId'))
                                                            .delete();
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                      },
                                                      child: Center(
                                                        child: Text(
                                                          S
                                                              .of(listContext)
                                                              .notification_buttonOK,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  textStyle:
                                                                      const TextStyle(
                                                            letterSpacing: 0.5,
                                                            fontSize: 20,
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
                                              ]);
                                        } else {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) => Story(
                                                      isActiveBackButton: true,
                                                      specificStory: snapshot
                                                          .data?.docs[index]
                                                          .get('storyId'))));
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data?.docs[index]
                                                .get('title'),
                                            style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                              letterSpacing: 0.5,
                                              fontSize: 21,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87
                                                  .withOpacity(0.7),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                  })),
    );
  }
}
