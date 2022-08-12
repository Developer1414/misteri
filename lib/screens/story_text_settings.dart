import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_story/generated/l10n.dart';
import 'package:my_story/screens/choose_language_for_new_story.dart';
import 'package:my_story/screens/home.dart';
import 'package:my_story/services/user_local_data.dart';
import 'dart:math' as math;

class StoryTextSettings extends StatefulWidget {
  const StoryTextSettings({Key? key, this.openedFromSettings = false})
      : super(key: key);

  final bool openedFromSettings;

  @override
  State<StoryTextSettings> createState() => _StoryTextSettingsState();
}

class _StoryTextSettingsState extends State<StoryTextSettings> {
  TextEditingController textSizeController = TextEditingController();
  TextEditingController textLetterSpacingController = TextEditingController();
  TextEditingController textWordSpacingController = TextEditingController();

  Color myColor = Colors.black87.withOpacity(0.7);
  double textSize = 22;
  double letterSpacing = 0;
  double wordSpacing = 0;
  String textWeight = '';
  FontWeight fontWeight = FontWeight.w700;

  @override
  void initState() {
    super.initState();

    setState(() {
      textSizeController.text = UserLocalData.storyTextSize.toString();
      textLetterSpacingController.text =
          UserLocalData.storyTextLetterSpacing.toString();
      textWordSpacingController.text =
          UserLocalData.storyTextWordSpacing.toString();

      myColor = Color.fromARGB(
          UserLocalData.storyTextColorA,
          UserLocalData.storyTextColorR,
          UserLocalData.storyTextColorG,
          UserLocalData.storyTextColorB);

      textSize = UserLocalData.storyTextSize;
      textWeight = UserLocalData.textFontWeight;
      letterSpacing = UserLocalData.storyTextLetterSpacing;
      wordSpacing = UserLocalData.storyTextWordSpacing;

      switch (textWeight) {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;

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
          bottomNavigationBar: isKeyboardOpen || widget.openedFromSettings
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
                        UserLocalData().saveTextSettings(
                            double.parse(textSizeController.text.isNotEmpty
                                ? textSizeController.text
                                : '22'),
                            myColor.alpha,
                            myColor.red,
                            myColor.green,
                            myColor.blue,
                            textWeight,
                            letterSpacing,
                            wordSpacing);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const NewStoryLanguage(
                                fromSettings: true,
                                isActiveBackButton: false)));
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
                widget.openedFromSettings
                    ? IconButton(
                        onPressed: () {
                          UserLocalData().saveTextSettings(
                              double.parse(textSizeController.text.isNotEmpty
                                  ? textSizeController.text
                                  : '22'),
                              myColor.alpha,
                              myColor.red,
                              myColor.green,
                              myColor.blue,
                              textWeight,
                              letterSpacing,
                              wordSpacing);
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.black87.withOpacity(0.7),
                          size: 30,
                        ))
                    : Container(),
                widget.openedFromSettings
                    ? const SizedBox(
                        width: 20,
                      )
                    : Container(),
                Text(
                  S.of(context).storySettings_title,
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
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
                      onChanged: (text) {
                        setState(() {
                          textSize =
                              double.parse(text.isNotEmpty ? text : '22');
                        });
                      },
                      textAlign: TextAlign.center,
                      controller: textSizeController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                        letterSpacing: 0.5,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87.withOpacity(0.7),
                      )),
                      decoration: InputDecoration(
                          labelText: S.of(context).storySettings_textSizeTitle,
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
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
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
                      onChanged: (text) {
                        setState(() {
                          letterSpacing =
                              double.parse(text.isNotEmpty ? text : '0');
                        });
                      },
                      textAlign: TextAlign.center,
                      controller: textLetterSpacingController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                        letterSpacing: 0.5,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87.withOpacity(0.7),
                      )),
                      decoration: InputDecoration(
                          labelText: S
                              .of(context)
                              .storySettings_textLetterSpacingTitle,
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
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
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
                      onChanged: (text) {
                        setState(() {
                          wordSpacing =
                              double.parse(text.isNotEmpty ? text : '0');
                        });
                      },
                      textAlign: TextAlign.center,
                      controller: textWordSpacingController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                        letterSpacing: 0.5,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87.withOpacity(0.7),
                      )),
                      decoration: InputDecoration(
                          labelText:
                              S.of(context).storySettings_wordSpacingTitle,
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
                ),
                Container(
                  margin:
                      const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
                  height: 60,
                  child: Material(
                    borderRadius: BorderRadius.circular(18.0),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.blue,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext cont) {
                              return AlertDialog(
                                title: Text(
                                  S.of(context).storySettings_pickColorTitle,
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87.withOpacity(0.7),
                                  )),
                                ),
                                content: SingleChildScrollView(
                                  child: ColorPicker(
                                    pickerColor: myColor,
                                    onColorChanged: (Color color) {
                                      setState(() {
                                        myColor = color;
                                      });
                                    },
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    child: Text(
                                      S.of(context).storySettings_buttonDone,
                                      style: GoogleFonts.roboto(
                                          textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      )),
                                    ),
                                    onPressed: () {
                                      Navigator.of(cont).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.color_lens_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              S.of(context).storySettings_buttonTextColorTitle,
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
                  margin:
                      const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
                  height: 60,
                  child: Material(
                    borderRadius: BorderRadius.circular(18.0),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.blue,
                    child: InkWell(
                      onTap: () async {
                        bottomModalSheetWeights();
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.rotate(
                              angle: 180 * math.pi / 180,
                              child: const Icon(
                                Icons.line_weight_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              S.of(context).storySettings_buttonTextWeightTitle,
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
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    S.of(context).storySettings_textExample,
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87.withOpacity(0.7),
                    )),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
                  child: Text(
                    S.of(context).storySettings_textRealExample,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                      letterSpacing: letterSpacing,
                      wordSpacing: wordSpacing,
                      fontSize:
                          textSizeController.text.isNotEmpty ? textSize : 22,
                      fontWeight: fontWeight,
                      color: myColor,
                    )),
                  ),
                ),
                Container(
                  height: 60,
                  margin: const EdgeInsets.all(20.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(18.0),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.redAccent,
                    child: InkWell(
                      onTap: () {
                        textSizeController.text = '22.0';
                        setState(() {
                          textSize = 22;
                          fontWeight = FontWeight.w700;
                          letterSpacing = 0.0;
                          wordSpacing = 0.0;

                          textLetterSpacingController.text =
                              UserLocalData.storyTextLetterSpacing.toString();
                          textWordSpacingController.text =
                              UserLocalData.storyTextWordSpacing.toString();
                        });
                        textWeight = 'w700';
                        myColor = Colors.black87.withOpacity(0.7);
                        UserLocalData().saveTextSettings(
                            22.0,
                            myColor.alpha,
                            myColor.red,
                            myColor.green,
                            myColor.blue,
                            textWeight,
                            letterSpacing,
                            wordSpacing);
                      },
                      child: Center(
                        child: Text(
                          S.of(context).storySettings_buttonDeafultSettings,
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
          ),
        ),
      ),
    );
  }

  Future bottomModalSheetWeights() async {
    await showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (context) {
          return SizedBox(
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          fontWeight = FontWeight.w100;
                          break;
                        case 1:
                          fontWeight = FontWeight.w200;
                          break;
                        case 2:
                          fontWeight = FontWeight.w300;
                          break;
                        case 3:
                          fontWeight = FontWeight.w400;
                          break;
                        case 4:
                          fontWeight = FontWeight.w500;
                          break;
                        case 5:
                          fontWeight = FontWeight.w600;
                          break;
                        case 6:
                          fontWeight = FontWeight.w700;
                          break;
                        case 7:
                          fontWeight = FontWeight.w800;
                          break;
                        case 8:
                          fontWeight = FontWeight.w900;
                          break;
                      }

                      return Container(
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
                              setState(() {
                                switch (index) {
                                  case 0:
                                    fontWeight = FontWeight.w100;
                                    break;
                                  case 1:
                                    fontWeight = FontWeight.w200;
                                    break;
                                  case 2:
                                    fontWeight = FontWeight.w300;
                                    break;
                                  case 3:
                                    fontWeight = FontWeight.w400;
                                    break;
                                  case 4:
                                    fontWeight = FontWeight.w500;
                                    break;
                                  case 5:
                                    fontWeight = FontWeight.w600;
                                    break;
                                  case 6:
                                    fontWeight = FontWeight.w700;
                                    break;
                                  case 7:
                                    fontWeight = FontWeight.w800;
                                    break;
                                  case 8:
                                    fontWeight = FontWeight.w900;
                                    break;
                                }

                                textWeight = 'w${index + 1}00';
                              });

                              Navigator.of(context).pop();
                            },
                            child: Center(
                              child: Text(
                                'w${index + 1}00',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                  letterSpacing: 0.5,
                                  fontSize: 23,
                                  fontWeight: fontWeight,
                                  color: Colors.white,
                                )),
                              ),
                            ),
                          ),
                        ),
                      );
                    })),
          );
        });
  }
}
