import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/product.dart';
import 'package:provider/provider.dart';

import 'item_entry_view.dart';

class ItemEntryContainerView extends StatefulWidget {
  const ItemEntryContainerView({
    required this.flag,
    required this.item,
  });
  final String flag;
  final Product item;
  @override
  ItemEntryContainerViewState createState() => ItemEntryContainerViewState();
}

class ItemEntryContainerViewState extends State<ItemEntryContainerView>
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
     final PsValueHolder psValueHolder = Provider.of<PsValueHolder>(context);
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
        appBar: AppBar(
        systemOverlayStyle:  SystemUiOverlayStyle(
           statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
         ),
          backgroundColor: PsColors.backgroundColor,
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: PsColors.mainColorWithWhite),
          title: Text(
            Utils.getString(context, 'item_entry__listing_entry'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.bold,
                color: PsColors.mainColorWithWhite),
          ),
          elevation: 0,
        ),
        body: ItemEntryView(
          animationController: animationController!,
          flag: widget.flag,
          item: widget.item,
          maxImageCount: psValueHolder.maxImageCount,
        ),
      ),
    );
  }
}
