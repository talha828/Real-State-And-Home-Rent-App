import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/utils/utils.dart';

class PsHeaderWidget extends StatelessWidget {
  const PsHeaderWidget({
    Key? key,
    required this.headerName,
    required this.viewAllClicked,
    this.showViewAll = true,
  }) : super(key: key);

  final String headerName;
  final Function viewAllClicked;
  final bool showViewAll;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: viewAllClicked as void Function()?,
      child: Padding(
        padding: const EdgeInsets.only(
            top: PsDimens.space20,
            left: PsDimens.space16,
            right: PsDimens.space16,
            bottom: PsDimens.space16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(headerName,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.subtitle1),
            Visibility(
              visible: showViewAll,
              child: InkWell(
                child: Text(
                  Utils.getString(context, 'profile__view_all'),
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: PsColors.mainColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}