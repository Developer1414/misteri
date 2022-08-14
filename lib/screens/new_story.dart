import 'dart:io';

import 'package:appodeal_flutter/appodeal_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_story/screens/choose_language_for_new_story.dart';
import 'package:my_story/screens/interests.dart';
import 'package:my_story/screens/new_story_additionally.dart';
import 'package:my_story/screens/new_story_screen.dart';
import 'package:my_story/services/user.dart';
import 'package:my_story/services/user_local_data.dart';
import 'package:profanity_filter/profanity_filter.dart';
import '../generated/l10n.dart';
import '../models/popup.dart';
import '../services/firebase_story_service.dart';
import '../services/story_data_service.dart';

class NewStory extends StatefulWidget {
  const NewStory(
      {Key? key,
      this.title = '',
      this.story = '',
      this.storyId = '',
      this.isActiveBackButton = false,
      this.isEditStory = false,
      this.draftId = ''})
      : super(key: key);

  final String title;
  final String story;
  final String storyId;
  final bool isActiveBackButton;
  final bool isEditStory;
  final String draftId;

  static String storyLanguage = 'English';
  static TextEditingController storyController = TextEditingController();

  static bool commentsAccess = true;
  static bool forAdults = false;

  @override
  State<NewStory> createState() => _NewStoryState();
}

class _NewStoryState extends State<NewStory> {
  TextEditingController titleController = TextEditingController();
  bool isLoading = false;
  bool isWritingStory = false;

  int _currentstep = 0;

  Future initAppodeal() async {
    await Appodeal.initialize(hasConsent: true, adTypes: [AdType.nonSkippable]);
  }

