import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_story/screens/new_story.dart';
//import 'package:flutter_quill/flutter_quill.dart';
import '../generated/l10n.dart';
import '../services/user_local_data.dart';

class NewStoryScreen extends StatefulWidget {
  const NewStoryScreen({Key? key}) : super(key: key);

  @override
  State<NewStoryScreen> createState() => _NewStoryScreenState();
}

class _NewStoryScreenState extends State<NewStoryScreen> {
  //final QuillController _controller = QuillController.basic();

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
                  S.of(context).newStory_title,
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
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin:
                const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.3),
                      blurStyle: BlurStyle.outer)
                ]),
            child: TextField(
              toolbarOptions: const ToolbarOptions(
                copy: true,
                cut: true,
                selectAll: false,
              ),
              maxLength: 10000,
              onChanged: (text) => UserLocalData().saveStory(text),
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              textInputAction: TextInputAction.newline,
              controller: NewStory.storyController,
              keyboardType: TextInputType.multiline,
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                letterSpacing: 0.5,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87.withOpacity(0.7),
              )),
              decoration: InputDecoration(
                  counterText: '',
                  hintText: S.of(context).newStory_textFieldStory,
                  hintStyle: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                    letterSpacing: 0.5,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black45,
                  )),
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 2)),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.black38, width: 2))),
            ),
          ),
        ),
      ),
    );
  }
}
