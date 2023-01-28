import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/language/language_provider.dart';
import 'package:flutteradhouse/repository/language_repository.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradhouse/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/language.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';

import '../item/language_list_item.dart';

class LanguageListView extends StatefulWidget {
  @override
  _LanguageListViewState createState() => _LanguageListViewState();
}

class _LanguageListViewState extends State<LanguageListView>
    with SingleTickerProviderStateMixin {
  LanguageRepository? repo1;

  AnimationController? animationController;
  Animation<double>? animation;

  @override
  void dispose() {
    animationController!.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
          final PsValueHolder valueHolder =
          Provider.of<PsValueHolder>(context, listen: false);
        final List<Language> _lanuageList = <Language>[];
    repo1 = Provider.of<LanguageRepository>(context);
    timeDilation = 1.0;
    Future<bool> _requestPop() {
      animationController!.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<LanguageProvider>(
        appBarTitle:
            Utils.getString(context, 'language_selection__title'),
        initProvider: () {
          return LanguageProvider(repo: repo1);
        },
        onProviderReady: (LanguageProvider provider) {
          provider.getLanguageList();
          provider.getExcludedLanguageCodeList();
        },
        builder:
            (BuildContext context, LanguageProvider provider, Widget? child) {
                for (Language language in provider.languageList) {
            if (!provider.excludedLanguageList!.contains(language.languageCode)) {
              _lanuageList.add(language);
            }
          }  
          return Padding(
            padding: const EdgeInsets.only(
                top: PsDimens.space8, bottom: PsDimens.space8),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _lanuageList.length,
              itemBuilder: (BuildContext context, int index) {
                final int count = _lanuageList.length;
                return LanguageListItem(
                    language: _lanuageList[index],
                    animationController: animationController!,
                    animation: Tween<double>(begin: 0.0, end: 1.0)
                        .animate(CurvedAnimation(
                      parent: animationController!,
                      curve: Interval((1 / count) * index, 1.0,
                          curve: Curves.fastOutSlowIn),
                    )),
                    onTap: () {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmDialogView(
                                description: Utils.getString(context,
                                    'home__language_dialog_description'),
                                leftButtonText:
                                    Utils.getString(context, 'dialog__cancel'),
                                rightButtonText:
                                    Utils.getString(context, 'dialog__ok'),
                                onAgreeTap: () {
                                   valueHolder.isUserAlradyChoose = true;

                                  print(valueHolder.isUserAlradyChoose);
                                  
                                  provider.replaceIsUserAlreadyChoose(true);
                                  Navigator.of(context).pop();
                                  Navigator.pop(
                                      context, _lanuageList[index]);

                                          if(valueHolder.isLanguageConfig == true){
                                  if (valueHolder.locationId != null) {
                                           Navigator.pushNamed(
                                             context,
                                             RoutePaths.home,
                                           );
                                   } else {
                                           Navigator.pushNamed(
                                             context,
                                             RoutePaths.itemLocationList,
                                           );
                                      }
                                    }
                                });
                          });
                    });
              },
            ),
          );
        },
      ),
    );
  }
}
