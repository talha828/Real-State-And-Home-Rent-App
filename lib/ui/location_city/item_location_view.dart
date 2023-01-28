import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/item_location_city/item_location_provider.dart';
import 'package:flutteradhouse/repository/item_location_city_repository.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_appbar_no_app_bar_title.dart';
import 'package:flutteradhouse/ui/common/ps_textfield_widget_with_icon.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/ui/location_city/item_location_list_item.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/location_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/item_location_city.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:provider/provider.dart';

class ItemLocationView extends StatefulWidget {
  const ItemLocationView({Key? key, required this.animationController})
      : super(key: key);

  final AnimationController animationController;
  @override
  _ItemLocationViewState createState() => _ItemLocationViewState();
}

class _ItemLocationViewState extends State<ItemLocationView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ItemLocationCityProvider? _itemLocationCityProvider;
  PsValueHolder? valueHolder;
  // Animation<double> animation;
  int i = 0;
  @override
  void dispose() {
    // animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _itemLocationCityProvider!.nextItemLocationList(
            _itemLocationCityProvider!.latestLocationParameterHolder.toMap(),
          Utils.checkUserLoginId(_itemLocationCityProvider!.psValueHolder!));
      }
    });

    super.initState();
  }

  ItemLocationCityRepository? repo1;
  dynamic data;

  @override
  Widget build(BuildContext context) {
    // data = EasyLocalizationProvider.of(context).data;
    repo1 = Provider.of<ItemLocationCityRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    print(
        '............................Build Item Location UI Again ............................');

    return PsWidgetWithAppBarNoAppBarTitle<ItemLocationCityProvider>(
        initProvider: () {
      return ItemLocationCityProvider(repo: repo1, psValueHolder: valueHolder);
    }, onProviderReady: (ItemLocationCityProvider provider) {
      provider.latestLocationParameterHolder.keyword =
          searchNameController.text;
      provider.loadItemLocationList(
          provider.latestLocationParameterHolder.toMap(),
          Utils.checkUserLoginId(provider.psValueHolder!));
      _itemLocationCityProvider = provider;
    }, builder: (BuildContext context, ItemLocationCityProvider provider,
            Widget ?child) {
      return ItemLocationListViewWidget(
        scrollController: _scrollController,
        animationController: widget.animationController,
      );
    });
  }
}

class ItemLocationListViewWidget extends StatefulWidget {
  const ItemLocationListViewWidget(
      {Key? key,
      required this.scrollController,
      required this.animationController})
      : super(key: key);

  final ScrollController scrollController;
  final AnimationController animationController;

  @override
  _ItemLocationListViewWidgetState createState() =>
      _ItemLocationListViewWidgetState();
}

LocationParameterHolder locationParameterHolder =
    LocationParameterHolder().getDefaultParameterHolder();
final TextEditingController searchNameController = TextEditingController();
PsValueHolder? valueHolder;

