import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/product/search_product_provider.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/product_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/post_type.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:provider/provider.dart';

class ProductFilterWidget extends StatefulWidget {
  const ProductFilterWidget(
      {this.searchProductProvider, this.changeAppBarTitle});
  final SearchProductProvider? searchProductProvider;
  final Function? changeAppBarTitle;

  @override
  State<ProductFilterWidget> createState() => _ProductFilterWidgetState();
}

class _ProductFilterWidgetState extends State<ProductFilterWidget> {
  bool isClickBaseLineList = false;
  bool isClickBaseLineTune = false;
  late PsValueHolder valueHolder;
  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context);
    return Container(
      color: PsColors.baseColor,
      child: Ink(
        child: Padding(
          padding: const EdgeInsets.only(
            left: PsDimens.space24,
            top: PsDimens.space12,
            bottom: PsDimens.space12,
            right: PsDimens.space24,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final dynamic itemTypeResult =
                      await Navigator.pushNamed(context, RoutePaths.searchPostType);

                  if (itemTypeResult != null && itemTypeResult is PostType) {
                    widget.searchProductProvider!.productParameterHolder
                        .postedById = itemTypeResult.id;
                    final String? loginUserId =
                        Utils.checkUserLoginId(valueHolder);
                    widget.searchProductProvider!.resetLatestProductList(
                        loginUserId!,
                        widget.searchProductProvider!.productParameterHolder);

                    widget.searchProductProvider?.postedById =
                        itemTypeResult.id!;
                    widget.searchProductProvider?.selectedPostedName =
                        itemTypeResult.name!;
                  } else if (itemTypeResult) {
                    widget.searchProductProvider!.productParameterHolder
                        .postedById = '';
                    final String? loginUserId =
                        Utils.checkUserLoginId(valueHolder);
                    widget.searchProductProvider!.resetLatestProductList(
                        loginUserId!,
                        widget.searchProductProvider!.productParameterHolder);
                    widget.searchProductProvider?.selectedPostedName =
                        Utils.getString(context, 'product_list__category_all');
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        widget.searchProductProvider!.selectedPostedName == ''
                            ? Utils.getString(context, 'home_search__not_set')
                            : widget
                                .searchProductProvider!.selectedPostedName,
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontSize: 16,
                            color: widget.searchProductProvider!
                                        .selectedPostedName ==
                                    ''
                                ? Utils.isLightMode(context)
                                    ? PsColors.textPrimaryColor
                                    : PsColors.textPrimaryColorForLight
                                : PsColors.mainColor)),
                    const SizedBox(
                      width: PsDimens.space10,
                    ),
                    Icon(
                      FontAwesome.down_open,
                      color: PsColors.textPrimaryColor,
                      size: PsDimens.space12,
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      final Map<String, String?> dataHolder =
                          <String, String?>{};
                      dataHolder[PsConst.PROPERTY_BY_ID] = widget
                          .searchProductProvider!.productParameterHolder.propertyById;
                      dataHolder[PsConst.POSTED_BY_ID] = widget
                          .searchProductProvider!
                          .productParameterHolder
                          .postedById;
                      final dynamic result = await Navigator.pushNamed(
                          context, RoutePaths.filterExpantion,
                          arguments: dataHolder);

                      if (result != null && result is Map<String, String?>) {
                        widget.searchProductProvider!.productParameterHolder
                            .propertyById = result[PsConst.PROPERTY_BY_ID];

                        widget.searchProductProvider!.productParameterHolder
                            .postedById = result[PsConst.POSTED_BY_ID];
                        final String? loginUserId =
                            Utils.checkUserLoginId(valueHolder);
                        widget.searchProductProvider!.resetLatestProductList(
                            loginUserId!,
                            widget
                                .searchProductProvider!.productParameterHolder);

                        if (result[PsConst.PROPERTY_BY_ID] == '' &&
                            result[PsConst.POSTED_BY_ID] == '') {
                          isClickBaseLineList = false;
                        } else {
                          widget.changeAppBarTitle!(
                              result[PsConst.PROPERTY_BY_NAME]);
                          isClickBaseLineList = true;
                        }
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesome.tags,
                          color: PsColors.iconColor,
                          size: PsDimens.space12,
                        ),
                        const SizedBox(
                          width: PsDimens.space4,
                        ),
                        Text(Utils.getString(context, 'Property'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    fontSize: 16,
                                    color: widget.searchProductProvider!
                                                .productParameterHolder.propertyById ==
                                            ''
                                        ? Utils.isLightMode(context)
                                            ? PsColors.textPrimaryColor
                                            : PsColors.textPrimaryColorForLight
                                        : PsColors.mainColor)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: PsDimens.space10,
                  ),
                  InkWell(
                    onTap: () async {
                      final dynamic result = await Navigator.pushNamed(
                          context, RoutePaths.itemSearch,
                          arguments: widget
                              .searchProductProvider!.productParameterHolder);
                      if (result != null && result is ProductParameterHolder) {
                        widget.searchProductProvider!.needReset = false; //not to reset while building app bar
                        widget.searchProductProvider!.productParameterHolder =
                            result;
                        final String? loginUserId =
                            Utils.checkUserLoginId(valueHolder);
                        widget.searchProductProvider!.resetLatestProductList(
                            loginUserId!,
                            widget
                                .searchProductProvider!.productParameterHolder);

                        if (widget.searchProductProvider!.productParameterHolder
                            .isFiltered()) {
                          isClickBaseLineTune = true;
                        } else {
                          isClickBaseLineTune = false;
                        }
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesome.filter,
                          color: PsColors.iconColor,
                          size: PsDimens.space12,
                        ),
                        const SizedBox(
                          width: PsDimens.space4,
                        ),
                        Text(
                          Utils.getString(context, 'search__filter'),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                  fontSize: 16,
                                  color: widget
                                                  .searchProductProvider!
                                                  .productParameterHolder
                                                  .searchTerm ==
                                              '' &&
                                          //      widget.searchProductProvider!.productParameterHolder.catId == '' &&
                                          //      widget.searchProductProvider!.productParameterHolder.subCatId == '' &&
                                          widget
                                                  .searchProductProvider!
                                                  .productParameterHolder
                                                  .maxPrice ==
                                              '' &&
                                          widget
                                                  .searchProductProvider!
                                                  .productParameterHolder
                                                  .minPrice ==
                                              '' &&
                                          widget
                                                  .searchProductProvider!
                                                  .productParameterHolder
                                                  .postedById ==
                                              '' &&
                                                
                                          widget
                                                  .searchProductProvider!
                                                  .productParameterHolder
                                                  .propertyById ==
                                                   '' &&
                                          widget
                                                  .searchProductProvider!
                                                  .productParameterHolder
                                                  .isSoldOut ==
                                              '' &&
                                          widget
                                                  .searchProductProvider!
                                                  .productParameterHolder
                                                  .itemPriceTypeId ==
                                              '' &&
                                          // widget
                                          //         .searchProductProvider!
                                          //         .productParameterHolder
                                          //         .conditionOfItemId ==
                                          //     '' &&
                                          widget 
                                                  .searchProductProvider!
                                                  .productParameterHolder
                                                  .itemLocationCityId == 
                                              '' &&
                                          widget 
                                                  .searchProductProvider!
                                                  .productParameterHolder
                                                  .itemLocationTownshipId == 
                                              ''          
                                      ? Utils.isLightMode(context)
                                          ? PsColors.textPrimaryColor
                                          : PsColors.textPrimaryColorForLight
                                      : PsColors.mainColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: PsDimens.space10,
                  ),
                  InkWell(
                    onTap: () async {
                      if (valueHolder.isSubLocation == PsConst.ONE) {
                        if (widget.searchProductProvider!.productParameterHolder
                                    .lat ==
                                '' &&
                            widget.searchProductProvider!.productParameterHolder
                                    .lng ==
                                '') {
                          widget.searchProductProvider!.productParameterHolder
                                  .lat =
                              widget.searchProductProvider!.psValueHolder!
                                  .locationTownshipLat;
                          widget.searchProductProvider!.productParameterHolder
                                  .lng =
                              widget.searchProductProvider!.psValueHolder!
                                  .locationTownshipLng;
                        }
                      } else {
                        if (widget.searchProductProvider!.productParameterHolder
                                    .lat ==
                                '' &&
                            widget.searchProductProvider!.productParameterHolder
                                    .lng ==
                                '') {
                          widget.searchProductProvider!.productParameterHolder
                                  .lat =
                              widget.searchProductProvider!.psValueHolder!
                                  .locationLat;
                          widget.searchProductProvider!.productParameterHolder
                                  .lng =
                              widget.searchProductProvider!.psValueHolder!
                                  .locationLng;
                        }
                      }
                      if (valueHolder.isUseGoogleMap!) {
                        final dynamic result = await Navigator.pushNamed(
                            context, RoutePaths.googleMapFilter,
                            arguments: widget
                                .searchProductProvider!.productParameterHolder);
                        if (result != null &&
                            result is ProductParameterHolder) {
                          widget.searchProductProvider!.productParameterHolder =
                              result;
                          if (widget.searchProductProvider!
                                      .productParameterHolder.mile !=
                                  null &&
                              widget.searchProductProvider!
                                      .productParameterHolder.mile !=
                                  '' &&
                              double.parse(widget.searchProductProvider!
                                      .productParameterHolder.mile!) <
                                  1) {
                            widget.searchProductProvider!.productParameterHolder
                                .mile = '1';
                          }
                          final String? loginUserId =
                              Utils.checkUserLoginId(valueHolder);
                          //for 0.5 km, it is less than 1 miles and error
                          widget.searchProductProvider!.resetLatestProductList(
                              loginUserId!,
                              widget.searchProductProvider!
                                  .productParameterHolder);
                        }
                      } else {
                        final dynamic result = await Navigator.pushNamed(
                            context, RoutePaths.mapFilter,
                            arguments: widget
                                .searchProductProvider!.productParameterHolder);
                        if (result != null &&
                            result is ProductParameterHolder) {
                          widget.searchProductProvider!.productParameterHolder =
                              result;
                          if (widget.searchProductProvider!
                                      .productParameterHolder.mile !=
                                  null &&
                              widget.searchProductProvider!
                                      .productParameterHolder.mile !=
                                  '' &&
                              double.parse(widget.searchProductProvider!
                                      .productParameterHolder.mile!) <
                                  1) {
                            widget.searchProductProvider!.productParameterHolder
                                .mile = '1';
                          }
                          final String? loginUserId =
                              Utils.checkUserLoginId(valueHolder);
                          //for 0.5 km, it is less than 1 miles and error
                          widget.searchProductProvider!.resetLatestProductList(
                              loginUserId!,
                              widget.searchProductProvider!
                                  .productParameterHolder);
                        }
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.gps_fixed,
                          color: PsColors.iconColor,
                          size: PsDimens.space12,
                        ),
                        const SizedBox(
                          width: PsDimens.space4,
                        ),
                        Text(
                          Utils.getString(context, 'search__map'),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                  fontSize: 16,
                                  color: widget.searchProductProvider!
                                                  .productParameterHolder.lat ==
                                              '' &&
                                          widget.searchProductProvider!
                                                  .productParameterHolder.lng ==
                                              '' &&
                                          widget
                                                  .searchProductProvider!
                                                  .productParameterHolder
                                                  .maxPrice ==
                                              ''
                                      ? Utils.isLightMode(context)
                                          ? PsColors.textPrimaryColor
                                          : PsColors.textPrimaryColorForLight
                                      : PsColors.mainColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}