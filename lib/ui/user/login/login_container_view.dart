import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/user/user_provider.dart';
import 'package:flutteradhouse/repository/user_repository.dart';
import 'package:flutteradhouse/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';

import 'login_view.dart';

class LoginContainerView extends StatefulWidget {
      const LoginContainerView({
    this.fromAppStart
  });
   final bool? fromAppStart;
  @override
  _CityLoginContainerViewState createState() => _CityLoginContainerViewState();
}

class _CityLoginContainerViewState extends State<LoginContainerView>
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

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  UserProvider? userProvider;
  UserRepository? userRepo;

  @override
  Widget build(BuildContext context) {
     final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context);
    Future<bool> _requestPop() {

     if (valueHolder.isForceLogin! && widget.fromAppStart != true) {
       return showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ConfirmDialogView(
                  description:
                      Utils.getString(context, 'home__quit_dialog_description'),
                  leftButtonText: Utils.getString(context, 'dialog__cancel'),
                  rightButtonText: Utils.getString(context, 'dialog__ok'),
                  onAgreeTap: () {
                    SystemNavigator.pop();
                  });
            }).then((dynamic value) => value as bool);
      }else{
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
    }

    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController!,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    print(
        '............................Build UI Again ............................');
    userRepo = Provider.of<UserRepository>(context);
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              color: PsColors.mainLightColorWithBlack,
              width: double.infinity,
              height: double.maxFinite,
            ),
            CustomScrollView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                slivers: <Widget>[
                  _SliverAppbar(
                    title: Utils.getString(context, 'login__title'),
                    scaffoldKey: scaffoldKey,
                  ),
                  LoginView(
                    animationController: animationController!,
                    animation: animation,
                  ),
                ])
          ],
        ),
      ),
    );
  }
}

class _SliverAppbar extends StatefulWidget {
  const _SliverAppbar(
      {Key? key, required this.title, this.scaffoldKey, })
      : super(key: key);
  final String title;
  final GlobalKey<ScaffoldState>? scaffoldKey;
//  final Drawer? menuDrawer;
  @override
  _SliverAppbarState createState() => _SliverAppbarState();
}

class _SliverAppbarState extends State<_SliverAppbar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
                      systemOverlayStyle:  SystemUiOverlayStyle(
           statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
         ),
      iconTheme: Theme.of(context)
          .iconTheme
          .copyWith(color: PsColors.mainColorWithWhite),
      title: Text(
        widget.title,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(fontWeight: FontWeight.bold)
            .copyWith(color: PsColors.mainColorWithWhite),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.notifications_none,
              color: Theme.of(context).iconTheme.color),
          onPressed: () {
            Navigator.pushNamed(
              context,
              RoutePaths.notiList,
            );
          },
        ),
        IconButton(
          icon:
              Icon(FontAwesome5.book_open, color: Theme.of(context).iconTheme.color),
          onPressed: () {
            Navigator.pushNamed(
              context,
              RoutePaths.blogList,
            );
          },
        )
      ],
      //backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}