class _ItemLocationListViewWidgetState
    extends State<ItemLocationListViewWidget> {
  Widget? _widget;

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context);
    final ItemLocationCityProvider _provider =
        Provider.of(context, listen: false);
    _widget ??= Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(child: ItemLocationHeaderTextWidget()),
        Row(
          children: <Widget>[
            const SizedBox(
              width: PsDimens.space4,
            ),
            Flexible(
                child: PsTextFieldWidgetWithIcon(
                    hintText:
                        Utils.getString(context, 'home__bottom_app_bar_search'),
                    textEditingController: searchNameController,
                    psValueHolder: _provider.psValueHolder,
                    clickSearchButton: () {
                      _provider.latestLocationParameterHolder.keyword =
                          searchNameController.text;
                      _provider.resetItemLocationList(
                          _provider.latestLocationParameterHolder.toMap(),
                          Utils.checkUserLoginId(_provider.psValueHolder!));
                    },
                    clickEnterFunction: () {
                      _provider.latestLocationParameterHolder.keyword =
                          searchNameController.text;
                      _provider.resetItemLocationList(
                          _provider.latestLocationParameterHolder.toMap(),
                          Utils.checkUserLoginId(_provider.psValueHolder!));
                    })),
            Container(
              height: PsDimens.space44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: PsColors.baseDarkColor,
                borderRadius: BorderRadius.circular(PsDimens.space4),
                border: Border.all(color: PsColors.mainDividerColor),
              ),
              child: InkWell(
                  child: Container(
                    height: double.infinity,
                    width: PsDimens.space44,
                    child: Icon(
                      Octicons.settings,
                      color: PsColors.iconColor,
                      size: PsDimens.space20,
                    ),
                  ),
                  onTap: () async {
                    locationParameterHolder.keyword = searchNameController.text;
                    final dynamic returnData = await Navigator.pushNamed(
                        context, RoutePaths.filterLocationList,
                        arguments: locationParameterHolder);
                    if (returnData != null &&
                        returnData is LocationParameterHolder) {
                      _provider.latestLocationParameterHolder = returnData;
                      searchNameController.text = returnData.keyword!;
                      _provider.resetItemLocationList(
                          _provider.latestLocationParameterHolder.toMap(),
                          Utils.checkUserLoginId(_provider.psValueHolder!));
                    }
                  }),
            ),
            const SizedBox(
              width: PsDimens.space16,
            ),
          ],
        ),
        Consumer<ItemLocationCityProvider>(builder: (BuildContext context,
            ItemLocationCityProvider provider, Widget? child) {
          print('Refresh Progress Indicator');

          return PSProgressIndicator(provider.itemLocationList.status,
              message: provider.itemLocationList.message);
        }),
        Expanded(
          child: RefreshIndicator(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Selector<ItemLocationCityProvider, List<ItemLocationCity>>(
                  child: Container(),
                  selector: (BuildContext context,
                      ItemLocationCityProvider provider) {
                    print(
                        'Selector ${provider.itemLocationList.data.hashCode}');
                    return provider.itemLocationList.data!;
                  },
                  builder: (BuildContext context,
                      List<ItemLocationCity> dataList, Widget? child) {
                    print('Builder');
                    return ListView.builder(
                        controller: widget.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: dataList.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          final int count = dataList.length + 1;
                          if ( dataList.isNotEmpty) {
                            return ItemLocationListItem(
                              animationController: widget.animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: widget.animationController,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                              itemLocation: index == 0
                                  ? Utils.getString(
                                      context, 'product_list__category_all')
                                  : dataList[index - 1].name!,
                              onTap: () async {
                                  if (index == 0) {
                                  await _provider.replaceItemLocationData(
                                      '',
                                      Utils.getString(context,
                                          'product_list__category_all'),
                                      PsConst.INVALID_LAT_LNG,
                                      PsConst.INVALID_LAT_LNG);

                                  await _provider
                                      .replaceItemLocationTownshipData(
                                    '',
                                    '',
                                    Utils.getString(context,
                                          'product_list__category_all'),
                                    PsConst.INVALID_LAT_LNG,
                                    PsConst.INVALID_LAT_LNG,
                                  );

                                    Navigator.pushReplacementNamed(
                                        context, RoutePaths.home);
                            
                                } else {
                                  await _provider.replaceItemLocationData(
                                      dataList[index - 1].id!,
                                      dataList[index - 1].name!,
                                      dataList[index - 1].lat!,
                                      dataList[index - 1].lng!);
                                  if (valueHolder!.isSubLocation ==
                                      PsConst.ONE) {
                                    Navigator.pushReplacementNamed(context,
                                        RoutePaths.itemLocationTownshipList,
                                        arguments: dataList[index - 1].id);
                                  } else {
                                    Navigator.pushReplacementNamed(
                                        context, RoutePaths.home);
                                  }
                                }
                                } 
                              );
                            } else {
                            return Container();
                          }
                        });
                  }),
            ),
            onRefresh: () {
              return _provider.resetItemLocationList(
                  _provider.latestLocationParameterHolder.toMap(),
                  _provider.psValueHolder!.loginUserId!);
            },
          ),
        )
      ],
    );
    print('Widget ${_widget.hashCode}');
    return _widget!;
  }
}

class ItemLocationHeaderTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      color: PsColors.mainColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: PsDimens.space32),
              child: Text(
                  Utils.getString(context, 'item_location__select_city'),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.white)),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: PsDimens.space64, top: PsDimens.space8),
              child: Text(
                  Utils.getString(
                      context, 'item_location__change_selected_city'),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
