import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/utils/utils.dart';

class RetryDialogView extends StatefulWidget {
  const RetryDialogView(
      {Key? key,
      this.description,
      this.rightButtonText,
      this.onAgreeTap})
      : super(key: key);

  final String? description, rightButtonText;
  final Function? onAgreeTap;

  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<RetryDialogView> {
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

  final RetryDialogView widget;

  @override
  Widget build(BuildContext context) {
    const Widget _spacingWidget = SizedBox(
      width: PsDimens.space4,
    );
    const Widget _largeSpacingWidget = SizedBox(
      height: PsDimens.space20,
    );
    final Widget _headerWidget = Row(
      children: <Widget>[
        _spacingWidget,
        Icon(
          Icons.help_outline,
          color: PsColors.white,
        ),
        _spacingWidget,
        Text(
          Utils.getString(context, 'logout_dialog__confirm'),
          textAlign: TextAlign.start,
          style: TextStyle(
            color: PsColors.white,
          ),
        ),
      ],
    );

    final Widget _messageWidget = Text(
      widget.description!,
      style: Theme.of(context).textTheme.subtitle2,
    );
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              height: PsDimens.space60,
              width: double.infinity,
              padding: const EdgeInsets.all(PsDimens.space8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                color: Utils.isLightMode(context)
                    ? PsColors.mainColor
                    : Colors.black12,
              ),
              child: _headerWidget),
          _largeSpacingWidget,
          Container(
            padding: const EdgeInsets.only(
                left: PsDimens.space16,
                right: PsDimens.space16,
                top: PsDimens.space8,
                bottom: PsDimens.space8),
            child: _messageWidget,
          ),
          _largeSpacingWidget,
          Divider(
            color: Theme.of(context).iconTheme.color,
            height: 0.4,
          ),
          Row(children: <Widget>[
            Expanded(
                child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                widget.onAgreeTap!();
              },
              child: Text(
                widget.rightButtonText!,
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: PsColors.mainColor),
              ),
            )),
          ])
        ],
      ),
    );
  }
}