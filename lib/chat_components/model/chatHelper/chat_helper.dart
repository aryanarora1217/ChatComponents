import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../view/screens/call_screens/agora/audio_call_screen.dart';
import '../../view/screens/call_screens/agora/video_call_screen.dart';
import '../../view/screens/call_screens/calling_screen/outgoing_screen.dart';
import '../../view/screens/chat_screen/chat_screen.dart';

/// enum for file
enum FileTypes { image, document, audio,video,contact }


/// enum for sign in types
enum SignType { google,email }


/// enum for call types
enum CallType { audioCall,videoCall }


/// enum for message types
enum MessageType { text,file }


/// enum for call status
enum CallStatus { calling,ringing,accepted,rejected,ended,running }


/// enum for pressence status
enum PresenceStatus { online,offline,typing }


/// font weights

FontWeight semiBold = FontWeight.w600;
FontWeight regular = FontWeight.w400;
FontWeight light = FontWeight.w200;
FontWeight medium = FontWeight.w500;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w900;


/// chat helper class

class ChatHelpers {
  static ChatHelpers? _instance;

  static ChatHelpers get instance => _instance ??= ChatHelpers._init();

  ChatHelpers._init();

  ///  String  Resources


///  Table names
  String get users => 'users';
  String get chats => 'chats';
  String get calls => 'calls';
  String get presence => 'presence';


  /// Profile store name
  String get usersProfiles => "Users_Profiles";


  /// common strings
  String get currentUser => 'currentUser';

  String get currentUserID => 'currentUserID';

  String get appState => 'appState';

  String get callType => 'call_Type';
  String get isMessage => 'isMessage';

  String get userDetails => 'User_Details';
  String get otherUserDetails => 'OtherUser_Details';

  String get callId => 'callId';
  String get messageId => 'messageId';
  String get chatRoomId => 'chatRoomId';
  String get userId => 'userId';
  String get isMicOn => 'isMicOn';
  String get callArguments => 'callArguments';

  ///messages string
  String get noChatsMessage =>
      "There are no chats available since you haven't chatted with anyone";


  /// Image Resources
  String lottie(String name) => 'assets/lottie/$name';
  String icons(String name) => 'assets/images/icons/$name';
  String gif(String name) => 'assets/images/gif/$name';
  String logoIcons(String name) => 'assets/images/logo/$name';
  String image(String name) => 'assets/images/image/$name';

  String get logo => logoIcons("logo.png");
  String get user => icons("user.png");
  String get placeHolder => icons("placeholder.png");
  String get errorImage => icons("errorImage.png");
  String get speaker => icons("speaker.png");
  String get loadingGIF => gif("LoadingAnimationSpinner.gif");
  String get speakerOff => icons("speakerOff.png");
  String get groupIcon => icons("groupIcon.png");
  String get noChatFound => icons("nochatFound.png");
  String get loginBanner => image("login_banner.png");
  String get facebookLogo => logoIcons("facebookLogo.png");
  String get googleLogo => logoIcons("googleLogo.png");
  String get appleLogo => logoIcons("appleLogo.png");

  String get hello => lottie("hello.json");
  String get soundEffectLottie => lottie("soundEffectAnimation.json");


  /// Audio Resources

  String sounds(String name) => 'assets/sounds/$name';

  String get ringingSound => sounds("cellphoneSound.mp3");


  /// Color Resources
  static const Color transparent = Color(0x00ffffff);
  static const Color mainColor = Color(0xff2A6EE7);
  static const Color mainColorLight = Color(0xff3e82ff);
  static const Color textColor_4 = Color(0xff758793);
  static const Color backcolor = Color(0xffe5e6ff);
  static const Color lightGrey = Color(0xfff8f8ff);

  static const Color white = Colors.white;
  static const Color blue = Colors.blue;
  static Color blueLight = Colors.blue.shade100;
  static const Color green = Colors.green;
  static const Color amber = Colors.amber;
  static const Color purple = Colors.deepPurple;
  static const Color orange = Colors.orange;
  static const Color cyan = Colors.cyan;
  static const Color red = Colors.red;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;



  /// Routes
  static String videoCall = '/VideoCall';
  static String audioCall = '/AudioCall';
  static String outGoingScreen = '/OutGoingScreen';
  static String chatScreen = '/ChatScreen';


  /// style Resources

  TextStyle styleExtraBold(double fontSize, Color color) {
    return TextStyle(
        fontSize: fontSize,
        color: color,
        fontFamily: mainFont,
        fontWeight: extraBold);
  }

  TextStyle styleBold(double fontSize, Color color) {
    return TextStyle(
        fontSize: fontSize,
        color: color,
        fontFamily: mainFont,
        fontWeight: bold);
  }

  TextStyle styleSemiBold(double fontSize, Color color) {
    return TextStyle(
        fontSize: fontSize,
        color: color,
        fontFamily: mainFont,
        fontWeight: semiBold);
  }

