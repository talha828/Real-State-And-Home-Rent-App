import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/user/user_provider.dart';
import 'package:flutteradhouse/repository/user_repository.dart';
import 'package:flutteradhouse/ui/common/ps_button_widget.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';

class IntroSliderView extends StatefulWidget {
  const IntroSliderView({required this.settingSlider});
  final int settingSlider;
  @override
  @override
  _IntroSliderViewState createState() => _IntroSliderViewState();
}

class _IntroSliderViewState extends State<IntroSliderView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  @override
  void initState() {
    _controller = TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  UserProvider? userProvider;
  UserRepository? userRepo;
  PsValueHolder? psValueHolder;
  TabController? _controller;

  @override
  Widget build(BuildContext context) {
    print(
        '............................Build UI Again ............................');
    userRepo = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    _controller!.animateTo(0);
    return ChangeNotifierProvider<UserProvider>(
        lazy: false,
        create: (BuildContext context) {
          userProvider =
              UserProvider(repo: userRepo, psValueHolder: psValueHolder);
          return userProvider!;
        },
        child: Consumer<UserProvider>(builder:
            (BuildContext context, UserProvider provider, Widget? child) {
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              body: TabBarView(controller: _controller, children: <Widget>[
                IntroSliderWidget(controller: _controller!),
                //IntroSliderWidget(),
                IntroSliderSecondWidget(controller: _controller!),
                IntroSliderDonotshowagainWidget(
                    provider: provider, settingSlider: widget.settingSlider)
              ]),
            ),
          );
        }));
  }
}

class IntroSliderWidget extends StatelessWidget {
  const IntroSliderWidget({this.controller});
  final TabController? controller;
  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    return Container(
      color: const Color(0xFF4153A2),
      child: Stack(children: <Widget>[
        Positioned.fill(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 120,
                height: 120,
                child: Image.asset(
                  'assets/images/seo.png',
                ),
              ),
              Text(
                Utils.getString(context, 'intro_slider1_title'),
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: PsColors.white,
                    ),
               textAlign: TextAlign.center,
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: PsDimens.space48,
                    top: PsDimens.space20,
                    right: PsDimens.space48),
                child: Text(
                  Utils.getString(context, 'intro_slider1_description'),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: PsColors.white,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: PsDimens.space12,
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              InkWell(
                  onTap: () {
                        if (psValueHolder.isForceLogin == true && Utils.checkUserLoginId(psValueHolder) == 'nologinuser') {
                            
                                  Navigator.pushReplacementNamed(
                                      context, RoutePaths.login_container,arguments: false);
                          
                       } else {
                          if(psValueHolder.isLanguageConfig= true && Utils.checkUserLoginId(psValueHolder) == 'nologinuser'){
                     Navigator.pushReplacementNamed(
                         context, RoutePaths.languagesetting);
                       }else{
                    if (psValueHolder.locationId != null) {
                      Navigator.pushReplacementNamed(
                        context,
                        RoutePaths.home,
                      );
                    } else {
                      Navigator.pushReplacementNamed(
                        context,
                        RoutePaths.itemLocationList,
                      );
                    }
                       }
                       }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: PsDimens.space12,
                    ),
                    child: Text(
                      Utils.getString(context, 'intro_slider_skip'),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: PsColors.white,
                          ),
                    ),
                  )),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: PsColors.mainColor)),
                  Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: PsColors.white)),
                  Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: PsColors.white))
                ],
              ),
              InkWell(
                  onTap: () {
                    controller!.animateTo(1);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: PsDimens.space12,
                    ),
                    child: Text(
                      Utils.getString(context, 'intro_slider_next'),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: PsColors.white,
                          ),
                    ),
                  ))
            ],
          ),
        ),
      ]),
    );
  }
}

class IntroSliderSecondWidget extends StatelessWidget {
  const IntroSliderSecondWidget({this.controller});
  final TabController? controller;
  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder =
        Provider.of<PsValueHolder>(context, listen: false);

