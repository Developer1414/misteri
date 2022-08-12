import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_story/screens/sign_in.dart';
import 'package:my_story/services/language_change_provider.dart';
import 'package:my_story/services/user_local_data.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';

class AppLanguage extends StatefulWidget {
  const AppLanguage({Key? key, this.isActiveBackButton = true})
      : super(key: key);

  final bool isActiveBackButton;

  @override
  State<AppLanguage> createState() => _AppLanguageState();
}

class _AppLanguageState extends State<AppLanguage> {
  List<String> languages = [
    'English',
    'Русский',
    'Français',
  ];

  List<String> languageCode = [
    'en',
    'ru',
    'fr',
  ];

  @override
  void initState() {
    super.initState();
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
      child: Consumer<LanguageChangeProvider>(
          builder: (context, provider, snapshot) {
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
                      S.of(context).app_language,
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
                  itemCount: languages.length,
                  itemBuilder: (cont, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          bottom: 15.0,
                          top: index == 0 ? 15.0 : 0),
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.3),
                                  blurStyle: BlurStyle.outer)
                            ]),
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () {
                              Locale locale = Locale(languageCode[index]);
                              provider.setLocale(locale);
                              UserLocalData()
                                  .saveUserLanguage(languageCode[index]);

                              /*context
                                  .read<LanguageChangeProvider>()
                                  .setLocale(locale);*/
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
                                      color: Colors.black87.withOpacity(0.7),
                                    )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  })),
        );
      }),
    );
  }
}
