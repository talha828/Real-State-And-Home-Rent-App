import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/product/added_item_provider.dart';
import 'package:flutteradhouse/provider/product/product_provider.dart';
import 'package:flutteradhouse/provider/user/user_provider.dart';
import 'package:flutteradhouse/repository/product_repository.dart';
import 'package:flutteradhouse/repository/user_repository.dart';
import 'package:flutteradhouse/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutteradhouse/ui/common/dialog/error_dialog.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/ui/common/smooth_star_rating_widget.dart';
import 'package:flutteradhouse/ui/item/item/product_vertical_list_item.dart';
import 'package:flutteradhouse/utils/ps_progress_dialog.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/api_status.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/item_list_intent_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutteradhouse/viewobject/holder/product_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/holder/unblock_user_holder.dart';
import 'package:flutteradhouse/viewobject/holder/user_block_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/holder/user_follow_holder.dart';
import 'package:flutteradhouse/viewobject/product.dart';
import 'package:flutteradhouse/viewobject/user.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetailView extends StatefulWidget {
  const UserDetailView({
    required this.userId,
    required this.userName,
  });
  final String userId;
  final String userName;
  @override
  _UserDetailViewState createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<UserDetailView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  UserProvider? userProvider;
  UserRepository ?userRepository;
  PsValueHolder? psValueHolder;
  ProductRepository? itemRepository;
  AddedItemProvider? itemProvider;
  ItemDetailProvider? itemDetailProvider;
  ProductParameterHolder? parameterHolder;

  @override
  Widget build(BuildContext context) {
    userRepository = Provider.of<UserRepository>(context);
    itemRepository = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    userProvider =
        UserProvider(repo: userRepository, psValueHolder: psValueHolder);
    itemProvider = AddedItemProvider(repo: itemRepository);

    parameterHolder = itemProvider!.addedUserParameterHolder;
    parameterHolder!.addedUserId = widget.userId;
    parameterHolder!.status = '1';

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

    print(
        '............................Build UI Again ............................');
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
            body: MultiProvider(
                providers: <SingleChildWidget>[
              ChangeNotifierProvider<UserProvider>(
                  lazy: false,
                  create: (BuildContext context) {
                    userProvider!.userParameterHolder.loginUserId =
                        userProvider!.psValueHolder!.loginUserId;
                    userProvider!.userParameterHolder.id = widget.userId;
                    userProvider!.getOtherUserData(
                        userProvider!.userParameterHolder.toMap(),
                        userProvider!.userParameterHolder.id!);

                    return userProvider!;
                  }),
              ChangeNotifierProvider<ItemDetailProvider>(
                lazy: false,
                create: (BuildContext context) {
                  itemDetailProvider = ItemDetailProvider(
                      repo: itemRepository, psValueHolder: psValueHolder);
                  return itemDetailProvider!;
                },
              ),
              ChangeNotifierProvider<AddedItemProvider>(
                  lazy: false,
                  create: (BuildContext context) {
                    itemProvider!.loadItemList(
                        Utils.checkUserLoginId(psValueHolder!), parameterHolder!);
                    return itemProvider!;
                  }),
            ],
                child: Consumer<AddedItemProvider>(builder:
                    (BuildContext context, AddedItemProvider provider,
                        Widget? child) {
                  // if (userProvider.user != null && userProvider.user.data != null){
                  return CustomScrollView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      slivers: <Widget>[
                        SliverAppBar(
                                          systemOverlayStyle:  SystemUiOverlayStyle(
           statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
         ),
                          iconTheme: Theme.of(context)
                              .iconTheme
                              .copyWith(color: PsColors.mainColorWithWhite),
                          title: Text(
                            // provider.itemList.data[index].user.userName,
                            widget.userName,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        _UserProfileWidget(
                          itemDetailProvider: itemDetailProvider!,
                          addedItemProvider: provider,
                          animationController: animationController!,
                          animation:
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animationController!,
                              curve: const Interval((1 / 4) * 2, 1.0,
                                  curve: Curves.fastOutSlowIn),
                            ),
                          ),
                        ),
                        if (
                            provider.itemList.data != null &&
                            provider.itemList.data!.isNotEmpty)
                          SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 300.0,
                                    childAspectRatio: 0.6),
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              final int count = provider.itemList.data!.length;
                              return ProductVeticalListItem(
                                coreTagKey: provider.hashCode.toString() +
                                    provider.itemList.data![index].id!,
                                psValueHolder: psValueHolder,
                                product: provider.itemList.data![index],
                                animationController: animationController,
                                animation:
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: animationController!,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn),
                                  ),
                                ),
                                onTap: () {
                                  final Product product = provider
                                      .itemList.data!.reversed
                                      .toList()[index];
                                  final ProductDetailIntentHolder holder =
                                      ProductDetailIntentHolder(
                                          productId:
                                              provider.itemList.data![index].id!,
                                          heroTagImage:
                                              provider.hashCode.toString() +
                                                  product.id! +
                                                  PsConst.HERO_TAG__IMAGE,
                                          heroTagTitle:
                                              provider.hashCode.toString() +
                                                  product.id! +
                                                  PsConst.HERO_TAG__TITLE);
                                  Navigator.pushNamed(
                                      context, RoutePaths.productDetail,
                                      arguments: holder);
                                },
                              );
                            }, childCount: provider.itemList.data!.length),
                          ),
                      ]);
                  // }else{
                  //   return Container();
                  // }
                }))));
  }
}

