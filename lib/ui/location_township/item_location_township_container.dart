import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/ui/location_township/item_location_township_view.dart';

class ItemLocationTownshipContainerView extends StatefulWidget {
  const ItemLocationTownshipContainerView({required this.cityId});

  final String cityId;
  @override
  ItemLocationTownshipContainerViewState createState() =>
      ItemLocationTownshipContainerViewState();
}

class ItemLocationTownshipContainerViewState
    extends State<ItemLocationTownshipContainerView>
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
        body: ItemLocationTownshipView(
          cityId: widget.cityId,
          animationController: animationController!,
        ),
      ),
    );
  }
}
