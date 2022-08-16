import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_story/screens/interests.dart';
import 'package:my_story/screens/new_story.dart';
import 'package:my_story/services/user.dart';

import '../generated/l10n.dart';
import '../services/user_local_data.dart';

class StorysLanguage extends StatefulWidget {
  const StorysLanguage(
      {Key? key, this.fromSettings = false, this.isActiveBackButton = true})
      : super(key: key);

  final bool fromSettings;
  final bool isActiveBackButton;

  @override
  State<StorysLanguage> createState() => _StorysLanguageState();
}

class _StorysLanguageState extends State<StorysLanguage> {
  TextEditingController myOwnLanguageController = TextEditingController();
  bool isSearching = false;
  bool isChoosedNewLanguage = false;

  String choosedLanguage = '';

  Map<String, String> langs = {
    'en': 'English',
    'ru': 'Русский',
    'zh': '中國人',
    'hi': 'हिन्दी',
    'es': 'Español',
    'ae': 'عرب',
    'bn': 'বাংলা',
    'pt': 'Português',
    'id': 'bahasa Indonesia',
    'fr': 'Français',
    'de': 'Deutsch',
  };

  @override
  void initState() {
    super.initState();

    String languageCode = CountryCodes.getDeviceLocale()!.languageCode;

    setState(() {
      if (widget.fromSettings) {
        if (!widget.isActiveBackButton) {
          if (langs.keys.contains(languageCode)) {
            choosedLanguage = langs[languageCode]!;
            UserLocalData().saveStorysLanguage(langs[languageCode]!);
          } else {
            choosedLanguage = 'English';
          }
        } else {
          choosedLanguage = UserData.storysLanguage;
        }

        if (!langs.values.contains(UserData.storysLanguage)) {
          myOwnLanguageController.text = choosedLanguage;
        }
      } else {
        choosedLanguage = NewStory.storyLanguage.isEmpty
            ? UserData.storysLanguage
            : NewStory.storyLanguage;

        if (!langs.values.contains(choosedLanguage)) {
          myOwnLanguageController.text = choosedLanguage;
        }
      }
    });
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
                      ? Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.black87.withOpacity(0.7),
                                size: 30,
                              )),
                        )
                      : Container(),
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
                itemCount: langs.length + 1,
                itemBuilder: (cont, index) {
                  return index < langs.length
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
                              color: choosedLanguage ==
                                      langs[langs.keys.elementAt(index)]
                                  ? Colors.blueAccent
                                  : null,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    choosedLanguage =
                                        langs[langs.keys.elementAt(index)] ??
                                            'English';
                                    if (!widget.fromSettings) {
                                      NewStory.storyLanguage =
                                          langs[langs.keys.elementAt(index)] ??
                                              'English';
                                    } else {
                                      UserLocalData().saveStorysLanguage(
                                          langs[langs.keys.elementAt(index)] ??
                                              'English');
                                    }
                                  });
                                },
                                child: SizedBox(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        langs.values.elementAt(index),
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                          letterSpacing: 0.5,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: choosedLanguage ==
                                                  langs[langs.keys
                                                      .elementAt(index)]
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
