import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_story/screens/home.dart';
import 'package:my_story/services/user.dart';
import 'package:my_story/services/user_local_data.dart';

import '../generated/l10n.dart';
import '../services/firestore_service.dart';

class Interests extends StatefulWidget {
  const Interests(
      {Key? key, this.isActiveBackButton = true, this.fromNewStory = false})
      : super(key: key);

  final bool isActiveBackButton;
  final bool fromNewStory;

  static List<dynamic> myInterests = [];

  @override
  State<Interests> createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  bool isPressed = false;
  Color colorChoosed = Colors.white54;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            bottomNavigationBar: widget.isActiveBackButton
                ? null
                : Container(
                    height: 60,
                    margin: const EdgeInsets.all(20.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(15.0),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.blue,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Home()));
                        },
                        child: Center(
                          child: Text(
                            S.of(context).storySettings_buttonDone,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 25,
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
                  const SizedBox(width: 20.0),
                  Text(
                    !widget.fromNewStory
                        ? S.of(context).interests_title
                        : S.of(context).newStory_storyCategoryTitle,
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
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    spacing: 15.0,
                    runSpacing: 15.0,
                    children: [
                      chip(S.of(context).interests_love, 'love',
                          Icons.favorite_rounded, Colors.redAccent),
                      chip(S.of(context).interests_comedy, 'comedy',
                          Icons.accessibility_new_rounded, Colors.orange),
                      chip(S.of(context).interests_sport, 'sports',
                          Icons.sports_baseball_rounded, Colors.blueAccent),
                      chip(S.of(context).interests_games, 'games',
                          Icons.games_rounded, Colors.green),
                      chip(S.of(context).interests_drama, 'drama',
                          Icons.mood_bad_rounded, Colors.blueGrey),
                      chip(S.of(context).interests_fantasy, 'fantasy',
                          Icons.auto_awesome_rounded, Colors.purpleAccent),
                      chip(S.of(context).interests_nature, 'nature',
                          Icons.nature_people_rounded, Colors.lightGreen),
                      chip(S.of(context).interests_animals, 'animals',
                          Icons.pets, Colors.brown.shade400),
                      chip(S.of(context).interests_travels, 'travels',
                          Icons.travel_explore_rounded, Colors.lime),
                      chip(S.of(context).interests_dailyLife, 'dailyLife',
                          Icons.man_rounded, Colors.blueGrey),
                    ],
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 20.0),
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
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.info_outline_rounded,
                                    color: Colors.orangeAccent, size: 25),
                                const SizedBox(width: 10.0),
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('Storys')
                                        .where('storyLanguage',
                                            isEqualTo: UserData.storysLanguage)
                                        .where('interests',
                                            arrayContainsAny:
                                                widget.fromNewStory
                                                    ? Interests.myInterests
                                                    : UserData.myInterests)
                                        .snapshots(),
                                    builder: (cont,
                                        AsyncSnapshot<QuerySnapshot> snaphot) {
                                      return SizedBox(
                                        width: 385,
                                        child: Text(
                                          '${S.of(context).interests_storyCount} ${FirestoreService().getCompactNumber(snaphot.data?.docs.length ?? 0)}',
                                          style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                            letterSpacing: 0.5,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color:
                                                Colors.black87.withOpacity(0.7),
                                          )),
                                        ),
                                      );
                                    })
                              ],
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            )));
  }

  Widget chip(String label, String chipID, IconData icon, Color iconColor) {
    return ActionChip(
      side: BorderSide(
          color: !widget.fromNewStory
              ? UserData.myInterests.contains(chipID)
                  ? Colors.blueAccent
                  : Colors.transparent
              : Interests.myInterests.contains(chipID)
                  ? Colors.blueAccent
                  : Colors.transparent,
          width: 2),
      backgroundColor: colorChoosed,
      onPressed: () {
        if (!widget.fromNewStory) {
          setState(() {
            if (!UserData.myInterests.contains(chipID)) {
              UserData.myInterests.add(chipID);
              UserLocalData().saveUserInterests(UserData.myInterests);
            } else {
              if (UserData.myInterests.length > 1) {
                UserData.myInterests.remove(chipID);
                UserLocalData().saveUserInterests(UserData.myInterests);
              }
            }
          });
        } else {
          setState(() {
            if (!Interests.myInterests.contains(chipID)) {
              Interests.myInterests.add(chipID);
            } else {
              if (Interests.myInterests.length > 1) {
                Interests.myInterests.remove(chipID);
              }
            }
          });
        }
      },
      labelPadding: const EdgeInsets.all(5.0),
      avatar: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(icon, color: iconColor, size: 25),
      ),
      label: Text(
        label,
        textAlign: TextAlign.center,
        style: GoogleFonts.roboto(
            textStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black87.withOpacity(0.7),
        )),
      ),
      elevation: 5.0,
      shadowColor: Colors.grey[60],
      padding: const EdgeInsets.all(8.0),
    );
  }
}
