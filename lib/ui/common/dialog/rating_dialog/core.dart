import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedantic/pedantic.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'conditions.dart';
import 'dialogs.dart';
import 'style.dart';

/// Allows to kindly ask users to rate your app if custom conditions are met (eg. install time, number of launches, etc...).
class RateMyApp {
  /// Creates a new Rate my app instance.
  RateMyApp({
    this.preferencesPrefix = 'rateMyApp_',
    int? minDays,
    int? remindDays,
    int? minLaunches,
    int? remindLaunches,
    this.googlePlayIdentifier,
    this.appStoreIdentifier,
  }) : conditions = <Condition>[] {
    populateWithDefaultConditions(
      minDays: minDays,
      remindDays: remindDays,
      minLaunches: minLaunches,
      remindLaunches: remindLaunches,
    );
  }

  /// Creates a new Rate my app instance with custom conditions.
  const RateMyApp.customConditions({
    this.preferencesPrefix = 'rateMyApp_',
    this.googlePlayIdentifier,
    this.appStoreIdentifier,
    required this.conditions,
  });

  /// The plugin channel.
  static const MethodChannel _channel = MethodChannel('rate_my_app');

  /// Prefix for preferences.
  final String preferencesPrefix;

  /// The google play identifier.
  final String? googlePlayIdentifier;

  /// The app store identifier.
  final String? appStoreIdentifier;

  /// All conditions that should be met to show the dialog.
  final List<Condition> conditions;

  /// Initializes the plugin (loads base launch date, app launches and whether the dialog should not be opened again).
  Future<void> init() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    for (Condition condition in conditions) {
      condition.readFromPreferences(preferences, preferencesPrefix);
    }

