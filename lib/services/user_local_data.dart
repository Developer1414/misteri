import 'package:my_story/services/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocalData {
  static String lastSavedTitle = '';
  static String lastStory = '';
  static String lastSavedStory = '';
  static String textFontWeight = '';

  static double storyTextSize = 22;
  static double storyTextLetterSpacing = 0;
  static double storyTextWordSpacing = 0;
  static int storyTextColorA = 221;
  static int storyTextColorR = 0;
  static int storyTextColorG = 0;
  static int storyTextColorB = 0;

  Future saveCurrentStoryId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastStoryId', id);
  }

  Future<String> getLastStoryId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastStoryId') ?? '';
  }

  Future removeLastStoryId() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('lastStoryId');
  }

  void saveTextSettings(double textSize, int a, int r, int g, int b,
      String fontWeight, double letterSpcacing, double wordSpacing) async {
    final prefs = await SharedPreferences.getInstance();

    storyTextSize = textSize;
    storyTextColorA = a;
    storyTextColorR = r;
    storyTextColorG = g;
    storyTextColorB = b;
    textFontWeight = fontWeight;
    storyTextLetterSpacing = letterSpcacing;
    storyTextWordSpacing = wordSpacing;

    await prefs.setDouble('textSize', textSize);
    await prefs.setDouble('letterSpacingText', letterSpcacing);
    await prefs.setDouble('wordSpacingText', wordSpacing);
    await prefs.setInt('textColorA', a);
    await prefs.setInt('textColorR', r);
    await prefs.setInt('textColorG', g);
    await prefs.setInt('textColorB', b);
    await prefs.setString('fontWeight', fontWeight);
  }

  Future getTextSettings() async {
    final prefs = await SharedPreferences.getInstance();

    storyTextSize = prefs.getDouble('textSize')?.toDouble() ?? 22;
    storyTextColorA = prefs.getInt('textColorA') ?? 221;
    storyTextColorR = prefs.getInt('textColorR') ?? 0;
    storyTextColorG = prefs.getInt('textColorG') ?? 0;
    storyTextColorB = prefs.getInt('textColorB') ?? 0;
    storyTextLetterSpacing =
        prefs.getDouble('letterSpacingText')?.toDouble() ?? 0;
    storyTextWordSpacing = prefs.getDouble('wordSpacingText')?.toDouble() ?? 0;
    textFontWeight = prefs.getString('fontWeight').toString();
  }

  void saveStory(String story) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastStory', story);
  }

  void saveTitle(String title) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastTitle', title);
  }

  void saveStorysLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    UserData.storysLanguage = lang;
    await prefs.setString('storysLanguage', lang);
  }

  Future getStorysLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    UserData.storysLanguage = prefs.getString('storysLanguage') ?? 'English';
  }

  Future getLastStory() async {
    final prefs = await SharedPreferences.getInstance();
    lastSavedStory = prefs.getString('lastStory') ?? '';
  }

  Future getLastTitle() async {
    final prefs = await SharedPreferences.getInstance();
    lastSavedTitle = prefs.getString('lastTitle') ?? '';
  }

  Future removeLastSavedStoryAndTitle() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('lastStory');
    prefs.remove('lastTitle');
  }

  Future saveUserLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    UserData.appLanguage = lang;
    await prefs.setString('userLanguage3', lang);
  }

  Future<String?> getUserLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    UserData.appLanguage = prefs.getString('userLanguage3') ?? 'en';
    return prefs.getString('userLanguage3');
  }

  Future saveUserInterests(List<String> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('interests', list);
  }

  Future getUserInterests() async {
    final prefs = await SharedPreferences.getInstance();
    UserData.myInterests = prefs.getStringList('interests') ??
        [
          'love',
          'comedy',
          'sports',
          'games',
          'drama',
          'fantasy',
          'nature',
          'animals',
          'travels',
          'dailyLife'
        ];
  }
}
