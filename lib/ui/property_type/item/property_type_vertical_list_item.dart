import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/viewobject/property_type.dart';

class PropertyTypeVerticalListItem extends StatelessWidget {
  const PropertyTypeVerticalListItem(
      {Key? key,
      required this.propertyType,
      this.onTap,
      this.animationController,
      this.animation,
      required this.propertyScribeNoti,
      required this.tempList})
      : super(key: key);

  final PropertyType propertyType;

  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final List<String?> tempList;
  final bool propertyScribeNoti;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();
    return AnimatedBuilder(
        animation: animationController!,
        child: GestureDetector(
            onTap: onTap  as void Function()?,
            child: Stack(
              children:<Widget> [
                Card(
                    elevation: 0.3,
                    child: Container(
                        child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Stack(
                              children: <Widget>[
                                InkWell(
                                  child: PsNetworkImage(
                                    photoKey: '',
                                    defaultPhoto: propertyType.defaultPhoto!,
                                    imageAspectRation: PsConst.Aspect_Ratio_2x,
                                    width: PsDimens.space200,
                                    height: PsDimens.space200,
                                    boxfit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  height: double.infinity,
                                  color: PsColors.black.withAlpha(110),
                                )
                              ],
                            )),
                        Text(
                          propertyType.name!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              color: PsColors.white, fontWeight: FontWeight.bold),
                        ),
                        Container(
                            child: Positioned(
                          bottom: 10,
                          left: 10,
                          child: Container(
                            width: PsDimens.space40,
                            height: PsDimens.space40,
                            child: PsNetworkCircleIconImage(
                              photoKey: '',
                              defaultIcon: propertyType.defaultIcon!,
                              // width: PsDimens.space40,
                              // height: PsDimens.space40,
                              boxfit: BoxFit.cover,
                              onTap: onTap,
                            ),
                          ),
                        )),

                      ],
                    ))),
                    Visibility(
                          visible: propertyScribeNoti,
                          child: Positioned(
                            top: 1,
                            right: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: Container(
                                color: PsColors.mainColor,
                                child: Icon(
                                  Icons.circle,
                                  color: tempList.contains(propertyType.id)
                                  ? PsColors.mainColor 
                                  : PsColors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
              ],
            )),
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
