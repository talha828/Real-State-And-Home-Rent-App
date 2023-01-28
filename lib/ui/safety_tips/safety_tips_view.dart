import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/utils/utils.dart';

class SafetyTipsView extends StatefulWidget {
  const SafetyTipsView({
    Key? key,
    required this.animationController,
    required this.safetyTips,
  }) : super(key: key);

  final AnimationController animationController;
  final String safetyTips;
  @override
  _SafetyTipsViewState createState() => _SafetyTipsViewState();
}

class _SafetyTipsViewState extends State<SafetyTipsView> {
  @override
  Widget build(BuildContext context) {
    // final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
    //     .animate(CurvedAnimation(
    //         parent: widget.animationController,
    //         curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    widget.animationController.forward();
    return Scaffold(
        appBar: AppBar(
         systemOverlayStyle:  SystemUiOverlayStyle(
           statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
         ),
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: PsColors.mainColorWithWhite),
          title: Text(
            Utils.getString(context, 'safety_tips__app_bar_name'),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(PsDimens.space10),
   child: SingleChildScrollView(
            child: Html(
                  data: widget.safetyTips,
                  // ignore: always_specify_types
                  style: {
                    'table': Style(
                      backgroundColor: PsColors.baseLightColor,
                      //  width: MediaQuery.of(context).size.width,
                    ),
                    'tr': Style(
                      border: const Border(
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                    'th': Style(
                      padding: const EdgeInsets.all(6),
                      backgroundColor: Colors.grey,
                    ),
                    'td': Style(
                      padding: const EdgeInsets.all(6),
                      alignment: Alignment.center,
                      width: 120,
                    ),
                  },
                  // ignore: always_specify_types
                  customRender: {
                    'table': (RenderContext context, Widget child) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: (context.tree as TableLayoutElement)
                            .toWidget(context),
                      );
                    },
                    'bird': (RenderContext context, Widget child) {
                      return const TextSpan(text: '🐦');
                    },
                    'flutter': (RenderContext context, Widget child) {
                      return FlutterLogo(
                        style:
                            (context.tree.element!.attributes['horizontal'] !=
                                    null)
                                ? FlutterLogoStyle.horizontal
                                : FlutterLogoStyle.markOnly,
                        textColor: context.style.color!,
                        size: context.style.fontSize!.size! * 5,
                      );
                    },
                  },

                ),

          ),
        )
      );
    //  AnimatedBuilder(
    //   animation: widget.animationController,
    //   builder: (BuildContext context, Widget child) {
    //     return FadeTransition(
    //       opacity: animation,
    //       child: Transform(
    //         transform: Matrix4.translationValues(
    //             0.0, 100 * (1.0 - animation.value), 0.0),
    //         child: Padding(
    //           padding: const EdgeInsets.all(PsDimens.space10),
    //           child: SingleChildScrollView(
    //             child: Text(
    //               widget.safetyTips ?? '',
    //               style: Theme.of(context).textTheme.bodyText1,
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // ));
  }
}
