import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/user/user_provider.dart';
import 'package:flutteradhouse/repository/user_repository.dart';
import 'package:flutteradhouse/ui/common/dialog/error_dialog.dart';
import 'package:flutteradhouse/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutteradhouse/ui/common/ps_button_widget.dart';
import 'package:flutteradhouse/utils/ps_progress_dialog.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/verify_phone_internt_holder.dart';
import 'package:provider/provider.dart';

class EditPhoneSignInView extends StatefulWidget {
  const EditPhoneSignInView(
      {Key? key,
      this.animationController,
      this.goToLoginSelected,
      this.phoneSignInSelected})
      : super(key: key);
  final AnimationController? animationController;
  final Function? goToLoginSelected;
  final Function? phoneSignInSelected;
  @override
  _EditPhoneSignInViewState createState() => _EditPhoneSignInViewState();
}

class _EditPhoneSignInViewState extends State<EditPhoneSignInView>
    with SingleTickerProviderStateMixin {
  final TextEditingController phoneController = TextEditingController();
  UserRepository? repo1;
  PsValueHolder? psValueHolder;
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

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController!,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    animationController!.forward();
    repo1 = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
      child: ChangeNotifierProvider<UserProvider>(
        lazy: false,
        create: (BuildContext context) {
          final UserProvider provider =
              UserProvider(repo: repo1, psValueHolder: psValueHolder);
          return provider;
        },
        child: Consumer<UserProvider>(builder:
            (BuildContext context, UserProvider provider, Widget? child) {
          return Stack(
            children: <Widget>[
              SingleChildScrollView(
                  child: AnimatedBuilder(
                      animation: animationController!,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          _HeaderIconAndTextWidget(),
                          _CardWidget(
                            phoneController: phoneController,
                          ),
                          const SizedBox(
                            height: PsDimens.space8,
                          ),
                          _SendButtonWidget(
                            provider: provider,
                            phoneController: phoneController,
                            phoneSignInSelected: widget.phoneSignInSelected,
                          ),
                        ],
                      ),
                      builder: (BuildContext context, Widget? child) {
                        return FadeTransition(
                          opacity: animation,
                          child: Transform(
                              transform: Matrix4.translationValues(
                                  0.0, 100 * (1.0 - animation.value), 0.0),
                              child: child),
                        );
                      }))
            ],
          );
        }),
      ),
    );
  }
}

class _HeaderIconAndTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget _textWidget = Text(
      Utils.getString(context, 'app_name'),
      style: Theme.of(context).textTheme.subtitle1!.copyWith(
            color: PsColors.mainColor,
          ),
    );

    final Widget _imageWidget = Container(
      width: 90,
      height: 90,
      child: Image.asset(
        'assets/images/flutter_adhouse_logo.png',
      ),
    );
    return Column(
      children: <Widget>[
        const SizedBox(
          height: PsDimens.space32,
        ),
        _imageWidget,
        const SizedBox(
          height: PsDimens.space8,
        ),
        _textWidget,
        const SizedBox(
          height: PsDimens.space52,
        ),
      ],
    );
  }
}

class _CardWidget extends StatelessWidget {
  const _CardWidget({required this.phoneController});

  final TextEditingController phoneController;
  @override
  Widget build(BuildContext context) {
    const EdgeInsets _marginEdgeInsetsforCard = EdgeInsets.only(
        left: PsDimens.space16,
        right: PsDimens.space16,
        top: PsDimens.space4,
        bottom: PsDimens.space4);
    return Column(
      children: <Widget>[
        Text(
          'Enter your new phone number',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 0.3,
          margin: const EdgeInsets.only(
              left: PsDimens.space32, right: PsDimens.space32),
          child: Container(
            margin: _marginEdgeInsetsforCard,
            child: Directionality(
                textDirection: Directionality.of(context) == TextDirection.ltr
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                child: TextField(
                  controller: phoneController,
                  textDirection: TextDirection.ltr,
                  textAlign: Directionality.of(context) == TextDirection.ltr
                      ? TextAlign.left
                      : TextAlign.right,
                  style: Theme.of(context).textTheme.button!.copyWith(),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '+959123456789',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: PsColors.textPrimaryLightColor),
                      icon: Icon(Icons.phone,
                          color: Theme.of(context).iconTheme.color)),
                  // keyboardType: TextInputType.number,
                )),
          ),
        ),
      ],
    );
  }
}

class _SendButtonWidget extends StatefulWidget {
  const _SendButtonWidget(
      {required this.provider,
      required this.phoneController,
      required this.phoneSignInSelected});
  final UserProvider provider;
  final TextEditingController phoneController;
  final Function? phoneSignInSelected;

  @override
  __SendButtonWidgetState createState() => __SendButtonWidgetState();
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

class __SendButtonWidgetState extends State<_SendButtonWidget> {
  Future<String> verifyPhone() async {
    String? verificationId;
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      verificationId = verId;
      PsProgressDialog.dismissDialog();
    };
    final PhoneCodeSent smsCodeSent =
        (String verId, [int? forceCodeResend]) async {
      verificationId = verId;
      PsProgressDialog.dismissDialog();
      print('code has been send');

      final dynamic returnEditPhone = await Navigator.pushNamed(
          context, RoutePaths.edit_phone_verify_container,
          arguments: VerifyPhoneIntentHolder(
              userName: '',
              phoneNumber: widget.phoneController.text,
              phoneId: verificationId!));
      if (returnEditPhone != null && returnEditPhone is String) {
        Navigator.pop(context, returnEditPhone);
      }
    };
    final PhoneVerificationCompleted verifySuccess = (AuthCredential user) {
      print('verify');
      PsProgressDialog.dismissDialog();
    };
    final PhoneVerificationFailed verifyFail =
        (FirebaseAuthException exception) {
      print('${exception.message}');
      PsProgressDialog.dismissDialog();
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: '${exception.message}',
            );
          });
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneController.text,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(minutes: 2),
        verificationCompleted: verifySuccess,
        verificationFailed: verifyFail);
    return verificationId!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space32, right: PsDimens.space32),
      child: PSButtonWidget(
          hasShadow: true,
          width: double.infinity,
          titleText: Utils.getString(context, 'edit_phone_btn'),
          onPressed: () async {
            await PsProgressDialog.showDialog(context);
            await verifyPhone();
          }),
    );
  }
}
