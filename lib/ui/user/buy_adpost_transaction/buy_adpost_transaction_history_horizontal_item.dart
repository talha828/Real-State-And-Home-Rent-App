import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/buyadpost_transaction.dart';

class BuyAdTransactionHorizontalListItem extends StatelessWidget {
  const BuyAdTransactionHorizontalListItem({
    Key? key,
    required this.transaction,
    this.onTap,
  }) : super(key: key);

  final PackageTransaction transaction;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    // final PsValueHolder valueHolder =
    //     Provider.of<PsValueHolder>(context, listen: false);
    const Widget _dividerWidget = Divider(
      height: 3,
      thickness: 2,
    );
    return InkWell(
      onTap: onTap as void Function()?,
      // child: Card(
      //   elevation: 0.3,
      //   child: ClipPath(
      child: Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space10, bottom: PsDimens.space8),
        decoration: BoxDecoration(
          color: Utils.isLightMode(context) ? Colors.black12 : Colors.white12,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        padding: const EdgeInsets.only(
                      left: PsDimens.space10,
                      right: PsDimens.space10,
                      top: PsDimens.space10,),
        width: PsDimens.space200,
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 88,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                       Row(
                         mainAxisSize: MainAxisSize.max,
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: <Widget>[
                           Expanded(
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: <Widget>[
                                 Text(
                                     transaction.package!.title!,
                                     textAlign: TextAlign.start,
                                     style: Theme.of(context)
                                         .textTheme
                                         .bodyText2!
                                         .copyWith(
                                             color: PsColors.textPrimaryColor,
                                             fontWeight: FontWeight.bold,
                                             
                                             )),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   children:<Widget>[ 
                                     Text(transaction.price!,
                                         textAlign: TextAlign.start,
                                         style: Theme.of(context)
                                             .textTheme
                                             .bodyText2!
                                             .copyWith(color: PsColors.mainColor)),
                                 
                                  Text(transaction.package!.currency!.currencySymbol!,
                                     textAlign: TextAlign.start,
                                     style: Theme.of(context)
                                         .textTheme
                                         .bodyText2!
                                         .copyWith(color: PsColors.mainColor))
                                           ],
                                 ),
                               ],
                             ),
                           ),
                         ],
                       ),
                    _dividerWidget,
                          Row(
                          //  mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child:
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                        Utils.getString(
                                            context, 'profile__package_transaction_payment'),
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(
                                                color: PsColors.textPrimaryColor,
                                                )),
                                    Text(transaction.packageMethod!,
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(color: PsColors.textPrimaryColor)),
                                  
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                          Utils.getString(
                                              context, 'profile__package_transaction_date'),
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                  color: PsColors.textPrimaryColor,
                                                  )),
                                      Text(transaction.addedDate!,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis, 
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(color: PsColors.textPrimaryColor))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      //     clipper: ShapeBorderClipper(
      //         shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(4))),
      //   ),
      // )
    );
  }
}