import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/blocked_user.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';

class BlockedUserVerticalListItem extends StatelessWidget {
  const BlockedUserVerticalListItem(
      {Key? key,
      required this.blockedUser,
      this.onTap,
      this.onUnblockTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final BlockedUser blockedUser;
  final Function? onTap;
  final Function? onUnblockTap;
  final AnimationController? animationController;
  final Animation<double> ?animation;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();

    return AnimatedBuilder(
        animation: animationController!,
        child: InkWell(
          onTap: onTap  as void Function()?,
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(bottom: PsDimens.space4),
            child: Ink(
              color: PsColors.backgroundColor,
              child: Padding(
                  padding: const EdgeInsets.all(PsDimens.space16),
                  child: UserWidget(
                      user: blockedUser,
                      onTap: onTap!,
                      onUnblockTap: onUnblockTap!)),
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
  const UserWidget(
      {Key? key,
      required this.user,
      required this.onTap,
      required this.onUnblockTap})
      : super(key: key);

  final BlockedUser user;
  final Function onTap;
  final Function onUnblockTap;

  @override
  Widget build(BuildContext context) {
     final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context);
    // final Widget _imageWidget = PsNetworkCircleImageForUser(
    //   photoKey: '',
    //   imagePath: user.userProfilePhoto ?? '',
    //   width: PsDimens.space44,
    //   height: PsDimens.space44,
    //   boxfit: BoxFit.cover,
    //   onTap: () {
    //     onTap();
    //   },
    // );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            // _imageWidget,
            Container(
              width: PsDimens.space44,
              height: PsDimens.space44,
              child: PsNetworkCircleImageForUser(
                photoKey: '',
                imagePath: user.userProfilePhoto ?? '',
                // width: PsDimens.space44,
                // height: PsDimens.space44,
                boxfit: BoxFit.cover,
                onTap: () {
                  onTap();
                },
              ),
            ),
            const SizedBox(
              width: PsDimens.space12,
            ),
            Expanded(
              child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                  (user.userName == '' || user.userName == null)
                      ? Utils.getString(context, 'default__user_name')
                      : user.userName!,
                  style: Theme.of(context).textTheme.subtitle1),
                        if (user.applicationStatus == PsConst.ONE &&
                            user.applyTo == PsConst.ONE &&
                            user.userType == PsConst.ONE)
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
            ),
            MaterialButton(
                color: PsColors.mainColor,
                height: 30,
                shape: const BeveledRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(PsDimens.space2)),
                ),
                child: Text(
                  Utils.getString(context, 'blocked_user__unblock'),
                  style: Theme.of(context)
                      .textTheme
                      .button!
                      .copyWith(color: Colors.white),
                ),
                onPressed: () {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmDialogView(
                            description: Utils.getString(
                                context, 'blocked_user__unblock_confirm'),
                            leftButtonText:
                                Utils.getString(context, 'dialog__cancel'),
                            rightButtonText:
                                Utils.getString(context, 'dialog__ok'),
                            onAgreeTap: () async {
                              Navigator.of(context).pop();

                              onUnblockTap();
                            });
                      });
                })
          ],
        ),
      ],
    );
  }
}
