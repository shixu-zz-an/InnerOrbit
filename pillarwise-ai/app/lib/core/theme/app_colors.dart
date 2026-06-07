import 'package:flutter/cupertino.dart';

class AppColors {
  const AppColors._();

  static const primary = Color(0xFF2563EB);
  static const primarySoft = Color(0xFFEAF1FF);
  static const secondary = Color(0xFF0F766E);
  static const secondarySoft = Color(0xFFE6F5F3);
  static const info = Color(0xFF2563EB);
  static const infoSoft = Color(0xFFEAF1FF);

  static const lightBackground = Color(0xFFF6F7F9);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceElevated = Color(0xFFFFFFFF);
  static const lightSurfaceSubtle = Color(0xFFFAFBFC);
  static const lightPressed = Color(0xFFEFF2F6);
  static const lightDivider = Color(0x12111827);
  static const lightBorder = Color(0x10111827);
  static const lightDisabled = Color(0xFFE9EDF3);
  static const lightDisabledText = Color(0xFF9AA3AF);

  static const ink = Color(0xFF111827);
  static const inkSecondary = Color(0xFF374151);
  static const inkMuted = Color(0xFF6B7280);
  static const inkFaint = Color(0xFF9CA3AF);

  static const success = Color(0xFF198754);
  static const successSoft = Color(0xFFE7F6EE);
  static const warning = Color(0xFFB7791F);
  static const warningSoft = Color(0xFFFFF4D8);
  static const destructive = CupertinoColors.systemRed;
  static const destructiveSoft = Color(0xFFFFECEF);

  static const darkBackground = Color(0xFF0D1117);
  static const darkSurface = Color(0xFF161B22);
  static const darkSurfaceElevated = Color(0xFF1B222D);
  static const darkSurfaceSubtle = Color(0xFF1F2630);
  static const darkDivider = Color(0x29FFFFFF);
  static const darkBorder = Color(0x1FFFFFFF);
  static const darkInk = Color(0xFFF9FAFB);
  static const darkInkSecondary = Color(0xFFD1D5DB);
  static const darkInkMuted = Color(0xFF9CA3AF);

  static const background = lightBackground;
  static const surface = lightSurface;
  static const surfaceElevated = lightSurfaceElevated;
  static const surfaceSubtle = lightSurfaceSubtle;
  static const textPrimary = ink;
  static const textSecondary = inkSecondary;
  static const textTertiary = inkMuted;
  static const border = lightBorder;
  static const divider = lightDivider;
  static const disabled = lightDisabled;
  static const disabledText = lightDisabledText;
  static const error = destructive;
  static const errorSoft = destructiveSoft;

  static Color resolveBackground(Brightness brightness) {
    return brightness == Brightness.dark ? darkBackground : lightBackground;
  }

  static Color resolveSurface(Brightness brightness) {
    return brightness == Brightness.dark ? darkSurface : lightSurface;
  }

  static Color resolveSurfaceElevated(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkSurfaceElevated
        : lightSurfaceElevated;
  }

  static Color resolveSurfaceSubtle(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkSurfaceSubtle
        : lightSurfaceSubtle;
  }

  static Color resolveDivider(Brightness brightness) {
    return brightness == Brightness.dark ? darkDivider : lightDivider;
  }

  static Color resolveBorder(Brightness brightness) {
    return brightness == Brightness.dark ? darkBorder : lightBorder;
  }

  static Color resolveTextPrimary(Brightness brightness) {
    return brightness == Brightness.dark ? darkInk : ink;
  }

  static Color resolveTextSecondary(Brightness brightness) {
    return brightness == Brightness.dark ? darkInkSecondary : inkSecondary;
  }

  static Color resolveTextMuted(Brightness brightness) {
    return brightness == Brightness.dark ? darkInkMuted : inkMuted;
  }
}
