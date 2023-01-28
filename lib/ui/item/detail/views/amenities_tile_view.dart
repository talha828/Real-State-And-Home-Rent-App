import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/provider/product/product_provider.dart';
import 'package:flutteradhouse/ui/common/ps_expansion_tile.dart';
import 'package:flutteradhouse/ui/item/detail/views/amenities_tile_list_view_item.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

class AmenitiesTileView extends StatefulWidget {
  const AmenitiesTileView({
    Key? key,
    required this.animationController,
    required this.itemDetail,
  }) : super(key: key);
  final AnimationController animationController;
  final ItemDetailProvider itemDetail;

  @override
  _AmenitiesTileViewState createState() => _AmenitiesTileViewState();
}

class _AmenitiesTileViewState extends State<AmenitiesTileView> {
  @override
  void dispose() {
    super.dispose();
  }

  dynamic data;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  @override
  Widget build(BuildContext context) {
    final Widget _amenitiesTileTitleWidget = Text(
        Utils.getString(context, 'amenities_tile__title'),
        style: Theme.of(context).textTheme.subtitle1);

    final Widget _amenitiesTileLeadingIconWidget = Icon(
      FontAwesome5.dot_circle,
      color: PsColors.mainColor,
    );
    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
          bottom: PsDimens.space12),
      decoration: BoxDecoration(
        color: PsColors.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(PsDimens.space8)),
      ),
      child: PsExpansionTile(
        initiallyExpanded: true,
        leading: _amenitiesTileLeadingIconWidget,
        title: _amenitiesTileTitleWidget,
        children: <Widget>[
          Column(
            children: <Widget>[
              const Divider(
                height: PsDimens.space1,
              ),
              Padding(
                  padding: const EdgeInsets.only(
                    top: PsDimens.space4,
                    left: PsDimens.space4,
                    bottom: PsDimens.space12
                  ),
                  child: IconAndTextWidget(
                    itemDetail: widget.itemDetail,
                    animationController: widget.animationController,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class IconAndTextWidget extends StatelessWidget {
  const IconAndTextWidget({
    Key? key,
    required this.itemDetail,
    required this.animationController,
  }) : super(key: key);

  final ItemDetailProvider itemDetail;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
      return CustomScrollView(
      shrinkWrap: true,
      slivers: <Widget>[
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300.0, childAspectRatio: 6),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              if (itemDetail.itemDetail.data!.itemAmenitiesList != null ||
                  itemDetail.itemDetail.data!.itemAmenitiesList!.isNotEmpty) {
                final int count = itemDetail.itemDetail.data!.itemAmenitiesList!.length;
                return AmenitiesTileListViewItem(
                  amenities: itemDetail.itemDetail.data!.itemAmenitiesList![index],
                  onTap: () {},
                  animationController: animationController,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: Interval((1 / count) * index, 1.0,
                          curve: Curves.fastOutSlowIn),
                      ),
                    ),
                  );
                } else {
                  return null;
                }
              },
              childCount: itemDetail.itemDetail.data!.itemAmenitiesList!.length,
            ),
          ),
        ],
      );
    }
  }

