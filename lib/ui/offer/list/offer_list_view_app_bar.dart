import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';

class OfferListViewAppBar extends StatefulWidget {
  const OfferListViewAppBar(
      {this.selectedIndex = 0,
      this.showElevation = true,
      this.iconSize = 24,
      required this.items,
      required this.onItemSelected})
      : 
        assert(items.length >= 2 && items.length <= 5)
      ;

  @override
  _OfferListViewAppBarState createState() {
    return _OfferListViewAppBarState(
        selectedIndexNo: selectedIndex,
        items: items,
        iconSize: iconSize,
        onItemSelected: onItemSelected);
  }

  final int selectedIndex;
  final double iconSize;
  final bool showElevation;
  final List<OfferListViewAppBarItem> items;
  final ValueChanged<int> onItemSelected;
}

class _OfferListViewAppBarState extends State<OfferListViewAppBar> {
  _OfferListViewAppBarState(
      {required this.items,
      this.iconSize,
      this.selectedIndexNo,
      required this.onItemSelected});

  final double? iconSize;
  List<OfferListViewAppBarItem> items;
  int? selectedIndexNo;

  ValueChanged<int> onItemSelected;

  Widget _buildItem(OfferListViewAppBarItem item, bool isSelected) {
    return AnimatedContainer(
      width: PsDimens.space160,
      height: double.maxFinite,
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: PsDimens.space12),
      decoration: BoxDecoration(
        color: isSelected
            ? item.activeBackgroundColor
            : item.inactiveBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
      ),
      child: Center(
          child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.message,
              color: isSelected ? item.activeColor : item.inactiveColor),
          const SizedBox(
            width: PsDimens.space8,
          ),
          Text(
            item.title!,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: isSelected ? item.activeColor : item.inactiveColor),
          ),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    selectedIndexNo = widget.selectedIndex;
    return Container(
      decoration: BoxDecoration(
          color: PsColors.baseColor,
          boxShadow: <BoxShadow>[
            if (widget.showElevation)
              const BoxShadow(color: Colors.black12, blurRadius: 2)
          ]),
      child: Container(
          margin: const EdgeInsets.only(
              top: PsDimens.space16,
              bottom: PsDimens.space16,
              left: PsDimens.space8,
              right: PsDimens.space8),
          width: double.infinity,
          height: 46,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                final OfferListViewAppBarItem item = items[index];
                return InkWell(
                  onTap: () {
                    onItemSelected(index);
                    setState(() {
                      selectedIndexNo = index;
                    });
                  },
                  child: _buildItem(item, selectedIndexNo == index),
                );
              })),
    );
  }
}

class OfferListViewAppBarItem {
  OfferListViewAppBarItem(
      {required this.title,
      Color? activeColor,
      Color? activeBackgroundColor,
      Color? inactiveColor,
      Color? inactiveBackgroundColor})
      : assert(title != null),
        activeColor = activeColor ?? PsColors.mainColor,
        activeBackgroundColor =
            activeBackgroundColor ?? PsColors.mainLightColor,
        inactiveColor = inactiveColor ?? PsColors.grey,
        inactiveBackgroundColor =
            inactiveBackgroundColor ?? PsColors.grey.withOpacity(0.2);

  final String? title;
  final Color activeColor;
  final Color activeBackgroundColor;
  final Color inactiveColor;
  final Color inactiveBackgroundColor;
}
