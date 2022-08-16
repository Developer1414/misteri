import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_story/models/popup.dart';
import 'package:my_story/screens/story_text_settings.dart';
import 'package:my_story/services/firebase_auth_service.dart';
import 'package:my_story/services/firestore_service.dart';
import 'package:my_story/services/storage_service.dart';
import 'package:my_story/services/user.dart';
import 'package:shimmer/shimmer.dart';

import '../generated/l10n.dart';

class UserProfileSettings extends StatefulWidget {
  const UserProfileSettings({Key? key, this.isActiveBackButton = true})
      : super(key: key);

  final bool isActiveBackButton;

  @override
  State<UserProfileSettings> createState() => _UserProfileSettingsState();
}

class _UserProfileSettingsState extends State<UserProfileSettings> {
  bool _nameIsExist = false;
  bool isLoadingImage = false;
  bool isLoading = false;

  String pathImage = '';
  FilePickerResult? result;

  TextEditingController nameController = TextEditingController();

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
                  bottomNavigationBar: Container(
                    height: 60,
                    margin: const EdgeInsets.all(20.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(15.0),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.blue,
                      child: InkWell(
                        onTap: () async {
                          if (_nameIsExist) return;

                          if (nameController.text.isEmpty) {
                            popUpDialog(
                                title: S.of(context).notification_titleError,
                                content: S.of(context).register_noWritedName,
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
                                        onTap: () => Navigator.of(context,
                                                rootNavigator: true)
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

                          if (nameController.text.length < 2) {
                            popUpDialog(
                                title: S.of(context).notification_titleError,
                                content: S.of(context).register_shortName,
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
                                        onTap: () => Navigator.of(context,
                                                rootNavigator: true)
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

                          setState(() {
                            isLoading = true;
                          });

                          await FirebaseAuthService()
                              .signUp(name: nameController.text.trim())
                              .whenComplete(() {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const StoryTextSettings()));
                          });

                          setState(() {
                            isLoading = false;
                          });
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
                            ? const SizedBox(width: 20.0)
                            : Container(),
                        Text(
                          S.of(context).register_photoAndNameTitle,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 80,
                                    child: Material(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      clipBehavior: Clip.antiAlias,
                                      shadowColor: Colors.black,
                                      elevation: 5,
                                      child: SizedBox(
                                        width: 200,
                                        height: 200,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: isLoadingImage
                                              ? const Center(
                                                  child: SizedBox(
                                                  width: 40,
                                                  height: 40,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 6.0,
                                                    color: Colors.blue,
                                                  ),
                                                ))
                                              : InkWell(
                                                  onTap: () async {
                                                    final results = await FilePicker
                                                        .platform
                                                        .pickFiles(
                                                            allowMultiple:
                                                                false,
                                                            type:
                                                                FileType.custom,
                                                            allowedExtensions: [
                                                          'jpg',
                                                          'png'
                                                        ]);

                                                    if (results == null) {
                                                      return;
                                                    }

                                                    if (results.files.first
                                                        .path!.isNotEmpty) {
                                                      setState(() {
                                                        isLoadingImage = true;
                                                        pathImage = results
                                                            .files.first.path
                                                            .toString();
                                                        UserData.userImageFile =
                                                            File(results.files
                                                                .first.path
                                                                .toString());
                                                      });

                                                      await StorageService()
                                                          .uploadImage(
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                              UserData
                                                                  .userImageFile!
                                                                  .path
                                                                  .toString());

                                                      setState(() {
                                                        isLoadingImage = false;
                                                      });
                                                    }
                                                  },
                                                  child: FirebaseAuth.instance
                                                              .currentUser !=
                                                          null
                                                      ? FutureBuilder(
                                                          future: FirestoreService()
                                                              .getAvatarImage(
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return Shimmer
                                                                  .fromColors(
                                                                      baseColor:
                                                                          Colors.grey[
                                                                              300]!,
                                                                      highlightColor:
                                                                          Colors.grey[
                                                                              100]!,
                                                                      child:
                                                                          CircleAvatar(
                                                                        backgroundColor:
                                                                            Colors.grey[300],
                                                                      ));
                                                            }

                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .done) {
                                                              return ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.0),
                                                                child: snapshot
                                                                            .data !=
                                                                        null
                                                                    ? snapshot
                                                                            .data
                                                                        as Image
                                                                    : const Icon(
                                                                        Icons
                                                                            .person,
                                                                        size:
                                                                            50,
                                                                        color: Colors
                                                                            .blue,
                                                                      ),
                                                              );
                                                            }

                                                            return const Center(
                                                                child: SizedBox(
                                                              width: 40,
                                                              height: 40,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                strokeWidth:
                                                                    6.0,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                            ));
                                                          })
                                                      : ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                          child: result != null
                                                              ? result?.files
                                                                      .first
                                                                  as Image
                                                              : const Icon(
                                                                  Icons.person,
                                                                  size: 60,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                        ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
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
                              if (text.isEmpty) {
                                _nameIsExist = false;
                                return;
                              }

                              FirebaseFirestore.instance
                                  .collection('Users')
                                  .where('name', isEqualTo: text)
                                  .get()
                                  .then((value) {
                                if (value.docs.isNotEmpty) {
                                  setState(() {
                                    _nameIsExist = true;
                                  });
                                } else {
                                  setState(() {
                                    _nameIsExist = false;
                                  });
                                }
                              });
                            },
                            controller: nameController,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp('[a-z A-Z 0-9]'))
                            ],
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87.withOpacity(0.7),
                            )),
                            decoration: InputDecoration(
                                hintText: S.of(context).register_textFieldName,
                                labelText: _nameIsExist
                                    ? S.of(context).register_nameIsExist
                                    : null,
                                hintStyle: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                  letterSpacing: 0.5,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black45,
                                )),
                                labelStyle: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                  letterSpacing: 0.5,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.redAccent,
                                )),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        color: _nameIsExist
                                            ? Colors.redAccent
                                            : Colors.transparent,
                                        width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        color: _nameIsExist
                                            ? Colors.redAccent
                                            : Colors.black38,
                                        width: 2))),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
    );
  }
}
