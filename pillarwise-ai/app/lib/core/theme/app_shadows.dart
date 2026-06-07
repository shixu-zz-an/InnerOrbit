import 'package:flutter/cupertino.dart';

class AppShadows {
  const AppShadows._();

  static const card = [
    BoxShadow(color: Color(0x05000000), blurRadius: 10, offset: Offset(0, 4)),
  ];

  static const elevated = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 22, offset: Offset(0, 10)),
  ];
}
