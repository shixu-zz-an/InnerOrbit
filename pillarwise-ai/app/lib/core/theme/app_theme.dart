import 'package:flutter/cupertino.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  const AppTheme._();

  static const light = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    barBackgroundColor: AppColors.surfaceElevated,
    textTheme: CupertinoTextThemeData(
      primaryColor: AppColors.ink,
      textStyle: AppTextStyles.body,
      navTitleTextStyle: TextStyle(
        inherit: false,
        fontFamily: '.SF Pro Text',
        color: AppColors.ink,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        decoration: TextDecoration.none,
      ),
      tabLabelTextStyle: TextStyle(
        inherit: false,
        fontFamily: '.SF Pro Text',
        color: AppColors.inkMuted,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        decoration: TextDecoration.none,
      ),
    ),
  );

  static const dark = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    barBackgroundColor: AppColors.darkBackground,
    textTheme: CupertinoTextThemeData(
      primaryColor: AppColors.darkInk,
      textStyle: TextStyle(
        inherit: false,
        fontFamily: '.SF Pro Text',
        color: AppColors.darkInk,
        fontSize: 17,
        height: 1.42,
        decoration: TextDecoration.none,
      ),
      navTitleTextStyle: TextStyle(
        inherit: false,
        fontFamily: '.SF Pro Text',
        color: AppColors.darkInk,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        decoration: TextDecoration.none,
      ),
      tabLabelTextStyle: TextStyle(
        inherit: false,
        fontFamily: '.SF Pro Text',
        color: AppColors.darkInkMuted,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        decoration: TextDecoration.none,
      ),
    ),
  );
}
