import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/viewobject/post_type.dart';

class PostTypeHorizontalListItem extends StatelessWidget {
  const PostTypeHorizontalListItem({
    Key? key,
    required this.postType,
    this.onTap,
  }) : super(key: key);

  final PostType postType;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap  as void Function()?,
        child: Container(
            child: Padding(
                padding: const EdgeInsets.only(right: PsDimens.space8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    MaterialButton(
                        color: PsColors.white,
                        height: PsDimens.space35,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: PsColors.mainColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(18.0))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: PsColors.mainColor,
                                size: 20,
                              ),
                              Text(
                                postType.name!,
                                style: Theme.of(context)
                                    .textTheme
                                    .button!
                                    .copyWith(color: PsColors.mainColor),
                              ),
                            ]),
                        onPressed: onTap  as void Function()?),
                  ],
                )
            )
        )
    );
  }
}
