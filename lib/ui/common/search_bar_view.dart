// Copyright (c) 2017, Spencer. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/utils/utils.dart';

typedef AppBarCallback = Widget Function(BuildContext context);
typedef TextFieldSubmitCallback = void Function(String value);
typedef TextFieldChangeCallback = void Function(String value);
// ignore: prefer_generic_function_type_aliases
typedef void SetStateCallback(void fn());

class SearchBar {
  /// Whether the search should take place "in the existing search bar", meaning whether it has the same background or a flipped one. Defaults to true.
  final bool inBar;

  /// Whether or not the search bar should close on submit. Defaults to true.
  final bool closeOnSubmit;

  /// Whether the text field should be cleared when it is submitted
  final bool clearOnSubmit;

  /// A callback which should return an AppBar that is displayed until search is started. One of the actions in this AppBar should be a search button which you obtain from SearchBar.getSearchAction(). This will be called every time search is ended, etc. (like a build method on a widget)
  final AppBarCallback buildDefaultAppBar;

  /// A void callback which takes a string as an argument, this is fired every time the search is submitted. Do what you want with the result.
  final TextFieldSubmitCallback? onSubmitted;

  /// A void callback which gets fired on close button press.
  final VoidCallback? onClosed;

  /// A callback which is fired when clear button is pressed.
  final VoidCallback? onCleared;

  /// Since this should be inside of a State class, just pass setState to this.
  final SetStateCallback setState;

  /// Whether or not the search bar should add a clear input button, defaults to true.
  final bool showClearButton;

  /// What the hintText on the search bar should be. Defaults to 'Search'.
  final String hintText;

  /// Whether search is currently active.
  // ignore: always_specify_types
  final ValueNotifier<bool> isSearching = ValueNotifier(false);

  /// A callback which is invoked each time the text field's value changes
  final TextFieldChangeCallback? onChanged;

  /// The controller to be used in the textField.
  TextEditingController? controller;

  /// Whether the clear button should be active (fully colored) or inactive (greyed out)
  bool _clearActive = false;

  /// The last built default AppBar used for colors and such.
  AppBar? _defaultAppBar;

  /// The tabBar to be added to app bar.
  TabBar? tabBar;

  // ignore: sort_constructors_first
  SearchBar({
    required this.setState,
    required this.buildDefaultAppBar,
    this.tabBar,
    this.onSubmitted,
    this.controller,
    this.hintText = 'Search',
    this.inBar = true,
    this.closeOnSubmit = true,
    this.clearOnSubmit = true,
    this.showClearButton = true,
    this.onChanged,
    this.onClosed,
    this.onCleared,
  }) {
    controller ??= TextEditingController();

    // Don't waste resources on listeners for the text controller if the dev
    // doesn't want a clear button anyways in the search bar
    if (!showClearButton) {
      return;
    }

    controller!.addListener(() {
      if (controller!.text.isEmpty) {
        // If clear is already disabled, don't disable it
        if (_clearActive) {
          setState(() {
            _clearActive = false;
          });
        }

        return;
      }

      // If clear is already enabled, don't enable it
      if (!_clearActive) {
        setState(() {
          _clearActive = true;
        });
      }
    });
  }

  /// Initializes the search bar.
  ///
  /// This adds a route that listens for onRemove (and stops the search when that happens), and then calls [setState] to rebuild and start the search.
  void beginSearch(BuildContext context) {
    ModalRoute.of(context)?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: () {
      setState(() {
        isSearching.value = false;
      });
    }));

    setState(() {
      isSearching.value = true;
    });
  }

  /// Builds, saves and returns the default app bar.
  ///
  /// This calls the [buildDefaultAppBar] provided in the constructor, and saves it to [_defaultAppBar].
  AppBar? buildAppBar(BuildContext context) {
    _defaultAppBar = buildDefaultAppBar(context) as AppBar?;

    return _defaultAppBar;
  }

  /// Builds the search bar!
  ///
  /// The leading will always be a back button.
  /// backgroundColor is determined by the value of inBar
  /// title is always a [TextField] with the key 'SearchBarTextField', and various text stylings based on [inBar]. This is also where [onSubmitted] has its listener registered.
  ///
  AppBar buildSearchBar(BuildContext context) {
    final ThemeData theme = Theme.of(context);
   // final Color? buttonColor = inBar ? null : theme.iconTheme.color;

    return AppBar(
      titleSpacing: 0,
      leading: IconButton(
          icon: const BackButtonIcon(),
          color: PsColors.mainColor,
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () {
            controller?.clear();
            Navigator.pop(context);
            onClosed?.call();
          }),
      backgroundColor: inBar ? null : theme.canvasColor,
      title: Container(
        margin: const EdgeInsets.only(right: PsDimens.space16),
        padding: const EdgeInsets.symmetric(horizontal: PsDimens.space8),
            decoration: BoxDecoration(
              color: PsColors.categoryBackgroundColor,//PsColors.primary50,
              borderRadius: BorderRadius.circular(PsDimens.space10),
             // border: Border.all(color: PsColors.mainDividerColor),
            ),
        child: Directionality(
          textDirection: Directionality.of(context),
          child: TextField(
            key: const Key('SearchBarTextField'),
            keyboardType: TextInputType.text,
            style: Theme.of(context)
                .textTheme
                .subtitle1,
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: inBar
                    ? null
                    : TextStyle(
                        color: Utils.isLightMode(context)? PsColors.textPrimaryLightColor: PsColors.mainColorWithBlack,
                      ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                border: InputBorder.none),
            onChanged: onChanged,
            onSubmitted: (String val) async {
              if (closeOnSubmit) {
                await Navigator.maybePop(context);
              }
              // if (clearOnSubmit) {
              //   controller?.clear();
              // }
              onSubmitted?.call(val);
            },
            autofocus: true,
            controller: controller,
          ),
        ),
      ),
      bottom: tabBar,
      // actions: !showClearButton
      //     ? null
      //     : <Widget>[
      //         // Show an icon if clear is not active, so there's no ripple on tap
      //         IconButton(
      //             icon: const Icon(Icons.clear),
      //             color: inBar ? null : buttonColor,
      //             disabledColor: inBar ? null : theme.disabledColor,
      //             onPressed: !_clearActive
      //                 ? null
      //                 : () {
      //                     onCleared?.call();
      //                     controller?.clear();
      //                   }),
      //       ],
    );
  }

  /// Returns an [IconButton] suitable for an Action
  ///
  /// Put this inside your [buildDefaultAppBar] method!
  IconButton getSearchAction(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          beginSearch(context);
        });
  }

  /// Returns an AppBar based on the value of [isSearching]
  AppBar? build(BuildContext context) {
    return isSearching.value ? buildSearchBar(context) : buildAppBar(context);
  }
}
