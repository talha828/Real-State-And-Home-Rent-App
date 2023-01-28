import 'package:flutter/material.dart';
import 'package:flutteradhouse/api/common/ps_admob_banner_widget.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/provider/rating/rating_list_provider.dart';
import 'package:flutteradhouse/provider/user/user_provider.dart';
import 'package:flutteradhouse/repository/product_repository.dart';
import 'package:flutteradhouse/repository/rating_repository.dart';
import 'package:flutteradhouse/repository/user_repository.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_appbar_with_two_provider.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/ui/common/smooth_star_rating_widget.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/rating_list_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../item/rating_list_item.dart';

class RatingListView extends StatefulWidget {
  const RatingListView({Key? key, required this.itemUserId}) : super(key: key);
  final String itemUserId;

  @override
  _RatingListViewState createState() => _RatingListViewState();
}

class _RatingListViewState extends State<RatingListView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  RatingRepository ?ratingRepo;
  RatingListProvider? ratingProvider;
  UserProvider? userProvider;
  UserRepository ?userRepository;
  PsValueHolder? psValueHolder;
  final ScrollController _scrollController = ScrollController();
  String? loginUserId;
  RatingListHolder? ratingListHolder;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        ratingProvider!.nextRatingList(
            ratingListHolder!.toMap(), widget.itemUserId);
      }
    });
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && psValueHolder!.isShowAdmob! ) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && psValueHolder!.isShowAdmob!) {
      print('loading ads....');
      checkConnection();
    }
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

    ratingRepo = Provider.of<RatingRepository>(context);
    userRepository = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    loginUserId = psValueHolder!.loginUserId;
    return WillPopScope(
        onWillPop: _requestPop,
        child: PsWidgetWithAppBarWithTwoProvider<RatingListProvider,
                UserProvider>(
            appBarTitle: Utils.getString(context, 'rating_list__title') ,
            initProvider1: () {
              ratingProvider = RatingListProvider(repo: ratingRepo);
              return ratingProvider;
            },
            onProviderReady1: (RatingListProvider provider) async {
              ratingListHolder = RatingListHolder(userId: widget.itemUserId);
              await provider.loadRatingList(
                  ratingListHolder!.toMap(), widget.itemUserId);
            },
            initProvider2: () {
              userProvider = UserProvider(
                  repo: userRepository, psValueHolder: psValueHolder);
              return userProvider;
            },
            onProviderReady2: (UserProvider userProvider) {
              userProvider.userParameterHolder.loginUserId =
                  userProvider.psValueHolder!.loginUserId;
              userProvider.userParameterHolder.id = widget.itemUserId;
              userProvider.getOtherUserData(
                  userProvider.userParameterHolder.toMap(),
                  userProvider.userParameterHolder.id!);
            },
            child: Consumer<RatingListProvider>(builder: (BuildContext context,
                RatingListProvider ratingProvider, Widget ?child) {
              return Stack(
                children: <Widget>[
                  Container(
                    color: PsColors.coreBackgroundColor,
                    child: RefreshIndicator(
                      child: CustomScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        slivers: <Widget>[
                          const SliverToBoxAdapter(
                            child: PsAdMobBannerWidget(
                              admobSize: AdSize.banner,
                            ),
                          ),
                          HeaderWidget(ratingProvider: ratingProvider),
                          if (
                              ratingProvider.ratingList.data!.isNotEmpty)
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return RatingListItem(
                                    rating:
                                        ratingProvider.ratingList.data![index],
                                    onTap: () {
                                      // Navigator.pushNamed(context, RoutePaths.directory1__ratingList,
                                      //     arguments: product);
                                    },
                                  );
                                },
                                childCount:
                                    ratingProvider.ratingList.data!.length,
                              ),
                            )
                        ],
                      ),
                      onRefresh: () {
                        return ratingProvider.resetRatingList(
                            ratingListHolder!.toMap(), widget.itemUserId);
                      },
                    ),
                  ),
                  PSProgressIndicator(ratingProvider.ratingList.status)
                ],
              );
            })));
  }
}

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({Key? key, required this.ratingProvider})
      : super(key: key);
  // final String itemDetailId;
  final RatingListProvider ratingProvider;

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  ProductRepository? repo;
  PsValueHolder? psValueHolder;

  @override
  Widget build(BuildContext context) {
    repo = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space10,
    );
    return SliverToBoxAdapter(
      child: Consumer<UserProvider>(builder:
          (BuildContext context, UserProvider userProvider, Widget? child) {
        if (
            userProvider.user.data != null &&
            userProvider.user.data!.ratingDetail != null) {
          return Container(
            color: PsColors.backgroundColor,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: PsDimens.space12,
                  right: PsDimens.space12,
                  bottom: PsDimens.space8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _spacingWidget,
                  Text(
                      '${userProvider.user.data!.ratingDetail!.totalRatingCount} ${Utils.getString(context, 'rating_list__customer_reviews')}'),
                  const SizedBox(
                    height: PsDimens.space4,
                  ),
                  Row(
                    children: <Widget>[
                      SmoothStarRating(
                          key: Key(userProvider
                              .user.data!.ratingDetail!.totalRatingValue!),
                          rating: double.parse(userProvider
                              .user.data!.ratingDetail!.totalRatingValue!),
                          isReadOnly: true,
                          allowHalfRating: false,
                          starCount: 5,
                          size: PsDimens.space16,
                          color: PsColors.ratingColor,
                          borderColor: PsColors.grey.withAlpha(100),
                          spacing: 0.0),
                      const SizedBox(
                        width: PsDimens.space100,
                      ),
                      Text(
                          '${userProvider.user.data!.ratingDetail!.totalRatingValue} ${Utils.getString(context, 'rating_list__out_of_five_stars')}'),
                    ],
                  ),
                  _RatingWidget(
                      starCount:
                          Utils.getString(context, 'rating_list__five_star'),
                      value: double.parse(
                          userProvider.user.data!.ratingDetail!.fiveStarCount!),
                      percentage:
                          '${userProvider.user.data!.ratingDetail!.fiveStarPercent} ${Utils.getString(context, 'rating_list__percent')}'),
                  _RatingWidget(
                      starCount:
                          Utils.getString(context, 'rating_list__four_star'),
                      value: double.parse(
                          userProvider.user.data!.ratingDetail!.fourStarCount!),
                      percentage:
                          '${userProvider.user.data!.ratingDetail!.fourStarPercent} ${Utils.getString(context, 'rating_list__percent')}'),
                  _RatingWidget(
                      starCount:
                          Utils.getString(context, 'rating_list__three_star'),
                      value: double.parse(
                          userProvider.user.data!.ratingDetail!.threeStarCount!),
                      percentage:
                          '${userProvider.user.data!.ratingDetail!.threeStarPercent!} ${Utils.getString(context, 'rating_list__percent')}'),
                  _RatingWidget(
                      starCount:
                          Utils.getString(context, 'rating_list__two_star'),
                      value: double.parse(
                          userProvider.user.data!.ratingDetail!.twoStarCount!),
                      percentage:
                          '${userProvider.user.data!.ratingDetail!.twoStarPercent} ${Utils.getString(context, 'rating_list__percent')}'),
                  _RatingWidget(
                      starCount:
                          Utils.getString(context, 'rating_list__one_star'),
                      value: double.parse(
                          userProvider.user.data!.ratingDetail!.oneStarCount!),
                      percentage:
                          '${userProvider.user.data!.ratingDetail!.oneStarPercent} ${Utils.getString(context, 'rating_list__percent')}'),
                  _spacingWidget,
                  const Divider(
                    height: PsDimens.space1,
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      }),
    );
  }
}

class _RatingWidget extends StatelessWidget {
  const _RatingWidget({
    Key? key,
    required this.starCount,
    required this.value,
    required this.percentage,
  }) : super(key: key);

  final String starCount;
  final double value;
  final String percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: PsDimens.space4),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            starCount,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          const SizedBox(
            width: PsDimens.space12,
          ),
          Expanded(
            flex: 5,
            child: LinearProgressIndicator(
              value: value,
            ),
          ),
          const SizedBox(
            width: PsDimens.space12,
          ),
          Container(
            width: PsDimens.space68,
            child: Text(
              percentage,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ],
      ),
    );
  }
}