class _UserProfileWidget extends StatefulWidget {
  const _UserProfileWidget({
    Key? key,
    this.animationController,
    this.animation,
    this.itemDetailProvider,
    this.addedItemProvider,
  }) : super(key: key);

  final AnimationController? animationController;
  final Animation<double>? animation;
  final ItemDetailProvider? itemDetailProvider;
   final AddedItemProvider? addedItemProvider;

  @override
  __UserProfileWidgetState createState() => __UserProfileWidgetState();
}

class __UserProfileWidgetState extends State<_UserProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider provider, Widget? child) {
      if ( provider.user.data != null) {
        widget.animationController!.forward();
        return AnimatedBuilder(
            animation: widget.animationController!,
            child: _ImageAndTextWidget(
              userId: provider.user.data!.userId!,
              loginUserId: provider.psValueHolder!.loginUserId!,
              data: provider.user.data!,
              userProvider: provider,
              itemDetailProvider: widget.itemDetailProvider!,
              addedItemProvider: widget.addedItemProvider,
            ),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                  opacity: widget.animation!,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - widget.animation!.value), 0.0),
                      child: child));
            });
      } else {
        return Container();
      }
    }));
  }
}

class _ImageAndTextWidget extends StatefulWidget {
  const _ImageAndTextWidget({
    Key? key,
    required this.userId,
    required this.loginUserId,
    required this.data,
    required this.userProvider,
    required this.itemDetailProvider,
    required this.addedItemProvider,
  }) : super(key: key);

  final String userId;
  final String loginUserId;
  final User data;
  final UserProvider userProvider;
  final ItemDetailProvider itemDetailProvider;
  final AddedItemProvider? addedItemProvider;

  @override
  __ImageAndTextWidgetState createState() => __ImageAndTextWidgetState();
}

