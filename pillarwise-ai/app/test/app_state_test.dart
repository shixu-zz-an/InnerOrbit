import 'package:flutter_test/flutter_test.dart';
import 'package:pillarwise_app/app_state.dart';

void main() {
  test('onboarding draft serializes API-ready birth data', () {
    final draft = OnboardingDraft();
    final json = draft.toMap();

    expect(json['birthDate'], '1994-08-21');
    expect(json['birthTime'], '14:30');
    expect(json['birthTimePrecision'], 'exact');
    expect(json['timezone'], 'America/Los_Angeles');
  });
}
