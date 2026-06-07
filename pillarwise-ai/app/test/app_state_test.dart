import 'package:flutter_test/flutter_test.dart';
import 'package:pillarwise_app/app_state.dart';

void main() {
  test('onboarding draft does not serialize sample birth data by default', () {
    final draft = OnboardingDraft();
    final json = draft.toMap();

    expect(json['birthDate'], isNull);
    expect(json['birthTime'], isNull);
    expect(json['birthTimePrecision'], 'exact');
    expect(json['birthPlaceText'], '');
    expect(json['timezone'], '');
  });

  test('onboarding draft serializes user-provided birth data', () {
    final draft = OnboardingDraft(
      birthDate: DateTime(1994, 8, 21),
      birthTime: DateTime(1970, 1, 1, 14, 30),
      birthPlaceText: 'Shanghai, China',
      timezone: 'Asia/Shanghai',
    );
    final json = draft.toMap();

    expect(json['birthDate'], '1994-08-21');
    expect(json['birthTime'], '14:30');
    expect(json['timezone'], 'Asia/Shanghai');
  });
}
