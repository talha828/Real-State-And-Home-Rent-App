import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/provider/about_us/about_us_provider.dart';
import 'package:flutteradhouse/repository/about_us_repository.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingFAQView extends StatefulWidget {
  const SettingFAQView();
  @override
  _SettingFAQViewState createState() {
    return _SettingFAQViewState();
  }
}

class _SettingFAQViewState extends State<SettingFAQView>
    with SingleTickerProviderStateMixin {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  AboutUsRepository? repo1;
  PsValueHolder? valueHolder;
  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<AboutUsRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    return PsWidgetWithAppBar<AboutUsProvider>(
        appBarTitle: Utils.getString(context, 'setting__faq'),
        initProvider: () {
          return AboutUsProvider(
            repo: repo1,
            psValueHolder: valueHolder,
          );
        },
        onProviderReady: (AboutUsProvider provider) {
          provider.loadAboutUsList();
          // _aboutUsProvider = provider;
        },
        builder:
            (BuildContext context, AboutUsProvider provider, Widget? child) {
          if (provider.aboutUsList.data != null &&
              provider.aboutUsList.data!.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(PsDimens.space10),
              child: SingleChildScrollView(
                child : Html(
                  data: provider.aboutUsList.data![0].faqPages!,
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
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
