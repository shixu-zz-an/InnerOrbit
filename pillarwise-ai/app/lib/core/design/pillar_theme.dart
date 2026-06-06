import 'package:flutter/cupertino.dart';

class PillarColors {
  static const bg = Color(0xFFF6F7F9);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceElevated = Color(0xFFFBFCFD);
  static const ink = Color(0xFF111318);
  static const secondaryInk = Color(0xFF3B414B);
  static const muted = Color(0xFF6E7480);
  static const faint = Color(0xFF9AA1AD);
  static const hairline = Color(0x1F111318);
  static const pressed = Color(0xFFECEFF3);
  static const accent = Color(0xFF2F6FED);
  static const accentSoft = Color(0xFFEAF1FF);
  static const teal = Color(0xFF0E8F7E);
  static const tealSoft = Color(0xFFE7F6F3);
  static const amber = Color(0xFFB7791F);
  static const amberSoft = Color(0xFFFFF4D8);
  static const rose = Color(0xFFD9486E);
  static const roseSoft = Color(0xFFFFECF1);
  static const success = Color(0xFF198754);
  static const warning = Color(0xFFC47A12);
  static const destructive = Color(0xFFFF3B30);
}

class S {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
}

class R {
  static const double control = 12;
  static const double card = 8;
  static const double sheet = 16;
}

class PillarType {
  static const largeTitle = TextStyle(
    fontFamily: '.SF Pro Display',
    fontSize: 34,
    fontWeight: FontWeight.w700,
    height: 1.08,
    letterSpacing: 0,
    color: PillarColors.ink,
  );

  static const title1 = TextStyle(
    fontFamily: '.SF Pro Display',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.12,
    letterSpacing: 0,
    color: PillarColors.ink,
  );

  static const title2 = TextStyle(
    fontFamily: '.SF Pro Display',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.18,
    letterSpacing: 0,
    color: PillarColors.ink,
  );

  static const title3 = TextStyle(
    fontFamily: '.SF Pro Text',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0,
    color: PillarColors.ink,
  );

  static const headline = TextStyle(
    fontFamily: '.SF Pro Text',
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.28,
    letterSpacing: 0,
    color: PillarColors.ink,
  );

  static const body = TextStyle(
    fontFamily: '.SF Pro Text',
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.42,
    letterSpacing: 0,
    color: PillarColors.ink,
  );

  static const callout = TextStyle(
    fontFamily: '.SF Pro Text',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.38,
    letterSpacing: 0,
    color: PillarColors.secondaryInk,
  );

  static const subhead = TextStyle(
    fontFamily: '.SF Pro Text',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.34,
    letterSpacing: 0,
    color: PillarColors.secondaryInk,
  );

  static const footnote = TextStyle(
    fontFamily: '.SF Pro Text',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.32,
    letterSpacing: 0,
    color: PillarColors.muted,
  );

  static const caption = TextStyle(
    fontFamily: '.SF Pro Text',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0,
    color: PillarColors.muted,
  );
}

const pillarTheme = CupertinoThemeData(
  brightness: Brightness.light,
  primaryColor: PillarColors.accent,
  scaffoldBackgroundColor: PillarColors.bg,
  barBackgroundColor: PillarColors.bg,
  textTheme: CupertinoTextThemeData(
    primaryColor: PillarColors.ink,
    textStyle: PillarType.body,
    navTitleTextStyle: TextStyle(
      fontFamily: '.SF Pro Text',
      color: PillarColors.ink,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    tabLabelTextStyle: TextStyle(
      fontFamily: '.SF Pro Text',
      color: PillarColors.muted,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
    ),
  ),
);
