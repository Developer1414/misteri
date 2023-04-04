import 'dart:io';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appodeal_flutter/appodeal_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_codes/country_codes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_story/screens/ban_screen.dart';
import 'package:my_story/screens/home.dart';
import 'package:my_story/screens/profile_settings.dart';
import 'package:my_story/screens/sign_in.dart';
import 'package:my_story/services/firestore_service.dart';
import 'models/popup.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  /*FirebaseUIAuth.configureProviders([
    GoogleProvider(
        clientId:
            '873556823155-ji5scikpnp0rmdd38h4grufj6pg97s9o.apps.googleusercontent.com'),
  ]);*/

  await CountryCodes.init();

  Appodeal.setAppKeys(
      androidAppKey: "2d8510a23c1036d7797d33bc2246e1326b06198ffd5c2300");

  //FirebaseMessaging messaging = FirebaseMessaging.instance;

  AppMetrica.activate(
      const AppMetricaConfig("235f074a-6dd0-45eb-97a6-e79d79a0609d"));
  AppMetrica.reportEvent('My first AppMetrica event!');

  /*NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );*/

  String screenNotif = '';
  String storyIdNotif = '';

  /*FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print(message.data);
    screenNotif = message.data['screen'];
    storyIdNotif = message.data['story_id'];
  });*/

  final String defaultSystemLocale = Platform.localeName;

  runApp(MyApp(
      screenFromNotification: screenNotif,
      storyIdFromNotification: storyIdNotif,
      initialDefaultSystemLocale: defaultSystemLocale));
}

class MyApp extends StatefulWidget {
  const MyApp(
      {Key? key,
      this.screenFromNotification = '',
      this.storyIdFromNotification = '',
      this.initialDefaultSystemLocale = ''})
      : super(key: key);

  final String screenFromNotification;
  final String storyIdFromNotification;

  final String initialDefaultSystemLocale;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = false;
  bool isLoadedUserAccount = false;

  @override
  void initState() {
    super.initState();
    //FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, AsyncSnapshot<dynamic> snap) {
              return !snap.hasData
                  ? const SignIn()
                  : FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .get(),
                      builder:
                          (cont, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 6.0,
                            ),
                          ));
                        }

                        return !snapshot.data!.exists
                            ? const UserProfileSettings(
                                isActiveBackButton: false)
                            : FutureBuilder<dynamic>(
                                future: FirestoreService().getAllMyData(),
                                builder:
                                    (cont, AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 6.0,
                                      ),
                                    ));
                                  }

                                  if (snapshot.hasError) {
                                    return popUpDialog(
                                        context: cont,
                                        title: S
                                            .of(context)
                                            .notification_titleError,
                                        content: snapshot.error.toString(),
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
                                                onTap: () =>
                                                    Navigator.of(cont).pop(),
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
                                                      fontWeight:
                                                          FontWeight.w700,
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

                                  return FutureBuilder<dynamic>(
                                      future: checkAccountOnBan(),
                                      builder: (cont,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child: SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 6.0,
                                            ),
                                          ));
                                        }

                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return snapshot.data;
                                        }

                                        return const Center(
                                            child: SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 6.0,
                                          ),
                                        ));
                                      });
                                },
                              );
                      });
            }),
      ),
    );
  }

  Future<Widget> checkAccountOnBan() async {
    Widget? screen;

    await FirebaseFirestore.instance
        .collection('Banned')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        final format = DateFormat('MM.dd.yyyy HH:mm');

        DateTime dt1 = format.parse(value.get('unlockDate'));
        DateTime dt2 = format.parse(
            '${DateTime.now().month}.${DateTime.now().day}.${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}');

        print(dt2.difference(dt1));

        if ((dt2.difference(dt1).inHours).abs() <= 0) {
          FirebaseFirestore.instance
              .collection('Banned')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .delete()
              .whenComplete(() => const Home());
        } else {
          screen = BanScreen(unlockDate: value.get('unlockDate'));
        }
      } else {
        screen = const Home();
      }
    });

    return screen ??
        const Center(
            child: SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            strokeWidth: 6.0,
          ),
        ));
  }
}