class __ImageAndTextWidgetState extends State<_ImageAndTextWidget> {
  @override
  Widget build(BuildContext context) {
            final PsValueHolder valueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space8,
    );
    const Widget _minispacingWidget = SizedBox(
      height: PsDimens.space4,
    );
    const Widget _dividerWidget = Divider(
      height: 1,
    ); 
    return Padding(
      padding: const EdgeInsets.all(PsDimens.space16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // _imageWidget,
              Container(
                width: PsDimens.space76,
                height: PsDimens.space80,
                child: PsNetworkCircleImageForUser(
                  photoKey: '',
                  imagePath: widget.data.userProfilePhoto,
                  // width: PsDimens.space76,
                  // height: PsDimens.space80,
                  boxfit: BoxFit.cover,
                  onTap: () {},
                ),
              ),
              const SizedBox(
                width: PsDimens.space12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.data.userName!,
                        style: Theme.of(context).textTheme.subtitle1),
                        if (widget.data.applicationStatus == PsConst.ONE &&
                            widget.data.applyTo == PsConst.ONE &&
                            widget.data.userType == PsConst.ONE)
                          Container(
                            margin:
                                const EdgeInsets.only(left: PsDimens.space2),
                            child: Icon(
                             Icons.check_circle,
                              color: PsColors.bluemarkColor,
                              size: valueHolder.bluemarkSize,
                            ),
                          )
                      ],
                    ),    
                    if (widget.data.applicationStatus == PsConst.ONE &&
                        widget.data.applyTo == PsConst.ONE &&
                        widget.data.userType == PsConst.ONE)
                    Visibility(
                      child: Container(
                        width: PsDimens.space160,
                        child: MaterialButton(
                            color: PsColors.mainColor,
                            height: PsDimens.space28,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: PsColors.mainColor),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(18.0))),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.verified_user,
                                    color: PsColors.white,
                                    size: 20,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: PsDimens.space6,
                                      right: PsDimens.space6),
                                  child: Text(
                                    Utils.getString(
                                        context, 'seller_info_tile__verified_dealer'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(color: PsColors.white),
                                    ),
                                  ),
                                ]),
                                onPressed: () {},
                            ),
                        ),
                      )
                      else
                        _spacingWidget,
                    _RatingWidget(
                      data: widget.data,
                    ),
                    _spacingWidget,
                    if (widget.data.isShowPhone == '1')
                      Visibility(
                        visible: true,
                        child: Row(
                          children: <Widget>[
                            const Icon(
                              Icons.phone,
                            ),
                            const SizedBox(
                              width: PsDimens.space8,
                            ),
                            InkWell(
                              child: Text(
                                widget.data.userPhone!,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              onTap: () async {
                                if (await canLaunchUrl(
                                   Uri.parse('tel://${widget.data.userPhone}') )) {
                                  await launchUrl(
                                      Uri.parse('tel://${widget.data.userPhone}'));
                                } else {
                                  throw 'Could not Call Phone Number 1';
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      _minispacingWidget,
                      if (widget.data.isShowEmail == '1')
                      Visibility(
                        child: Row(
                          children: <Widget>[
                            const Icon(
                              Icons.email,
                            ),
                            const SizedBox(
                              width: PsDimens.space8,
                            ),
                            Text(
                              widget.data.userEmail!,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          _spacingWidget,
          if (widget.userProvider.psValueHolder!.loginUserId !=
              widget.userProvider.user.data!.userId)
            MaterialButton(
              color: PsColors.mainColor,
              height: 45,
              shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              child: widget.userProvider.user.data!.isFollowed == PsConst.ONE
                  ? Text(
                      Utils.getString(context, 'user_detail__unfollow'),
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: Colors.white),
                    )
                  : Text(
                      Utils.getString(context, 'user_detail__follow'),
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: Colors.white),
                    ),
              onPressed: () async {
                if (await Utils.checkInternetConnectivity()) {
                  Utils.navigateOnUserVerificationView(
                      widget.userProvider, context, () async {
                    if (widget.userProvider.user.data!.isFollowed ==
                        PsConst.ZERO) {
                      setState(() {
                        widget.userProvider.user.data!.isFollowed = PsConst.ONE;
                      });
                    } else {
                      setState(() {
                        widget.userProvider.user.data!.isFollowed = PsConst.ZERO;
                      });
                    }

                    final UserFollowHolder userFollowHolder = UserFollowHolder(
                        userId: widget.userProvider.psValueHolder!.loginUserId,
                        followedUserId: widget.data.userId);

                    final PsResource<User> _user = await widget.userProvider
                        .postUserFollow(userFollowHolder.toMap());
                    if (_user.data != null) {
                      if (_user.data!.isFollowed == PsConst.ONE) {
                        widget.userProvider.user.data!.isFollowed = PsConst.ONE;
                      } else {
                        widget.userProvider.user.data!.isFollowed = PsConst.ZERO;
                      }
                    }
                  });
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: Utils.getString(
                              context, 'error_dialog__no_internet'),
                        );
                      });
                }
              },
            ),
          _spacingWidget,
          _dividerWidget,
          _spacingWidget,
          InkWell(
            child: Text(
              widget.userProvider.user.data!.addedDateTimeStamp != null &&
              widget.userProvider.user.data!.addedDateTimeStamp != ''
                  ? '${Utils.getString(context, 'user_detail__joined')} - ${Utils.changeTimeStampToStandardDateTimeFormat(widget.data.addedDateTimeStamp)}'
                  : '${Utils.getString(context, 'user_detail__joined')} - ${Utils.getDateFormat(widget.data.addedDate!,valueHolder.dateFormat!)}',
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () async {},
          ),
          _spacingWidget,
          _VerifiedWidget(
            data: widget.data,
          ),
           if (Utils.showUI(widget.userProvider.psValueHolder!.blockedFeatureDisabled) )
          _BlockUserWidget(
            itemDetailProvider: widget.itemDetailProvider,
            userId: widget.userProvider.user.data!.userId!,
            loginUserId: widget.userProvider.psValueHolder!.loginUserId!,
            userProvider: widget.userProvider,
            addedItemProvider: widget.addedItemProvider!,
          ),
          _spacingWidget,
          _dividerWidget,
          _spacingWidget,
          _spacingWidget,
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, RoutePaths.userItemList,
                  arguments: ItemListIntentHolder(
                      userId: widget.data.userId!,
                      status: '1',
                      title: Utils.getString(context, 'profile__listing')));
            },
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'user_detail__listing'),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    Utils.getString(context, 'user_detail__view_all'),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: PsColors.mainColor),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _RatingWidget extends StatelessWidget {
  const _RatingWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  final User data;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          data.overallRating!,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const SizedBox(
          width: PsDimens.space8,
        ),
        if(data.ratingDetail != null &&
           data.ratingDetail!.totalRatingCount != null)
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, RoutePaths.ratingList,
                  arguments: data.userId);
          },
          child: SmoothStarRating(
              key: Key(data.ratingDetail!.totalRatingValue!),
              rating: double.parse(data.ratingDetail!.totalRatingValue!),
              allowHalfRating: false,
              isReadOnly: true,
              starCount: 5,
              size: PsDimens.space16,
              color: Colors.yellow,
              borderColor: Colors.blueGrey[200],
              onRated: (double? v) {},
              spacing: 0.0),
        ),
        const SizedBox(
          width: PsDimens.space8,
        ),
        Text(
          '( ${data.ratingCount} )',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }
}

