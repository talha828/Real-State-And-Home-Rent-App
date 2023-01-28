import 'package:flutter/material.dart';
import 'package:flutteradhouse/api/common/ps_admob_banner_widget.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/provider/property_type/property_type_provider.dart';
import 'package:flutteradhouse/repository/property_type_repository.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/ui/location_city/item_location_view.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/property_type_parameter_holder.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'filter_list_item_view.dart';

class FilterListView extends StatefulWidget {
  const FilterListView({this.selectedData});

  final dynamic selectedData;

  @override
  State<StatefulWidget> createState() => _FilterListViewState();
}

class _FilterListViewState extends State<FilterListView> {
  final ScrollController _scrollController = ScrollController();

  final PropertyTypeParameterHolder categoryIconList =
      PropertyTypeParameterHolder();
  PropertyTypeRepository? propertyTypeRepository;
  PsValueHolder? psValueHolder;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onAllPropertyClick(Map<String, String> propertyType) {
    Navigator.pop(context, propertyType);
  }

  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && psValueHolder!.isShowAdmob!) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
        propertyTypeRepository = Provider.of<PropertyTypeRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    if (!isConnectedToInternet && psValueHolder!.isShowAdmob!) {
      print('loading ads....');
      checkConnection();
    }

    return PsWidgetWithAppBar<PropertyTypeProvider>(
        appBarTitle: Utils.getString(context, 'search__property_type'),
        initProvider: () {
          return PropertyTypeProvider(
              repo: propertyTypeRepository, psValueHolder: psValueHolder);
        },
        onProviderReady: (PropertyTypeProvider provider) {
          provider.loadPropertyTypeList(provider.propertyType.toMap(),psValueHolder!.loginUserId);
        },
        actions: <Widget>[
          IconButton(
            icon: Icon(Elusive.filter,
                color: PsColors.mainColor),
            onPressed: () {
              final Map<String, String> dataHolder = <String, String>{};
              dataHolder[PsConst.PROPERTY_BY_ID] = '';
              dataHolder[PsConst.PROPERTY_BY_NAME] = '';
              onAllPropertyClick(dataHolder);
            },
          )
        ],
         builder: (BuildContext context, PropertyTypeProvider provider,
              Widget? child) {
            return Stack(children: <Widget>[
              const PsAdMobBannerWidget(
                admobSize: AdSize.banner,
              ),
              RefreshIndicator(
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: provider.propertyTypeList.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.propertyTypeList.data != null ||
                          provider.propertyTypeList.data!.isEmpty) {
                        return FilterListItemView(
                            selectedData: widget.selectedData,
                            propertyType: provider.propertyTypeList.data![index],
                            onAllPropertyClick: onAllPropertyClick);
                      } else {
                        return Container();
                      }
                    }),
                onRefresh: () {
                  return provider.resetPropertyTypeList(provider.propertyType.toMap(),valueHolder!.loginUserId);
                },
              ),
              PSProgressIndicator(provider.propertyTypeList.status)
            ]);
          }
    );
  }
}
    
