import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';

import 'package:flutteradhouse/viewobject/property_type.dart';

class PropertyTypeHorizontalTrendingListItem extends StatelessWidget {
  const PropertyTypeHorizontalTrendingListItem(
      {Key? key,
      required this.propertyType,
      this.onTap,
      required this.animationController,
      required this.animation})
      : super(key: key);

  final PropertyType propertyType;

  final Function? onTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        child: InkWell(
            onTap: onTap  as void Function()?,
            child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: PsDimens.space8, vertical: PsDimens.space8),
                decoration: BoxDecoration(
                  color: PsColors.backgroundColor,
                  borderRadius:
                      const BorderRadius.all(Radius.circular(PsDimens.space8)),
                ),
                child: Ink(
                  color: PsColors.backgroundColor,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              child: InkWell(
                                child: Image.asset(
                                  'assets/images/user_default_photo.png',
                                  width: PsDimens.space160,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                                width: 200,
                                height: double.infinity,
                                color: PsColors.black.withAlpha(110)),
                          ],
                        ),
                      ),
                      Text(
                        propertyType.name!,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: PsColors.white, fontWeight: FontWeight.bold),
                      ),
                      Container(
                          child: Positioned(
                        bottom: 10,
                        left: 10,
                        child: PsNetworkCircleIconImage(
                            photoKey: '',
                            defaultIcon: propertyType.defaultIcon!,
                            width: PsDimens.space40,
                            height: PsDimens.space40,
                            boxfit: BoxFit.cover,
                            onTap: onTap),
                      )),
                    ],
                  ),
                ))),
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: animation,
            child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - animation.value), 0.0),
                child: child),
          );
        });
  }
}