  @override
  void initState() {
    super.initState();
    initAppodeal();

    NewStory.commentsAccess = true;
    NewStory.forAdults = false;
    NewStory.storyLanguage = '';

    if (widget.isEditStory) {
      NewStory.forAdults = StoryDataService.forAdults;
      NewStory.commentsAccess = StoryDataService.commentsAccess;
      Interests.myInterests = StoryDataService.interests;
      NewStory.storyLanguage = StoryDataService.storyLanguage;
    } else {
      Interests.myInterests = ['dailyLife'];
    }

    if (widget.storyId.isNotEmpty) {
      setState(() {
        titleController.text = widget.title;
        NewStory.storyController.text = widget.story;
      });
    } else {
      UserLocalData().getLastStory().whenComplete(() {
        NewStory.storyController.text = UserLocalData.lastSavedStory;
      });
      UserLocalData().getLastTitle().whenComplete(() {
        titleController.text = UserLocalData.lastSavedTitle;
      });
    }
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
  Widget build(BuildContext context) {
    List<Step> steps = [
      Step(
        isActive: titleController.text.isNotEmpty,
        title: Text(S.of(context).newStory_stepTitle,
            style: GoogleFonts.roboto(
                textStyle: TextStyle(
              letterSpacing: 0.5,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87.withOpacity(0.7),
            ))),
        content: Container(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).newStory_stepTitleContent,
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                      letterSpacing: 0.5,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87.withOpacity(0.7),
                    ))),
                Container(
                  margin: const EdgeInsets.only(top: 15.0, bottom: 15.0),
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
                    onChanged: (text) => UserLocalData().saveTitle(text),
                    maxLines: 1,
                    maxLength: 50,
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                      letterSpacing: 0.5,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87.withOpacity(0.7),
                    )),
                    decoration: InputDecoration(
                        counterText: '',
                        hintText: S.of(context).newStory_textFieldTitle,
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
                            borderSide:
                                BorderSide(color: Colors.black38, width: 2))),
                  ),
                ),
              ],
            )),
      ),
      Step(
        isActive: NewStory.storyController.text.split(' ').length >= 50,
        title: Text(S.of(context).newStory_stepStory,
            style: GoogleFonts.roboto(
                textStyle: TextStyle(
              letterSpacing: 0.5,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87.withOpacity(0.7),
            ))),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).newStory_stepStoryContent,
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                  letterSpacing: 0.5,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87.withOpacity(0.7),
                ))),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0, top: 15.0),
              child: Material(
                borderRadius: BorderRadius.circular(18.0),
                clipBehavior: Clip.antiAlias,
                shadowColor: Colors.black,
                color: Colors.blueAccent,
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const NewStoryScreen()));
                  },
                  child: SizedBox(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
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
                              S.of(context).newStory_buttonMyStory,
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Step(
        isActive: true,
        title: Text(S.of(context).newStory_stepLanguage,
            style: GoogleFonts.roboto(
                textStyle: TextStyle(
              letterSpacing: 0.5,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87.withOpacity(0.7),
            ))),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).newStory_stepLanguageContent,
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                  letterSpacing: 0.5,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87.withOpacity(0.7),
                ))),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Material(
                borderRadius: BorderRadius.circular(18.0),
                clipBehavior: Clip.antiAlias,
                shadowColor: Colors.black,
                color: Colors.blueAccent,
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const NewStoryLanguage()));
                  },
                  child: SizedBox(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
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
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Step(
        isActive: true,
        title: Text(S.of(context).newStory_stepCategory,
            style: GoogleFonts.roboto(
                textStyle: TextStyle(
              letterSpacing: 0.5,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87.withOpacity(0.7),
            ))),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).newStory_stepCategoryContent,
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                  letterSpacing: 0.5,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87.withOpacity(0.7),
                ))),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Material(
                borderRadius: BorderRadius.circular(18.0),
                clipBehavior: Clip.antiAlias,
                shadowColor: Colors.black,
                color: Colors.blueAccent,
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            const Interests(fromNewStory: true)));
                  },
                  child: SizedBox(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
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
                              S.of(context).newStory_storyCategoryTitle,
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Step(
        isActive: true,
        title: Text(S.of(context).newStory_stepAdditional,
            style: GoogleFonts.roboto(
                textStyle: TextStyle(
              letterSpacing: 0.5,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87.withOpacity(0.7),
            ))),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).newStory_stepAdditionalContent,
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                  letterSpacing: 0.5,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87.withOpacity(0.7),
                ))),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0, top: 15.0),
              child: Material(
                borderRadius: BorderRadius.circular(18.0),
                clipBehavior: Clip.antiAlias,
                shadowColor: Colors.black,
                color: Colors.blueAccent,
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NewStoryAdditionallySettings(
                            isEditStory: widget.isEditStory)));
                  },
                  child: SizedBox(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.menu_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              S.of(context).newStory_additionally,
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Step(
        isActive: true,
        title: Text(S.of(context).newStory_stepCompletion,
            style: GoogleFonts.roboto(
                textStyle: TextStyle(
              letterSpacing: 0.5,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87.withOpacity(0.7),
            ))),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              borderRadius: BorderRadius.circular(18.0),
              clipBehavior: Clip.antiAlias,
              shadowColor: Colors.black,
              color: Colors.blueAccent,
              elevation: 5,
              child: InkWell(
                onTap: () async {
                  if (titleController.text.isEmpty) {
                    popUpDialog(
                        title: S.of(context).notification_titleError,
                        content: S.of(context).newStory_noWritedTitle,
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
                    return;
                  }

                  if (NewStory.storyController.text.isEmpty) {
                    popUpDialog(
                        title: S.of(context).notification_titleError,
                        content: S.of(context).newStory_noWritedStory,
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
                    return;
                  }

                  try {
                    setState(() {
                      isLoading = true;
                    });
                    await StoryService().publishStoryToDraft(
                        title: titleController.text,
                        story: NewStory.storyController.text,
                        draftId: widget.storyId);
                    setState(() {
                      isLoading = false;
                    });
                    popUpDialog(
                        title: S.of(context).notification_titleNotification,
                        content: S.of(context).newStory_addedToDraft,
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
                    UserLocalData().removeLastSavedStoryAndTitle();
                    titleController.text = '';
                    NewStory.storyController.text = '';
                    showAd();
                  } on FirebaseException catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    popUpDialog(
                        title: S.of(context).notification_titleError,
                        content: e.message.toString(),
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
                                onTap: () => Navigator.of(context).pop(),
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
                child: SizedBox(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.drafts_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            S.of(context).newStory_stepButtonToDraft,
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
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0, top: 15.0),
              child: Material(
                borderRadius: BorderRadius.circular(18.0),
                clipBehavior: Clip.antiAlias,
                shadowColor: Colors.black,
                color: const Color.fromARGB(255, 89, 192, 93),
                elevation: 5,
                child: InkWell(
                  onTap: () async {
                    if (titleController.text.isEmpty) {
                      popUpDialog(
                          title: S.of(context).notification_titleError,
                          content: S.of(context).newStory_noWritedTitle,
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
                      return;
                    }

                    if (NewStory.storyController.text.isEmpty) {
                      popUpDialog(
                          title: S.of(context).notification_titleError,
                          content: S.of(context).newStory_noWritedStory,
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
                      return;
                    }

                    if (NewStory.storyController.text.split(' ').length < 50) {
                      popUpDialog(
                          title: S.of(context).notification_titleError,
                          content: S.of(context).newStory_shortStory,
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
                      return;
                    }

                    if (Interests.myInterests.isEmpty) {
                      popUpDialog(
                          title: S.of(context).notification_titleError,
                          content: S.of(context).newStory_noCategory,
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
                      return;
                    }

                    try {
                      setState(() {
                        isLoading = true;
                      });
                      await StoryService().publishStory(
                          title: titleController.text,
                          story: NewStory.storyController.text,
                          storyId: widget.storyId,
                          draftId: widget.draftId,
                          forAdults: NewStory.forAdults,
                          commentsAccess: NewStory.commentsAccess,
                          storyLanguage: NewStory.storyLanguage.isEmpty
                              ? UserData.storysLanguage
                              : NewStory.storyLanguage);
                      setState(() {
                        isLoading = false;
                      });
                      popUpDialog(
                          title: S.of(context).notification_titleNotification,
                          content: S.of(context).newStory_storyPublished,
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
                      UserLocalData().removeLastSavedStoryAndTitle();
                      titleController.text = '';
                      NewStory.storyController.text = '';
                      showAd();
                    } on FirebaseException catch (e) {
                      setState(() {
                        isLoading = false;
                      });
                      popUpDialog(
                          title: S.of(context).notification_titleError,
                          content: e.message.toString(),
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
                  child: SizedBox(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.cloud_upload_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              S.of(context).newComment_buttonPublish,
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }

        setState(() {
          isWritingStory = false;
        });
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
                )),
              )
            : Scaffold(
                resizeToAvoidBottomInset: false,
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
                        child: Text(
                          widget.isEditStory
                              ? S.of(context).newStory_editStoryTitle
                              : S.of(context).newStory_title,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87.withOpacity(0.7),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                body: Theme(
                  data: ThemeData(
                      colorScheme: Theme.of(context).colorScheme.copyWith(
                          primary: const Color.fromARGB(255, 89, 192, 93),
                          onSurface: Colors.redAccent)),
                  child: Stepper(
                      controlsBuilder: (context, details) {
                        return Row(
                          mainAxisAlignment: _currentstep != 0
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.end,
                          children: [
                            if (_currentstep != 0)
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        primary: Colors.redAccent),
                                    onPressed: details.onStepCancel,
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Icon(
                                        Icons.arrow_back_ios_new_outlined,
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                            if (_currentstep < 5)
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      primary: const Color.fromARGB(
                                          255, 89, 192, 93)),
                                  onPressed: details.onStepContinue,
                                  child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.white,
                                    ),
                                  )),
                          ],
                        );
                      },
                      currentStep: _currentstep,
                      onStepCancel: () {
                        if (_currentstep > 0) {
                          setState(() {
                            _currentstep--;
                          });
                        }
                      },
                      onStepContinue: () {
                        if (_currentstep < steps.length - 1) {
                          setState(() {
                            _currentstep++;
                          });
                        }
                      },
                      onStepTapped: (int index) {
                        setState(() {
                          _currentstep = index;
                        });
                      },
                      steps: steps),
                )),
      ),
    );
  }
}
