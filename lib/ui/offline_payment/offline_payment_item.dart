import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/viewobject/offline_payment.dart';

class OfflinePaymenItem extends StatelessWidget {
  const OfflinePaymenItem({
    Key? key,
    required this.offlinePayment,
    this.animationController,
    this.animation,
    this.onTap,
  }) : super(key: key);

  final OfflinePayment offlinePayment;
  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();
    return AnimatedBuilder(
        animation: animationController!,
        child: InkWell(
          onTap: onTap  as void Function()?,
          child: Container(
              color: PsColors.backgroundColor,
              margin: const EdgeInsets.only(top: PsDimens.space8),
              child: Ink(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        PsNetworkImageWithUrl(
                          photoKey: '',
                          imagePath: offlinePayment.defaultIcon!.imgPath!,
                          imageAspectRation: PsConst.Aspect_Ratio_1x,
                          width: PsDimens.space64,
                          height: PsDimens.space64,
                          onTap: onTap,
                        ),
                        const SizedBox(
                          width: PsDimens.space12,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(offlinePayment.title!,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.bodyText2),
                              const SizedBox(
                                height: PsDimens.space8,
                              ),
                              Text(
                                offlinePayment.description!,
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ))),
        ),
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