// class _WriteReviewButtonWidget extends StatelessWidget {
//   const _WriteReviewButtonWidget({
//     Key key,
//     @required this.productprovider,
//     @required this.ratingProvider,
//     @required this.productId,
//     // @required this.loginUserId,
//   }) : super(key: key);

//   final ItemDetailProvider productprovider;
//   final RatingProvider ratingProvider;
//   final String productId;
//   // final String loginUserId;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(top: PsDimens.space10),
//       alignment: Alignment.bottomCenter,
//       child: SizedBox(
//         width: double.infinity,
//         height: PsDimens.space36,
//         child: MaterialButton(
//           child: Text(
//             Utils.getString(context, 'rating_list__write_review'),
//             style: const TextStyle(color: Colors.white),
//           ),
//           color: PsColors.mainColor,
//           shape: const BeveledRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(7.0)),
//           ),
//           onPressed: () async {
//             if (await Utils.checkInternetConnectivity()) {
//               Utils.navigateOnUserVerificationView(productprovider, context,
//                   () async {
//                 // await showDialog<dynamic>(
//                 //     context: context,
//                 //     builder: (BuildContext context) {
//                 //       return RatingInputDialog(
//                 //           productprovider: productprovider);
//                 //     });

//                 await showDialog<dynamic>(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return RatingInputDialog(
//                         itemUserId: productprovider.itemDetail.data.user.userId,
//                         psValueHolder: productprovider.psValueHolder,
//                       );
//                     });

//                 final RatingListHolder ratingListHolder = RatingListHolder(
//                     userId: productprovider.itemDetail.data.user.userId);
//                 ratingProvider.refreshRatingList(ratingListHolder.toMap(),
//                     productprovider.itemDetail.data.user.userId);
//                 await productprovider.loadProduct(
//                     productId, productprovider.psValueHolder.loginUserId);
//               });
//             } else {
//               showDialog<dynamic>(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return ErrorDialog(
//                       message:
//                           Utils.getString(context, 'error_dialog__no_internet'),
//                     );
//                   });
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
