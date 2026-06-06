# A01. Design Tokens

## Colors

```dart
@immutable
class PillarPalette extends ThemeExtension<PillarPalette> {
  final Color bg;
  final Color surface;
  final Color surfaceWarm;
  final Color ink;
  final Color muted;
  final Color hairline;
  final Color accent;
  final Color accentSoft;
  final Color gold;
  final Color rose;
  final Color success;
  final Color warning;
  final Color destructive;
}
```

Light：

```dart
const lightPalette = PillarPalette(
  bg: Color(0xFFF8F3EC),
  surface: Color(0xFFFFFFFF),
  surfaceWarm: Color(0xFFFFFBF5),
  ink: Color(0xFF17151F),
  muted: Color(0xFF7D7489),
  hairline: Color(0x1F17151F),
  accent: Color(0xFF6B5DD3),
  accentSoft: Color(0xFFEDE9FF),
  gold: Color(0xFFC7A66A),
  rose: Color(0xFFD77A8A),
  success: Color(0xFF2E8B57),
  warning: Color(0xFFD28A2E),
  destructive: Color(0xFFFF3B30),
);
```

Dark：

```dart
const darkPalette = PillarPalette(
  bg: Color(0xFF0F0D14),
  surface: Color(0xFF1A1722),
  surfaceWarm: Color(0xFF221D2B),
  ink: Color(0xFFF8F3EC),
  muted: Color(0xFFAAA0B8),
  hairline: Color(0x33FFFFFF),
  accent: Color(0xFF9B8CFF),
  accentSoft: Color(0xFF2A2440),
  gold: Color(0xFFD8BE7E),
  rose: Color(0xFFE89AAA),
  success: Color(0xFF67C98D),
  warning: Color(0xFFE5B15C),
  destructive: Color(0xFFFF453A),
);
```

## Spacing

```dart
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
```

## Radius

```dart
class R {
  static const double sm = 12;
  static const double md = 18;
  static const double lg = 24;
  static const double xl = 32;
}
```

## Animation

```dart
class Motion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 220);
  static const Duration slow = Duration(milliseconds: 420);
}
```

## Accessibility

- Min tap target：44pt。
- Body text：16pt。
- Main CTA：52pt height。
- Contrast ratio：至少 WCAG AA。
