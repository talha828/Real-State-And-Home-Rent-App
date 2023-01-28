import 'package:flutter/material.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/provider/post_type/post_type_provider.dart';
import 'package:flutteradhouse/repository/post_type_repository.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradhouse/ui/common/ps_frame_loading_widget.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/ui/post_type/item/post_type_search_list_item.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PostTypeSearchListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PostTypeSearchListViewState();
  }
}

class _PostTypeSearchListViewState extends State<PostTypeSearchListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  PostTypeProvider? _postedByProvider;
  // final propertyTypeParameterHolder categoryIconList = propertyTypeParameterHolder();
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
        _postedByProvider!.nextPostTypeList();
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    animation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(animationController!);
    super.initState();
  }

  PostTypeRepository? repo1;

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController!.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    repo1 = Provider.of<PostTypeRepository>(context);

    print(
        '............................Build UI Again ............................');

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<PostTypeProvider>(
          appBarTitle: Utils.getString(
                  context, 'post_type_post_type_list'),
          initProvider: () {
            return PostTypeProvider(
              repo: repo1,
            );
          },
          onProviderReady: (PostTypeProvider provider) {
            provider.loadPostTypeList();
            _postedByProvider = provider;
          },
          builder:
              (BuildContext context, PostTypeProvider provider, Widget? child) {
            return Stack(children: <Widget>[
              Container(
                  child: RefreshIndicator(
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
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                            ]));
                      } else {
                        final int count = provider.postTypeList.data!.length;
                        animationController!.forward();
                        return FadeTransition(
                            opacity: animation!,
                            child: PostTypeSearchListItem(
                              animationController: animationController!,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController!,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                              postType: provider.postTypeList.data![index],
                              onTap: () {
                                // print(provider.postTypeList.data[index]
                                //     .defaultPhoto.imgPath);
                                //Navigator.pop(context, provider.postTypeList.data[index]);

                                Navigator.of(context, rootNavigator: true)
                                    .pop(provider.postTypeList.data![index]);

                                print(provider.postTypeList.data![index].name);
                             
                              },
                            ));
                      }
                    }),
                onRefresh: () {
                  return provider.resetPostTypeList();
                },
              )),
              PSProgressIndicator(provider.postTypeList.status)
            ]);
          }),
    );
  }
}
