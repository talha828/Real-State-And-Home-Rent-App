import 'package:flutter/material.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/ui/common/ps_button_widget_with_round_corner.dart';
import 'package:flutteradhouse/utils/utils.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({Key? key, this.onDescendingTap, this.onAscendingTap})
      : super(key: key);

  final Function? onDescendingTap;
  final Function? onAscendingTap;

  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<FilterDialog> {
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

  final FilterDialog widget;

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
            const SizedBox(height: PsDimens.space24),
            PSButtonWidgetRoundCorner(
              hasShadow: true,
              width: double.infinity,
              titleText: Utils.getString(
                  context, 'item_filter__lowest_to_highest_letter'),
              onPressed: () {
                Navigator.pop(context);
                widget.onAscendingTap!();
              },
            ),
            const SizedBox(height: PsDimens.space16),
            PSButtonWidgetRoundCorner(
              hasShadow: true,
              width: double.infinity,
              titleText: Utils.getString(
                  context, 'item_filter__highest_to_lowest_letter'),
              onPressed: () {
                Navigator.pop(context);
                widget.onDescendingTap!();
              },
            ),
            const SizedBox(height: PsDimens.space16),
            PSButtonWidgetRoundCorner(
              hasShadow: true,
              width: double.infinity,
              titleText: Utils.getString(context, 'dialog__cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
