import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_story/main.dart';
import 'package:my_story/screens/profile_settings.dart';
import 'package:my_story/screens/sign_up.dart';

import '../generated/l10n.dart';
import '../models/popup.dart';
import '../services/firebase_auth_service.dart';
import '../services/user_local_data.dart';
import 'home.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
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
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  toolbarHeight: 180,
                  title: Text(
                    S.of(context).login_title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    )),
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

                                  await FirebaseAuthService().signIn(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim());

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const Home()));
                                } on FirebaseException catch (e) {
                                  setState(() {
                                    isLoading = false;
                                  });

                                  String error = '';

                                  if (e.code == 'user-not-found') {
                                    error = S.of(context).login_userNotFound;
                                  } else if (e.code == 'wrong-password') {
                                    error = S.of(context).login_wrongPassword;
                                  } else {
                                    error = e.message.toString();
                                  }

                                  popUpDialog(
                                      title:
                                          S.of(context).notification_titleError,
                                      content: error,
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
                                  S.of(context).storySettings_buttonDone,
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
                                await signInWithGoogle().whenComplete(() {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const Home()));
                                });
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const FaIcon(
                                      FontAwesomeIcons.google,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    const SizedBox(width: 10.0),
                                    Text(
                                      S.of(context).login_withGoogle,
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
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                text: '${S.of(context).login_notMember} ',
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
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUp()));
                                  },
                                text: S.of(context).login_buttonRegister,
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                  letterSpacing: 0.5,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blue,
                                )),
                              )
                            ])),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
