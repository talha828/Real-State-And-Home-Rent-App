import 'package:flutter/material.dart';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/user/user_provider.dart';
import 'package:flutteradhouse/repository/user_repository.dart';
import 'package:flutteradhouse/ui/common/dialog/error_dialog.dart';
import 'package:flutteradhouse/ui/common/dialog/success_dialog.dart';
import 'package:flutteradhouse/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutteradhouse/ui/common/ps_button_widget.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/api_status.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/resend_code_holder.dart';
import 'package:flutteradhouse/viewobject/holder/user_email_verify_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/user.dart';
import 'package:provider/provider.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView(
      {Key? key,
      this.animationController,
      this.onProfileSelected,
      this.onSignInSelected,
      this.userId})
      : super(key: key);

  final AnimationController? animationController;
  final Function? onProfileSelected, onSignInSelected;
  final String? userId;
  @override
  _VerifyEmailViewState createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  UserRepository? repo1;
  PsValueHolder? valueHolder;

  @override
  Widget build(BuildContext context) {
    widget.animationController!.forward();

    const Widget _dividerWidget = Divider(
      height: PsDimens.space2,
    );

    repo1 = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    return ChangeNotifierProvider<UserProvider>(
      lazy: false,
      create: (BuildContext context) {
        final UserProvider provider =
            UserProvider(repo: repo1, psValueHolder: valueHolder);
        // provider.postUserRegister(userRegisterParameterHolder.toMap());
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
                      ),
                      _TextFieldAndButtonWidget(
                        provider: provider,
                        onProfileSelected: widget.onProfileSelected!,
                        userId: widget.userId!,
                      ),
                      Column(
                        children: const <Widget>[
                          SizedBox(
                            height: PsDimens.space16,
                          ),
                          Divider(
                            height: PsDimens.space1,
                          ),
                          SizedBox(
                            height: PsDimens.space32,
                          )
                        ],
                      ),
                      _ChangeEmailAndRecentCodeWidget(
                        provider: provider,
                        userEmailText: provider.psValueHolder!.userIdToVerify!,
                        onSignInSelected: widget.onSignInSelected!,
                      ),
                    ],
                  ),
                )),
            //_imageInCenterWidget,
          ],
        ));
      }),
    );
  }
}

class _TextFieldAndButtonWidget extends StatefulWidget {
  const _TextFieldAndButtonWidget({
    required this.provider,
    this.onProfileSelected,
    required this.userId,
  });
  final UserProvider provider;
  final Function? onProfileSelected;
  final String userId;

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
    final PsValueHolder psValueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
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
                } else {
                  if (await Utils.checkInternetConnectivity()) {
                    final EmailVerifyParameterHolder
                        emailVerifyParameterHolder = EmailVerifyParameterHolder(
                      userId: (psValueHolder.userIdToVerify ==
                                  null ||
                              psValueHolder.userIdToVerify ==
                                  '')
                          ? widget.userId
                          : psValueHolder.userIdToVerify,
                      code: codeController.text,
                    );

                    final PsResource<User> _apiStatus = await widget.provider
                        .postUserEmailVerify(
                            emailVerifyParameterHolder.toMap());

                    if (_apiStatus.data != null) {
                      widget.provider.replaceVerifyUserData('', '', '', '');
                      widget.provider
                          .replaceLoginUserId(_apiStatus.data!.userId!);
                      widget.provider
                          .replaceLoginUserName(_apiStatus.data!.userName!);

                      if (widget.onProfileSelected != null) {
                        await widget.provider
                            .replaceVerifyUserData('', '', '', '');
                        await widget.provider
                            .replaceLoginUserId(_apiStatus.data!.userId!);
                        await widget.provider
                            .replaceLoginUserName(_apiStatus.data!.userName!);
                        await widget.onProfileSelected!(_apiStatus.data!.userId!);
                      } else {
                        Navigator.pop(context, _apiStatus.data);
                      }
                    } else {
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
                            message: Utils.getString(
                                context, 'error_dialog__no_internet'),
                          );
                        });
                  }
                }
              },
            ))
      ],
    );
  }
}

class _HeaderTextWidget extends StatelessWidget {
  const _HeaderTextWidget(
      {required this.userProvider});
  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
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
                  Utils.getString(context, 'email_verify__title1'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: PsColors.white),
                ),
                Text(
                  (psValueHolder.userEmailToVerify == null)
                      ? ''
                      : psValueHolder.userEmailToVerify!,
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

class _ChangeEmailAndRecentCodeWidget extends StatefulWidget {
  const _ChangeEmailAndRecentCodeWidget(
      {required this.provider,
      required this.userEmailText,
      this.onSignInSelected});
  final UserProvider provider;
  final String userEmailText;
  final Function? onSignInSelected;

  @override
  __ChangeEmailAndRecentCodeWidgetState createState() =>
      __ChangeEmailAndRecentCodeWidgetState();
}

class __ChangeEmailAndRecentCodeWidgetState
    extends State<_ChangeEmailAndRecentCodeWidget> {
  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        MaterialButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          height: 40,
          child: Text(Utils.getString(context, 'email_verify__change_email')),
          textColor: PsColors.mainColor,
          onPressed: () {
            if (widget.onSignInSelected != null) {
              widget.onSignInSelected!();
            } else {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(
                context,
                RoutePaths.user_register_container,
              );
            }
          },
        ),
        MaterialButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          height: 40,
          child: Text(Utils.getString(context, 'email_verify__resent_code')),
          textColor: PsColors.mainColor,
          onPressed: () async {
            if (await Utils.checkInternetConnectivity()) {
              final ResendCodeParameterHolder resendCodeParameterHolder =
                  ResendCodeParameterHolder(
                userEmail: psValueHolder.userEmailToVerify,
              );

              final PsResource<ApiStatus> _apiStatus = await widget.provider
                  .postResendCode(resendCodeParameterHolder.toMap());

              if (_apiStatus.data != null) {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return SuccessDialog(
                        message: _apiStatus.data!.message,
                        onPressed: () {},
                      );
                    });
              } else {
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
                      message:
                          Utils.getString(context, 'error_dialog__no_internet'),
                    );
                  });
            }
          },
        ),
      ],
    );
  }
}
