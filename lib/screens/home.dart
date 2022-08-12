import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_story/screens/new_story.dart';
import 'package:my_story/screens/profile.dart';
import 'package:my_story/screens/search_story.dart';
import 'package:my_story/screens/story.dart';

import '../generated/l10n.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  List<Widget> screens = [
    const Story(),
    const SearchStory(),
    const NewStory(),
    const Profile(),
  ];

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
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: BottomNavigationBar(
                unselectedItemColor: Colors.black87.withOpacity(0.5),
                selectedItemColor: Colors.black,
                elevation: 15,
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.text_snippet_outlined),
                    activeIcon: Icon(Icons.text_snippet_rounded),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search_outlined),
                    activeIcon: Icon(Icons.search_rounded),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add_outlined),
                    activeIcon: Icon(Icons.add_rounded),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline_rounded),
                    activeIcon: Icon(Icons.person_rounded),
                    label: '',
                  ),
                ]),
            body: screens.elementAt(_selectedIndex)));
  }
}
