import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_story/services/firestore_service.dart';
import 'package:my_story/services/story_data_service.dart';

import '../generated/l10n.dart';
import '../models/popup.dart';

class NewCommentScreen extends StatefulWidget {
  const NewCommentScreen(
      {Key? key,
      this.reply = '',
      this.comment = '',
      this.commentId = '',
      this.subcommentId = ''})
      : super(key: key);

  final String reply;
  final String comment;
  final String commentId;
  final String subcommentId;

  @override
  State<NewCommentScreen> createState() => _NewCommentScreenState();
}

class _NewCommentScreenState extends State<NewCommentScreen> {
  TextEditingController commentController = TextEditingController();

  bool isLoading = false;
  int countSymbols = 0;

  @override
  void initState() {
    super.initState();
    if (widget.reply.isNotEmpty) {
      commentController.text = '@${widget.reply}, ';
    }

    if (widget.comment.isNotEmpty) {
      commentController.text = widget.comment;
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
                        child: SizedBox(
                          width: 300,
                          child: Text(
                            widget.reply.isNotEmpty
                                ? S.of(context).comments_buttonReplyToUser
                                : widget.comment.isNotEmpty
                                    ? S.of(context).comments_buttonEditComment
                                    : S.of(context).newComment_title,
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
                      ),
                    ],
                  ),
                  actions: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Text(
                          '$countSymbols/300',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87.withOpacity(0.5),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.only(left: 15.0, right: 15.0),
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
                          maxLength: 300,
                          expands: true,
                          maxLines: null,
                          minLines: null,
                          textAlignVertical: TextAlignVertical.top,
                          controller: commentController,
                          onChanged: (value) {
                            setState(() {
                              countSymbols = value.length;
                            });
                          },
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
                              hintText:
                                  S.of(context).newComment_textFieldYourComment,
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
                    Container(
                      height: 60,
                      margin: const EdgeInsets.all(15.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(15.0),
                        clipBehavior: Clip.antiAlias,
                        color: const Color.fromARGB(255, 89, 192, 93),
                        child: InkWell(
                          onTap: () {
                            if (commentController.text.isEmpty) {
                              popUpDialog(
                                  title: S.of(context).notification_titleError,
                                  content:
                                      S.of(context).newComment_noWritedComment,
                                  context: context,
                                  buttons: [
                                    SizedBox(
                                      height: 50,
                                      width: 70,
                                      child: Material(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        clipBehavior: Clip.antiAlias,
                                        color: Colors.blue,
                                        child: InkWell(
                                          onTap: () => Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop(),
                                          child: Center(
                                            child: Text(
                                              S
                                                  .of(context)
                                                  .notification_buttonOK,
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
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              newComment(context);
                            } on FirebaseException catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              popUpDialog(
                                  title: S.of(context).notification_titleError,
                                  content:
                                      S.of(context).notification_titleError,
                                  context: context,
                                  buttons: [
                                    SizedBox(
                                      height: 50,
                                      width: 70,
                                      child: Material(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        clipBehavior: Clip.antiAlias,
                                        color: Colors.blue,
                                        child: InkWell(
                                          onTap: () => Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop(),
                                          child: Center(
                                            child: Text(
                                              S
                                                  .of(context)
                                                  .notification_buttonOK,
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
                          child: Center(
                            child: Text(
                              S.of(context).newComment_buttonPublish,
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
                  ],
                ),
              ),
      ),
    );
  }

  Future newComment(BuildContext context) {
    return FirestoreService()
        .publishComment(commentController.text, widget.commentId,
            isReply: widget.reply.isNotEmpty, subcommentId: widget.subcommentId)
        .whenComplete(() => {
              setState(() {
                isLoading = false;
              }),
              popUpDialog(
                  title: S.of(context).notification_titleNotification,
                  content: S.of(context).newComment_commentPublished,
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
                              Navigator.of(context, rootNavigator: true).pop(),
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
                  ]),
              commentController.text = ''
            });
  }
}
