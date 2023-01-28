import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:flutteradhouse/api/common/ps_admob_banner_widget.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/provider/post_type/post_type_provider.dart';
import 'package:flutteradhouse/repository/post_type_repository.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/ui/post_type/item/post_type_vertical_list_item.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PostTypeListView extends StatefulWidget {
  @override
  _PostTypeListViewState createState() {
    return _PostTypeListViewState();
  }
}

class _PostTypeListViewState extends State<PostTypeListView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  PostTypeProvider? postTypeProvider;

  AnimationController? animationController;
  Animation<double>? animation;

  @override
  void dispose() {
    animationController!.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        postTypeProvider!.nextPostTypeList();
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    super.initState();
  }

  PostTypeRepository? repo1;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
 PsValueHolder? psValueHolder;
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
    psValueHolder = Provider.of<PsValueHolder>(context, listen: false);
    if (!isConnectedToInternet && psValueHolder!.isShowAdmob!) {
      print('loading ads....');
      checkConnection();
    }

    timeDilation = 1.0;
    repo1 = Provider.of<PostTypeRepository>(context);
    // final dynamic data = EasyLocalizationProvider.of(context).data;

    // return EasyLocalizationProvider(
    //     data: data,
    //     child:
    return Scaffold(
        appBar: AppBar(
                          systemOverlayStyle:  SystemUiOverlayStyle(
           statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
         ),
          title: Text(
            Utils.getString(context, 'Sub'),
            style: TextStyle(color: PsColors.white),
          ),
          iconTheme: IconThemeData(
            color: PsColors.white,
          ),
        ),
        body: ChangeNotifierProvider<PostTypeProvider>(
            lazy: false,
            create: (BuildContext context) {
              postTypeProvider = PostTypeProvider(repo: repo1);
              postTypeProvider!.loadPostTypeList();
              return postTypeProvider!;
            },
            child: Consumer<PostTypeProvider>(builder: (BuildContext context,
                PostTypeProvider provider, Widget? child) {
              return Column(
                children: <Widget>[
                  const PsAdMobBannerWidget(
                    admobSize: AdSize.banner,
                  ),
                  Expanded(
                    child: Stack(children: <Widget>[
                      Container(
                          child: RefreshIndicator(
                        onRefresh: () {
                          return postTypeProvider!.resetPostTypeList();
                        },
                        child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            itemCount: provider.postTypeList.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (provider.postTypeList.status ==
                                  PsStatus.BLOCK_LOADING) {
                                return Shimmer.fromColors(
                                    baseColor: PsColors.grey,
                                    highlightColor: PsColors.white,
                                    child: Column(children: const <Widget>[
                                      FrameUIForLoading(),
                                      FrameUIForLoading(),
                                      FrameUIForLoading(),
                                      FrameUIForLoading(),
                                      FrameUIForLoading(),
                                      FrameUIForLoading(),
                                    ]));
                              } else {
                                return PostTypeVerticalListItem(
                                  postType: provider.postTypeList.data![index],
                                  onTap: () {
                                    // print(provider.postTypeList.data[index]
                                    //     .defaultPhoto.imgPath);
                                  },
                                  // )
                                );
                              }
                            }),
                      )),
                      PSProgressIndicator(provider.postTypeList.status)
                    ]),
                  )
                ],
              );
            }))
        // )
        );
  }
}

class FrameUIForLoading extends StatelessWidget {
  const FrameUIForLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            height: 70,
            width: 70,
            margin: const EdgeInsets.all(PsDimens.space16),
            decoration: BoxDecoration(color: PsColors.grey)),
        Expanded(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Container(
              height: 15,
              margin: const EdgeInsets.all(PsDimens.space8),
              decoration: BoxDecoration(color: Colors.grey[300])),
          Container(
              height: 15,
              margin: const EdgeInsets.all(PsDimens.space8),
              decoration: const BoxDecoration(color: Colors.grey)),
        ]))
      ],
    );
  }
}
