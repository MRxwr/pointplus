import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:point/app/string_labels.dart';

class Constant {
  static const String baseUrl="https://pointplus.app/app/request/";
  static const String SERVER_UPLOADS = "${baseUrl}uploads/";
  static const String STORAGE_DEVICE_OPEN_FIRST_TIME = 'device_first_open';
  static const String STORAGE_USER_PROFILE_KEY = 'user_profile_key';
  static const String STORAGE_USER_TOKEN_KEY = 'user_token_key';
  static const String empty="";
  static const int zero =0;
  static const String url="url";
  static const String headerKey ="pointsheader";
  static const String headerValue ="pointsCreateKW";

  static const String id="id";
  static const String title= "title";

  static  bool isDialogShown = false;
  GlobalKey alertKey = GlobalKey();
  static const double zeroDouble =0.0;
  static const bool falseBool =false;
  static const int apiTimeOut =60*1000;

  static bool isEnabled = false;
  static bool isDismissed = false;
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

}
const predefinedMessages = [
  'Hello..!!',
  'How are you..?',
  'Fine..!!',
  'Have a nice day..',
  'Well played',
  'What a performance..!!',
  'Thanks..',
  'Welcome..',
  'Merry Christmas',
  'Happy new year',
  'Happy Diwali',
  'Good night',
  'Hurry Up',
  'Dudeeee',
];
const inBetweenQuestionTimeInSeconds = 1;
const appName = 'POINT+';
//firestore collection names
const battleRoomCollection = 'battleRoom'; //  testBattleRoom
const multiUserBattleRoomCollection =
    'multiUserBattleRoom'; //testMultiUserBattleRoom
const messagesCollection = 'message'; // testMessages
const EMPTY="";
const ZERO =0;
const  LANG_CODE ="lang";
const NotificationStatus = "notificationStatus";

const  TAG_IMAGE_URL ="https://pointplus.app/app/admin/banners/";
const  TAG_LOGO_URL ="https://pointplus.app/app/admin/logos/";
const  TAG_QUIZ_URL ="https://pointplus.app/app/quizes/";
const TAG_PRODUCTS_URL="https://pointplus.app/app/admin/products/";
const TAG_GAME_URL="https://pointplus.app/app/admin/quizes/";
const maxUsersInGroupBattle = 6;
const kCorrectAnswerColor = Colors.green;
const defaultThemeKey = lightThemeKey;
const kWrongAnswerColor = Colors.red;
const correctAnswerSoundTrack = 'assets/sounds/right.mp3';
const wrongAnswerSoundTrack = 'assets/sounds/wrong.mp3';
const clickEventSoundTrack = 'assets/sounds/click.mp3';
const authBox = 'auth';
const settingsBox = 'settings';
const bookmarkBox = 'bookmark';
const guessTheWordBookmarkBox = 'guessTheWordBookmarkBox';
const audioBookmarkBox = 'audioBookmarkBox';
const userDetailsBox = 'userdetails';
const examBox = 'exam';

/// [authBox] Keys
const isLoginKey = 'isLogin';
const jwtTokenKey = 'jwtToken';
const firebaseIdBoxKey = 'firebaseId';
const authTypeKey = 'authType';
const isNewUserKey = 'isNewUser';

/// [userDetailsBox] Keys
const nameBoxKey = 'name';
const userUIdBoxKey = 'userUID';
const emailBoxKey = 'email';
const mobileNumberBoxKey = 'mobile';
const rankBoxKey = 'rank';
const coinsBoxKey = 'coins';
const scoreBoxKey = 'score';
const profileUrlBoxKey = 'profileUrl';
const statusBoxKey = 'status';
const referCodeBoxKey = 'referCode';
const defaultLanguageCode = 'en';


/// [settingsBox] keys
///
const showIntroSliderKey = 'showIntroSlider';
const numberOfHintsPerGuessTheWordQuestion = 2;
const vibrationKey = 'vibration';
const backgroundMusicKey = 'backgroundMusic';
const soundKey = 'sound';
const languageCodeKey = 'language';
const fontSizeKey = 'fontSize';
const rewardEarnedKey = 'rewardEarned';
const fcmTokenBoxKey = 'fcmToken';
const settingsThemeKey = 'theme';
const klBackgroundColor = Color(0xFF0E3151);
const klCanvasColor = Color(0xcc000000);
const klPageBackgroundColor = Color(0xFF0E3151);
const klPrimaryColor = Color(0xFF0E3151);
const klPrimaryTextColor = Color(0xffffffff);

