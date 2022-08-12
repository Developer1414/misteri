import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_story/screens/app_language.dart';
import 'package:my_story/screens/interests.dart';
import 'package:my_story/screens/sign_in.dart';
import 'package:my_story/screens/story_text_settings.dart';

import '../generated/l10n.dart';
import '../models/popup.dart';
import '../services/user_local_data.dart';
import 'choose_language_for_new_story.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
              )),
            )
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
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      S.of(context).settings_title,
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
              body: Column(
                children: [
                  Container(
                    height: 60,
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(18.0),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.blueGrey,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const StoryTextSettings(
                                  openedFromSettings: true)));
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.library_books_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                S.of(context).storySettings_title,
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                  letterSpacing: 0.5,
                                  fontSize: 22,
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
                        top: 20.0, left: 20.0, right: 20.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(18.0),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.blueGrey,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const NewStoryLanguage(fromSettings: true)));
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.language_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                S.of(context).newStory_buttonStoryLanguage,
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                  letterSpacing: 0.5,
                                  fontSize: 22,
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
                        top: 20.0, left: 20.0, right: 20.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(18.0),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.blueGrey,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Interests()));
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.interests_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                S.of(context).interests_title,
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                  letterSpacing: 0.5,
                                  fontSize: 22,
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
                  /*Container(
                    height: 60,
                    margin: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(18.0),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.blueGrey,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AppLanguage()));
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.language_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                S.of(context).app_language,
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                  letterSpacing: 0.5,
                                  fontSize: 22,
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
                  ),*/
                  Container(
                    height: 60,
                    margin: const EdgeInsets.all(20.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(18.0),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.red,
                      child: InkWell(
                        onTap: () {
                          popUpDialog(
                              title:
                                  S.of(context).notification_titleNotification,
                              content: S.of(context).settings_exitConfirmation,
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
                                      onTap: () {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        try {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          FirebaseAuth.instance
                                              .signOut()
                                              .whenComplete(() => {
                                                    setState(() {
                                                      isLoading = false;
                                                    }),
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const SignIn())),
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
                                          Navigator.of(context).pop();
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
                                      onTap: () => Navigator.of(context,
                                              rootNavigator: true)
                                          .pop(),
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
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.logout_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                S.of(context).settings_buttonLogOut,
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                  letterSpacing: 0.5,
                                  fontSize: 22,
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
}
