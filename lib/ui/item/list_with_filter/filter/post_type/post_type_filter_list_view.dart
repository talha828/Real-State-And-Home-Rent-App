import 'package:flutter/material.dart';
import 'package:flutteradhouse/api/common/ps_admob_banner_widget.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/provider/post_type/post_type_provider.dart';
import 'package:flutteradhouse/repository/post_type_repository.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'post_type_filter_list_item_view.dart';

class PostTypeFilterListView extends StatefulWidget {
  const PostTypeFilterListView({this.selectedData});

  final dynamic selectedData;

  @override
  State<StatefulWidget> createState() => _PostedFilterListViewState();
}

class _PostedFilterListViewState extends State<PostTypeFilterListView> {
  final ScrollController _scrollController = ScrollController();

  PostTypeRepository? postTypeRepository;
  PsValueHolder? psValueHolder;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onAllPostTypeClick(Map<String, String> postType) {
    Navigator.pop(context, postType);
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
        postTypeRepository = Provider.of<PostTypeRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    if (!isConnectedToInternet && psValueHolder!.isShowAdmob!) {
      print('loading ads....');
      checkConnection();
    }

    return PsWidgetWithAppBar<PostTypeProvider>(
        appBarTitle: Utils.getString(context, 'search__post_type'),
        initProvider: () {
          return PostTypeProvider(repo: postTypeRepository);
        },
        onProviderReady: (PostTypeProvider provider) {
          provider.loadPostTypeList();
        },
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list,
                color: PsColors.mainColor),
            onPressed: () {
              final Map<String, String> dataHolder = <String, String>{};
              dataHolder[PsConst.POSTED_BY_ID] = '';
              dataHolder[PsConst.POSTED_BY_NAME] = '';
              onAllPostTypeClick(dataHolder);
            },
          )
        ],
        builder:
            (BuildContext context, PostTypeProvider provider, Widget? child) {
          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const PsAdMobBannerWidget(
                    admobSize: AdSize.banner,
                  ),
                  Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: provider.postTypeList.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (provider.postTypeList.data != null ||
                              provider.postTypeList.data!.isEmpty) {
                            return PostTypeFilterListItemView(
                              selectedData: widget.selectedData,
                              onAllPostTypeClick: onAllPostTypeClick,
                              postType: provider.postTypeList.data![index],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }
}
