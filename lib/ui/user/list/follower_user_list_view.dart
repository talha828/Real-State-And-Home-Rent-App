import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/user/user_list_provider.dart';
import 'package:flutteradhouse/repository/user_repository.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/ui/user/list/user_vertical_list_item.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/user_intent_holder.dart';
import 'package:provider/provider.dart';

class FollowerUserListView extends StatefulWidget {
  @override
  _FollowerUserListViewState createState() {
    return _FollowerUserListViewState();
  }
}

class _FollowerUserListViewState extends State<FollowerUserListView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  UserListProvider? _userListProvider;

  AnimationController? animationController;

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final String loginUserId =
            Utils.checkUserLoginId(_userListProvider!.psValueHolder!);
        _userListProvider!.followerUserParameterHolder.loginUserId = loginUserId;
        _userListProvider!
            .nextUserList(_userListProvider!.followerUserParameterHolder);
      }
    });
  }

  UserRepository? repo1;
  PsValueHolder? psValueHolder;
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

    timeDilation = 1.0;
    repo1 = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<UserListProvider>(
          appBarTitle: Utils.getString(context, 'follower__title') ,
          initProvider: () {
            return UserListProvider(repo: repo1, psValueHolder: psValueHolder);
          },
          onProviderReady: (UserListProvider provider) {
            final String loginUserId =
                Utils.checkUserLoginId(provider.psValueHolder!);

            provider.followerUserParameterHolder.loginUserId = loginUserId;
            provider.loadUserList(provider.followerUserParameterHolder);

            _userListProvider = provider;
          },
          builder:
              (BuildContext context, UserListProvider provider, Widget? child) {
            return Stack(children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(
                      top: PsDimens.space8, bottom: PsDimens.space8),
                  child: RefreshIndicator(
                    child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                if (provider.userList.data != null ||
                                    provider.userList.data!.isNotEmpty) {
                                  final int count =
                                      provider.userList.data!.length;
                                  return UserVerticalListItem(
                                    animationController: animationController!,
                                    animation:
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(
                                      CurvedAnimation(
                                        parent: animationController!,
                                        curve: Interval(
                                            (1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn),
                                      ),
                                    ),
                                    user: provider.userList.data![index],
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, RoutePaths.userDetail,
                                          arguments: UserIntentHolder(
                                              userId: provider
                                                  .userList.data![index].userId!,
                                              userName: provider.userList
                                                  .data![index].userName!));
                                    },
                                  );
                                } else {
                                  return null;
                                }
                              },
                              childCount: provider.userList.data!.length,
                            ),
                          ),
                        ]),
                    onRefresh: () async {
                      provider.followerUserParameterHolder.loginUserId =
                          provider.psValueHolder!.loginUserId;
                      return _userListProvider!
                          .resetUserList(provider.followerUserParameterHolder);
                    },
                  )),
              PSProgressIndicator(provider.userList.status)
            ]);
          }),
    );
  }
}