class _VerifiedWidget extends StatelessWidget {
  const _VerifiedWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  final User data;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          Utils.getString(context, 'seller_info_tile__verified'),
          style: Theme.of(context).textTheme.bodyText1,
        ),
        if (data.facebookVerify == '1')
          const Padding(
            padding:
                EdgeInsets.only(left: PsDimens.space4, right: PsDimens.space4),
            child: Icon(
              FontAwesome.facebook_official,
            ),
          )
        else
          Container(),
        if (data.googleVerify == '1')
          const Padding(
            padding:
                EdgeInsets.only(left: PsDimens.space4, right: PsDimens.space4),
            child: Icon(
              FontAwesome.google,
            ),
          )
        else
          Container(),
        if (data.phoneVerify == '1')
          const Padding(
            padding:
                EdgeInsets.only(left: PsDimens.space4, right: PsDimens.space4),
            child: Icon(
              FontAwesome.phone,
            ),
          )
        else
          Container(),
        if (data.emailVerify == '1')
          const Padding(
            padding:
                EdgeInsets.only(left: PsDimens.space4, right: PsDimens.space4),
            child: Icon(
             Icons.email,
            ),
          )
        else
          Container(),
      ],
    );
  }
}

class _BlockUserWidget extends StatelessWidget {
  const _BlockUserWidget(
      {required this.userId,
      required this.loginUserId,
      required this.itemDetailProvider,
      required this.addedItemProvider,
      required this.userProvider});

