import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/viewobject/user.dart';

class AgentVerticalListItem extends StatelessWidget {
  const AgentVerticalListItem(
      {Key? key,
      required this.user,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final User user;

  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();
    return AnimatedBuilder(
        animation: animationController!,
        child: GestureDetector(
            onTap: onTap as void Function()?,
            child: Card(
              elevation: 0.5,
              margin: const EdgeInsets.symmetric(
                  horizontal: PsDimens.space8, vertical: PsDimens.space8),
              child: Container(
                width: PsDimens.space150,
                child: Ink(
                  color: PsColors.backgroundColor,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: PsNetworkImageForUser(
                            width: PsDimens.space100,
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
