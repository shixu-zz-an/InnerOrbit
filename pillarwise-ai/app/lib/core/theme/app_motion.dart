import 'package:flutter/animation.dart';

class AppMotion {
  const AppMotion._();

  static const Duration quick = Duration(milliseconds: 120);
  static const Duration standard = Duration(milliseconds: 180);
  static const Duration sheet = Duration(milliseconds: 260);

  static const Curve ease = Curves.easeOutCubic;
  static const Curve press = Curves.easeOut;
}
