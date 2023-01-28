import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/package_bought/package_bought_provider.dart';
import 'package:flutteradhouse/ui/common/dialog/error_dialog.dart';
import 'package:flutteradhouse/ui/common/dialog/success_dialog.dart';
import 'package:flutteradhouse/ui/common/ps_header_widget.dart';
import 'package:flutteradhouse/ui/package/package_item.dart';
import 'package:flutteradhouse/utils/ps_progress_dialog.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/api_status.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/package_bought_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/package.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:provider/provider.dart';

class PackageRecommendedWidget extends StatefulWidget {
  const PackageRecommendedWidget(
      {required this.androidKeyList,
      required this.iosKeyList,
      required this.callToRefresh});
  final Function callToRefresh;
  final String? androidKeyList;
  final String? iosKeyList;

  @override
  PackageRecommendedWidgetState createState() =>
      PackageRecommendedWidgetState();
}

class PackageRecommendedWidgetState extends State<PackageRecommendedWidget> {
  /// Is the API available on the device
  bool available = true;

  /// The In App Purchase plugin
  final InAppPurchase _iap = InAppPurchase.instance;

  /// Products for sale
  List<ProductDetails> _products = <ProductDetails>[];

  /// Updates to purchases
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  final String _kConsumableId = 'consumable';
  final bool _kAutoConsume = true;
  String? amount;

  PsValueHolder? psValueHolder;
  PackageBoughtProvider? packageBoughtProvider;
  final int recommendedPackageCount = 1;

  /// Initialize data
  Future<void> _initialize() async {
    // Check availability of In App Purchases
    available = await _iap.isAvailable();

    if (available) {
      await _getProducts();

      // Listen to new purchases
      _subscription = _iap.purchaseStream.listen(
          (List<PurchaseDetails> purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      }, onDone: () {
        print('Done Purhcase');
        _subscription.cancel();
      }, onError: (dynamic error) {
        print(error);
        print('Error Purchase');
        PsProgressDialog.dismissDialog();
        // handle error here.
      });
    }
  }

  Set<String> idListByPlatfrom() {
    String keyListString = '';

    if (Platform.isAndroid && widget.androidKeyList != null) {
      keyListString = widget.androidKeyList!;
    } else if (Platform.isIOS && widget.iosKeyList != null) {
      keyListString = widget.iosKeyList!;
    }
    // ignore: prefer_final_locals
    List<String> keyList = keyListString.split('##');
    keyList.removeLast();
    return keyList.toSet();
  }

  /// Get all products available for sale
  Future<void> _getProducts() async {
    ProductDetailsResponse response;
    response = await _iap.queryProductDetails(idListByPlatfrom());

    setState(() {
      _products = response.productDetails;
    });
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (Platform.isAndroid) {
        if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
          final InAppPurchaseAndroidPlatformAddition androidAddition =
              _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
          await androidAddition.consumePurchase(purchaseDetails);
        }
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await PsProgressDialog.showDialog(context);
        await _iap.completePurchase(purchaseDetails);
      }

      if (purchaseDetails.status == PurchaseStatus.purchased) {
        //
        // Call PS Server
        //
        print('NEW PURCHASE');
        print(purchaseDetails.status);
        final Package package = getPackageByIAPKey(purchaseDetails.productID)!;
        final PackgageBoughtParameterHolder packgageBoughtParameterHolder =
            PackgageBoughtParameterHolder(
                userId: psValueHolder!.loginUserId,
                packageId: package.packageId,
                paymentMethod: PsConst.PAYMENT_IN_APP_PURCHASE_METHOD,
                price: amount,
                razorId: '',
                isPaystack: PsConst.ZERO);
        final PsResource<ApiStatus> packageBoughtStatus =
            await packageBoughtProvider!
                .buyAdPackge(packgageBoughtParameterHolder.toMap());
        PsProgressDialog.dismissDialog();
        if (packageBoughtStatus.status == PsStatus.SUCCESS) {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext contet) {
                return SuccessDialog(
                  message: Utils.getString(
                      context, 'item_entry__buy_package_success'),
                  onPressed: widget.callToRefresh,
                );
              });
        } else {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(
                  message: packageBoughtStatus.message,
                );
              });
        }
      }
      PsProgressDialog.dismissDialog();
    }
  }

  /// Purchase a product
  Future<void> _buyProduct(ProductDetails prod) async {
    final ProductDetails productDetails = prod;
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);

    if (Platform.isIOS) {
      // try {
      //    final transactions = await SKPaymentQueueWrapper().transactions();
      //   transactions.forEach((skPaymentTransactionWrapper) {
      //       SKPaymentQueueWrapper().finishTransaction(skPaymentTransactionWrapper);
      //   });
      //   final bool status = await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      //   print(status);
      // }catch(e) {
      //   print(status);
      // }
      // await _removeUnfinishTransaction();
    }

    try {
      // if (productDetails.id == _kConsumableId) {
      final bool status = await _iap.buyConsumable(
          purchaseParam: purchaseParam);
      print(status);
      // }
    } catch (e) {
      print(e.toString());
      PsProgressDialog.dismissDialog();
      if (Platform.isIOS) {
        // try {
        //   await _iap.buyNonConsumable(purchaseParam: purchaseParam);
        //   // await _removeUnfinishTransaction();
        //   try {
        //     final bool status =
        //         await _iap.buyConsumable(purchaseParam: purchaseParam);
        //     print(status);
        //   } catch (e) {
        //     print('error 2');
        //     print(e);
        //   }
        // }catch(e) {
        //   print('error 3');
        //   PsProgressDialog.dismissDialog();

        // }
      }
    }
  }

  Package? getPackageByIAPKey(String key) {
    final int index = packageBoughtProvider!.packageList.data!
        .indexWhere((Package package) => package.iapId == key);
    if (index == -1) 
      return null;    
    final Package package =
        packageBoughtProvider!.packageList.data!.elementAt(index);
    return package;
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
      child: Consumer<PackageBoughtProvider>(
        builder: (BuildContext context, PackageBoughtProvider provider,
            Widget? child) {
          if (provider.packageList.data != null ||
              provider.packageList.data!.isNotEmpty) {
            packageBoughtProvider = provider;
            return Container(
              height: 220,
              child: Column(
                children: <Widget>[
                  PsHeaderWidget(
                    headerName:
                        Utils.getString(context, 'package__recommended'),
                    viewAllClicked: () async {
                      _subscription.cancel();
                      await Navigator.pushNamed(context, RoutePaths.buyPackage,
                          arguments: <String, dynamic>{
                            'android': psValueHolder?.packageAndroidKeyList,
                            'ios': psValueHolder?.packageIOSKeyList
                          });
                      //  widget.callToRefresh();
                    },
                  ),
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Container(
                            child: CustomScrollView(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                slivers: <Widget>[
                              SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 220.0,
                                        childAspectRatio: 1.40),
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    final Package? package =
                                        getPackageByIAPKey(_products[index].id);
                                    if (package == null) 
                                      return const SizedBox();   
                                    return PackageItem(
                                      package: package,
                                      priceWithCurrency: _products[index].price,
                                      onTap: () {
                                        amount = _products[index].price;
                                        _buyProduct(_products[index]);
                                      },
                                    );
                                  },
                                  childCount: (_products.length <
                                          recommendedPackageCount)
                                      ? _products.length
                                      : recommendedPackageCount,
                                ),
                              ),
                            ])),
                        //  PSProgressIndicator(provider.packageList.status)
                      ],
                    ),
                  )
                ],
              ),
            );
          } else
            return const SizedBox();
        },
      ),
    );
  }
}
