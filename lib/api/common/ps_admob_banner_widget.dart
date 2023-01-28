import 'package:flutter/material.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class PsAdMobBannerWidget extends StatefulWidget {
  const PsAdMobBannerWidget({
    required this.admobSize});
    
  final AdSize admobSize;

  @override
  _PsAdMobBannerWidgetState createState() => _PsAdMobBannerWidgetState();
}

class _PsAdMobBannerWidgetState extends State<PsAdMobBannerWidget> {
  bool isShouldLoadAdMobBanner = true;
  bool isConnectedToInternet = false;
  int currentRetry = 0;
  int retryLimit = 1;
  bool showAds = false;
 
  //late StreamSubscription? _subscription;
  late BannerAd _bannerAd;
  double height = 0;
late PsValueHolder valueHolder;
  @override
  void initState() {
    _bannerAd = BannerAd(
      adUnitId:Utils.getBannerAdUnitId(),
      request: const AdRequest(),
      size: widget.admobSize,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            //if (widget.admobSize != null) {
              if (widget.admobSize == AdSize.banner) {
                height = 80;
              } else {
                height = 250;
              }
          //  }
          });
          print('loaded');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
        },
        onAdOpened: (Ad ad) {
          print('$BannerAd onAdOpened.');
        },
        onAdClosed: (Ad ad) {
          print('$BannerAd onAdClosed.');
        },
      ),
    );
    _bannerAd.load();
    super.initState();
  }

  @override
  void dispose() {
   // _subscription?.cancel();
    super.dispose();
  }

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && valueHolder.isShowAdmob!) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
     valueHolder =Provider.of<PsValueHolder>(context, listen: false);
    return Container(
      alignment: Alignment.center,
      child:showAds && valueHolder.isShowAdmob! ? AdWidget(ad: _bannerAd) : Container(),
      width:  showAds && valueHolder.isShowAdmob! ? _bannerAd.size.width.toDouble() : 0,
      height: showAds && valueHolder.isShowAdmob! ? height : 0,
    );
  }
}

