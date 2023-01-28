import 'package:flutter/material.dart';
import 'package:flutteradhouse/api/common/ps_admob_banner_widget.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/blog/blog_provider.dart';
import 'package:flutteradhouse/repository/blog_repository.dart';
import 'package:flutteradhouse/ui/blog/item/blog_list_item.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class BlogListView extends StatefulWidget {
  const BlogListView({Key? key, required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _BlogListViewState createState() => _BlogListViewState();
}

class _BlogListViewState extends State<BlogListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  PsValueHolder? valueHolder;
  BlogProvider? _blogProvider;
  Animation<double>? animation;

  @override
  void dispose() {
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _blogProvider!.nextBlogList(Utils.checkUserLoginId(valueHolder!),
            _blogProvider!.blogParameterHolder);
      }
    });

    super.initState();
  }

  BlogRepository? repo1;
  dynamic data;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;


  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && valueHolder!.isShowAdmob!) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
     valueHolder =Provider.of<PsValueHolder>(context, listen: false);
    if (!isConnectedToInternet && valueHolder!.isShowAdmob!) {
      print('loading ads....');
      checkConnection();
    }
    repo1 = Provider.of<BlogRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);
    print(
        '............................Build UI Again ............................');

    return ChangeNotifierProvider<BlogProvider>(
      lazy: false,
      create: (BuildContext context) {
        _blogProvider = BlogProvider(repo: repo1, limit: valueHolder!.blockItemLoadingLimit!);
        _blogProvider!.blogParameterHolder.cityId = valueHolder!.locationId;
        final String loginUserId = Utils.checkUserLoginId(valueHolder!);
        _blogProvider!.loadBlogList(
            loginUserId, _blogProvider!.blogParameterHolder);
        return _blogProvider!;
      },
      child: Consumer<BlogProvider>(
        builder: (BuildContext context, BlogProvider provider, Widget? child) {
          return Column(
            children: <Widget>[
              const PsAdMobBannerWidget(
                admobSize: AdSize.banner,),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(
                            left: PsDimens.space16,
                            right: PsDimens.space16,
                            top: PsDimens.space8,
                            bottom: PsDimens.space8),
                        child: RefreshIndicator(
                          child: CustomScrollView(
                              controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              slivers: <Widget>[
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      if (provider.blogList.data != null ||
                                          provider.blogList.data!.isNotEmpty) {
                                        final int count =
                                            provider.blogList.data!.length;
                                        return BlogListItem(
                                          animationController:
                                              widget.animationController,
                                          animation: Tween<double>(
                                                  begin: 0.0, end: 1.0)
                                              .animate(
                                            CurvedAnimation(
                                              parent:
                                                  widget.animationController,
                                              curve: Interval(
                                                  (1 / count) * index, 1.0,
                                                  curve: Curves.fastOutSlowIn),
                                            ),
                                          ),
                                          blog: provider.blogList.data![index],
                                          onTap: () {
                                            print(provider.blogList.data![index]
                                                .defaultPhoto!.imgPath);
                                            Navigator.pushNamed(
                                                context, RoutePaths.blogDetail,
                                                arguments: provider
                                                    .blogList.data![index]);
                                          },
                                        );
                                      } else {
                                        return null;
                                      }
                                    },
                                    childCount: provider.blogList.data!.length,
                                  ),
                                ),
                              ]),
                          onRefresh: () {
                            return _blogProvider!.resetBlogList(
                                Utils.checkUserLoginId(valueHolder!),
                                _blogProvider!.blogParameterHolder);
                          },
                        )),
                    PSProgressIndicator(provider.blogList.status)
                  ],
                ),
              )
            ],
          );
        },
      ),
      // ),
    );
  }
}