    return Container(
      color: const Color(0xFFAF4D5D), //894DAF
      child:Stack(children: <Widget>[
        Positioned.fill(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 120,
                height: 120,
                child: Image.asset(
                  'assets/images/chat.png',
                ),
              ),
              Text(
                Utils.getString(context, 'intro_slider2_title'),
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: PsColors.white,
                    ),
               textAlign: TextAlign.center,
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: PsDimens.space48,
                    top: PsDimens.space20,
                    right: PsDimens.space48),
                child: Text(
                  Utils.getString(context, 'intro_slider2_description'),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: PsColors.white,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: PsDimens.space12,
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              InkWell(
                  onTap: () {
                        if (psValueHolder.isForceLogin == true && Utils.checkUserLoginId(psValueHolder) == 'nologinuser') {
                            
                                  Navigator.pushReplacementNamed(
                                      context, RoutePaths.login_container,arguments: false);
                          
                       } else {
                          if(psValueHolder.isLanguageConfig= true && Utils.checkUserLoginId(psValueHolder) == 'nologinuser'){
                     Navigator.pushReplacementNamed(
                         context, RoutePaths.languagesetting);
                       }else{
                    if (psValueHolder.locationId != null) {
                      Navigator.pushReplacementNamed(
                        context,
                        RoutePaths.home,
                      );
                    } else {
                      Navigator.pushReplacementNamed(
                        context,
                        RoutePaths.itemLocationList,
                      );
                    }
                       }
                       }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: PsDimens.space12,
                    ),
                    child: Text(
                      Utils.getString(context, 'intro_slider_skip'),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: PsColors.white,
                          ),
                    ),
                  )),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: PsColors.mainColor)),
                  Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: PsColors.white)),
                  Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: PsColors.white))
                ],
              ),
              InkWell(
                  onTap: () {
                    controller!.animateTo(2);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: PsDimens.space12,
                    ),
                    child: Text(
                      Utils.getString(context, 'intro_slider_next'),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: PsColors.white,
                          ),
                    ),
                  ))
            ],
          ),
        ),
      ]),
    );
    
  }
}

class IntroSliderDonotshowagainWidget extends StatefulWidget {
  const IntroSliderDonotshowagainWidget(
      {required this.provider, required this.settingSlider});

  final UserProvider provider;
  final int settingSlider;
  @override
  _IntroSliderDonotshowagainWidgetState createState() =>
      _IntroSliderDonotshowagainWidgetState();
}

Future<void> updateCheckBox(
    BuildContext context, UserProvider provider, bool isCheckBoxSelect) async {
  if (isCheckBoxSelect) {
    provider.isCheckBoxSelect = false;
  } else {
    provider.isCheckBoxSelect = true;
  }
}

class _IntroSliderDonotshowagainWidgetState
    extends State<IntroSliderDonotshowagainWidget> {
  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder =
        Provider.of<PsValueHolder>(context, listen: false);

    return Container(
      // color: PsColors.mainShadowColor,
      color: const Color(0xFF894DAF), //
      child: Stack(
          children: <Widget>[
            Positioned.fill(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 120,
                height: 120,
                child: Image.asset(
                  'assets/images/upload.png',
                ),
              ),
              Text(
                Utils.getString(context, 'intro_slider3_title'),
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: PsColors.white,
                    ),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: PsDimens.space48,
                    top: PsDimens.space20,
                    right: PsDimens.space48),
                child: Text(
                  Utils.getString(context, 'intro_slider3_description'),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: PsColors.white,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
          
        Positioned(
          bottom: PsDimens.space12,
          width: MediaQuery.of(context).size.width,
          child: Padding(
              padding: const EdgeInsets.only(left : PsDimens.space12, right : PsDimens.space12),
                      child: Column(
              children: <Widget>[
                Row(children: <Widget>[
                  Checkbox(
                      activeColor: PsColors.mainColor,
                      value: widget.provider.isCheckBoxSelect,
                      onChanged: (bool? value) {
                        setState(() {
                          updateCheckBox(context, widget.provider,
                              widget.provider.isCheckBoxSelect);
                        });
                      }),
                  Expanded(
                    child: Text(
                      Utils.getString(
                          context, 'intro_slider_do_not_show_again'),
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: PsColors.white,
                        ),
                    ),
                  ),
                ]),
                PSButtonWidget(
                  hasShadow: false,
                  width: double.infinity,
                  titleText:
                      Utils.getString(context, 'intro_slider_lets_explore'),
                  onPressed: () async {
                    if (widget.provider.isCheckBoxSelect) {
                      await widget.provider
                          .replaceIsToShowIntroSlider(false);
                    }

                    if (widget.settingSlider == 1) {
                      Navigator.pop(context);
                    } else {
                          if (psValueHolder.isForceLogin == true && Utils.checkUserLoginId(psValueHolder) == 'nologinuser') {
                            
                                  Navigator.pushReplacementNamed(
                                      context, RoutePaths.login_container,arguments: false);
                          
                       } else {
                          if(psValueHolder.isLanguageConfig= true && Utils.checkUserLoginId(psValueHolder) == 'nologinuser'){
                     Navigator.pushReplacementNamed(
                         context, RoutePaths.languagesetting);
                       }else{
                      if (psValueHolder.locationId != null) {
                        Navigator.pushNamed(
                          context,
                          RoutePaths.home,
                        );
                      } else {
                        Navigator.pushNamed(
                          context,
                          RoutePaths.itemLocationList,
                        );
                      }
                       }
                       }
                    }
                  },
                ),
              ],
            ),
          )),
          ]),
    );
  }
}
