import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/provider/user/user_provider.dart';
import 'package:flutteradhouse/repository/user_repository.dart';
import 'package:flutteradhouse/ui/common/dialog/error_dialog.dart';
import 'package:flutteradhouse/ui/common/dialog/success_dialog.dart';
import 'package:flutteradhouse/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutteradhouse/ui/common/ps_button_widget.dart';
import 'package:flutteradhouse/utils/ps_progress_dialog.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/profile_update_view_holder.dart';
import 'package:flutteradhouse/viewobject/user.dart' as obj;
import 'package:provider/provider.dart';

class EditPhoneVerifyView extends StatefulWidget {
  const EditPhoneVerifyView(
      {Key? key,
      required this.userName,
      required this.phoneNumber,
      required this.phoneId,
      required this.animationController,
      this.onProfileSelected,
      this.onSignInSelected})
      : super(key: key);

  final String userName;
  final String phoneNumber;
  final String phoneId;
  final AnimationController animationController;
  final Function? onProfileSelected, onSignInSelected;
  @override
  _EditPhoneVerifyViewState createState() => _EditPhoneVerifyViewState();
}

class _EditPhoneVerifyViewState extends State<EditPhoneVerifyView> {
  UserRepository? repo1;
  PsValueHolder? valueHolder;

  @override
  Widget build(BuildContext context) {
    widget.animationController.forward();

    const Widget _dividerWidget = Divider(
      height: PsDimens.space1,
    );

    repo1 = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    return ChangeNotifierProvider<UserProvider>(
      lazy: false,
      create: (BuildContext context) {
        final UserProvider provider =
            UserProvider(repo: repo1, psValueHolder: valueHolder);
        provider.getUser(valueHolder!.loginUserId!);
        return provider;
      },
      child: Consumer<UserProvider>(
          builder: (BuildContext context, UserProvider provider, Widget? child) {
        return SingleChildScrollView(
            child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
                color: PsColors.backgroundColor,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _dividerWidget,
                      _HeaderTextWidget(
                          userProvider: provider,
                          phoneNumber: widget.phoneNumber),
                      _TextFieldAndButtonWidget(
                        userName: widget.userName,
                        phoneNumber: widget.phoneNumber,
                        phoneId: widget.phoneId,
                        provider: provider,
                        onProfileSelected: widget.onProfileSelected,
                      ),
                    ],
                  ),
                )),
          ],
        ));
      }),
    );
  }
}

class _TextFieldAndButtonWidget extends StatefulWidget {
  const _TextFieldAndButtonWidget({
    required this.userName,
    required this.phoneNumber,
    required this.phoneId,
    required this.provider,
    this.onProfileSelected,
    // @required this.userId,
  });

  final String userName;
  final String phoneNumber;
  final String phoneId;
  final UserProvider provider;
  final Function? onProfileSelected;
  // final String userId;

  @override
  __TextFieldAndButtonWidgetState createState() =>
      __TextFieldAndButtonWidgetState();
}

dynamic callWarningDialog(BuildContext context, String text) {
  showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return WarningDialog(
          message: Utils.getString(context, text),
          onPressed: () {},
        );
      });
}

