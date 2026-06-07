import 'package:flutter/cupertino.dart';

class AppShadows {
  const AppShadows._();

  static const card = [
    BoxShadow(color: Color(0x04000000), blurRadius: 16, offset: Offset(0, 8)),
  ];

  static const elevated = [
    BoxShadow(color: Color(0x08000000), blurRadius: 24, offset: Offset(0, 12)),
  ];
}
