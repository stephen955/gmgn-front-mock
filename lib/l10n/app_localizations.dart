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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'gmgn.AI'**
  String get app_title;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to gmgn.AI'**
  String get welcome;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @open_orders.
  ///
  /// In en, this message translates to:
  /// **'Open Orders'**
  String get open_orders;

  /// No description provided for @trade_history.
  ///
  /// In en, this message translates to:
  /// **'Trade History'**
  String get trade_history;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @fee.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get fee;

  /// No description provided for @market.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get market;

  /// No description provided for @kline.
  ///
  /// In en, this message translates to:
  /// **'K-Line'**
  String get kline;

  /// No description provided for @last_price.
  ///
  /// In en, this message translates to:
  /// **'Last Price'**
  String get last_price;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @paste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @assets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get assets;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @network.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get network;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get min;

  /// No description provided for @max.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get max;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @discover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// No description provided for @leaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard;

  /// No description provided for @monitor.
  ///
  /// In en, this message translates to:
  /// **'Monitor'**
  String get monitor;

  /// No description provided for @asset.
  ///
  /// In en, this message translates to:
  /// **'Asset'**
  String get asset;

  /// No description provided for @tabWatchlist.
  ///
  /// In en, this message translates to:
  /// **'Watchlist'**
  String get tabWatchlist;

  /// No description provided for @tabTrenches.
  ///
  /// In en, this message translates to:
  /// **'Trenches'**
  String get tabTrenches;

  /// No description provided for @tabNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get tabNew;

  /// No description provided for @tabTrending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get tabTrending;

  /// No description provided for @tabXStocks.
  ///
  /// In en, this message translates to:
  /// **'xStocks'**
  String get tabXStocks;

  /// No description provided for @btnNewCreation.
  ///
  /// In en, this message translates to:
  /// **'New Creation'**
  String get btnNewCreation;

  /// No description provided for @btnFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get btnFilter;

  /// No description provided for @btnRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get btnRefresh;

  /// No description provided for @btnPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get btnPaused;

  /// No description provided for @pillUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get pillUpcoming;

  /// No description provided for @pillOpened.
  ///
  /// In en, this message translates to:
  /// **'Opened'**
  String get pillOpened;

  /// No description provided for @searchTokenWallet.
  ///
  /// In en, this message translates to:
  /// **'Search Token/Wallet'**
  String get searchTokenWallet;

  /// No description provided for @nextStep.
  ///
  /// In en, this message translates to:
  /// **'Next Step'**
  String get nextStep;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get loginEmailHint;

  /// No description provided for @loginEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get loginEmailRequired;

  /// No description provided for @loginEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get loginEmailInvalid;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginPasswordHint;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get loginPasswordRequired;

  /// No description provided for @loginPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get loginPasswordTooShort;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get loginForgotPassword;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get loginNoAccount;

  /// No description provided for @loginRegisterNow.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get loginRegisterNow;

  /// No description provided for @loginAppleLogin.
  ///
  /// In en, this message translates to:
  /// **'Apple Login'**
  String get loginAppleLogin;

  /// No description provided for @loginTelegramLogin.
  ///
  /// In en, this message translates to:
  /// **'Telegram Login'**
  String get loginTelegramLogin;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerTitle;

  /// No description provided for @registerUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get registerUsernameHint;

  /// No description provided for @registerUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get registerUsernameRequired;

  /// No description provided for @registerUsernameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters'**
  String get registerUsernameTooShort;

  /// No description provided for @registerEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get registerEmailHint;

  /// No description provided for @registerEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get registerEmailRequired;

  /// No description provided for @registerEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get registerEmailInvalid;

  /// No description provided for @registerHasAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get registerHasAccount;

  /// No description provided for @registerGoLogin.
  ///
  /// In en, this message translates to:
  /// **'Go to Login'**
  String get registerGoLogin;

  /// No description provided for @registerAppleLogin.
  ///
  /// In en, this message translates to:
  /// **'Apple Login'**
  String get registerAppleLogin;

  /// No description provided for @registerTelegramLogin.
  ///
  /// In en, this message translates to:
  /// **'Telegram Login'**
  String get registerTelegramLogin;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful, please login'**
  String get registerSuccess;

  /// No description provided for @assetManageDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage your digital assets'**
  String get assetManageDescription;

  /// No description provided for @assetUnloggedTitle.
  ///
  /// In en, this message translates to:
  /// **'Please login first'**
  String get assetUnloggedTitle;

  /// No description provided for @assetUnloggedDescription.
  ///
  /// In en, this message translates to:
  /// **'Login to view your assets'**
  String get assetUnloggedDescription;

  /// No description provided for @pillSoaring.
  ///
  /// In en, this message translates to:
  /// **'Soaring'**
  String get pillSoaring;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a password reset link'**
  String get forgotPasswordDescription;

  /// No description provided for @forgotPasswordEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get forgotPasswordEmailHint;

  /// No description provided for @forgotPasswordEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get forgotPasswordEmailRequired;

  /// No description provided for @forgotPasswordEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get forgotPasswordEmailInvalid;

  /// No description provided for @forgotPasswordSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Email'**
  String get forgotPasswordSubmit;

  /// No description provided for @forgotPasswordRememberPassword.
  ///
  /// In en, this message translates to:
  /// **'Remember your password?'**
  String get forgotPasswordRememberPassword;

  /// No description provided for @forgotPasswordLoginNow.
  ///
  /// In en, this message translates to:
  /// **'Login Now'**
  String get forgotPasswordLoginNow;

  /// No description provided for @forgotPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reset email sent, please check your inbox'**
  String get forgotPasswordSuccess;

  /// No description provided for @forgotPasswordFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send email, please try again'**
  String get forgotPasswordFailed;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
