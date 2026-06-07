import 'package:flutter/cupertino.dart';

import 'app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static const largeTitle = TextStyle(
    inherit: false,
    fontFamily: '.SF Pro Display',
    fontSize: 34,
    fontWeight: FontWeight.w700,
    height: 1.08,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const title1 = TextStyle(
    inherit: false,
    fontFamily: '.SF Pro Display',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.12,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const title2 = TextStyle(
    inherit: false,
    fontFamily: '.SF Pro Display',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.18,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const title3 = TextStyle(
    inherit: false,
    fontFamily: '.SF Pro Text',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const headline = TextStyle(
    inherit: false,
    fontFamily: '.SF Pro Text',
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.28,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const body = TextStyle(
    inherit: false,
    fontFamily: '.SF Pro Text',
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.42,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const bodyEmphasized = TextStyle(
    inherit: false,
    fontFamily: '.SF Pro Text',
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.38,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const callout = TextStyle(
    inherit: false,
    fontFamily: '.SF Pro Text',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.38,
    letterSpacing: 0,
    color: AppColors.inkSecondary,
  );

  static const subhead = TextStyle(
    inherit: false,
    fontFamily: '.SF Pro Text',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.34,
    letterSpacing: 0,
    color: AppColors.inkSecondary,
  );

  static const subheadline = subhead;

  static const footnote = TextStyle(
    inherit: false,
    fontFamily: '.SF Pro Text',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.32,
    letterSpacing: 0,
    color: AppColors.inkMuted,
  );

  static const caption = TextStyle(
    inherit: false,
    fontFamily: '.SF Pro Text',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0,
    color: AppColors.inkMuted,
  );

  static const button = TextStyle(
    inherit: false,
    fontFamily: '.SF Pro Text',
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static TextStyle onSurface(TextStyle style, Brightness brightness) {
    return style.copyWith(color: AppColors.resolveTextPrimary(brightness));
  }
}
