import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/viewobject/post_type.dart';

class PostTypeVerticalListItem extends StatelessWidget {
  const PostTypeVerticalListItem(
      {Key? key,
      required this.postType,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final PostType postType;

  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();
    return AnimatedBuilder(
        animation: animationController!,
        child: GestureDetector(
            onTap: onTap  as void Function()?,
            child: Card(
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
                              child: Image.asset(
                                'assets/images/user_default_photo.png',
                                width: double.infinity,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // PsNetworkImage(
                            //   photoKey: '',
                            //   defaultPhoto: postType.defaultPhoto,
                            //   width: PsDimens.space200,
                            //   height: double.infinity,
                            //   boxfit: BoxFit.cover,
                            // ),
                            Container(
                              width: 200,
                              height: double.infinity,
                              color: PsColors.black.withAlpha(110),
                            )
                          ],
                        )),
                    Text(
                      postType.name!,
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
                        // child: PsNetworkCircleIconImage(
                        //   photoKey: '',
                        //   defaultIcon: postType.defaultIcon,
                        //   // width: PsDimens.space40,
                        //   // height: PsDimens.space40,
                        //   boxfit: BoxFit.cover,
                        //   onTap: onTap,
                        // ),
                      ),
                    )),
                  ],
                )))),
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
