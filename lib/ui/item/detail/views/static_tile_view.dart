import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/provider/product/product_provider.dart';
import 'package:flutteradhouse/ui/common/ps_expansion_tile.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/mfg_labs_icons.dart';

class StatisticTileView extends StatefulWidget {
  const StatisticTileView(this.itemDetail);
  final ItemDetailProvider itemDetail;

  @override
  _StatisticTileViewState createState() => _StatisticTileViewState();
}

class _StatisticTileViewState extends State<StatisticTileView> {
  @override
  Widget build(BuildContext context) {
    return _StatisticBuildTileswidget(itemDetail: widget.itemDetail);
  }
}

class _StatisticBuildTileswidget extends StatelessWidget {
  const _StatisticBuildTileswidget({this.itemDetail});
  final ItemDetailProvider? itemDetail;

  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'statistic_tile__title'),
        style: Theme.of(context).textTheme.subtitle1);

    final Widget _expansionTileIconWidget = Icon(
     MfgLabs.chart_bar,
      color: PsColors.mainColor,
    );
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space16,
    );

    if (
        itemDetail!.itemDetail.data != null) {
      return Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space12,
            right: PsDimens.space12,
            bottom: PsDimens.space12),
        decoration: BoxDecoration(
          color: PsColors.backgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: PsExpansionTile(
          initiallyExpanded: true,
          leading: _expansionTileIconWidget,
          title: _expansionTileTitleWidget,
          children: <Widget>[
            Column(
              children: <Widget>[
                Divider(
                  height: PsDimens.space1,
                  color: Theme.of(context).iconTheme.color,
                ),
                _spacingWidget,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _IconAndTextWidget(
                        icon: FontAwesome5.eye,
                        title:
                            '${itemDetail!.itemDetail.data!.touchCount} ${Utils.getString(context, 'statistic_tile__views')}',
                        textType: 0),
                    _IconAndTextWidget(
                        icon: Icons.favorite_border,
                        title:
                            '${itemDetail!.itemDetail.data!.favouriteCount} ${Utils.getString(context, 'statistic_tile__favourite')}',
                        textType: 3),
                  ],
                ),
                _spacingWidget
              ],
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class _IconAndTextWidget extends StatelessWidget {
  const _IconAndTextWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.textType,
  }) : super(key: key);
  final IconData icon;
  final String title;
  final int textType;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          size: PsDimens.space20,
          color: Theme.of(context).iconTheme.color,
        ),
        const SizedBox(
          width: PsDimens.space12,
        ),
        InkWell(
          onTap: () {
            // textType == 1
            //     ? Navigator.pushNamed(
            //         context,
            //         Directory1RoutePaths.ratingList,
            //       )
            //     : textType == 2
            //         ? Navigator.pushNamed(
            //             context,
            //             Directory1RoutePaths.commentList,
            //           )
            //         : const Text('Hello');
          },
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: textType == 0
                    ? Theme.of(context).iconTheme.color
                    : textType == 3
                        ? Theme.of(context).iconTheme.color
                        : PsColors.mainColor),
          ),
        ),
      ],
    );
  }
}
