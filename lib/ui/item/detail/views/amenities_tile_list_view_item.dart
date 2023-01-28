import 'package:flutter/material.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/viewobject/amenities.dart';
import 'package:fluttericon/linearicons_free_icons.dart';

class AmenitiesTileListViewItem extends StatelessWidget {
  const AmenitiesTileListViewItem(
      {Key? key,
      required this.amenities,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final Amenities amenities;
  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();
    return AnimatedBuilder(
      animation: animationController!,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                left: PsDimens.space4,
                right: PsDimens.space4
              ),
              child: Row(
                children: <Widget>[
                  const Icon(
                    LineariconsFree.arrow_right_circle,
                    size: PsDimens.space24,
                  ),
                  Container(
                    width: PsDimens.space130,
                    child: Text(
                      amenities.name!,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1,
                      ),
                  ),
                ],
              ),
            ),
          ]),
      builder: (BuildContext contenxt, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 100 * (1.0 - animation!.value), 0.0),
              child: child),
        );
      },
    );
  }
}
