import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/ui/location_city/item_location_view.dart';

class ItemLocationContainerView extends StatefulWidget {
  @override
  ItemLocationContainerViewState createState() =>
      ItemLocationContainerViewState();
}

class ItemLocationContainerViewState extends State<ItemLocationContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController!.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    print(
        '............................Build UI Again ............................');
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        // appBar: AppBar(
        //   brightness: Utils.getBrightnessForAppBar(context),
        //   iconTheme: Theme.of(context).iconTheme.copyWith(color: PsColors.mainColorWithWhite),
        // title: Text(
        //   Utils.getString(context, 'history_list__title'),
        //   textAlign: TextAlign.center,
        //   style: Theme.of(context)
        //       .textTheme
        //       .headline6
        //       .copyWith(fontWeight: FontWeight.bold),
        // ),
        //   elevation: 0,
        // ),
        body: ItemLocationView(
          animationController: animationController!,
        ),
      ),
    );
  }
}
