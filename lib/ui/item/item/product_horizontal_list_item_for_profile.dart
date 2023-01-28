import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/ui/common/ps_hero.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/product.dart';
import 'package:provider/provider.dart';

class ProductHorizontalListItemForProfile extends StatelessWidget {
  const ProductHorizontalListItemForProfile({
    Key? key,
    required this.product,
    required this.coreTagKey,
    required this.psValueHolder,
    this.onTap,
  }) : super(key: key);

  final Product product;
  final Function? onTap;
  final String coreTagKey;
  final PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    // print('***Tag*** $coreTagKey${PsConst.HERO_TAG__IMAGE}');
 final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context);
    return InkWell(
      onTap: onTap as void Function()?,
      child: Card(
        elevation: 0.0,
        color: PsColors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: PsDimens.space4, vertical: PsDimens.space12),
          decoration: BoxDecoration(
            color: PsColors.backgroundColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(PsDimens.space8)),
          ),
          width: PsDimens.space180,
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  if(psValueHolder.isShowOwnerInfo!)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: PsDimens.space4,
                      top: PsDimens.space4,
                      right: PsDimens.space12,
                      bottom: PsDimens.space4,
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: PsDimens.space40,
                          height: PsDimens.space40,
                          child: PsNetworkCircleImageForUser(
                            photoKey: '',
                            imagePath: product.user!.userProfilePhoto,
                            // width: PsDimens.space40,
                            // height: PsDimens.space40,
                            boxfit: BoxFit.cover,
                            onTap: () {
                              Utils.psPrint(product.defaultPhoto!.imgParentId!);
                              onTap!();
                            },
                          ),
                        ),
                        const SizedBox(width: PsDimens.space8),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: PsDimens.space8, top: PsDimens.space8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                                      product.user!.userName == ''
                                          ? Utils.getString(
                                              context, 'default__user_name')
                                          : '${product.user!.userName}',
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.bodyText1),
                        ),
                        if (product.user!.applicationStatus == PsConst.ONE &&
                            product.user!.applyTo == PsConst.ONE &&
                            product.user!.userType == PsConst.ONE)
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
                                
                                Text('${product.addedDateStr}',
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context).textTheme.caption)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                  else
                   Container(),
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Container(
                            width: PsDimens.space180,
                            height: PsDimens.space160,
                          child: PsNetworkImage(
                            photoKey: '$coreTagKey${PsConst.HERO_TAG__IMAGE}',
                            defaultPhoto: product.defaultPhoto!,
                             imageAspectRation: PsConst.Aspect_Ratio_2x,

                            boxfit: BoxFit.cover,
                            onTap: () {
                              Utils.psPrint(product.defaultPhoto!.imgParentId!);
                              onTap!();
                          },
                      ),
                        ),
                      if(Utils.showUI(psValueHolder.postedId) &&  product.postType!.name != null &&
                        product.postType!.name != '' &&
                        product.postType!.colors!.colorCode != null &&
                        product.postType!.colors!.colorCode != '')
                        Positioned(
                          child: Container(
                            alignment: Alignment.topRight,
                            margin:
                                const EdgeInsets.only(right: PsDimens.space12),
                            child: MaterialButton(
                                color:  Utils.hexToColor( product.postType!.colors!.colorCode!),
                                height: PsDimens.space26,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Utils.hexToColor( product.postType!.colors!.colorCode!)),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Text(
                                  product.postType!.name!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .copyWith(color: PsColors.white),
                                ),
                                onPressed: () {}),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            child: product.isSoldOut == '1'
                                ? Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: PsDimens.space12),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            Utils.getString(
                                                context, 'dashboard__sold_out'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                    color: PsColors.white)),
                                      ),
                                    ),
                                    height: 30,
                                    width: PsDimens.space180,
                                    decoration: BoxDecoration(
                                        color: PsColors.soldOutUIColor),
                                  )
                                : Container()),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space8,
                        top: PsDimens.space12,
                        right: PsDimens.space8,
                        bottom: PsDimens.space4),
                    child: PsHero(
                      tag: '$coreTagKey$PsConst.HERO_TAG__TITLE',
                      child: Text(
                        product.title!,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText2,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       left: PsDimens.space8,
                  //       top: PsDimens.space4,
                  //       right: PsDimens.space8),
                  //   child: Row(
                  //     children: <Widget>[
                  //       PsHero(
                  //         tag: '$coreTagKey$PsConst.HERO_TAG__UNIT_PRICE',
                  //         flightShuttleBuilder: Utils.flightShuttleBuilder,
                  //         child: Material(
                  //           type: MaterialType.transparency,
                  //           child: Text(
                            
                  //                       product.price != '0' &&
                  //                       product.price != ''
                  //                   ? '${product.itemCurrency!.currencySymbol}${Utils.getPriceFormat(product.price!)}'
                  //                   : Utils.getString(
                  //                       context, 'item_price_free'),
                  //               textAlign: TextAlign.start,
                  //               style: Theme.of(context)
                  //                   .textTheme
                  //                   .subtitle2!
                  //                   .copyWith(color: PsColors.mainColor)),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                                     Padding(
                       padding: const EdgeInsets.only(
                        left: PsDimens.space8,
                        top: PsDimens.space4,
                        right: PsDimens.space8),
                     child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                PsHero(
                                  tag: '$coreTagKey$PsConst.HERO_TAG__UNIT_PRICE',
                                  flightShuttleBuilder: Utils.flightShuttleBuilder,
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: Text(
                                      product.discountRate == '0' || product.discountRate == '' ?
                                            product.price != '0' && product.price != ''
                                            ? '${product.itemCurrency!.currencySymbol}${Utils.getPriceFormat(product.price!,psValueHolder.priceFormat!)}'
                                            : Utils.getString(context, 'item_price_free') :
                                      '${product.itemCurrency!.currencySymbol}${Utils.getPriceFormat(product.discountedPrice!,psValueHolder.priceFormat!)}',
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                            color: PsColors.mainColor,
                                            fontSize: 16
                                          ),)
                                  ),
                                ),
                                Visibility(
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  visible: product.discountRate != '0',
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                            '  ${product.itemCurrency!.currencySymbol}${Utils.getPriceFormat(product.price!,psValueHolder.priceFormat!)}  ',                                      
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                  color: Utils.isLightMode(context)? PsColors.textPrimaryLightColor: PsColors.textPrimaryColor, 
                                                  decoration: TextDecoration.lineThrough,
                                                  fontSize: 10),
                                      ),
                                      const SizedBox(
                                        width: PsDimens.space6
                                      ),
                                      Text(
                                            '-${product.discountRate}%',                                      
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                  color: Utils.isLightMode(context)? PsColors.textPrimaryLightColor: PsColors.textPrimaryColor,
                                                  fontSize: 10),
                                      ),
                                    ],
                                  )
                                )
                              ], 
                            ),
                          ],
                        ),
                   ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space8,
                        top: PsDimens.space12,
                        right: PsDimens.space8,
                        bottom: PsDimens.space4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/baseline_pin_black_24.png',
                              width: PsDimens.space10,
                              height: PsDimens.space10,
                              fit: BoxFit.contain,

                              // ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: PsDimens.space8,
                                    right: PsDimens.space8),
                                child: Text(
                                  psValueHolder.isSubLocation == PsConst.ONE && product.itemLocationTownship!.townshipName != ''
                                      ? '${product.itemLocationTownship!.townshipName}'
                                      : '${product.itemLocationCity!.name}',
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context).textTheme.caption))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/baseline_favourite_grey_24.png',
                              width: PsDimens.space10,
                              height: PsDimens.space10,
                              fit: BoxFit.contain,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: PsDimens.space4,
                              ),
                              child: Text('${product.favouriteCount}',
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.caption),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          // ),
          // clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
        ),
      ),
    );
  }
}
