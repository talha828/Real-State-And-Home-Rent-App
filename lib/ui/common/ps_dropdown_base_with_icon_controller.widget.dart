import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/utils/utils.dart';

class PsDropdownBaseWithIconControllerWidget extends StatelessWidget {
  const PsDropdownBaseWithIconControllerWidget(
      {Key? key,
      required this.onTap,
      this.textEditingController,
      this.icon,
      this.hintText,
      })
      : super(key: key);

  final TextEditingController? textEditingController;
  final Function? onTap;
  final IconData? icon; 
  final String? hintText;
 
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: onTap as void Function()?,
          child: Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space6),
            height: PsDimens.space35,
            decoration: BoxDecoration(
            color: Utils.isLightMode(context) ? Colors.white60 : Colors.black54,
            borderRadius: BorderRadius.circular(PsDimens.space18),
            border: Border.all(
                color: Utils.isLightMode(context)
                    ? PsColors.mainColor
                    : Colors.black87),
            ),
            child: Ink(
                child: Container(
                  margin: const EdgeInsets.only(
                    left: PsDimens.space12,
                    right: PsDimens.space8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        icon,
                        color: PsColors.mainColor,
                        size: 16,
                      ),
                      InkWell(
                        child: Container(
                          width: PsDimens.space80,
                           margin: const EdgeInsets.only(
                              left: PsDimens.space8),
                        child: Ink(
                          child: Text(
                            textEditingController!.text == ''
                                ? hintText!
                                : textEditingController!.text,
                            overflow: TextOverflow.ellipsis,
                            style: textEditingController!.text == ''
                                ? Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: PsColors.textPrimaryLightColor)
                                : Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
