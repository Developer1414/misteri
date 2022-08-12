import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_story/screens/home.dart';
import 'package:my_story/screens/interests.dart';
import 'package:my_story/screens/new_story.dart';
import 'package:my_story/services/user.dart';

import '../generated/l10n.dart';
import '../services/user_local_data.dart';

class NewStoryLanguage extends StatefulWidget {
  const NewStoryLanguage(
      {Key? key, this.fromSettings = false, this.isActiveBackButton = true})
      : super(key: key);

  final bool fromSettings;
  final bool isActiveBackButton;

  @override
  State<NewStoryLanguage> createState() => _NewStoryLanguageState();
}

class _NewStoryLanguageState extends State<NewStoryLanguage> {
  TextEditingController myOwnLanguageController = TextEditingController();
  bool isSearching = false;
  bool isChoosedNewLanguage = false;

  String choosedLanguage = 'English';

  List<String> languages = [
    'English',
    'Русский',
    '中國人',
    'हिन्दी',
    'Español',
    'عرب',
    'বাংলা',
    'Português',
    'bahasa Indonesia',
    'Français',
    'Deutsch'
  ];

  @override
  void initState() {
    super.initState();

    /*if (!widget.fromSettings) {
      setState(() {
        choosedLanguage = NewStory.storyLanguage;
      });
      if (!languages.contains(NewStory.storyLanguage)) {
        myOwnLanguageController.text = NewStory.storyLanguage;
      }
    } else {
      setState(() {
        choosedLanguage = UserData.storysLanguage;
      });

      if (!languages.contains(UserData.storysLanguage)) {
        myOwnLanguageController.text = UserData.storysLanguage;
      }
    }*/

    setState(() {
      if (widget.fromSettings) {
        choosedLanguage = UserData.storysLanguage;
      } else {
        choosedLanguage = NewStory.storyLanguage.isEmpty
            ? UserData.storysLanguage
            : NewStory.storyLanguage;
      }
    });

    if (!languages.contains(choosedLanguage)) {
      myOwnLanguageController.text = choosedLanguage;
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
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomInset: false,
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
                              builder: (context) =>
                                  const Interests(isActiveBackButton: false)));
                        },
                        child: Center(
                          child: Text(
                            S.of(context).register_buttonNext,
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
                    S.of(context).newStory_buttonStoryLanguage,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87.withOpacity(0.7),
                    )),
                  ),
                  /*Expanded(
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
                        /*onChanged: (value) {
                              setState(() {
                                showSearchingStorys();
                              });
                            },*/
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
                            hintText: 'Search...',
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
                  ),*/
                ],
              ),
            ),
            body: ListView.builder(
                itemCount: languages.length + 1,
                itemBuilder: (cont, index) {
                  return index < languages.length
                      ? Padding(
                          padding: EdgeInsets.only(
                              left: 15.0,
                              right: 15.0,
                              bottom: 15.0,
                              top: index == 0 ? 15.0 : 0),
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.3),
                                      blurStyle: BlurStyle.outer)
                                ]),
                            child: Material(
                              borderRadius: BorderRadius.circular(10.0),
                              clipBehavior: Clip.antiAlias,
                              color: choosedLanguage == languages[index]
                                  ? Colors.blueAccent
                                  : null,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    choosedLanguage = languages[index];
                                    if (!widget.fromSettings) {
                                      NewStory.storyLanguage = languages[index];
                                    } else {
                                      UserLocalData()
                                          .saveStorysLanguage(languages[index]);
                                    }
                                  });
                                },
                                child: SizedBox(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        languages[index],
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                          letterSpacing: 0.5,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: choosedLanguage ==
                                                  languages[index]
                                              ? Colors.white
                                              : Colors.black87.withOpacity(0.7),
                                        )),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.only(
                              left: 15.0, right: 15.0, bottom: 15.0),
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
                                choosedLanguage = value;
                                if (!widget.fromSettings) {
                                  NewStory.storyLanguage = value;
                                } else {
                                  UserLocalData().saveStorysLanguage(value);
                                }
                              });
                            },
                            controller: myOwnLanguageController,
                            keyboardType: TextInputType.text,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87.withOpacity(0.7),
                            )),
                            decoration: InputDecoration(
                                hintText: S
                                    .of(context)
                                    .newStory_storyLanguage_textFieldMyLanguage,
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
                        );
                })),
      ),
    );
  }
}
