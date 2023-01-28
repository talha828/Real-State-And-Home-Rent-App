import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/offer.dart';
import 'package:provider/provider.dart';

class OfferSentListItem extends StatelessWidget {
  const OfferSentListItem({
    Key? key,
    required this.offer,
    this.animationController,
    this.animation,
    this.onTap,
  }) : super(key: key);

  final Offer offer;
  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController!,
        child: InkWell(
                onTap: onTap  as void Function()?,
                child: Container(
                  margin: const EdgeInsets.only(bottom: PsDimens.space8),
                  child: Ink(
                    color: PsColors.backgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(PsDimens.space16),
                      child: _ImageAndTextWidget(
                        offer: offer,
                      ),
                    ),
                  ),
                ),
              )
            ,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
              opacity: animation!,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation!.value), 0.0),
                  child: child));
        });
  }
}

class _ImageAndTextWidget extends StatelessWidget {
  const _ImageAndTextWidget({
    Key? key,
    required this.offer,
  }) : super(key: key);

  final Offer offer;

  @override
  Widget build(BuildContext context) {
            final PsValueHolder valueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space8,
    );

    if ( offer.item != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: PsDimens.space40,
            height: PsDimens.space40,
            child: PsNetworkCircleImageForUser(
              photoKey: '',
              imagePath: offer.seller!.userProfilePhoto,
              // width: PsDimens.space40,
              // height: PsDimens.space40,
              boxfit: BoxFit.cover,
              onTap: () {},
            ),
          ),
          const SizedBox(
            width: PsDimens.space8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                      offer.seller!.userName == ''
                          ? Utils.getString(context, 'default__user_name')
                          : offer.seller!.userName!,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(color: Colors.grey),
                    ),
                        if (offer.seller!.applicationStatus == PsConst.ONE &&
                            offer.seller!.applyTo == PsConst.ONE &&
                            offer.seller!.userType == PsConst.ONE)
                          Container(
                            margin:
                                const EdgeInsets.only(left: PsDimens.space2),
                            child: Icon(
                              Icons.check_circle,
                              color: PsColors.bluemarkColor,
                              size: valueHolder.bluemarkSize,
                            ),
                          )
                      ],
                    ),
                    
                    // if (offer.sellerUnreadCount != null &&
                    //     offer.sellerUnreadCount != '' &&
                    //     offer.sellerUnreadCount == '0')
                    //   Container()
                    // else
                    //   Container(
                    //     padding: const EdgeInsets.all(PsDimens.space4),
                    //     decoration: BoxDecoration(
                    //       color: PsColors.mainColor,
                    //       borderRadius: BorderRadius.circular(PsDimens.space8),
                    //       border: Border.all(
                    //           color: Utils.isLightMode(context)
                    //               ? Colors.grey[200]!
                    //               : Colors.black87),
                    //     ),
                    //     child: Text(
                    //       offer.sellerUnreadCount!,
                    //       textAlign: TextAlign.center,
                    //       overflow: TextOverflow.ellipsis,
                    //       style: Theme.of(context)
                    //           .textTheme
                    //           .caption!
                    //           .copyWith(color: Colors.white),
                    //     ),
                    //   )
                     Visibility(
                        maintainSize: true, 
                        maintainAnimation: true,
                        maintainState: true,
                        visible: !(offer.buyerUnreadCount != null &&
                        offer.buyerUnreadCount != '' &&
                        offer.buyerUnreadCount == '0'),
                        child: Container(
                            width: 25,
                          padding: const EdgeInsets.all(PsDimens.space4),
                          decoration: BoxDecoration(
                            color: PsColors.mainColor,
                            borderRadius: BorderRadius.circular(PsDimens.space28),
                            border: Border.all(
                                color: Utils.isLightMode(context)
                                    ? Colors.grey[200]!
                                    : Colors.black87),
                          ),
                          child: Text(
                            offer.buyerUnreadCount!,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme.caption?.copyWith(color: PsColors.textPrimaryLightColor),
                          ),
                        ),
                      )
                  ],
                ),
                _spacingWidget,
                const Divider(
                  height: 2,
                ),
                _spacingWidget,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        offer.item!.title!,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    if (offer.item!.isSoldOut == '1')
                      Container(
                        padding: const EdgeInsets.all(PsDimens.space4),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(PsDimens.space8),
                          border: Border.all(
                              color: Utils.isLightMode(context)
                                  ? Colors.grey[200]!
                                  : Colors.black87),
                        ),
                        child: Text(
                          // Utils.getString(
                          //     context, 'chat_history_list_item__sold'),
                          'Sold',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: Colors.white),
                        ),
                      )
                    else
                      Container()
                  ],
                ),
                _spacingWidget,
                Row(
                  children: <Widget>[
                    Text(
                      offer.item != null &&
                              offer.item!.price != '0' &&
                              offer.item!.price != ''
                          ? '${offer.item!.itemCurrency!.currencySymbol}  ${Utils.getPriceFormat(offer.item!.price!,valueHolder.priceFormat!)}'
                          : Utils.getString(context, 'item_price_free'),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: PsColors.mainColor),
                    ),
                    // const SizedBox(
                    //   width: PsDimens.space8,
                    // ),
                    // Text(
                    //   '( ${offer.item.conditionOfItem.name} )',
                    //   overflow: TextOverflow.ellipsis,
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .bodyText2
                    //       .copyWith(color: Colors.blue),
                    // ),
                  ],
                ),
                _spacingWidget,
                Text(
                  offer.addedDateStr!,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: PsDimens.space8,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(PsDimens.space4),
            child: Container(
              height: PsDimens.space60,
              width: PsDimens.space60,
              child: PsNetworkImage(
                // height: PsDimens.space60,
                // width: PsDimens.space60,
                photoKey: '',
                defaultPhoto: offer.item!.defaultPhoto!,
                imageAspectRation: PsConst.Aspect_Ratio_1x,
                boxfit: BoxFit.cover,
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
