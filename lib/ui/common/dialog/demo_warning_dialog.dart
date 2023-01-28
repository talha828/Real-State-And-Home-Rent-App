import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/utils/utils.dart';

class DemoWarningDialog extends StatefulWidget {
  const DemoWarningDialog();

  @override
  _WarningDialogState createState() => _WarningDialogState();
}

class _WarningDialogState extends State<DemoWarningDialog> {
  @override
  Widget build(BuildContext context) {
    return _NewDialog(widget: widget);
  }
}

class _NewDialog extends StatelessWidget {
  const _NewDialog({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final DemoWarningDialog widget;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                height: 60,
                width: double.infinity,
                padding: const EdgeInsets.all(PsDimens.space8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  color: Utils.isLightMode(context)
                      ? PsColors.mainColor
                      : Colors.black12,
                ),
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: PsDimens.space4,
                    ),
                    Image.asset(
                      'assets/images/demo_alert.png',
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      width: PsDimens.space4,
                    ),
                    Flexible(
                      child: Text(
                          Utils.getString(
                              context, 'demo_warning_title'),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,    
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(color: PsColors.white)),
                    ),
                  ],
                )),
            const SizedBox(
              height: PsDimens.space20,
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: PsDimens.space16,
                  right: PsDimens.space16,
                  top: PsDimens.space8,
                  bottom: PsDimens.space8),
              child: Text(
                Utils.getString(context,
                    'demo_warning_description'),
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
            const SizedBox(
              height: PsDimens.space20,
            ),
            Divider(
              thickness: 0.5,
              height: 1,
              color: Theme.of(context).iconTheme.color,
            ),
            MaterialButton(
                height: 50,
                minWidth: double.infinity,
                onPressed: () {
            Navigator.of(context).pop();
                },
                child: Text(
            Utils.getString(context, 'dialog_understand'),
            style: Theme.of(context)
                .textTheme
                .button!
                .copyWith(color: PsColors.mainColor),
                ),
              )
          ],
        ));
  }
}
