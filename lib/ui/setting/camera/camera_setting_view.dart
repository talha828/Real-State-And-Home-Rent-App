import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/provider/common/notification_provider.dart';
import 'package:flutteradhouse/repository/Common/notification_repository.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';

class CameraSettingView extends StatefulWidget {
  @override
  _NotificationSettingViewState createState() =>
      _NotificationSettingViewState();
}

NotificationRepository? notiRepository;
NotificationProvider? notiProvider;
PsValueHolder? _psValueHolder;

class _NotificationSettingViewState extends State<CameraSettingView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    notiRepository = Provider.of<NotificationRepository>(context);
    _psValueHolder = Provider.of<PsValueHolder>(context);
    print(
        '............................Build UI Again ...........................');

    return PsWidgetWithAppBar<NotificationProvider>(
        appBarTitle:
            Utils.getString(context, 'camera_setting__toolbar_name'),
        initProvider: () {
          return NotificationProvider(
              repo: notiRepository!, psValueHolder: _psValueHolder);
        },
        onProviderReady: (NotificationProvider provider) {
          notiProvider = provider;
        },
        builder: (BuildContext context, NotificationProvider provider,
            Widget? child) {
          return _NotificationSettingWidget(notiProvider: provider);
        });
  }
}

class _NotificationSettingWidget extends StatefulWidget {
  const _NotificationSettingWidget({this.notiProvider});
  final NotificationProvider? notiProvider;
  @override
  __NotificationSettingWidgetState createState() =>
      __NotificationSettingWidgetState();
}

class __NotificationSettingWidgetState
    extends State<_NotificationSettingWidget> {
  bool isCustomCameraSwitched = false;

  @override
  Widget build(BuildContext context) {
    //if (notiProvider!.psValueHolder!.isCustomCamera != null) {
      if (notiProvider!.psValueHolder!.isCustomCamera) {
        isCustomCameraSwitched = true;
      } else {
        isCustomCameraSwitched = false;
      }
   // }

    final Widget _customSwitchButtonwidget = Switch(
        value: isCustomCameraSwitched,
        onChanged: (bool value) {
          if (mounted) {
            setState(() async {
              if (value) {
                isCustomCameraSwitched = value;
                notiProvider!.psValueHolder!.isCustomCamera = true;
                await notiProvider!.replaceCustomCameraSetting(true);
              } else {
                isCustomCameraSwitched = value;
                notiProvider!.psValueHolder!.isCustomCamera = false;
                await notiProvider!.replaceCustomCameraSetting(false);
              }
            });
          }
        },
        activeTrackColor: PsColors.mainColor,
        activeColor: PsColors.mainColor);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              left: PsDimens.space8,
              top: PsDimens.space8,
              bottom: PsDimens.space8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                Utils.getString(context, 'camera_setting__custom_camera'),
                style: Theme.of(context).textTheme.subtitle1,
              ),
              _customSwitchButtonwidget,
            ],
          ),
        ),
      ],
    );
  }
}