    // conditions.forEach((Condition condition) =>
    //     condition.readFromPreferences(preferences, preferencesPrefix);;
    await callEvent(RateMyAppEventType.initialized);
  }

  /// Saves the plugin current data to the shared preferences.
  Future<void> save() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    for (Condition condition in conditions) {
      await condition.saveToPreferences(preferences, preferencesPrefix);
    }

    await callEvent(RateMyAppEventType.saved);
  }

  /// Resets the plugin data.
  Future<void> reset() async {
    for (Condition condition in conditions) {
      condition.reset();
    }
    // conditions.forEach((condition) => condition.reset());
    await save();
  }

  /// Whether the dialog should be opened.
  bool get shouldOpenDialog =>
      conditions.firstWhereOrNull((Condition condition) => !condition.isMet) ==
      null;

  /// Returns the corresponding store identifier.
  String? get storeIdentifier {
    if (Platform.isIOS) {
      return appStoreIdentifier;
    }

    if (Platform.isAndroid) {
      return googlePlayIdentifier;
    }

    return null;
  }

  /// Returns whether native review dialog is supported.
  Future<bool?> get isNativeReviewDialogSupported =>
      _channel.invokeMethod<bool>('isNativeDialogSupported');

  /// Launches the native review dialog.
  /// You should check for [isNativeReviewDialogSupported] before running the method.
  Future<void> launchNativeReviewDialog() =>
      _channel.invokeMethod('launchNativeReviewDialog');

  /// Shows the rate dialog.
  Future<void> showRateDialog(
    BuildContext context, {
    String? title,
    String? message,
    DialogContentBuilder? contentBuilder,
    DialogActionsBuilder? actionsBuilder,
    String? rateButton,
    String? noButton,
    String? laterButton,
    RateMyAppDialogButtonClickListener? listener,
    bool? ignoreNativeDialog,
    DialogStyle? dialogStyle,
    VoidCallback? onDismissed,
  }) async {
    ignoreNativeDialog ??= Platform.isAndroid;
    if (!ignoreNativeDialog &&
        await (isNativeReviewDialogSupported as FutureOr<bool>)) {
      unawaited(callEvent(RateMyAppEventType.iOSRequestReview));
      await launchNativeReviewDialog();
      return;
    }

    unawaited(callEvent(RateMyAppEventType.dialogOpen));
    final RateMyAppDialogButton? clickedButton =
        await showDialog<RateMyAppDialogButton>(
      context: context,
      builder: (BuildContext context) => RateMyAppDialog(
        this,
        title: title ?? 'Rate this app',
        message: message ??
            'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.',
        contentBuilder: contentBuilder ??
            ((BuildContext context, Widget defaultContent) => defaultContent),
        actionsBuilder: actionsBuilder,
        rateButton: rateButton ?? 'RATE',
        noButton: noButton ?? 'NO THANKS',
        laterButton: laterButton ?? 'MAYBE LATER',
        listener: listener,
        dialogStyle: dialogStyle ?? const DialogStyle(),
      ),
    );

    if (clickedButton == null && onDismissed != null) {
      onDismissed();
    }
  }

  /// Shows the star rate dialog.
  Future<void> showStarRateDialog(
    BuildContext context, {
    String? title,
    String? message,
    DialogContentBuilder? contentBuilder,
    StarDialogActionsBuilder? actionsBuilder,
    bool? ignoreNativeDialog,
    DialogStyle? dialogStyle,
    StarRatingOptions? starRatingOptions,
    VoidCallback? onDismissed,
  }) async {
    ignoreNativeDialog ??= Platform.isAndroid;
    if (!ignoreNativeDialog &&
        await (isNativeReviewDialogSupported as FutureOr<bool>)) {
      unawaited(callEvent(RateMyAppEventType.iOSRequestReview));
      await launchNativeReviewDialog();
      return;
    }

    assert(actionsBuilder != null, 'You should provide an actions builder.');
    unawaited(callEvent(RateMyAppEventType.starDialogOpen));

    final RateMyAppDialogButton? clickedButton = await showDialog(
      context: context,
      builder: (BuildContext context) => RateMyAppStarDialog(
        this,
        title: title ?? 'Rate this app',
        message: message ??
            'You like this app ? Then take a little bit of your time to leave a rating :',
        contentBuilder: contentBuilder ??
            ((BuildContext context, Widget defaultContent) => defaultContent),
        actionsBuilder: actionsBuilder,
        dialogStyle: dialogStyle ??
            const DialogStyle(
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 20),
            ),
        starRatingOptions: starRatingOptions ?? const StarRatingOptions(),
      ),
    );

    if (clickedButton == null && onDismissed != null) {
      onDismissed();
    }
  }

  /// Launches the corresponding store.
  Future<LaunchStoreResult> launchStore() async {
    final int? result = await _channel.invokeMethod(
        'launchStore',
        // ignore: always_specify_types
        storeIdentifier == null ? null : {'appId': storeIdentifier});
    switch (result) {
      case 0:
        return LaunchStoreResult.storeOpened;
      case 1:
        return LaunchStoreResult.browserOpened;
      default:
        return LaunchStoreResult.errorOccurred;
    }
  }

  /// Calls the specified event.
  Future<void> callEvent(RateMyAppEventType eventType) async {
    bool saveSharedPreferences = false;
    for (Condition condition in conditions) {
      saveSharedPreferences =
          condition.onEventOccurred(eventType) || saveSharedPreferences;
    }
    // conditions.forEach((condition) => saveSharedPreferences =
    //     condition.onEventOccurred(eventType) || saveSharedPreferences);
    if (saveSharedPreferences) {
      await save();
    }
  }

  /// Adds the default conditions to the current conditions list.
  void populateWithDefaultConditions({
    int? minDays,
    int? remindDays,
    int? minLaunches,
    int? remindLaunches,
  }) {
    conditions.add(MinimumDaysCondition(
      minDays: minDays ?? 7,
      remindDays: remindDays ?? 7,
    ));
    conditions.add(MinimumAppLaunchesCondition(
      minLaunches: minLaunches ?? 10,
      remindLaunches: remindLaunches ?? 10,
    ));
    conditions.add(DoNotOpenAgainCondition());
  }
}

/// Represents all events that can occur during the Rate my app lifecycle.
enum RateMyAppEventType {
  /// When Rate my app is fully initialized.
  initialized,

  /// When Rate my app is saved.
  saved,

  /// When a native iOS rating dialog will be opened.
  iOSRequestReview,

  /// When the classic Rate my app dialog will be opened.
  dialogOpen,

  /// When the star dialog will be opened.
  starDialogOpen,

  /// When the rate button has been pressed.
  rateButtonPressed,

  /// When the later button has been pressed.
  laterButtonPressed,

  /// When the no button has been pressed.
  noButtonPressed,
}

/// Allows to handle the result of the `launchStore` method.
enum LaunchStoreResult {
  /// The store has been opened, everything is okay.
  storeOpened,

  /// The store has not been opened, but a link to your app has been opened in the user web browser.
  browserOpened,

  /// An error occurred and the method did nothing.
  errorOccurred,
}
