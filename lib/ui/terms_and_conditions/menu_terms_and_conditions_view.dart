

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/provider/about_us/about_us_provider.dart';
import 'package:flutteradhouse/repository/about_us_repository.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuTermsAndConditionView extends StatefulWidget {
  const MenuTermsAndConditionView({Key? key, required this.animationController})
      : super(key: key);
  final AnimationController? animationController;
  @override
  _MenuTermsAndConditionViewState createState() => _MenuTermsAndConditionViewState();
}

class _MenuTermsAndConditionViewState extends State<MenuTermsAndConditionView> {
  AboutUsRepository? repo1;
  PsValueHolder? psValueHolder;
  AboutUsProvider? provider;
  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<AboutUsRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    widget.animationController!.forward();
    return ChangeNotifierProvider<AboutUsProvider?>(
        lazy: false,
        create: (BuildContext context) {
          provider = AboutUsProvider(repo: repo1, psValueHolder: psValueHolder);
          provider!.loadAboutUsList();
          return provider;
        },
        child: Consumer<AboutUsProvider>(builder: (BuildContext context,
            AboutUsProvider basketProvider, Widget? child) {
          if (provider!.aboutUsList.data == null ||
              provider!.aboutUsList.data!.isEmpty) {
            return Container();
          } else {
            return AnimatedBuilder(
              animation: widget.animationController!,
              child: Padding(
                padding: const EdgeInsets.all(PsDimens.space10),
                child: SingleChildScrollView(
                  child : Html(
                  data: provider!.aboutUsList.data![0].termsAndConditions ?? '',
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
                  onLinkTap: (String? url, _, __, ___) async{
                     if (await canLaunchUrl(Uri.parse(url!)))
                      await launchUrl(Uri.parse(url));
                    else // can't launch url, there is some error
                    throw 'Could not launch $url';
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
                  // ignore: always_specify_types
                  //   style: {
                  //   '#': Style(
                  //    // maxLines: 3,
                  //     fontWeight: FontWeight.normal,
                  //    // textOverflow: TextOverflow.ellipsis,
                  //   ),
                  // },
                )
                ),
              ),
              builder: (BuildContext context, Widget? child) {
                return FadeTransition(
                  opacity: animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - animation.value), 0.0),
                      child: child),
                );
              },
            );
          }
        }));
  }
}
