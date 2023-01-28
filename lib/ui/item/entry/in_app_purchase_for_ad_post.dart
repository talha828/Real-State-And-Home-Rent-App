import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/provider/package_bought/package_bought_provider.dart';
import 'package:flutteradhouse/repository/package_bought_repository.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:flutteradhouse/ui/common/dialog/error_dialog.dart';
import 'package:flutteradhouse/ui/common/dialog/success_dialog.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/utils/ps_progress_dialog.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/api_status.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/package_bought_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/package.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class PackageBoughtInAppPurchaseView extends StatefulWidget {
  const PackageBoughtInAppPurchaseView(this.userId);
  final String? userId;
  @override
  _PackageBoughtInAppPurchaseViewState createState() =>
      _PackageBoughtInAppPurchaseViewState();
}

class _PackageBoughtInAppPurchaseViewState
    extends State<PackageBoughtInAppPurchaseView> {
  /// Is the API available on the device
  // bool available = true;

  /// Updates to purchases
//  late StreamSubscription<List<PurchaseDetails>> _subscription;

  PackageBoughtRepository? repo1;
  PsValueHolder? psValueHolder;
  PackageBoughtProvider? packageBoughtProvider;
  String? amount;
  String status = '';

  String? prdIdforIOS;
  String? prdIdforAndroid;
  Map<String, String>? dayMap = <String, String>{};
  String? startDate;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    //  _initialize();
    super.initState();
  }

  @override
  void dispose() {
    //  _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<PackageBoughtRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
          ),
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: PsColors.mainColor
                  // color: Utils.isLightMode(context)
                  //     ? PsColors.primary500
                  //     : PsColors.primaryDarkWhite
                  ),
          title: Text(
            Utils.getString(
                context, 'item_entry__package_shop'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.bold,
                  //  color: Utils.isLightMode(context)? PsColors.primary500 : PsColors.primaryDarkWhite
                ),
          )),
      body: PsWidgetWithMultiProvider(
        child: MultiProvider(
            providers: <SingleChildWidget>[
              ChangeNotifierProvider<PackageBoughtProvider?>(
                lazy: false,
                create: (BuildContext context) {
                  packageBoughtProvider = PackageBoughtProvider(repo: repo1);
                  packageBoughtProvider!.getAllPackages();

                  return packageBoughtProvider;
                },
              ),
            ],
            child: Consumer<PackageBoughtProvider>(
              builder: (BuildContext context, PackageBoughtProvider provider,
                  Widget? child) {
                return Container(
                  padding: const EdgeInsets.only(top: PsDimens.space8),
                  color: PsColors.coreBackgroundColor,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            Container(
                                margin: const EdgeInsets.only(
                                  //  left: PsDimens.space8,
                                    right: PsDimens.space12,
                                    top: PsDimens.space8,
                                    bottom: PsDimens.space8),
                                child: RefreshIndicator(
                                  child: CustomScrollView(
                                      controller: _scrollController,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      slivers: <Widget>[
                                        SliverGrid(
                                                    gridDelegate:
                                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                                            maxCrossAxisExtent:
                                                                220.0,
                                                            childAspectRatio:
                                                                1.0),
                                          delegate: SliverChildBuilderDelegate(
                                            (BuildContext context, int index) {
                                              if (provider.packageList.data !=
                                                      null ||
                                                  provider.packageList.data!
                                                      .isNotEmpty) {
                                                // final int count =
                                                //     provider.packageList.data!.length;
                                                final Package package = provider
                                                    .packageList.data![index];
                                                return Container(
                                                  margin: const EdgeInsets.only(
                                                      left: PsDimens.space12,
                                                      bottom: PsDimens.space8
                                                      ),
                                                  padding: const EdgeInsets.only(
                                                      top: PsDimens.space8,
                                                      left: PsDimens.space8,
                                                      right: PsDimens.space8),    
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Utils.isLightMode(context)
                                                            ? Colors.white60
                                                            : Colors.black54,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            PsDimens.space4),
                                                    border: Border.all(
                                                        color: Utils.isLightMode(
                                                                context)
                                                            ? Colors.grey[200]!
                                                            : Colors.black87),
                                                  ),
                                                  child: Column(
                                                    // mainAxisSize:
                                                    //     MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        package.title!,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6,
                                                      ),
                                                      Text(
                                                        'Buy and create ${package.postCount} new posts.',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                                color: PsColors
                                                                    .mainColor,
                                                                fontSize: 12 ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 2.0),
                                                        child: Text(
                                                          '${package.price} ${package.currency!.currencyShortForm}',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .bodyText2!
                                                              .copyWith(
                                                                color: PsColors
                                                                    .mainColor,
                                                                fontSize: 18,
                                                              ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.bottomRight,
                                                        child: MaterialButton(
                                                          color: PsColors
                                                              .mainColor,
                                                          height: 30,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        PsDimens
                                                                            .space8)),
                                                          ),
                                                          child: Text(
                                                            Utils.getString(
                                                                context,
                                                                'item_promote__purchase_buy'),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .button!
                                                                .copyWith(
                                                                    color: PsColors
                                                                        .baseColor),
                                                          ),
                                                          onPressed: () async {
                                                            await PsProgressDialog
                                                                .showDialog(
                                                                    context);
                                                            final PackgageBoughtParameterHolder
                                                                packgageBoughtParameterHolder =
                                                                PackgageBoughtParameterHolder(
                                                                    userId: widget
                                                                        .userId,
                                                                    packageId:
                                                                        package
                                                                            .packageId,
                                                                    paymentMethod:
                                                                        PsConst
                                                                            .PAYMENT_IN_APP_PURCHASE_METHOD,
                                                                    price: package
                                                                        .price,
                                                                    razorId: '',
                                                                    isPaystack:
                                                                        PsConst
                                                                            .ZERO);
                                                            final PsResource<
                                                                    ApiStatus>
                                                                packageBoughtStatus =
                                                                await provider
                                                                    .buyAdPackge(
                                                                        packgageBoughtParameterHolder
                                                                            .toMap());
                                                            PsProgressDialog
                                                                .dismissDialog();
                                                            if (packageBoughtStatus
                                                                    .status ==
                                                                PsStatus
                                                                    .SUCCESS) {
                                                              showDialog<
                                                                      dynamic>(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          contet) {
                                                                    return SuccessDialog(
                                                                      message: Utils.getString(
                                                                          context,
                                                                          'item_entry__buy_package_success'),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context,
                                                                            package.postCount
                                                                            );
                                                                      },
                                                                    );
                                                                  });
                                                            } else {
                                                              showDialog<
                                                                      dynamic>(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return ErrorDialog(
                                                                      message:
                                                                          packageBoughtStatus
                                                                              .message,
                                                                    );
                                                                  });
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                return null;
                                              }
                                            },
                                            childCount:
                                                provider.packageList.data!.length,
                                          ),
                                        ),
                                      ]),
                                  onRefresh: () {
                                    return packageBoughtProvider!
                                        .getAllPackages();
                                  },
                                )),
                            PSProgressIndicator(provider.packageList.status)
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }
}
