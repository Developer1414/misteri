import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_story/screens/new_story.dart';

import '../generated/l10n.dart';
import '../models/popup.dart';

class MyDraftScreen extends StatefulWidget {
  const MyDraftScreen({Key? key}) : super(key: key);

  @override
  State<MyDraftScreen> createState() => _MyDraftScreenState();
}

class _MyDraftScreenState extends State<MyDraftScreen> {
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
                          S.of(context).draft_title,
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
                      .collection('Draft')
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
                                S.of(context).draft_noStorysText,
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
                            itemBuilder: (cont2, int index) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15.0)),
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 10,
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                blurStyle: BlurStyle.outer)
                                          ]),
                                      margin: const EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                          bottom: 15.0),
                                      child: Material(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        clipBehavior: Clip.antiAlias,
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) => NewStory(
                                                        isActiveBackButton:
                                                            true,
                                                        draftId: snapshot
                                                            .data?.docs[index]
                                                            .get('draftId'),
                                                        title: snapshot
                                                            .data?.docs[index]
                                                            .get('title'),
                                                        story: snapshot
                                                            .data?.docs[index]
                                                            .get('story'),
                                                        storyId: snapshot
                                                            .data?.docs[index]
                                                            .get('draftId'))));
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
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        right: 15.0, bottom: 15.0),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(15.0),
                                      clipBehavior: Clip.antiAlias,
                                      color: Colors.redAccent,
                                      child: InkWell(
                                        onTap: () {
                                          popUpDialog(
                                              title: S
                                                  .of(context)
                                                  .notification_titleNotification,
                                              content: S
                                                  .of(context)
                                                  .draft_deletionConfirmation,
                                              context: context,
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
                                                      onTap: () async {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                        setState(() {
                                                          isLoading = true;
                                                        });
                                                        try {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Users/${FirebaseAuth.instance.currentUser!.uid}/Draft')
                                                              .doc(snapshot.data
                                                                  ?.docs[index]
                                                                  .get(
                                                                      'draftId'))
                                                              .delete();
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                        } on FirebaseAuthException catch (e) {
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                          popUpDialog(
                                                              title: S
                                                                  .of(context)
                                                                  .notification_titleError,
                                                              content: S
                                                                  .of(context)
                                                                  .notification_titleError,
                                                              context: context,
                                                              buttons: [
                                                                SizedBox(
                                                                  height: 50,
                                                                  width: 70,
                                                                  child:
                                                                      Material(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15.0),
                                                                    clipBehavior:
                                                                        Clip.antiAlias,
                                                                    color: Colors
                                                                        .blue,
                                                                    child:
                                                                        InkWell(
                                                                      onTap: () => Navigator.of(
                                                                              context,
                                                                              rootNavigator: true)
                                                                          .pop(),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          S.of(context).notification_buttonOK,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: GoogleFonts.roboto(
                                                                              textStyle: const TextStyle(
                                                                            letterSpacing:
                                                                                0.5,
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color:
                                                                                Colors.white,
                                                                          )),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    shadowColor:
                                                                        Colors
                                                                            .black,
                                                                    elevation:
                                                                        5,
                                                                  ),
                                                                ),
                                                              ]);
                                                        }
                                                      },
                                                      child: Center(
                                                        child: Text(
                                                          S
                                                              .of(context)
                                                              .notification_buttonYes,
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
                                                const SizedBox(width: 20.0),
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
                                                      onTap: () => Navigator.of(
                                                              context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop(),
                                                      child: Center(
                                                        child: Text(
                                                          S
                                                              .of(context)
                                                              .notification_buttonNo,
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
                                        },
                                        child: const Padding(
                                            padding: EdgeInsets.all(15.0),
                                            child: Icon(Icons.delete_rounded,
                                                color: Colors.white, size: 25)),
                                      ),
                                      shadowColor: Colors.black,
                                      elevation: 5,
                                    ),
                                  ),
                                ],
                              );
                            });
                  })),
    );
  }
}