  final String userId;
  final String loginUserId;
  final ItemDetailProvider itemDetailProvider;
  final UserProvider userProvider;
  final AddedItemProvider addedItemProvider;


  @override
  Widget build(BuildContext context) {
     final PsValueHolder psValueHolder = Provider.of<PsValueHolder>(context);
    return Visibility(
      visible: itemDetailProvider.psValueHolder!.loginUserId != userId &&
          itemDetailProvider.psValueHolder!.loginUserId != null &&
          itemDetailProvider.psValueHolder!.loginUserId != '',
      child: Padding(
          padding: const EdgeInsets.only(
            right: PsDimens.space8,
            top: PsDimens.space8,
          ),
          child: Row(children: <Widget>[
            InkWell(
                child: Text(
                   (userProvider.user.data!.isBlocked== PsConst.ONE) ? 
                  Utils.getString(context, 'user_detail__un_block_user') :
                  Utils.getString(context, 'user_detail__block_user'),
                  style: const TextStyle(decoration: TextDecoration.underline),
                ),
                onTap: () async {
                  if (userProvider.user.data!.isBlocked== PsConst.ONE) 
                    showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmDialogView(
                            description: Utils.getString(context,
                                'blocked_user__unblock_confirm'),
                            leftButtonText:
                                Utils.getString(context, 'dialog__cancel'),
                            rightButtonText:
                                Utils.getString(context, 'dialog__ok'),
                            onAgreeTap: () async {
                              await PsProgressDialog.showDialog(context);

                              final UnblockUserHolder
                                          userBlockItemParameterHolder =
                                          UnblockUserHolder(
                                              fromBlockUserId: userProvider
                                                  .psValueHolder!.loginUserId,
                                              toBlockUserId: userId);

                                      // ignore: unused_local_variable
                                      final PsResource<ApiStatus> _apiStatus =
                                          await userProvider.postUnBlockUser(
                                              userBlockItemParameterHolder
                                                  .toMap());
                                      if (_apiStatus.data != null &&
                                              _apiStatus.data!.status != null)  {
                                          PsProgressDialog.dismissDialog();
                                          Navigator.pop(context);  

                                          await addedItemProvider.loadItemList(
                                            Utils.checkUserLoginId(psValueHolder),
                                             addedItemProvider.addedUserParameterHolder);     

                                          await userProvider.getOtherUserData(
                                            userProvider.userParameterHolder.toMap(),
                                            userProvider.userParameterHolder.id!); 
                                          
                                      }            
                                      // Navigator.of(context).popUntil(
                                      //       ModalRoute.withName(RoutePaths.home));
                            });
                      });
                  else 
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmDialogView(
                            description: Utils.getString(context,
                                'item_detail__confirm_dialog_block_user'),
                            leftButtonText:
                                Utils.getString(context, 'dialog__cancel'),
                            rightButtonText:
                                Utils.getString(context, 'dialog__ok'),
                            onAgreeTap: () async {
                              await PsProgressDialog.showDialog(context);

                              final UserBlockParameterHolder
                                  userBlockItemParameterHolder =
                                  UserBlockParameterHolder(
                                      loginUserId: loginUserId,
                                      addedUserId: userId);

                              final PsResource<ApiStatus> _apiStatus =
                                  await userProvider.blockUser(
                                      userBlockItemParameterHolder.toMap());

                              if (
                                  _apiStatus.data != null &&
                                  _apiStatus.data!.status != null) {
                                await itemDetailProvider
                                    .deleteLocalProductCacheByUserId(
                                        loginUserId, userId);
                              }

                              PsProgressDialog.dismissDialog();
                              Navigator.of(context).popUntil(
                                  ModalRoute.withName(RoutePaths.home));
                            });
                      });
                })
          ])),
    );
  }
}
