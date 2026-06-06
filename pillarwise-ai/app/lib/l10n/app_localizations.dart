import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'PillarWise AI'**
  String get appTitle;

  /// No description provided for @loadingPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing your guide...'**
  String get loadingPreparing;

  /// No description provided for @genericErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something needs a retry.'**
  String get genericErrorTitle;

  /// No description provided for @genericRetry.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get genericRetry;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @premiumActive.
  ///
  /// In en, this message translates to:
  /// **'Premium active'**
  String get premiumActive;

  /// No description provided for @welcomeEyebrow.
  ///
  /// In en, this message translates to:
  /// **'PRIVATE SELF-REFLECTION'**
  String get welcomeEyebrow;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Read your patterns with more clarity.'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A calm personal guide for timing, relationships, decisions, and recurring inner themes.'**
  String get welcomeSubtitle;

  /// No description provided for @welcomePrimary.
  ///
  /// In en, this message translates to:
  /// **'Start My Blueprint'**
  String get welcomePrimary;

  /// No description provided for @disclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Before we begin'**
  String get disclaimerTitle;

  /// No description provided for @disclaimerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'PillarWise is for self-reflection and personal insight. It does not provide medical, legal, financial, or mental health advice. Readings are not deterministic predictions.'**
  String get disclaimerSubtitle;

  /// No description provided for @disclaimerAccept.
  ///
  /// In en, this message translates to:
  /// **'I understand and want to continue.'**
  String get disclaimerAccept;

  /// No description provided for @birthDateTitle.
  ///
  /// In en, this message translates to:
  /// **'When were you born?'**
  String get birthDateTitle;

  /// No description provided for @birthDateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your date anchors the core pattern behind your blueprint.'**
  String get birthDateSubtitle;

  /// No description provided for @birthTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'What time were you born?'**
  String get birthTimeTitle;

  /// No description provided for @birthTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'An exact time improves timing and relationship insights. If you do not know it, we can still create a partial blueprint.'**
  String get birthTimeSubtitle;

  /// No description provided for @timeExact.
  ///
  /// In en, this message translates to:
  /// **'Exact'**
  String get timeExact;

  /// No description provided for @timeApprox.
  ///
  /// In en, this message translates to:
  /// **'Approx'**
  String get timeApprox;

  /// No description provided for @timeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get timeUnknown;

  /// No description provided for @birthPlaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Where were you born?'**
  String get birthPlaceTitle;

  /// No description provided for @birthPlaceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Birthplace helps us calculate timing and location details more accurately.'**
  String get birthPlaceSubtitle;

  /// No description provided for @selectedBirthplace.
  ///
  /// In en, this message translates to:
  /// **'Selected birthplace'**
  String get selectedBirthplace;

  /// No description provided for @timezoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Timezone: {timezone}'**
  String timezoneLabel(Object timezone);

  /// No description provided for @traditionalTitle.
  ///
  /// In en, this message translates to:
  /// **'One calculation detail'**
  String get traditionalTitle;

  /// No description provided for @traditionalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Some traditional cycle calculations use sex assigned at birth. This is only used for timing math and does not define your gender identity.'**
  String get traditionalSubtitle;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @preferNot.
  ///
  /// In en, this message translates to:
  /// **'Prefer not'**
  String get preferNot;

  /// No description provided for @goalTitle.
  ///
  /// In en, this message translates to:
  /// **'What do you want to understand first?'**
  String get goalTitle;

  /// No description provided for @goalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick up to three. You can change this later.'**
  String get goalSubtitle;

  /// No description provided for @goalMyself.
  ///
  /// In en, this message translates to:
  /// **'Myself'**
  String get goalMyself;

  /// No description provided for @goalLove.
  ///
  /// In en, this message translates to:
  /// **'Love & relationships'**
  String get goalLove;

  /// No description provided for @goalCareer.
  ///
  /// In en, this message translates to:
  /// **'Career direction'**
  String get goalCareer;

  /// No description provided for @goalMoney.
  ///
  /// In en, this message translates to:
  /// **'Money patterns'**
  String get goalMoney;

  /// No description provided for @goalTiming.
  ///
  /// In en, this message translates to:
  /// **'Life timing'**
  String get goalTiming;

  /// No description provided for @goalGrowth.
  ///
  /// In en, this message translates to:
  /// **'Emotional growth'**
  String get goalGrowth;

  /// No description provided for @generateBlueprint.
  ///
  /// In en, this message translates to:
  /// **'Generate My Blueprint'**
  String get generateBlueprint;

  /// No description provided for @generationFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your blueprint did not load.'**
  String get generationFailedTitle;

  /// No description provided for @generatingText.
  ///
  /// In en, this message translates to:
  /// **'Mapping your Four Pillars...'**
  String get generatingText;

  /// No description provided for @previewTitle.
  ///
  /// In en, this message translates to:
  /// **'Your First Reading'**
  String get previewTitle;

  /// No description provided for @previewDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Life Blueprint'**
  String get previewDefaultTitle;

  /// No description provided for @previewDefaultSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your first reading is ready.'**
  String get previewDefaultSubtitle;

  /// No description provided for @unlockBlueprint.
  ///
  /// In en, this message translates to:
  /// **'Unlock Full Blueprint'**
  String get unlockBlueprint;

  /// No description provided for @continueFree.
  ///
  /// In en, this message translates to:
  /// **'Continue with Free Preview'**
  String get continueFree;

  /// No description provided for @tabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tabToday;

  /// No description provided for @tabBlueprint.
  ///
  /// In en, this message translates to:
  /// **'Blueprint'**
  String get tabBlueprint;

  /// No description provided for @tabAsk.
  ///
  /// In en, this message translates to:
  /// **'Ask'**
  String get tabAsk;

  /// No description provided for @tabLove.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get tabLove;

  /// No description provided for @tabMe.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get tabMe;

  /// No description provided for @todayFocus.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Focus'**
  String get todayFocus;

  /// No description provided for @challenge.
  ///
  /// In en, this message translates to:
  /// **'Challenge'**
  String get challenge;

  /// No description provided for @opportunity.
  ///
  /// In en, this message translates to:
  /// **'Opportunity'**
  String get opportunity;

  /// No description provided for @askAboutThis.
  ///
  /// In en, this message translates to:
  /// **'Ask about this'**
  String get askAboutThis;

  /// No description provided for @createBlueprintFirstTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your blueprint first.'**
  String get createBlueprintFirstTitle;

  /// No description provided for @createBlueprintFirstBody.
  ///
  /// In en, this message translates to:
  /// **'Your daily insights are personalized from your birth details.'**
  String get createBlueprintFirstBody;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @reflectionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Write a quick reflection...'**
  String get reflectionPlaceholder;

  /// No description provided for @saveReflection.
  ///
  /// In en, this message translates to:
  /// **'Save Reflection'**
  String get saveReflection;

  /// No description provided for @weeklyTheme.
  ///
  /// In en, this message translates to:
  /// **'This week\'s theme'**
  String get weeklyTheme;

  /// No description provided for @journalSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get journalSavedTitle;

  /// No description provided for @journalSavedBody.
  ///
  /// In en, this message translates to:
  /// **'Added to your journal.'**
  String get journalSavedBody;

  /// No description provided for @coreArchetype.
  ///
  /// In en, this message translates to:
  /// **'Core Archetype'**
  String get coreArchetype;

  /// No description provided for @saveToJournal.
  ///
  /// In en, this message translates to:
  /// **'Save to Journal'**
  String get saveToJournal;

  /// No description provided for @lockedReadingSuffix.
  ///
  /// In en, this message translates to:
  /// **'Unlock the full reading to go deeper.'**
  String get lockedReadingSuffix;

  /// No description provided for @askIntro.
  ///
  /// In en, this message translates to:
  /// **'Ask your guide about love, career, patterns, or timing themes.'**
  String get askIntro;

  /// No description provided for @askPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Ask your guide...'**
  String get askPlaceholder;

  /// No description provided for @promptStuck.
  ///
  /// In en, this message translates to:
  /// **'Why do I feel stuck lately?'**
  String get promptStuck;

  /// No description provided for @promptCareer.
  ///
  /// In en, this message translates to:
  /// **'What career path fits my natural strengths?'**
  String get promptCareer;

  /// No description provided for @promptRelationship.
  ///
  /// In en, this message translates to:
  /// **'Why do I repeat the same relationship pattern?'**
  String get promptRelationship;

  /// No description provided for @promptMonth.
  ///
  /// In en, this message translates to:
  /// **'What should I focus on this month?'**
  String get promptMonth;

  /// No description provided for @notice.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get notice;

  /// No description provided for @guideUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Guide unavailable'**
  String get guideUnavailable;

  /// No description provided for @unlockUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlock unlimited guidance'**
  String get unlockUnlimited;

  /// No description provided for @guideLabel.
  ///
  /// In en, this message translates to:
  /// **'PillarWise Guide'**
  String get guideLabel;

  /// No description provided for @tryThis.
  ///
  /// In en, this message translates to:
  /// **'Try this: {step}'**
  String tryThis(Object step);

  /// No description provided for @loveEmptyLabel.
  ///
  /// In en, this message translates to:
  /// **'Relationship Insights'**
  String get loveEmptyLabel;

  /// No description provided for @loveEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Understand a relationship dynamic.'**
  String get loveEmptyTitle;

  /// No description provided for @loveEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add someone\'s birth details to explore communication, chemistry, and conflict patterns.'**
  String get loveEmptyBody;

  /// No description provided for @addSomeone.
  ///
  /// In en, this message translates to:
  /// **'Add Someone'**
  String get addSomeone;

  /// No description provided for @relationshipFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationshipFallbackTitle;

  /// No description provided for @relationshipPreviewFallback.
  ///
  /// In en, this message translates to:
  /// **'Generate a preview to understand this dynamic.'**
  String get relationshipPreviewFallback;

  /// No description provided for @viewRelationshipReport.
  ///
  /// In en, this message translates to:
  /// **'View Full Relationship Report'**
  String get viewRelationshipReport;

  /// No description provided for @unlockRelationshipReport.
  ///
  /// In en, this message translates to:
  /// **'Unlock Full Relationship Report'**
  String get unlockRelationshipReport;

  /// No description provided for @relationshipReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Relationship Report'**
  String get relationshipReportTitle;

  /// No description provided for @relationshipReportUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Full relationship report is ready.'**
  String get relationshipReportUnlocked;

  /// No description provided for @generatePreview.
  ///
  /// In en, this message translates to:
  /// **'Generate Preview'**
  String get generatePreview;

  /// No description provided for @namePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Name or nickname'**
  String get namePlaceholder;

  /// No description provided for @datePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'YYYY-MM-DD'**
  String get datePlaceholder;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @birthDetails.
  ///
  /// In en, this message translates to:
  /// **'Birth Details'**
  String get birthDetails;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlan;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// No description provided for @manageSubscription.
  ///
  /// In en, this message translates to:
  /// **'Manage Subscription'**
  String get manageSubscription;

  /// No description provided for @managedInAppStore.
  ///
  /// In en, this message translates to:
  /// **'Managed in App Store account settings'**
  String get managedInAppStore;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @savedJournal.
  ///
  /// In en, this message translates to:
  /// **'Saved Journal'**
  String get savedJournal;

  /// No description provided for @noJournalTitle.
  ///
  /// In en, this message translates to:
  /// **'No saved notes yet.'**
  String get noJournalTitle;

  /// No description provided for @noJournalBody.
  ///
  /// In en, this message translates to:
  /// **'Reflections and saved guide answers will appear here.'**
  String get noJournalBody;

  /// No description provided for @dataPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data & Privacy'**
  String get dataPrivacy;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export My Data'**
  String get exportData;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get disclaimer;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemLanguage.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @chineseSimplified.
  ///
  /// In en, this message translates to:
  /// **'Simplified Chinese'**
  String get chineseSimplified;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'PillarWise AI v1.0.0'**
  String get versionLabel;

  /// No description provided for @privacyBody.
  ///
  /// In en, this message translates to:
  /// **'We collect birth details, conversations, journal entries, and entitlement state to personalize readings. We do not sell personal data.'**
  String get privacyBody;

  /// No description provided for @termsBody.
  ///
  /// In en, this message translates to:
  /// **'PillarWise is a self-reflection product and does not provide medical, legal, financial, or mental health advice.'**
  String get termsBody;

  /// No description provided for @disclaimerBody.
  ///
  /// In en, this message translates to:
  /// **'Readings are reflective patterns, not deterministic predictions.'**
  String get disclaimerBody;

  /// No description provided for @deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get deleteTitle;

  /// No description provided for @deleteBody.
  ///
  /// In en, this message translates to:
  /// **'This removes your birth profiles, charts, reports, conversations, journal entries, and local subscription state. This action cannot be undone.'**
  String get deleteBody;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock your full Life Blueprint'**
  String get paywallTitle;

  /// No description provided for @paywallBody.
  ///
  /// In en, this message translates to:
  /// **'Full personality reading, daily personalized insights, unlimited AI follow-up, and relationship reports.\n\nAnnual - Best value - \$79.99/year\nMonthly - \$14.99/month\nSubscription renews automatically unless canceled at least 24 hours before the end of the current period.'**
  String get paywallBody;

  /// No description provided for @startAnnual.
  ///
  /// In en, this message translates to:
  /// **'Start Annual Plan'**
  String get startAnnual;

  /// No description provided for @appLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguageTitle;

  /// No description provided for @exportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export My Data'**
  String get exportTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
