import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_story/models/popup.dart';
import 'package:my_story/screens/profile_settings.dart';
import 'package:my_story/services/firebase_auth_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../generated/l10n.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

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
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  toolbarHeight: 180,
                  title: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      S.of(context).register_title,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      )),
                    ),
                  ),
                ),
                body: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, bottom: 20.0),
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
                            controller: emailController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87.withOpacity(0.7),
                            )),
                            decoration: InputDecoration(
                                hintText: S.of(context).register_textFieldEmail,
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
                        Container(
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
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
                            controller: passwordController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.visiblePassword,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87.withOpacity(0.7),
                            )),
                            decoration: InputDecoration(
                                hintText:
                                    S.of(context).register_textFieldPassword,
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
                        Container(
                          height: 60,
                          margin: const EdgeInsets.all(20.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(15.0),
                            clipBehavior: Clip.antiAlias,
                            color: Colors.blue,
                            child: InkWell(
                              onTap: () async {
                                if (emailController.text.isEmpty) {
                                  popUpDialog(
                                      title:
                                          S.of(context).notification_titleError,
                                      content:
                                          S.of(context).login_noWritedEmail,
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
                                                      textStyle:
                                                          const TextStyle(
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

                                if (passwordController.text.isEmpty) {
                                  popUpDialog(
                                      title:
                                          S.of(context).notification_titleError,
                                      content:
                                          S.of(context).login_noWritedPassword,
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
                                                      textStyle:
                                                          const TextStyle(
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

                                  await FirebaseAuthService().signUp(
                                      name: '',
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim());

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const UserProfileSettings(
                                              isActiveBackButton: false)));
                                } on FirebaseException catch (e) {
                                  setState(() {
                                    isLoading = false;
                                  });

                                  String notification = '';

                                  switch (e.code) {
                                    case 'invalid-email':
                                      notification =
                                          S.of(context).register_invalidEmail;
                                      break;
                                    case 'weak-password':
                                      notification =
                                          S.of(context).register_weakPassword;
                                      break;
                                    case 'email-already-in-use':
                                      notification = S
                                          .of(context)
                                          .register_emailAlreadyInUse;
                                      break;
                                    default:
                                      e.message.toString();
                                  }

                                  popUpDialog(
                                      title:
                                          S.of(context).notification_titleError,
                                      content: notification,
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
                                                      textStyle:
                                                          const TextStyle(
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
                        Text(
                          S.of(context).login_textOr,
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                            letterSpacing: 0.5,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87.withOpacity(0.7),
                          )),
                        ),
                        Container(
                          height: 60,
                          margin: const EdgeInsets.all(20.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(18.0),
                            clipBehavior: Clip.antiAlias,
                            color: Colors.redAccent,
                            child: InkWell(
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });

                                Object? error;

                                await signInWithGoogle().catchError((onError) {
                                  error = onError;
                                });

                                if (error == null) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const UserProfileSettings(
                                              isActiveBackButton: false)));
                                } else {
                                  Navigator.of(context).pop();
                                }

                                setState(() {
                                  isLoading = false;
                                });
                              },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.google,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      const SizedBox(width: 10.0),
                                      SizedBox(
                                        width: 370,
                                        child: Text(
                                          S.of(context).register_withGoogle,
                                          style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                            letterSpacing: 0.5,
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            shadowColor: Colors.black,
                            elevation: 5,
                          ),
                        ),
                        Container(
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange, width: 2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text:
                                          '${S.of(context).register_PrivacyPolicyConfirmation} ',
                                      style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87.withOpacity(0.7),
                                      )),
                                    ),
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          var url = Uri.parse(
                                              "https://drive.google.com/file/d/1fm16m9BCD8QroWlVUeE3S31K06mGTTzl/view?usp=sharing");
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url);
                                          } else {
                                            throw "Could not launch $url";
                                          }
                                        },
                                      text: S
                                          .of(context)
                                          .register_buttonPrivacyPolicy,
                                      style: GoogleFonts.roboto(
                                          textStyle: const TextStyle(
                                        letterSpacing: 0.5,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.blue,
                                      )),
                                    )
                                  ])),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 20.0, bottom: 20, left: 20.0, right: 20.0),
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text:
                                  '${S.of(context).register_textAlreadyMember} ',
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87.withOpacity(0.7),
                              )),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pop();
                                },
                              text: S.of(context).register_buttonAlreadyMember,
                              style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                letterSpacing: 0.5,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.blue,
                              )),
                            )
                          ])),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return null;

    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