  TextStyle styleRegular(double fontSize, Color color) {
    return TextStyle(
        fontSize: fontSize,
        color: color,
        fontFamily: mainFont,
        fontWeight: regular);
  }

  TextStyle styleMedium(double fontSize, Color color) {
    return TextStyle(
        fontSize: fontSize,
        color: color,
        fontFamily: mainFont,
        fontWeight: semiBold);
  }

  TextStyle styleLight(double fontSize, Color color) {
    return TextStyle(
        fontSize: fontSize,
        color: color,
        fontFamily: mainFont,
        fontWeight: light);
  }



  /// font Resources

  String get  mainFont =>   "Inter";



  /// Dimension Resources

  static const double fontSizeExtraSmall = 10.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeDefault = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeExtraLarge = 18.0;
  static const double fontSizeDoubleExtraLarge = 20.0;
  static const double fontSizeOverLarge = 24.0;
  static const double fontSizeOverExtraLarge = 26.0;

  static const double paddingSizeExtraSmall = 5.0;
  static const double paddingSizeSmall = 10.0;
  static const double paddingSizeDefault = 15.0;
  static const double paddingSizeLarge = 18.0;
  static const double paddingExtraSizeLarge = 20.0;
  static const double paddingSizeExtraLarge = 25.0;
  static const double paddingSizeOverExtraLarge = 100.0;

  static const double marginSizeExtraSmall = 5.0;
  static const double marginSizeSmall = 10.0;
  static const double marginSizeDefault = 15.0;
  static const double marginSizeLarge = 20.0;
  static const double marginSizeExtraLarge = 25.0;
  static const double marginSizeExtraOverLarge = 100.0;

  static const double iconSizeExtraSmall = 12.0;
  static const double iconSizeSmall = 18.0;
  static const double iconSizeDefault = 24.0;
  static const double iconSizeLarge = 28.0;
  static const double iconSizeExtraLarge = 34.0;
  static const double iconSizeExtraOverLarge = 40.0;

  static const double buttonRadius = 8.0;
  static const double cornerRadius = 15.0;
  static const double roundButtonRadius = 25.0;
  static const double circularImage = 50.0;

  /// Decoration Resources 

  BoxDecoration decorationFilterSpinnerNoRadius() {
    return BoxDecoration(
      border: Border.all(color: const Color(0xffFFDDDD), width: 1),
    );
  }

  OutlineInputBorder focusedTextFieldRadius() {
    return OutlineInputBorder(
        borderSide:
        const BorderSide(width: 1, color: mainColorLight),
        borderRadius: BorderRadius.circular(buttonRadius));
  }

  OutlineInputBorder borderTextFieldRadius() {
    return OutlineInputBorder(
        borderSide:
        const BorderSide(width: 1, color: lightGrey),
        borderRadius: BorderRadius.circular(buttonRadius));
  }

  BoxDecoration borderMessageFieldRadius(Color borderColor , double borderRadius) {
    return BoxDecoration(
        border: Border.all(width: 1, color: borderColor),
        borderRadius: BorderRadius.circular(borderRadius));
  }

  BoxDecoration focusedMessageFieldRadius(Color borderColor , double borderRadius) {
    return BoxDecoration(
      color: ChatHelpers.backcolor,
        border: Border.all(width: 1, color: borderColor),
        borderRadius: BorderRadius.circular(borderRadius));
  }

  BoxDecoration chipDecoration() {
    return BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: mainColor, width: 1.5));
  }

  Border borderImageView() {
    return Border.all(color: mainColorLight, width: 1.0);
  }

  List<BoxShadow> buttonBoxShadow() {
    return const [
      BoxShadow(
        color: mainColorLight,
        offset: Offset(
          0.5,
          0.5,
        ),
        blurRadius: 8.0,
        spreadRadius: 0.1,
      ), //BoxShadow
      BoxShadow(
        color: Colors.white,
        offset: Offset(0.0, 0.0),
        blurRadius: 0.0,
        spreadRadius: 0.0,
      ), //BoxShadow
    ];
  }

  BoxDecoration buttonBoxDecoration(Color fillColor) {
    return BoxDecoration(
      boxShadow: buttonBoxShadow(),
      borderRadius: BorderRadius.circular(roundButtonRadius),
      shape: BoxShape.rectangle,
      color: fillColor,
    );
  }

}

/// routes list

final getPages = [
  GetPage(
      name: ChatHelpers.chatScreen,
      page: () => const ChatScreen()),
  GetPage(
      name: ChatHelpers.videoCall,
      page: () => const VideoCallScreen()),
  GetPage(
      name: ChatHelpers.audioCall,
      page: () => const AudioCallScreen()),
  GetPage(
      name: ChatHelpers.outGoingScreen,
      page: () => const OutGoingScreen()),
];