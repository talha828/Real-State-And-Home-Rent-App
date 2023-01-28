import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/chat_history.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/user_intent_holder.dart';
import 'package:provider/provider.dart';

class ChatSellerListItem extends StatelessWidget {
  const ChatSellerListItem({
    Key? key,
    required this.chatHistory,
    this.animationController,
    this.animation,
    this.onTap,
  }) : super(key: key);

  final ChatHistory chatHistory;
  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double> ?animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController!,
        child:InkWell(
                onTap: onTap as void Function()?,
                child: Container(
                  margin: const EdgeInsets.only(bottom: PsDimens.space8),
                  child: Ink(
                    color: PsColors.backgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(PsDimens.space16),
                      child: _ImageAndTextWidget(
                        chatHistory: chatHistory,
                      ),
                    ),
                  ),
                ),
              ),
            
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
    required this.chatHistory,
  }) : super(key: key);

  final ChatHistory chatHistory;

  @override
  Widget build(BuildContext context) {
     final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context);
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space8,
    );

    if ( chatHistory.item != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: PsDimens.space40,
            height: PsDimens.space40,
            child: PsNetworkCircleImageForUser(
              photoKey: '',
              imagePath: chatHistory.item!.user!.userProfilePhoto!,
              // width: PsDimens.space40,
              // height: PsDimens.space40,
              boxfit: BoxFit.cover,
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.userDetail,
                    arguments: UserIntentHolder(
                        userId: chatHistory.seller!.userId!,
                        userName: chatHistory.seller!.userName!));
              },
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
                      chatHistory.seller!.userName! == ''
                          ? Utils.getString(context, 'default__user_name')
                          : chatHistory.seller!.userName!,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(color: Colors.grey),
                    ),
                        if (chatHistory.seller!.applicationStatus == PsConst.ONE &&
                            chatHistory.seller!.applyTo == PsConst.ONE &&
                            chatHistory.seller!.userType == PsConst.ONE)
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
                    // if (chatHistory.buyerUnreadCount != null &&
                    //     chatHistory.buyerUnreadCount != '' &&
                    //     chatHistory.buyerUnreadCount == '0')
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
                    //       chatHistory.buyerUnreadCount!,
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
                        visible: !(chatHistory.buyerUnreadCount != null &&
                        chatHistory.buyerUnreadCount != '' &&
                        chatHistory.buyerUnreadCount == '0'),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: PsDimens.space1, right: PsDimens.space1),
                            width: 20,
                            height: 20,
                          decoration: BoxDecoration(
                            color: PsColors.mainColor,
                            borderRadius: BorderRadius.circular(PsDimens.space28),
                            // border: Border.all(
                            //     color: Utils.isLightMode(context)
                            //         ? Colors.grey[200]!
                            //         : Colors.black87),
                          ),
                          child: Center(
                            child: Text(
                              chatHistory.buyerUnreadCount!,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(color: PsColors.textPrimaryLightColor, fontSize: 10),
                            ),
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
                        chatHistory.item!.title!,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    if (chatHistory.item!.isSoldOut == '1')
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
                          Utils.getString(
                              context, 'chat_history_list_item__sold'),
                          // 'Sold',
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
                      chatHistory.item != null &&
                              chatHistory.item!.price != '0' &&
                              chatHistory.item!.price != ''
                          ? '${chatHistory.item!.itemCurrency!.currencySymbol}  ${Utils.getPriceFormat(chatHistory.item!.price!,valueHolder.priceFormat!)}'
                          : Utils.getString(context, 'item_price_free'),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: PsColors.mainColor),
                    ),
                    const SizedBox(
                      width: PsDimens.space8,
                    ),
                    // Text(
                    //   '( ${chatHistory.item.conditionOfItem.name} )',
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
                  chatHistory.addedDateStr!,
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
                defaultPhoto: chatHistory.item!.defaultPhoto!,
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