class __TextFieldAndButtonWidgetState extends State<_TextFieldAndButtonWidget> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController userIdTextField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: PsDimens.space40,
        ),
        TextField(
          textAlign: TextAlign.center,
          controller: codeController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: Utils.getString(
                context, 'email_verify__enter_verification_code'),
            hintStyle: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: PsColors.textPrimaryLightColor),
          ),
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(
          height: PsDimens.space16,
        ),
        Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space16, right: PsDimens.space16),
          child: PSButtonWidget(
            hasShadow: true,
            width: double.infinity,
            titleText: Utils.getString(context, 'email_verify__submit'),
            onPressed: () async {
              if (codeController.text.isEmpty) {
                callWarningDialog(context,
                    Utils.getString(context, 'warning_dialog__code_require'));
              } else if (codeController.text.length != 6) {
                callWarningDialog(context, 'Verification OTP code is wrong');
              } else {
                final fb_auth.User? user =
                    fb_auth.FirebaseAuth.instance.currentUser;

                if (user != null) {
                  print('correct code');
                  callApi(widget.provider, user, widget.phoneNumber, context);
                } else {
                  final fb_auth.AuthCredential credential =
                      fb_auth.PhoneAuthProvider.credential(
                          verificationId: widget.phoneId,
                          smsCode: codeController.text);

                  try {
                    await fb_auth.FirebaseAuth.instance
                        .signInWithCredential(credential)
                        .then((fb_auth.UserCredential? user) async {
                      if (user != null) {
                        print('correct code again');
                        callApi(widget.provider, user.user!, widget.phoneNumber,
                            context);
                        // showDialog<dynamic>(
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       return SuccessDialog(
                        //         message: Utils.getString(
                        //             context, 'success_dialog__success'),
                        //         onPressed: () {
                        //           Navigator.pop(context, true);
                        //         },
                        //       );
                        //     });
                      }
                    });
                  } on Exception {
                    print('show error');
                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return ErrorDialog(
                            message: Utils.getString(
                                context, 'error_dialog__code_wrong'),
                          );
                        });
                  }
                }
              }
            },
          ),
        )
      ],
    );
  }
}

class _HeaderTextWidget extends StatelessWidget {
  const _HeaderTextWidget(
      {required this.userProvider, required this.phoneNumber});
  final UserProvider userProvider;
  final String phoneNumber;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: PsDimens.space200,
      width: double.infinity,
      child: Stack(children: <Widget>[
        Container(
            color: PsColors.mainColor,
            padding: const EdgeInsets.only(
                left: PsDimens.space16, right: PsDimens.space16),
            height: PsDimens.space160,
            width: double.infinity,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: PsDimens.space28,
                ),
                Text(
                  Utils.getString(context, 'phone_signin__title1'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: PsColors.white),
                ),
                Text(
                   phoneNumber,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: PsColors.white),
                ),
              ],
            )),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 90,
            height: 90,
            child: const CircleAvatar(
              backgroundImage:
                  ExactAssetImage('assets/images/verify_email_icon.jpg'),
            ),
          ),
        )
      ]),
    );
  }
}

dynamic callApi(UserProvider userProvider, fb_auth.User user,
    String phoneNmuber, BuildContext context) async {
  if (await Utils.checkInternetConnectivity()) {
    final ProfileUpdateParameterHolder profileUpdateParameterHolder =
        ProfileUpdateParameterHolder(
            userId: userProvider.user.data!.userId,
            userName: userProvider.user.data!.userName!.isEmpty
                ? '-'
                : userProvider.user.data!.userName,
            userEmail: userProvider.user.data!.userEmail!.isEmpty
                ? 'default@gmail.com'
                : userProvider.user.data!.userEmail,
            userPhone: phoneNmuber,
            userAboutMe: userProvider.user.data!.userAboutMe!.isEmpty
                ? '-'
                : userProvider.user.data!.userAboutMe,
            isShowEmail: userProvider.user.data!.isShowEmail,
            isShowPhone: userProvider.user.data!.isShowPhone,
            userAddress: userProvider.user.data!.userAddress,
            city: userProvider.user.data!.city,
            deviceToken: userProvider.psValueHolder!.deviceToken);
    // final ProgressDialog progressDialog = loadingDialog(context);
    // progressDialog.show();
    await PsProgressDialog.showDialog(context);
    final PsResource<obj.User> _apiStatus = await userProvider
        .postProfileUpdate(profileUpdateParameterHolder.toMap());
    if (_apiStatus.data != null) {
      // progressDialog.dismiss();
      PsProgressDialog.dismissDialog();
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext contet) {
            return SuccessDialog(
              message: Utils.getString(context, 'edit_profile__success'),
              onPressed: () {
                Navigator.pop(context, phoneNmuber);
              },
            );
          });
    } else {
      // progressDialog.dismiss();
      PsProgressDialog.dismissDialog();

      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: _apiStatus.message,
            );
          });
    }
  } else {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            message: Utils.getString(context, 'error_dialog__no_internet'),
          );
        });
  }
}
