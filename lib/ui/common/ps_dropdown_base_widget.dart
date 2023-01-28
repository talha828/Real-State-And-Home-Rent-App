import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/utils/utils.dart';

class PsDropdownBaseWidget extends StatelessWidget {
  const PsDropdownBaseWidget(
      {Key? key, required this.title, required this.onTap, this.selectedText})
      : super(key: key);

  final String title;
  final String? selectedText;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space12,
              top: PsDimens.space4,
              right: PsDimens.space12),
          child: Row(
            children: <Widget>[
              Text(
                title,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ),
        InkWell(
          onTap: onTap as void Function()?,
          child: Container(
            width: double.infinity,
            height: PsDimens.space44,
            margin: const EdgeInsets.all(PsDimens.space12),
            decoration: BoxDecoration(
              color: PsColors.backgroundColor,
              borderRadius: BorderRadius.circular(PsDimens.space4),
              border: Border.all(color: PsColors.mainDividerColor),
            ),
            child: Ink(
              color: PsColors.backgroundColor,
              child: Container(
                margin: const EdgeInsets.all(PsDimens.space12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        child: Ink(
                          color: PsColors.backgroundColor,
                          child: Text(
                            selectedText! == ''
                                ? Utils.getString(
                                    context, 'home_search__not_set')
                                : selectedText!,
                            overflow: TextOverflow.ellipsis,
                            style: selectedText == ''
                                ? Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
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
