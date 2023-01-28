import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class PsWidgetWithAppBarWithTwoProvider<T extends ChangeNotifier,
    V extends ChangeNotifier> extends StatefulWidget {
  const PsWidgetWithAppBarWithTwoProvider(
      {Key? key,
      required this.initProvider1,
      required this.initProvider2,
      this.child,
      this.onProviderReady1,
      this.onProviderReady2,
      required this.appBarTitle,
      this.actions = const <Widget>[]})
      : super(key: key);

  final Function initProvider1, initProvider2;
  final Widget? child;
  final Function(T)? onProviderReady1;
  final Function(V)? onProviderReady2;
  final String appBarTitle;
  final List<Widget> actions;

  @override
  _PsWidgetWithAppBarWithTwoProviderState<T, V> createState() =>
      _PsWidgetWithAppBarWithTwoProviderState<T, V>();
}

class _PsWidgetWithAppBarWithTwoProviderState<T extends ChangeNotifier,
        V extends ChangeNotifier>
    extends State<PsWidgetWithAppBarWithTwoProvider<T, V>> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final dynamic data = EasyLocalizationProvider.of(context).data;
    // return EasyLocalizationProvider(
    //     data: data,
    //     child:
    return Scaffold(
        appBar: AppBar(
        systemOverlayStyle:  SystemUiOverlayStyle(
           statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
         ),
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: PsColors.mainColorWithWhite),
          title: Text(widget.appBarTitle,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: PsColors.mainColorWithWhite)),
          actions: widget.actions,
          flexibleSpace: Container(
            height: 200,
          ),
          elevation: 0,
        ),
        body: MultiProvider(providers: <SingleChildWidget>[
          ChangeNotifierProvider<T>(
            lazy: false,
            create: (BuildContext context) {
              final T providerObj1 = widget.initProvider1();

              if (widget.onProviderReady1 != null) {
                widget.onProviderReady1!(providerObj1);
              }

              return providerObj1;
            },
          ),
          ChangeNotifierProvider<V>(
            lazy: false,
            create: (BuildContext context) {
              final V providerObj2 = widget.initProvider2();
              if (widget.onProviderReady2 != null) {
                widget.onProviderReady2!(providerObj2);
              }

              return providerObj2;
            },
          )
        ], child: widget.child)
        // )
        );
  }
}
