import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/viewobject/user.dart';

class AgentHorizontalListItem extends StatelessWidget {
  const AgentHorizontalListItem({
    Key? key,
    required this.user,
    this.onTap,
  }) : super(key: key);

  final User user;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap as void Function()?,
        child: Card(
          elevation: 0.5,
          margin: const EdgeInsets.symmetric(
              horizontal: PsDimens.space8, vertical: PsDimens.space12),
          child: Container(
            width: PsDimens.space140,
            child: Ink(
              color: PsColors.backgroundColor,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: PsNetworkImageForUser(
                        width: PsDimens.space90,
                        photoKey: '',
                        imagePath: user.userProfilePhoto!,
                        boxfit: BoxFit.cover,
                        onTap: () {
                          onTap!();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: PsDimens.space8,
                    ),
                    Text(
                      user.userName!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
