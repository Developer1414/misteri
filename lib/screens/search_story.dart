import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_story/screens/new_story.dart';
import 'package:my_story/screens/profile.dart';
import 'package:my_story/screens/story.dart';
import 'package:my_story/services/user.dart';
import '../generated/l10n.dart';
import '../services/firestore_service.dart';
import '../services/story_data_service.dart';

class SearchStory extends StatefulWidget {
  const SearchStory({Key? key}) : super(key: key);

  @override
  State<SearchStory> createState() => _SearchStoryState();
}

enum SortBy { New, Popular, Old }

class _SearchStoryState extends State<SearchStory> {
  bool isLoading = false;
  bool isSearching = false;
  bool isSearchingStorys = true;
  TextEditingController searchController = TextEditingController();

  SortBy sortStoriesBy = SortBy.New;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();

          if (searchController.text == '') {
            isSearching = false;
          }
        }
      },
      child: MaterialApp(
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
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  elevation: 0,
                  toolbarHeight: 95,
                  backgroundColor: Colors.transparent,
                  title: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.3),
                                    blurStyle: BlurStyle.outer)
                              ]),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                showSearchingStorys();
                              });
                            },
                            onSubmitted: (value) {
                              if (value == '') {
                                isSearching = false;
                                setState(() {
                                  showSearchingStorys();
                                });
                              }
                            },
                            onTap: () => setState(() {
                              isSearching = true;
                            }),
                            controller: searchController,
                            keyboardType: TextInputType.text,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87.withOpacity(0.7),
                            )),
                            decoration: InputDecoration(
                                hintText: S.of(context).search_textFieldSearch,
                                hintStyle: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                  letterSpacing: 0.5,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black45,
                                )),
                                enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 2)),
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        color: Colors.black38, width: 2))),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15.0),
                      IconButton(
                          onPressed: () {
                            showBottomSheetSort();
                          },
                          icon: const Icon(Icons.sort_rounded,
                              color: Colors.blueAccent, size: 30))
                    ],
                  ),
                ),
                body: Column(
                  children: [
                    Row(children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          margin:
                              const EdgeInsets.only(left: 15.0, bottom: 15.0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              border: Border.all(
                                  color: isSearchingStorys
                                      ? Colors.transparent
                                      : Colors.black38,
                                  width: 2)),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            clipBehavior: Clip.antiAlias,
                            color: isSearchingStorys
                                ? Colors.blue
                                : Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isSearchingStorys = true;
                                });
                              },
                              child: Center(
                                child: Text(
                                  S.of(context).search_buttonStorys,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                    letterSpacing: 0.5,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: isSearchingStorys
                                        ? Colors.white
                                        : Colors.black45,
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15.0),
                      Expanded(
                        child: Container(
                          height: 40,
                          margin:
                              const EdgeInsets.only(right: 15.0, bottom: 15.0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              border: Border.all(
                                  color: !isSearchingStorys
                                      ? Colors.transparent
                                      : Colors.black38,
                                  width: 2)),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            clipBehavior: Clip.antiAlias,
                            color: !isSearchingStorys
                                ? Colors.blue
                                : Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isSearchingStorys = false;
                                });
                              },
                              child: Center(
                                child: Text(
                                  S.of(context).search_buttonUsers,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                    letterSpacing: 0.5,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: !isSearchingStorys
                                        ? Colors.white
                                        : Colors.black45,
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    Expanded(
                        child: isSearchingStorys
                            ? searchController.text.isEmpty
                                ? showStories()
                                : showSearchingStorys()
                            : showSearchingUsers())
                  ],
                ),
              ),
      ),
    );
  }

  Widget showSearchingStorys() {
    return StreamBuilder<QuerySnapshot>(
        stream: sortStoriesBy != SortBy.Popular
            ? FirebaseFirestore.instance
                .collection('Storys')
                .where('storyLanguage', isEqualTo: UserData.storysLanguage)
                .where('searchIndex',
                    arrayContains: searchController.text.trim().toLowerCase())
                .orderBy('date',
                    descending: sortStoriesBy == SortBy.New
                        ? true
                        : sortStoriesBy == SortBy.Old
                            ? false
                            : true)
                .snapshots()
            : FirebaseFirestore.instance
                .collection('Storys')
                .where('searchIndex',
                    arrayContains: searchController.text.trim().toLowerCase())
                .orderBy('views', descending: true)
                .snapshots(),
        builder: (cont, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(
              S.of(context).notification_titleError,
              style: TextStyle(
                color: Colors.black87.withOpacity(0.7),
                fontSize: 22,
                fontWeight: FontWeight.w700,
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
                  child: Text(
                    S.of(context).search_storyNotFound,
                    style: TextStyle(
                      color: Colors.black87.withOpacity(0.5),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, int index) {
                        return listStory(snapshot, index);
                      }));
        });
  }

  Widget showSearchingUsers() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .where('nameIndex',
                arrayContains: searchController.text.toLowerCase())
            .snapshots(),
        builder: (cont1, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(
              S.of(context).notification_titleError,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 22,
                fontWeight: FontWeight.w700,
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
                  child: Text(
                    S.of(context).search_authorNotFound,
                    style: TextStyle(
                      color: Colors.black87.withOpacity(0.5),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (cont2, int index) {
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
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Profile(
                                      isActiveBackButton: true,
                                      isMyProfile: snapshot.data?.docs[index]
                                              .get('id') ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                      userId:
                                          snapshot.data?.docs[index].get('id'),
                                      userName: snapshot.data?.docs[index]
                                          .get('name'),
                                    )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    snapshot.data?.docs[index].get('name'),
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
                                        const Icon(Icons.people_rounded,
                                            color: Colors.blueAccent, size: 20),
                                        const SizedBox(width: 5.0),
                                        FutureBuilder<QuerySnapshot>(
                                            future: FirebaseFirestore.instance
                                                .collection('Users')
                                                .doc(snapshot.data?.docs[index]
                                                    .get('id'))
                                                .collection('Subscribers')
                                                .get(),
                                            builder: (context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              return Text(
                                                FirestoreService()
                                                    .getCompactNumber(snapshot
                                                            .data
                                                            ?.docs
                                                            .length ??
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
                                    const SizedBox(width: 10.0),
                                    Row(
                                      children: [
                                        const Icon(Icons.library_books_rounded,
                                            color: Colors.blueAccent, size: 20),
                                        const SizedBox(width: 5.0),
                                        FutureBuilder<QuerySnapshot>(
                                            future: FirebaseFirestore.instance
                                                .collection('Storys')
                                                .where('userId',
                                                    isEqualTo: snapshot
                                                        .data?.docs[index]
                                                        .get('id'))
                                                .get(),
                                            builder: (context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              return Text(
                                                FirestoreService()
                                                    .getCompactNumber(snapshot
                                                            .data
                                                            ?.docs
                                                            .length ??
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

  Widget showStories() {
    return ListView(children: [
      sortStoriesBy != SortBy.Popular
          ? FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Storys')
                  .where('storyLanguage', isEqualTo: UserData.storysLanguage)
                  .orderBy('date',
                      descending: sortStoriesBy == SortBy.New
                          ? true
                          : sortStoriesBy == SortBy.Old
                              ? false
                              : true)
                  .limit(100)
                  .get(),
              builder: (cont, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      S.of(cont).notification_titleError,
                      style: TextStyle(
                        color: Colors.black87.withOpacity(0.5),
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
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
                    ? noStorys()
                    : Container(
                        margin: const EdgeInsets.only(top: 15.0),
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, int index) {
                              return listStory(snapshot, index);
                            }));
              })
          : FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Storys')
                  .where('storyLanguage', isEqualTo: UserData.storysLanguage)
                  .orderBy('views', descending: true)
                  .limit(100)
                  .get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      S.of(context).notification_titleError,
                      style: TextStyle(
                        color: Colors.black87.withOpacity(0.5),
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
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
                    ? noStorys()
                    : Container(
                        margin: const EdgeInsets.only(top: 15.0),
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, int index) {
                              return listStory(snapshot, index);
                            }));
              })
    ]);
  }

  Widget listStory(AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    bool isNew = false;
    String date = '';

    final format = DateFormat('MM.dd.yyyy HH:mm:ss');

    DateTime dt1 = format.parse(snapshot.data?.docs[index].get('date'));
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

    if (((dt2.difference(dt1).inHours / 24).abs()).round() >= 7 &&
        ((dt2.difference(dt1).inHours / 24).abs()).round() < 14) {
      date = S.of(context).story_dateWeekAgo;
    }

    if (((dt2.difference(dt1).inHours / 24).abs()).round() >= 14 &&
        ((dt2.difference(dt1).inHours / 24).abs()).round() < 21) {
      date = S.of(context).story_dateTwoWeeksAgo;
    }

    if (((dt2.difference(dt1).inHours / 24).abs()).round() >= 21 &&
        ((dt2.difference(dt1).inHours / 24).abs()).round() < 28) {
      date = S.of(context).story_dateThreeWeeksAgo;
    }

    if (((dt2.difference(dt1).inHours / 24).abs()).round() >= 28) {
      date = snapshot.data?.docs[index].get('date');
    }

    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                color: Colors.black.withOpacity(0.3),
                blurStyle: BlurStyle.outer)
          ]),
      margin: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
      child: Material(
        borderRadius: BorderRadius.circular(15.0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Story(
                    isActiveBackButton: true,
                    specificStory: snapshot.data?.docs[index].get('storyId'))));
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${snapshot.data?.docs[index].get('userName')} • $date',
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
                                  color: Colors.redAccent.withOpacity(0.8),
                                  blurStyle: BlurStyle.normal)
                            ],
                            borderRadius: BorderRadius.circular(10.0),
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
                        const Icon(Icons.favorite_rounded,
                            color: Colors.redAccent, size: 20),
                        const SizedBox(width: 5.0),
                        Text(
                          FirestoreService().getCompactNumber(
                              snapshot.data!.docs[index].get('likes')),
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                            letterSpacing: 0.5,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87.withOpacity(0.7),
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
                              snapshot.data!.docs[index].get('views')),
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                            letterSpacing: 0.5,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87.withOpacity(0.7),
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
  }

  Future showBottomSheetSort() async {
    await showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (cont) {
          return SizedBox(
            height: 245,
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
                        color: sortStoriesBy == SortBy.New
                            ? Colors.red
                            : Colors.blue,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25.0),
                        onTap: () {
                          Navigator.of(cont).pop();
                          setState(() {
                            sortStoriesBy = SortBy.New;
                          });
                        },
                        child: Center(
                          child: Text(
                            S.of(context).search_sortByOld,
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
                        color: sortStoriesBy == SortBy.Popular
                            ? Colors.red
                            : Colors.blue,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25.0),
                        onTap: () {
                          Navigator.of(cont).pop();
                          setState(() {
                            sortStoriesBy = SortBy.Popular;
                          });
                        },
                        child: Center(
                          child: Text(
                            S.of(context).search_sortByPopular,
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
                        color: sortStoriesBy == SortBy.Old
                            ? Colors.red
                            : Colors.blue,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25.0),
                        onTap: () {
                          Navigator.of(cont).pop();
                          setState(() {
                            sortStoriesBy = SortBy.Old;
                          });
                        },
                        child: Center(
                          child: Text(
                            S.of(context).search_sortByNew,
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

  Widget noStorys() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            S.of(context).story_noStorysTitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
                textStyle: TextStyle(
              letterSpacing: 0.5,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black87.withOpacity(0.5),
            )),
          ),
        ),
        Container(
          height: 60,
          margin: const EdgeInsets.only(
              left: 20.0, right: 20.0, bottom: 20.0, top: 20.0),
          child: Material(
            borderRadius: BorderRadius.circular(15.0),
            clipBehavior: Clip.antiAlias,
            color: const Color.fromARGB(255, 89, 192, 93),
            child: InkWell(
              onTap: () async {
                setState(() {
                  isSearchingStorys = true;
                });
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
                      S.of(context).story_noStorysButtonUpdate,
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
          margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: Material(
            borderRadius: BorderRadius.circular(15.0),
            clipBehavior: Clip.antiAlias,
            color: Colors.blue,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        const NewStory(isActiveBackButton: true)));
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
                      S.of(context).story_noStorysButtonNewStory,
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
    );
  }
}
