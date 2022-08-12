// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Answers`
  String get answers_title {
    return Intl.message(
      'Answers',
      name: 'answers_title',
      desc: '',
      args: [],
    );
  }

  /// `App language`
  String get app_language {
    return Intl.message(
      'App language',
      name: 'app_language',
      desc: '',
      args: [],
    );
  }

  /// `Author`
  String get comments_authorText {
    return Intl.message(
      'Author',
      name: 'comments_authorText',
      desc: '',
      args: [],
    );
  }

  /// `Copy comment`
  String get comments_buttonCopyComment {
    return Intl.message(
      'Copy comment',
      name: 'comments_buttonCopyComment',
      desc: '',
      args: [],
    );
  }

  /// `Delete comment`
  String get comments_buttonDeleteComment {
    return Intl.message(
      'Delete comment',
      name: 'comments_buttonDeleteComment',
      desc: '',
      args: [],
    );
  }

  /// `Edit comment`
  String get comments_buttonEditComment {
    return Intl.message(
      'Edit comment',
      name: 'comments_buttonEditComment',
      desc: '',
      args: [],
    );
  }

  /// `Reply to user`
  String get comments_buttonReplyToUser {
    return Intl.message(
      'Reply to user',
      name: 'comments_buttonReplyToUser',
      desc: '',
      args: [],
    );
  }

  /// `The author has banned comments on this story!`
  String get comments_CommentsForbiddenText {
    return Intl.message(
      'The author has banned comments on this story!',
      name: 'comments_CommentsForbiddenText',
      desc: '',
      args: [],
    );
  }

  /// `There are no comments yet.\nYou can be the first!`
  String get comments_noCommentsText {
    return Intl.message(
      'There are no comments yet.\nYou can be the first!',
      name: 'comments_noCommentsText',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get comments_title {
    return Intl.message(
      'Comments',
      name: 'comments_title',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this draft?`
  String get draft_deletionConfirmation {
    return Intl.message(
      'Are you sure you want to delete this draft?',
      name: 'draft_deletionConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `You haven't added any stories to your draft yet`
  String get draft_noStorysText {
    return Intl.message(
      'You haven\'t added any stories to your draft yet',
      name: 'draft_noStorysText',
      desc: '',
      args: [],
    );
  }

  /// `Draft`
  String get draft_title {
    return Intl.message(
      'Draft',
      name: 'draft_title',
      desc: '',
      args: [],
    );
  }

  /// `Animals`
  String get interests_animals {
    return Intl.message(
      'Animals',
      name: 'interests_animals',
      desc: '',
      args: [],
    );
  }

  /// `Auto`
  String get interests_auto {
    return Intl.message(
      'Auto',
      name: 'interests_auto',
      desc: '',
      args: [],
    );
  }

  /// `Comedy`
  String get interests_comedy {
    return Intl.message(
      'Comedy',
      name: 'interests_comedy',
      desc: '',
      args: [],
    );
  }

  /// `Daily life`
  String get interests_dailyLife {
    return Intl.message(
      'Daily life',
      name: 'interests_dailyLife',
      desc: '',
      args: [],
    );
  }

  /// `Drama`
  String get interests_drama {
    return Intl.message(
      'Drama',
      name: 'interests_drama',
      desc: '',
      args: [],
    );
  }

  /// `Fantasy`
  String get interests_fantasy {
    return Intl.message(
      'Fantasy',
      name: 'interests_fantasy',
      desc: '',
      args: [],
    );
  }

  /// `Foods`
  String get interests_foods {
    return Intl.message(
      'Foods',
      name: 'interests_foods',
      desc: '',
      args: [],
    );
  }

  /// `Games`
  String get interests_games {
    return Intl.message(
      'Games',
      name: 'interests_games',
      desc: '',
      args: [],
    );
  }

  /// `Love`
  String get interests_love {
    return Intl.message(
      'Love',
      name: 'interests_love',
      desc: '',
      args: [],
    );
  }

  /// `Nature`
  String get interests_nature {
    return Intl.message(
      'Nature',
      name: 'interests_nature',
      desc: '',
      args: [],
    );
  }

  /// `Sports`
  String get interests_sport {
    return Intl.message(
      'Sports',
      name: 'interests_sport',
      desc: '',
      args: [],
    );
  }

  /// `Stories with this interest(s):`
  String get interests_storyCount {
    return Intl.message(
      'Stories with this interest(s):',
      name: 'interests_storyCount',
      desc: '',
      args: [],
    );
  }

  /// `Interests`
  String get interests_title {
    return Intl.message(
      'Interests',
      name: 'interests_title',
      desc: '',
      args: [],
    );
  }

  /// `Travels`
  String get interests_travels {
    return Intl.message(
      'Travels',
      name: 'interests_travels',
      desc: '',
      args: [],
    );
  }

  /// `You haven't liked any of the stories yet`
  String get likes_noStorysText {
    return Intl.message(
      'You haven\'t liked any of the stories yet',
      name: 'likes_noStorysText',
      desc: '',
      args: [],
    );
  }

  /// `This story is no more`
  String get likes_storyNotExist {
    return Intl.message(
      'This story is no more',
      name: 'likes_storyNotExist',
      desc: '',
      args: [],
    );
  }

  /// `Likes`
  String get likes_title {
    return Intl.message(
      'Likes',
      name: 'likes_title',
      desc: '',
      args: [],
    );
  }

  /// `Register!`
  String get login_buttonRegister {
    return Intl.message(
      'Register!',
      name: 'login_buttonRegister',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get login_notMember {
    return Intl.message(
      'Don\'t have an account?',
      name: 'login_notMember',
      desc: '',
      args: [],
    );
  }

  /// `You didn't write a email!`
  String get login_noWritedEmail {
    return Intl.message(
      'You didn\'t write a email!',
      name: 'login_noWritedEmail',
      desc: '',
      args: [],
    );
  }

  /// `You didn't write a password!`
  String get login_noWritedPassword {
    return Intl.message(
      'You didn\'t write a password!',
      name: 'login_noWritedPassword',
      desc: '',
      args: [],
    );
  }

  /// `Or`
  String get login_textOr {
    return Intl.message(
      'Or',
      name: 'login_textOr',
      desc: '',
      args: [],
    );
  }

  /// `Welcome!\nAuthorization:`
  String get login_title {
    return Intl.message(
      'Welcome!\nAuthorization:',
      name: 'login_title',
      desc: '',
      args: [],
    );
  }

  /// `This account does not exist`
  String get login_userNotFound {
    return Intl.message(
      'This account does not exist',
      name: 'login_userNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get login_withGoogle {
    return Intl.message(
      'Sign in with Google',
      name: 'login_withGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Wrong password`
  String get login_wrongPassword {
    return Intl.message(
      'Wrong password',
      name: 'login_wrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `Publish`
  String get newComment_buttonPublish {
    return Intl.message(
      'Publish',
      name: 'newComment_buttonPublish',
      desc: '',
      args: [],
    );
  }

  /// `The comment has been successfully published!`
  String get newComment_commentPublished {
    return Intl.message(
      'The comment has been successfully published!',
      name: 'newComment_commentPublished',
      desc: '',
      args: [],
    );
  }

  /// `You didn't write a comment!`
  String get newComment_noWritedComment {
    return Intl.message(
      'You didn\'t write a comment!',
      name: 'newComment_noWritedComment',
      desc: '',
      args: [],
    );
  }

  /// `Your comment...`
  String get newComment_textFieldYourComment {
    return Intl.message(
      'Your comment...',
      name: 'newComment_textFieldYourComment',
      desc: '',
      args: [],
    );
  }

  /// `New comment`
  String get newComment_title {
    return Intl.message(
      'New comment',
      name: 'newComment_title',
      desc: '',
      args: [],
    );
  }

  /// `Story added to draft successfully!`
  String get newStory_addedToDraft {
    return Intl.message(
      'Story added to draft successfully!',
      name: 'newStory_addedToDraft',
      desc: '',
      args: [],
    );
  }

  /// `Additionally`
  String get newStory_additionally {
    return Intl.message(
      'Additionally',
      name: 'newStory_additionally',
      desc: '',
      args: [],
    );
  }

  /// `My story`
  String get newStory_buttonMyStory {
    return Intl.message(
      'My story',
      name: 'newStory_buttonMyStory',
      desc: '',
      args: [],
    );
  }

  /// `Story language`
  String get newStory_buttonStoryLanguage {
    return Intl.message(
      'Story language',
      name: 'newStory_buttonStoryLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Edit story`
  String get newStory_editStoryTitle {
    return Intl.message(
      'Edit story',
      name: 'newStory_editStoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your story contains profanity! Replace these words:`
  String get newStory_existProfanity {
    return Intl.message(
      'Your story contains profanity! Replace these words:',
      name: 'newStory_existProfanity',
      desc: '',
      args: [],
    );
  }

  /// `You have not selected a story category!`
  String get newStory_noCategory {
    return Intl.message(
      'You have not selected a story category!',
      name: 'newStory_noCategory',
      desc: '',
      args: [],
    );
  }

  /// `You didn't write the story!`
  String get newStory_noWritedStory {
    return Intl.message(
      'You didn\'t write the story!',
      name: 'newStory_noWritedStory',
      desc: '',
      args: [],
    );
  }

  /// `You didn't write the title!`
  String get newStory_noWritedTitle {
    return Intl.message(
      'You didn\'t write the title!',
      name: 'newStory_noWritedTitle',
      desc: '',
      args: [],
    );
  }

  /// `The story must be at least 50 words!`
  String get newStory_shortStory {
    return Intl.message(
      'The story must be at least 50 words!',
      name: 'newStory_shortStory',
      desc: '',
      args: [],
    );
  }

  /// `History category`
  String get newStory_storyCategoryTitle {
    return Intl.message(
      'History category',
      name: 'newStory_storyCategoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `My language...`
  String get newStory_storyLanguage_textFieldMyLanguage {
    return Intl.message(
      'My language...',
      name: 'newStory_storyLanguage_textFieldMyLanguage',
      desc: '',
      args: [],
    );
  }

  /// `The story has been successfully published!`
  String get newStory_storyPublished {
    return Intl.message(
      'The story has been successfully published!',
      name: 'newStory_storyPublished',
      desc: '',
      args: [],
    );
  }

  /// `Story...`
  String get newStory_textFieldStory {
    return Intl.message(
      'Story...',
      name: 'newStory_textFieldStory',
      desc: '',
      args: [],
    );
  }

  /// `Title...`
  String get newStory_textFieldTitle {
    return Intl.message(
      'Title...',
      name: 'newStory_textFieldTitle',
      desc: '',
      args: [],
    );
  }

  /// `New story`
  String get newStory_title {
    return Intl.message(
      'New story',
      name: 'newStory_title',
      desc: '',
      args: [],
    );
  }

  /// `NO`
  String get notification_buttonNo {
    return Intl.message(
      'NO',
      name: 'notification_buttonNo',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get notification_buttonOK {
    return Intl.message(
      'OK',
      name: 'notification_buttonOK',
      desc: '',
      args: [],
    );
  }

  /// `YES`
  String get notification_buttonYes {
    return Intl.message(
      'YES',
      name: 'notification_buttonYes',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get notification_titleError {
    return Intl.message(
      'Error',
      name: 'notification_titleError',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification_titleNotification {
    return Intl.message(
      'Notification',
      name: 'notification_titleNotification',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe`
  String get profile_buttonSubscribe {
    return Intl.message(
      'Subscribe',
      name: 'profile_buttonSubscribe',
      desc: '',
      args: [],
    );
  }

  /// `Unsubscribe`
  String get profile_buttonUnsubscribe {
    return Intl.message(
      'Unsubscribe',
      name: 'profile_buttonUnsubscribe',
      desc: '',
      args: [],
    );
  }

  /// `You haven't written any stories yet`
  String get profile_iDontHaveStories {
    return Intl.message(
      'You haven\'t written any stories yet',
      name: 'profile_iDontHaveStories',
      desc: '',
      args: [],
    );
  }

  /// `This user hasn't written any stories yet`
  String get profile_userHasNoStories {
    return Intl.message(
      'This user hasn\'t written any stories yet',
      name: 'profile_userHasNoStories',
      desc: '',
      args: [],
    );
  }

  /// `Log in!`
  String get register_buttonAlreadyMember {
    return Intl.message(
      'Log in!',
      name: 'register_buttonAlreadyMember',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get register_buttonNext {
    return Intl.message(
      'Next',
      name: 'register_buttonNext',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get register_buttonPrivacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'register_buttonPrivacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `The email address is already in use by another account.`
  String get register_emailAlreadyInUse {
    return Intl.message(
      'The email address is already in use by another account.',
      name: 'register_emailAlreadyInUse',
      desc: '',
      args: [],
    );
  }

  /// `The email address is badly formatted.`
  String get register_invalidEmail {
    return Intl.message(
      'The email address is badly formatted.',
      name: 'register_invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `This name is already exist!`
  String get register_nameIsExist {
    return Intl.message(
      'This name is already exist!',
      name: 'register_nameIsExist',
      desc: '',
      args: [],
    );
  }

  /// `You didn't write a name!`
  String get register_noWritedName {
    return Intl.message(
      'You didn\'t write a name!',
      name: 'register_noWritedName',
      desc: '',
      args: [],
    );
  }

  /// `Your photo and name:`
  String get register_photoAndNameTitle {
    return Intl.message(
      'Your photo and name:',
      name: 'register_photoAndNameTitle',
      desc: '',
      args: [],
    );
  }

  /// `By registering, you agree to our`
  String get register_PrivacyPolicyConfirmation {
    return Intl.message(
      'By registering, you agree to our',
      name: 'register_PrivacyPolicyConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `The name is too short!`
  String get register_shortName {
    return Intl.message(
      'The name is too short!',
      name: 'register_shortName',
      desc: '',
      args: [],
    );
  }

  /// `Do you already have an account?`
  String get register_textAlreadyMember {
    return Intl.message(
      'Do you already have an account?',
      name: 'register_textAlreadyMember',
      desc: '',
      args: [],
    );
  }

  /// `Your email...`
  String get register_textFieldEmail {
    return Intl.message(
      'Your email...',
      name: 'register_textFieldEmail',
      desc: '',
      args: [],
    );
  }

  /// `Your name...`
  String get register_textFieldName {
    return Intl.message(
      'Your name...',
      name: 'register_textFieldName',
      desc: '',
      args: [],
    );
  }

  /// `Your password...`
  String get register_textFieldPassword {
    return Intl.message(
      'Your password...',
      name: 'register_textFieldPassword',
      desc: '',
      args: [],
    );
  }

  /// `Welcome!\nRegistration:`
  String get register_title {
    return Intl.message(
      'Welcome!\nRegistration:',
      name: 'register_title',
      desc: '',
      args: [],
    );
  }

  /// `Password should be at least 6 characters!`
  String get register_weakPassword {
    return Intl.message(
      'Password should be at least 6 characters!',
      name: 'register_weakPassword',
      desc: '',
      args: [],
    );
  }

  /// `Sign up with Google`
  String get register_withGoogle {
    return Intl.message(
      'Sign up with Google',
      name: 'register_withGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Author not found`
  String get search_authorNotFound {
    return Intl.message(
      'Author not found',
      name: 'search_authorNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Storys`
  String get search_buttonStorys {
    return Intl.message(
      'Storys',
      name: 'search_buttonStorys',
      desc: '',
      args: [],
    );
  }

  /// `Authors`
  String get search_buttonUsers {
    return Intl.message(
      'Authors',
      name: 'search_buttonUsers',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get search_sortByNew {
    return Intl.message(
      'New',
      name: 'search_sortByNew',
      desc: '',
      args: [],
    );
  }

  /// `Old`
  String get search_sortByOld {
    return Intl.message(
      'Old',
      name: 'search_sortByOld',
      desc: '',
      args: [],
    );
  }

  /// `Popular`
  String get search_sortByPopular {
    return Intl.message(
      'Popular',
      name: 'search_sortByPopular',
      desc: '',
      args: [],
    );
  }

  /// `History not found`
  String get search_storyNotFound {
    return Intl.message(
      'History not found',
      name: 'search_storyNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Search...`
  String get search_textFieldSearch {
    return Intl.message(
      'Search...',
      name: 'search_textFieldSearch',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get settings_buttonLogOut {
    return Intl.message(
      'Log out',
      name: 'settings_buttonLogOut',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out of your account?`
  String get settings_exitConfirmation {
    return Intl.message(
      'Are you sure you want to log out of your account?',
      name: 'settings_exitConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get settings_mainLanguage {
    return Intl.message(
      'Language',
      name: 'settings_mainLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings_title {
    return Intl.message(
      'Settings',
      name: 'settings_title',
      desc: '',
      args: [],
    );
  }

  /// `Delete story`
  String get story_buttonDeleteStory {
    return Intl.message(
      'Delete story',
      name: 'story_buttonDeleteStory',
      desc: '',
      args: [],
    );
  }

  /// `Go to author`
  String get story_buttonGoToAuthor {
    return Intl.message(
      'Go to author',
      name: 'story_buttonGoToAuthor',
      desc: '',
      args: [],
    );
  }

  /// `Next story`
  String get story_buttonNextStory {
    return Intl.message(
      'Next story',
      name: 'story_buttonNextStory',
      desc: '',
      args: [],
    );
  }

  /// `Read story`
  String get story_buttonReadStory {
    return Intl.message(
      'Read story',
      name: 'story_buttonReadStory',
      desc: '',
      args: [],
    );
  }

  /// `The day before yesterday`
  String get story_dateDayBeforeYesterday {
    return Intl.message(
      'The day before yesterday',
      name: 'story_dateDayBeforeYesterday',
      desc: '',
      args: [],
    );
  }

  /// `5 days ago`
  String get story_dateFiveDaysAgo {
    return Intl.message(
      '5 days ago',
      name: 'story_dateFiveDaysAgo',
      desc: '',
      args: [],
    );
  }

  /// `4 days ago`
  String get story_dateFourDaysAgo {
    return Intl.message(
      '4 days ago',
      name: 'story_dateFourDaysAgo',
      desc: '',
      args: [],
    );
  }

  /// `6 days ago`
  String get story_dateSixDaysAgo {
    return Intl.message(
      '6 days ago',
      name: 'story_dateSixDaysAgo',
      desc: '',
      args: [],
    );
  }

  /// `3 days ago`
  String get story_dateThreeDaysAgo {
    return Intl.message(
      '3 days ago',
      name: 'story_dateThreeDaysAgo',
      desc: '',
      args: [],
    );
  }

  /// `3 weeks ago`
  String get story_dateThreeWeeksAgo {
    return Intl.message(
      '3 weeks ago',
      name: 'story_dateThreeWeeksAgo',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get story_dateToday {
    return Intl.message(
      'Today',
      name: 'story_dateToday',
      desc: '',
      args: [],
    );
  }

  /// `2 weeks ago`
  String get story_dateTwoWeeksAgo {
    return Intl.message(
      '2 weeks ago',
      name: 'story_dateTwoWeeksAgo',
      desc: '',
      args: [],
    );
  }

  /// `A week ago`
  String get story_dateWeekAgo {
    return Intl.message(
      'A week ago',
      name: 'story_dateWeekAgo',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday`
  String get story_dateYesterday {
    return Intl.message(
      'Yesterday',
      name: 'story_dateYesterday',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this story?`
  String get story_deleteStoryConfirmation {
    return Intl.message(
      'Are you sure you want to delete this story?',
      name: 'story_deleteStoryConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `You didn't read the previous story. Do you want to read?`
  String get story_lastStory {
    return Intl.message(
      'You didn\'t read the previous story. Do you want to read?',
      name: 'story_lastStory',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get story_newStoryText {
    return Intl.message(
      'New',
      name: 'story_newStoryText',
      desc: '',
      args: [],
    );
  }

  /// `New story`
  String get story_noStorysButtonNewStory {
    return Intl.message(
      'New story',
      name: 'story_noStorysButtonNewStory',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get story_noStorysButtonUpdate {
    return Intl.message(
      'Update',
      name: 'story_noStorysButtonUpdate',
      desc: '',
      args: [],
    );
  }

  /// `No new stories! Wait for users to add new ones.`
  String get story_noStorysTitle {
    return Intl.message(
      'No new stories! Wait for users to add new ones.',
      name: 'story_noStorysTitle',
      desc: '',
      args: [],
    );
  }

  /// `min`
  String get story_readTimeMinutes {
    return Intl.message(
      'min',
      name: 'story_readTimeMinutes',
      desc: '',
      args: [],
    );
  }

  /// `Default settings`
  String get storySettings_buttonDeafultSettings {
    return Intl.message(
      'Default settings',
      name: 'storySettings_buttonDeafultSettings',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get storySettings_buttonDone {
    return Intl.message(
      'Done',
      name: 'storySettings_buttonDone',
      desc: '',
      args: [],
    );
  }

  /// `Text color`
  String get storySettings_buttonTextColorTitle {
    return Intl.message(
      'Text color',
      name: 'storySettings_buttonTextColorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Text weight`
  String get storySettings_buttonTextWeightTitle {
    return Intl.message(
      'Text weight',
      name: 'storySettings_buttonTextWeightTitle',
      desc: '',
      args: [],
    );
  }

  /// `Pick a color:`
  String get storySettings_pickColorTitle {
    return Intl.message(
      'Pick a color:',
      name: 'storySettings_pickColorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Example:`
  String get storySettings_textExample {
    return Intl.message(
      'Example:',
      name: 'storySettings_textExample',
      desc: '',
      args: [],
    );
  }

  /// `Letter spacing:`
  String get storySettings_textLetterSpacingTitle {
    return Intl.message(
      'Letter spacing:',
      name: 'storySettings_textLetterSpacingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.`
  String get storySettings_textRealExample {
    return Intl.message(
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
      name: 'storySettings_textRealExample',
      desc: '',
      args: [],
    );
  }

  /// `Text size:`
  String get storySettings_textSizeTitle {
    return Intl.message(
      'Text size:',
      name: 'storySettings_textSizeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Story settings`
  String get storySettings_title {
    return Intl.message(
      'Story settings',
      name: 'storySettings_title',
      desc: '',
      args: [],
    );
  }

  /// `Word spacing:`
  String get storySettings_wordSpacingTitle {
    return Intl.message(
      'Word spacing:',
      name: 'storySettings_wordSpacingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get story_textComments {
    return Intl.message(
      'Comments',
      name: 'story_textComments',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get story_textDate {
    return Intl.message(
      'Date',
      name: 'story_textDate',
      desc: '',
      args: [],
    );
  }

  /// `Likes`
  String get story_textLikes {
    return Intl.message(
      'Likes',
      name: 'story_textLikes',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get story_textTime {
    return Intl.message(
      'Time',
      name: 'story_textTime',
      desc: '',
      args: [],
    );
  }

  /// `Viewed`
  String get story_textViewed {
    return Intl.message(
      'Viewed',
      name: 'story_textViewed',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'eo'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
