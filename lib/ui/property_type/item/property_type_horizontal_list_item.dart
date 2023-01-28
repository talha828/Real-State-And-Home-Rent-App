import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/viewobject/property_type.dart';

class PropertyTypeHorizontalListItem extends StatelessWidget {
  const PropertyTypeHorizontalListItem({
    Key? key,
    required this.propertyType,
    this.onTap,
  }) : super(key: key);

  final PropertyType propertyType;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap  as void Function()?,
        child: Container(
            // color: PsColors.backgroundColor,
            margin: const EdgeInsets.only(
                left: PsDimens.space4, right: PsDimens.space4),
            width: MediaQuery.of(context).size.width / 2,
            height: PsDimens.space100,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: PsNetworkImage(
                          photoKey: '',
                          defaultPhoto: propertyType.defaultPhoto!,
                          imageAspectRation: PsConst.Aspect_Ratio_1x,
                          width: double.infinity,
                          height: PsDimens.space100,
                          boxfit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: PsDimens.space100,
                        color: PsColors.black.withAlpha(110),
                      )
                    ],
                  ),
                ),
                Text(
                  propertyType.name!,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: PsColors.white, fontWeight: FontWeight.bold),
                ),
              ],
            )));
  }
}
