import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/ui/common/smooth_star_rating_widget.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/user.dart';

class SearchUserVerticalListItem extends StatelessWidget {
  const SearchUserVerticalListItem(
      {Key? key,
      required this.user,
      required this.currentUser,
      this.onTap,
      this.onFollowBtnTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final User user;
  final String? currentUser;
  final Function? onTap;
  final Function? onFollowBtnTap;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();

    return AnimatedBuilder(
        animation: animationController!,
        child: InkWell(
          onTap: onTap as void Function()?,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: PsDimens.space96,
            decoration: BoxDecoration(
            color: PsColors.mainLightColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(PsDimens.space10)),
              ),
            margin: const EdgeInsets.only(bottom: PsDimens.space12,left: PsDimens.space14,right: PsDimens.space14),
            child: Padding(
                  padding: const EdgeInsets.only(
                    top:PsDimens.space8, bottom: PsDimens.space8, 
                    left: PsDimens.space12, right: PsDimens.space12),
                  child: UserWidget(user: user, currentUser: currentUser, onFollowBtnTap: onFollowBtnTap)
                  //  Card(
                  //   elevation: 0.0,
                  //   child: ClipPath(
                  //     child: Container(
                  //         height: PsDimens.space120,
                  //         margin: const EdgeInsets.all(PsDimens.space8),
                  //         child: UserWidget(user: user, onTap: onTap)),
                  //     clipper: ShapeBorderClipper(
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(4))),
                  //   ),
                  // )
                  ),
            
          ),
        ),
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
              opacity: animation!,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation!.value), 0.0),
                  child: child));
        });
  }
}

class UserWidget extends StatelessWidget {
  const UserWidget({
    Key? key,
    required this.user,
    required this.currentUser,
    this.onFollowBtnTap,
  }) : super(key: key);

  final User user;
  final String? currentUser;
  final Function? onFollowBtnTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: PsDimens.space44,
          height: PsDimens.space44,
          child: PsNetworkCircleImageForUser(
            photoKey: '',
            imagePath: user.userProfilePhoto ?? '',
            boxfit: BoxFit.cover,
            
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                          user.userName == ''
                              ? Utils.getString(context, 'default__user_name')
                              : user.userName ?? '',
                              textAlign: TextAlign.start,
                           overflow: TextOverflow.ellipsis,
                           maxLines: 1,
                          style: Theme.of(context).textTheme.subtitle1),

                  ),
              if (user.userAboutMe != '')
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text(
                          user.userAboutMe!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: PsColors.textPrimaryColor
                )),
              ),
              _RatingWidget(
                data: user,
              ),
            ],
          ),
        ),
        Visibility(
          visible: currentUser != user.userId,
          child: MaterialButton(
          color: PsColors.mainColor,
          
          height: 32,
          shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(PsDimens.space8)),
          ),

          onPressed: onFollowBtnTap as void Function()?,
          child: Text(
            user.isFollowed == PsConst.ZERO ? Utils.getString(context, 'profile__follow') : Utils.getString(context, 'profile__following'),
            style: Theme.of(context)
                .textTheme
                .button!
                .copyWith(color: Colors.white),
          ),
          ),
        )
      ],
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
        const SizedBox(
          width: PsDimens.space8,
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, RoutePaths.ratingList,
                arguments: data.userId);
          },
          child: SmoothStarRating(
              key: Key(data.ratingDetail!.totalRatingValue ?? ''),
              rating: double.parse(data.ratingDetail!.totalRatingValue ?? ''),
              allowHalfRating: false,
              isReadOnly: true,
              starCount: 5,
              size: PsDimens.space16,
              color: PsColors.mainColor,
              borderColor: PsColors.iconColor,
              onRated: (double? v) {},
              spacing: 0.0),
        ),
        const SizedBox(
          width: PsDimens.space8,
        ),
        Text(
          data.overallRating ?? '',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }
}
