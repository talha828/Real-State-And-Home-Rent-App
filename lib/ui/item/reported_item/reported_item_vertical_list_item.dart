import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/reported_item.dart';

class ReportedItemVerticalListItem extends StatelessWidget {
  const ReportedItemVerticalListItem(
      {Key? key,
      required this.reportedItem,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final ReportedItem reportedItem;
  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();

    return AnimatedBuilder(
        animation: animationController!,
        child: InkWell(
          onTap: onTap  as void Function()?,
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(bottom: PsDimens.space4),
            child: Ink(
              color: PsColors.backgroundColor,
              child: Padding(
                  padding: const EdgeInsets.all(PsDimens.space16),
                  child: UserWidget(reportedItem: reportedItem, onTap: onTap!)),
            ),
          ),
        ),
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
              opacity: animation!,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation!.value), 0.0),
                  child: child));
        });
  }
}

class UserWidget extends StatelessWidget {
  const UserWidget({
    Key? key,
    required this.reportedItem,
    required this.onTap,
  }) : super(key: key);

  final ReportedItem reportedItem;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final Widget _imageWidget = PsNetworkCircleImage(
      photoKey: '',
      imagePath: reportedItem.defaultPhoto!.imgPath ?? '',
      // width: PsDimens.space44,
      // height: PsDimens.space44,
      boxfit: BoxFit.cover,
      onTap: () {
        onTap();
      },
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
                width: PsDimens.space44,
                height: PsDimens.space44,
                child: _imageWidget),
            const SizedBox(
              width: PsDimens.space12,
            ),
            Expanded(
              child: Text(
                  (reportedItem.title == '' || reportedItem.title == null)
                      ? Utils.getString(context, 'default__user_name')
                      : reportedItem.title!,
                  style: Theme.of(context).textTheme.subtitle1),
            ),
          ],
        ),
      ],
    );
  }
}
