import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/viewobject/noti.dart';

class NotiListItem extends StatelessWidget {
  const NotiListItem({
    Key? key,
    required this.noti,
    this.animationController,
    this.animation,
    this.onTap,
  }) : super(key: key);

  final Noti noti;
  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();
    return AnimatedBuilder(
        animation: animationController!,
        child: GestureDetector(
          onTap: onTap  as void Function()?,
          child: Container(
              color: noti.isRead == '0'
                  ? PsColors.backgroundColor
                  : PsColors.baseColor,
              margin: const EdgeInsets.only(top: PsDimens.space8),
              child: Ink(
                  color: PsColors.mainColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            PsNetworkImage(
                              photoKey: '',
                              defaultPhoto: noti.defaultPhoto!,
                              width: PsDimens.space64,
                              height: PsDimens.space64,
                               imageAspectRation: PsConst.Aspect_Ratio_1x,
                              onTap: onTap,
                            ),
                            const SizedBox(
                              width: PsDimens.space8,
                            ),
                            Expanded(
                              child: Text(noti.message!,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.bodyText1),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: PsDimens.space8,
                        ),
                        Text(
                          noti.addedDateStr!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ))),
        ),
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: animation!,
            child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - animation!.value), 0.0),
                child: child),
          );
        });
  }
}
