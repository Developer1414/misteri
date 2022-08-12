import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_story/screens/new_story.dart';
import '../generated/l10n.dart';
import '../services/story_data_service.dart';

class NewStoryAdditionallySettings extends StatefulWidget {
  const NewStoryAdditionallySettings({Key? key, this.isEditStory = false})
      : super(key: key);

  final bool isEditStory;

  @override
  State<NewStoryAdditionallySettings> createState() =>
      _NewStoryAdditionallySettingsState();
}

class _NewStoryAdditionallySettingsState
    extends State<NewStoryAdditionallySettings> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
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
              Expanded(
                child: Text(
                  S.of(context).newStory_additionally,
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: 60,
                  margin: const EdgeInsets.all(15.0),
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
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${S.of(context).comments_title}:',
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                            letterSpacing: 0.5,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87.withOpacity(0.7),
                          )),
                        ),
                        FlutterSwitch(
                          activeColor: const Color.fromARGB(255, 89, 192, 93),
                          width: 80.0,
                          height: 40.0,
                          valueFontSize: 20.0,
                          toggleSize: 30.0,
                          value: NewStory.commentsAccess,
                          borderRadius: 20.0,
                          padding: 6.0,
                          showOnOff: false,
                          onToggle: (val) {
                            setState(() {
                              NewStory.commentsAccess = val;
                            });
                          },
                        ),
                      ],
                    ),
                  )),
              Container(
                  height: 60,
                  margin: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 15.0),
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
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '18+:',
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                            letterSpacing: 0.5,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87.withOpacity(0.7),
                          )),
                        ),
                        FlutterSwitch(
                          activeColor: const Color.fromARGB(255, 89, 192, 93),
                          width: 80.0,
                          height: 40.0,
                          valueFontSize: 20.0,
                          toggleSize: 30.0,
                          value: NewStory.forAdults,
                          borderRadius: 20.0,
                          padding: 6.0,
                          showOnOff: false,
                          onToggle: (val) {
                            setState(() {
                              NewStory.forAdults = val;
                            });
                          },
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
