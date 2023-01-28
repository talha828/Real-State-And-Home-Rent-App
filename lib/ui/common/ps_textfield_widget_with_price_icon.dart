import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:fluttericon/font_awesome_icons.dart';

class PsTextFieldWidgetWithPriceIcon extends StatelessWidget {
  const PsTextFieldWidgetWithPriceIcon(
      {this.textEditingController,
      this.hintText,
      this.height = PsDimens.space35,
      this.keyboardType = TextInputType.text,
      this.psValueHolder,
      this.clickEnterFunction,
      this.clickSearchButton});

  final TextEditingController? textEditingController;
  final String? hintText;
  final double height;
  final TextInputType keyboardType;
  final PsValueHolder? psValueHolder;
  final Function? clickEnterFunction;
  final Function? clickSearchButton;

  @override
  Widget build(BuildContext context) {
    final Widget _productTextFieldWidget = TextField(
      keyboardType: TextInputType.text,
      maxLines: null,
      controller: textEditingController,
      style: Theme.of(context).textTheme.bodyText1,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          bottom: PsDimens.space12,
        ),
        border: InputBorder.none,
        icon: 
        Container(
            margin: Directionality.of(context) == TextDirection.ltr
              ? const EdgeInsets.only(
                  left: PsDimens.space12)
              : const EdgeInsets.only(
                  right: PsDimens.space12),
            child: InkWell(
              child: Icon(
                FontAwesome.dollar,
                color: PsColors.mainColor,
                size: 16,
              ),
            onTap: () {
              clickSearchButton!();
            }),
        ),
        hintText: hintText,
      ),
      onSubmitted: (String value) {
        clickEnterFunction!();
      },
    );

    return Column(
      children: <Widget>[
        Container(
          height: height,
          margin: const EdgeInsets.only(
            top: PsDimens.space6,
            left: PsDimens.space6,
            bottom: PsDimens.space6),
          decoration: BoxDecoration(
            color: Utils.isLightMode(context) ? Colors.white60 : Colors.black54,
            borderRadius: BorderRadius.circular(PsDimens.space18),
            border: Border.all(
                color: Utils.isLightMode(context)
                    ? PsColors.mainColor
                    : Colors.black87),
          ),
          child: _productTextFieldWidget,
        ),
      ],
    );
  }
}
