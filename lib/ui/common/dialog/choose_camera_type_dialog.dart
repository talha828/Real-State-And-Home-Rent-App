import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/ui/common/ps_button_widget_with_round_corner.dart';
import 'package:flutteradhouse/utils/utils.dart';

class ChooseCameraTypeDialog extends StatefulWidget {
  const ChooseCameraTypeDialog({Key? key, this.onCameraTap, this.onGalleryTap})
      : super(key: key);

  final Function? onCameraTap;
  final Function? onGalleryTap;

  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<ChooseCameraTypeDialog> {
  @override
  Widget build(BuildContext context) {
    return NewDialog(widget: widget);
  }
}

class NewDialog extends StatelessWidget {
  const NewDialog({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final ChooseCameraTypeDialog widget;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        width: 400.0,
        // height: 300.0,
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(height: PsDimens.space16),
            Text(Utils.getString(context, 'camera_dialog__title'),
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: PsColors.mainColor, fontWeight: FontWeight.bold)),
            const SizedBox(height: PsDimens.space24),
            PSButtonWidgetRoundCorner(
              hasShadow: true,
              width: double.infinity,
              titleText:
                  Utils.getString(context, 'camera_dialog__gallery_and_camera'),
              onPressed: () {
                Navigator.pop(context);
                widget.onGalleryTap!();
              },
            ),
            const SizedBox(height: PsDimens.space24),
            Padding(
              padding: const EdgeInsets.only(
                  left: PsDimens.space32, right: PsDimens.space32),
              child: Divider(
                color: Theme.of(context).iconTheme.color,
                height: 0.1,
              ),
            ),
            const SizedBox(height: PsDimens.space16),
            Text(Utils.getString(context, 'camera_dialog__text'),
                style: Theme.of(context).textTheme.button!.copyWith()),
            const SizedBox(height: PsDimens.space8),
            PSButtonWidgetRoundCorner(
              hasShadow: true,
              width: double.infinity,
              titleText:
                  Utils.getString(context, 'camera_dialog__custom_camera'),
              onPressed: () {
                Navigator.pop(context);
                widget.onCameraTap!();
              },
            ),
            const SizedBox(height: PsDimens.space16),
          ],
        ),
      ),
    );
  }
}
