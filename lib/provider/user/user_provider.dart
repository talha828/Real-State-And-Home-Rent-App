import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/user_repository.dart';
import 'package:flutteradhouse/ui/common/dialog/error_dialog.dart';
import 'package:flutteradhouse/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutteradhouse/utils/ps_progress_dialog.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/api_status.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/apple_login_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/holder/facebook_login_user_holder.dart';
import 'package:flutteradhouse/viewobject/holder/fb_login_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/holder/google_login_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/holder/user_login_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/holder/user_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/holder/user_register_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/shipping_city.dart';
import 'package:flutteradhouse/viewobject/shipping_country.dart';
import 'package:flutteradhouse/viewobject/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class UserProvider extends PsProvider {
  UserProvider(
      {required UserRepository? repo,
      required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    isDispose = false;
    print('User Provider: $hashCode');
    userListStream = StreamController<PsResource<User>>.broadcast();
    subscription = userListStream.stream.listen((PsResource<User> resource) {
      if ( resource.data != null) {
        _user = resource;
        holderUser = resource.data!;
      }

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  UserRepository? _repo;
  PsValueHolder? psValueHolder;
  User? holderUser;
  ShippingCountry? selectedCountry;
  ShippingCity? selectedCity;
  bool isCheckBoxSelect = true;
  UserParameterHolder userParameterHolder =
      UserParameterHolder().getOtherUserData();

  PsResource<User> _user = PsResource<User>(PsStatus.NOACTION, '', null);
  PsResource<User> _holderUser = PsResource<User>(PsStatus.NOACTION, '', null);
  PsResource<User> get user => _user;

  PsResource<ApiStatus> _apiStatus =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get apiStatus => _apiStatus;

 late StreamSubscription<PsResource<User>> subscription;
 late StreamController<PsResource<User>> userListStream;
  final fb_auth.FirebaseAuth _firebaseAuth = fb_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? fbUserId;

  @override
  void dispose() {
    subscription.cancel();
    userListStream.close();
    isDispose = true;
    print('User Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postUserRegister(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo!.postUserRegister(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postUserEmailVerify(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo!.postUserEmailVerify(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postImageUpload(
    String userId,
    String platformName,
    File? imageFile,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo!.postImageUpload(userId, platformName, imageFile!,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postUserLogin(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo!.postUserLogin(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postForgotPassword(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo!.postForgotPassword(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<dynamic> postChangePassword(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo!.postChangePassword(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<dynamic> postProfileUpdate(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _holderUser = await _repo!.postProfileUpdate(
        jsonMap, isConnectedToInternet, PsStatus.SUCCESS);
    if (_holderUser.status == PsStatus.SUCCESS) {
      _user = _holderUser;
      return _holderUser;
    } else {
      return _holderUser;
    }
  }

  Future<dynamic> postPhoneLogin(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo!.postPhoneLogin(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postUserFollow(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo!.postUserFollow(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postFBLogin(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo!.postFBLogin(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postAppleLogin(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo!.postAppleLogin(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postGoogleLogin(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo!.postGoogleLogin(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postResendCode(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo!.postResendCode(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<dynamic> getUser(
    String loginUserId,
  ) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo!.getUser(userListStream, loginUserId, isConnectedToInternet,
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> getUserFromDB(String loginUserId) async {
    isLoading = true;

    await _repo!.getUserFromDB(
        loginUserId, userListStream, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> getOtherUserData(
      Map<dynamic, dynamic> jsonMap, String otherUserId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

   // _user = 
    await _repo!.getOtherUserData(userListStream, jsonMap, otherUserId,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> userReportItem(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo!.userReportItem(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<dynamic> blockUser(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo!.blockUser(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<dynamic> postUnBlockUser(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo!.postUnBlockUser(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<dynamic> postDeleteUser(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo!.postDeleteUser(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  ///
  /// Firebase Auth
  ///
  Future<fb_auth.User?> getCurrentFirebaseUser() async {
    final fb_auth.FirebaseAuth auth = fb_auth.FirebaseAuth.instance;
    final fb_auth.User? currentUser = auth.currentUser;
    return currentUser;
  }

  Future<void> handleFirebaseAuthError(BuildContext context, String email,
      {bool ignoreEmail = false}) async {
    if (email.isEmpty) {
      return;
    }

    final List<String> providers =
        await _firebaseAuth.fetchSignInMethodsForEmail(email);

    final String provider = providers.single;
    print('provider : $provider');
    // Registered With Email
    if (provider.contains(PsConst.emailAuthProvider) && !ignoreEmail) {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
              message: '[ $email ]\n' +
                  Utils.getString(context,
                      Utils.getString(context, 'auth__email_provider')),
              onPressed: () {},
            );
          });
    }
    // Registered With Google
    else if (provider.contains(PsConst.googleAuthProvider)) {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
              message: '[ $email ]\n' +
                  Utils.getString(context,
                      Utils.getString(context, 'auth__google_provider')),
              onPressed: () {},
            );
          });
    }
    // Registered With Facebook
    else if (provider.contains(PsConst.facebookAuthProvider)) {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
              message: '[ $email ]\n' +
                  Utils.getString(context,
                      Utils.getString(context, 'auth__facebook_provider')),
              onPressed: () {},
            );
          });
    }
    // Registered With Apple
    else if (provider.contains(PsConst.appleAuthProvider)) {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
              message: '[ $email ]\n' +
                  Utils.getString(context,
                      Utils.getString(context, 'auth__apple_provider')),
              onPressed: () {},
            );
          });
    }
  }

  ///
  /// Apple Login Related
  ///
  Future<void> loginWithAppleId(
      BuildContext context, Function? onAppleIdSignInSelected) async {
    ///
    /// Check User is Accept Terms and Conditions
    ///
    if (isCheckBoxSelect) {
      ///
      /// Check Connection
      ///
      if (await Utils.checkInternetConnectivity()) {
        ///
        /// Get Firebase User with Apple Id Login
        ///
        final fb_auth.User? firebaseUser =
            await _getFirebaseUserWithAppleId(context);

        if (firebaseUser != null) {
          ///
          /// Got Firebase User
          ///
          Utils.psPrint('User id : ${firebaseUser.uid}');

          ///
          /// Show Progress Dialog
          ///
          await PsProgressDialog.showDialog(context);

          ///
          /// Submit to backend
          ///
          final PsResource<User>? resourceUser =
              await _submitLoginWithAppleId(firebaseUser);

          ///
          /// Close Progress Dialog
          ///
          PsProgressDialog.dismissDialog();

          if (resourceUser != null && resourceUser.data != null) {
            ///
            /// Success
            ///
            if (onAppleIdSignInSelected != null) {
              onAppleIdSignInSelected(resourceUser.data!.userId);
            } else {
                    if (psValueHolder!.isForceLogin == true) {
                     if(psValueHolder!.isLanguageConfig == true){
                     Navigator.pushReplacementNamed(
                         context, RoutePaths.languagesetting);
                }else{
                    if (psValueHolder!.locationId != null) {
                            Navigator.pushNamed(
                              context,
                              RoutePaths.home,
                            );
                    } else {
                            Navigator.pushNamed(
                              context,
                              RoutePaths.itemLocationList,
                            );
                          }
                }
              } else {
                Navigator.pop(context, resourceUser.data);
              }
          
            }
          } else {
            ///
            /// Error from server
            ///
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  if (resourceUser != null) {
                    return ErrorDialog(
                      message: resourceUser.message,
                    );
                  } else {
                    return ErrorDialog(
                      message: Utils.getString(context, 'login__error_signin'),
                    );
                  }
                });
          }
        }
      } else {
        ///
        /// No Internet Connection
        ///
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(context, 'error_dialog__no_internet'),
              );
            });
      }
    } else {
      ///
      /// Not yet agree on Privacy Policy
      ///
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
              message: Utils.getString(context, 'login__warning_agree_privacy'),
              onPressed: () {},
            );
          });
    }
  }

  Future<PsResource<User>?> _submitLoginWithAppleId(fb_auth.User user) async {
    // ignore: unnecessary_null_comparison
    if (user != null) {
      String? email = user.email;
      if (email == null || email == '') {
        // if (user.providerData.isNotEmpty) {
        //   email = user.providerData[0].email;
        // }
        // Apple and Facebook
        if (user.providerData.isNotEmpty) {
          for (int i = 0; i < user.providerData.length; i++) {
            if (user.providerData[i].email != null &&
                user.providerData[i].email!.trim() != '') {
              email = user.providerData[i].email;
            }
          }

          // Email Checking
          email ??= '';
        }
      }
      final AppleLoginParameterHolder appleLoginParameterHolder =
          AppleLoginParameterHolder(
              appleId: user.uid,
              userName: user.displayName,
              userEmail: email,
              profilePhotoUrl: user.photoURL,
              deviceToken: psValueHolder!.deviceToken);

      final PsResource<User> _apiStatus =
          await postAppleLogin(appleLoginParameterHolder.toMap());

      if (_apiStatus.data != null) {
        await replaceVerifyUserData('', '', '', '');
        await replaceLoginUserId(_apiStatus.data!.userId!);
      }
      return _apiStatus;
    } else {
      return null;
    }
  }

  Future<fb_auth.User?> _getFirebaseUserWithAppleId(
      BuildContext context) async {
    final List<Scope> scopes = <Scope>[Scope.email, Scope.fullName];

    // 1. perform the sign-in request
    final AuthorizationResult result = await TheAppleSignIn.performRequests(
        <AppleIdRequest>[AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final AppleIdCredential appleIdCredential = result.credential!;

        final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
        final OAuthCredential credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        fb_auth.UserCredential authResult;
        try {
          authResult = await _firebaseAuth.signInWithCredential(credential);
        } on PlatformException catch (e) {
          print(e);

          handleFirebaseAuthError(context, appleIdCredential.email!);
          // Fail to Login to Firebase, must return null;
          return null;
        }
        fb_auth.User? firebaseUser = authResult.user;
        if (scopes.contains(Scope.fullName)) {
          String? displayName;

          displayName = null;

          if (appleIdCredential.fullName!.givenName != null) {
            displayName = '${appleIdCredential.fullName!.givenName}';
          }

          if (appleIdCredential.fullName!.familyName != null) {
            if (displayName != null) {
              displayName = '$displayName ';
            }

            if (displayName != null) {
              displayName += '${appleIdCredential.fullName!.familyName}';
            } else {
              displayName = '${appleIdCredential.fullName!.familyName}';
            }
          }

          if (displayName != null && displayName != ' ' && displayName != '') {
            await firebaseUser!.updateDisplayName(displayName);
          }
        }

        firebaseUser = _firebaseAuth.currentUser;

        return firebaseUser;
      case AuthorizationStatus.error:
        print(result.error.toString());
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
    }
  }

  ///
  /// Google Login Related
  ///
  Future<void> loginWithGoogleId(
      BuildContext context, Function? onGoogleIdSignInSelected) async {
    ///
    /// Check User is Accept Terms and Conditions
    ///
    if (isCheckBoxSelect) {
      ///
      /// Check Connection
      ///
      if (await Utils.checkInternetConnectivity()) {
        ///
        /// Get Firebase User with Google Id Login
        ///
        final fb_auth.User? firebaseUser = await _getFirebaseUserWithGoogleId();

        if (firebaseUser != null) {
          ///
          /// Got Firebase User
          ///
          Utils.psPrint('User id : ${firebaseUser.uid}');

          ///
          /// Show Progress Dialog
          ///
          await PsProgressDialog.showDialog(context);

          ///
          /// Submit to backend
          ///
          final PsResource<User>? resourceUser =
              await _submitLoginWithGoogleId(firebaseUser);

          ///
          /// Close Progress Dialog
          ///
          PsProgressDialog.dismissDialog();

          if (resourceUser != null && resourceUser.data != null) {
            ///
            /// Success
            ///
            if (onGoogleIdSignInSelected != null) {
              onGoogleIdSignInSelected(resourceUser.data!.userId);
            } else {
                    if (psValueHolder!.isForceLogin == true) {
                     if(psValueHolder!.isLanguageConfig == true){
                     Navigator.pushReplacementNamed(
                         context, RoutePaths.languagesetting);
                }else{
                    if (psValueHolder!.locationId != null) {
                            Navigator.pushNamed(
                              context,
                              RoutePaths.home,
                            );
                    } else {
                            Navigator.pushNamed(
                              context,
                              RoutePaths.itemLocationList,
                            );
                          }
                }
              } else {
                Navigator.pop(context, resourceUser.data);
              }
            }
          } else {
            ///
            /// Error from server
            ///
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  if (resourceUser != null) {
                    return ErrorDialog(
                      message: resourceUser.message,
                    );
                  } else {
                    return ErrorDialog(
                      message: Utils.getString(context, 'login__error_signin'),
                    );
                  }
                });
          }
        }
      } else {
        ///
        /// No Internet Connection
        ///
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(context, 'error_dialog__no_internet'),
              );
            });
      }
    } else {
      ///
      /// Not yet agree on Privacy Policy
      ///
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
              message: Utils.getString(context, 'login__warning_agree_privacy'),
              onPressed: () {},
            );
          });
    }
  }

  Future<fb_auth.User?> _getFirebaseUserWithGoogleId() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      //for not select any google acc
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final fb_auth.User? user =
          (await _firebaseAuth.signInWithCredential(credential)).user;
      print('signed in' + user!.displayName!);
      return user;
    } on Exception {
      print('not select google account');
      return null;
    }
  }

  Future<PsResource<User>?> _submitLoginWithGoogleId(fb_auth.User user) async {
    // ignore: unnecessary_null_comparison
    if (user != null) {
      String? email = user.email;
      if (email == null || email == '') {
        // if (user.providerData.isNotEmpty) {
        //   email = user.providerData[0].email;
        // }
        if (user.providerData.isNotEmpty) {
          for (int i = 0; i < user.providerData.length; i++) {
            if (user.providerData[i].email != null &&
                user.providerData[i].email!.trim() != '') {
              email = user.providerData[i].email;
              break;
            }
          }
        } else {
          return null;
        }
      }
      final GoogleLoginParameterHolder googleLoginParameterHolder =
          GoogleLoginParameterHolder(
        googleId: user.uid,
        userName: user.displayName,
        userEmail: email,
        profilePhotoUrl: user.photoURL,
        deviceToken: psValueHolder!.deviceToken,
      );

      final PsResource<User> _apiStatus =
          await postGoogleLogin(googleLoginParameterHolder.toMap());

      if (_apiStatus.data != null) {
        await replaceVerifyUserData('', '', '', '');
        await replaceLoginUserId(_apiStatus.data!.userId!);
      }

      return _apiStatus;
    } else {
      return null;
    }
  }

  ///
  /// Facebook Login Related
  ///
  Future<void> loginWithFacebookId(
      BuildContext context, Function? onFacebookIdSignInSelected) async {
    ///
    /// Check User is Accept Terms and Conditions
    ///
    if (isCheckBoxSelect) {
      ///
      /// Check Connection
      ///
      if (await Utils.checkInternetConnectivity()) {
        ///
        /// Get Firebase User with Facebook Id Login
        ///
        final FacebookLoginUserHolder? facebookLoginUserHolder =
            await _getFirebaseUserWithFacebookId(context);

        if (facebookLoginUserHolder != null ) {
          ///
          /// Got Firebase User
          ///
          Utils.psPrint(
              'User id : ${facebookLoginUserHolder.firebaseUser.uid}');

          ///
          /// Show Progress Dialog
          ///
          await PsProgressDialog.showDialog(context);

          ///
          /// Submit to backend
          ///
          final PsResource<User>? resourceUser =
              await _submitLoginWithFacebookId(facebookLoginUserHolder);

          ///
          /// Close Progress Dialog
          ///
          PsProgressDialog.dismissDialog();

          if (resourceUser != null && resourceUser.data != null) {
            ///
            /// Success
            ///
            if (onFacebookIdSignInSelected != null) {
              onFacebookIdSignInSelected(resourceUser.data!.userId);
            } else {
                     if (psValueHolder!.isForceLogin == true) {
                     if(psValueHolder!.isLanguageConfig == true){
                     Navigator.pushReplacementNamed(
                         context, RoutePaths.languagesetting);
                }else{
                    if (psValueHolder!.locationId != null) {
                            Navigator.pushNamed(
                              context,
                              RoutePaths.home,
                            );
                    } else {
                            Navigator.pushNamed(
                              context,
                              RoutePaths.itemLocationList,
                            );
                          }
                }
              } else {
                Navigator.pop(context, resourceUser.data);
              }
            }
          } else {
            ///
            /// Error from server
            ///
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  if (resourceUser != null ) {
                    return ErrorDialog(
                      message: resourceUser.message,
                    );
                  } else {
                    return ErrorDialog(
                      message: Utils.getString(context, 'login__error_signin'),
                    );
                  }
                });
          }
        }
      } else {
        ///
        /// No Internet Connection
        ///
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(context, 'error_dialog__no_internet'),
              );
            });
      }
    } else {
      ///
      /// Not yet agree on Privacy Policy
      ///
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
              message: Utils.getString(context, 'login__warning_agree_privacy'),
              onPressed: () {},
            );
          });
    }
  }

  Future<FacebookLoginUserHolder?> _getFirebaseUserWithFacebookId(
      BuildContext context) async {
    
    final LoginResult result = await FacebookAuth.instance.login();
   final String token = result.accessToken!.token;
    // Get User Info Based on the Access Token
    final dynamic graphResponse = await http.get(Uri.parse(
        'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=$token'));
    final dynamic profile = json.decode(graphResponse.body);

    // Firebase Base Login
    // ignore: unnecessary_null_comparison
    if (result != null) {
      final FacebookAuthCredential facebookAuthCredential = 
          FacebookAuthProvider.credential(result.accessToken!.token) as FacebookAuthCredential;

      fbUserId = result.accessToken!.userId;

      try {
        final fb_auth.User? user =
            (await _firebaseAuth.signInWithCredential(facebookAuthCredential)).user;
        print('signed in' + user!.displayName!);

        return FacebookLoginUserHolder(user, profile);
        // return user;
      } on PlatformException catch (e) {
        print(e);

        handleFirebaseAuthError(context, profile['email']);

        return null;
      }
    } else {
      return null;
    }
  }

  Future<PsResource<User>?> _submitLoginWithFacebookId(
      FacebookLoginUserHolder facebookLoginUserHolder) async {
    final fb_auth.User user = facebookLoginUserHolder.firebaseUser;
    // final dynamic facebookUser = facebookLoginUserHolder.facebookUser;
    // ignore: unnecessary_null_comparison
    if (user != null) {
      String? email = user.email;
      if (email == null || email == '') {
        // if (user.providerData.isNotEmpty) {
        //   email = user.providerData[0].email;
        // }
        if (user.providerData.isNotEmpty) {
          for (int i = 0; i < user.providerData.length; i++) {
            if (user.providerData[i].email != null &&
                user.providerData[i].email!.trim() != '') {
              email = user.providerData[i].email;
            }
          }

          // Email Checking
          email ??= '';
        }
      }
      final FBLoginParameterHolder fbLoginParameterHolder =
          FBLoginParameterHolder(
        facebookId: user.uid,
        userName: user.displayName,
        userEmail: email,
        profilePhotoUrl: '',
        deviceToken: psValueHolder!.deviceToken,
        profileImgId: fbUserId,
      );

      final PsResource<User> _apiStatus =
          await postFBLogin(fbLoginParameterHolder.toMap());

      if (_apiStatus.data != null) {
        await replaceVerifyUserData('', '', '', '');
        await replaceLoginUserId(_apiStatus.data!.userId!);
      }

      return _apiStatus;
    } else {
      return null;
    }
  }

  ///
  /// Email Login Related
  ///
  Future<void> loginWithEmailId(BuildContext context, String email,
      String password, Function? onProfileSelected) async {
    ///
    /// Check Connection
    ///
    if (await Utils.checkInternetConnectivity()) {
      ///
      /// Get Firebase User with Email Id Login
      ///

      await signInWithEmailAndPassword(context, email, email);

      ///
      /// Show Progress Dialog
      ///
      await PsProgressDialog.showDialog(context);

      ///
      /// Submit to backend
      ///
      final PsResource<User>? resourceUser =
          await _submitLoginWithEmailId(email, password);

      ///
      /// Close Progress Dialog
      ///
      PsProgressDialog.dismissDialog();

      if (resourceUser != null && resourceUser.data != null) {
        ///
        /// Success
        ///
        if (onProfileSelected != null) {
          onProfileSelected(resourceUser.data!.userId);
        } else {
                if (psValueHolder!.isForceLogin == true) {
                     if(psValueHolder!.isLanguageConfig == true){
                     Navigator.pushReplacementNamed(
                         context, RoutePaths.languagesetting);
                }else{
                    if (psValueHolder!.locationId != null) {
                            Navigator.pushNamed(
                              context,
                              RoutePaths.home,
                            );
                    } else {
                            Navigator.pushNamed(
                              context,
                              RoutePaths.itemLocationList,
                            );
                          }
                }
              } else {
                Navigator.pop(context, resourceUser.data);
              }
        }
      } else {
        ///
        /// Error from server
        ///
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              if (resourceUser != null ) {
                return ErrorDialog(
                  message: resourceUser.message,
                );
              } else {
                return ErrorDialog(
                  message: Utils.getString(context, 'login__error_signin'),
                );
              }
            });
      }
    } else {
      ///
      /// No Internet Connection
      ///
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'error_dialog__no_internet'),
            );
          });
    }
  }

  Future<fb_auth.User> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    fb_auth.UserCredential result;
    fb_auth.User? user;
    try {
      result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
    } on Exception catch (e1) {
      print(e1);

      final fb_auth.User? _user = await createUserWithEmailAndPassword(
          context, email, password,
          ignoreHandleFirebaseAuthError: true);

      // Sign In as Dummy User
      if (_user == null) {
        try {
          result = await _firebaseAuth.signInWithEmailAndPassword(
              email: PsConst.defaultEmail, password: PsConst.defaultPassword);
          user = result.user;
        } on PlatformException catch (e) {
          print(e);
          final fb_auth.User? _user2 = await createUserWithEmailAndPassword(
              context, PsConst.defaultEmail, PsConst.defaultPassword,
              ignoreHandleFirebaseAuthError: true);

          if (_user2 != null) {
            user = _user2;
          }
        }
      } else {
        user = _user;
      }
    }

    print('signInEmail succeeded: $user');

    return user!;
  }

  Future<PsResource<User>> _submitLoginWithEmailId(
      String email, String password) async {
    final UserLoginParameterHolder userLoginParameterHolder =
        UserLoginParameterHolder(
      userEmail: email,
      userPassword: password,
      deviceToken: psValueHolder!.deviceToken,
    );

    final PsResource<User> _apiStatus =
        await postUserLogin(userLoginParameterHolder.toMap());

    if (_apiStatus.data != null) {
      await replaceVerifyUserData('', '', '', '');
      await replaceLoginUserId(_apiStatus.data!.userId!);
    }
    return _apiStatus;
  }

  ///
  /// Email Register Related
  ///
  Future<void> signUpWithEmailId(
      BuildContext context,
      Function? onRegisterSelected,
      String name,
      String email,
      String password) async {
    ///
    /// Check User is Accept Terms and Conditions
    ///
    if (isCheckBoxSelect) {
      ///
      /// Check Connection
      ///
      if (await Utils.checkInternetConnectivity()) {
        ///
        /// Get Firebase User with Email Id Login
        ///
        final fb_auth.User? firebaseUser =
            await createUserWithEmailAndPassword(context, email, email);

        if (firebaseUser != null) {
          ///
          /// Show Progress Dialog
          ///
          await PsProgressDialog.showDialog(context);

          ///
          /// Submit to backend
          ///
          final PsResource<User>? resourceUser = await _submitSignUpWithEmailId(
              context, onRegisterSelected!, name, email, password);

          ///
          /// Close Progress Dialog
          ///
          ///
          PsProgressDialog.dismissDialog();

          if (resourceUser != null && resourceUser.data != null) {
            ///
            /// Success
            /// 
            final User user = resourceUser.data!;
            if (user.status == PsConst.ONE) {
              // Approval Off
              await replaceVerifyUserData('', '', '', '');
              await replaceLoginUserId(resourceUser.data!.userId!);

              // ignore: unnecessary_null_comparison
              if (onRegisterSelected != null) {
                onRegisterSelected(resourceUser.data);
              } else {
                // Register Screen Pop
                       if (psValueHolder!.isForceLogin == true) {
                     if(psValueHolder!.isLanguageConfig == true){
                     Navigator.pushReplacementNamed(
                         context, RoutePaths.languagesetting);
                }else{
                    if (psValueHolder!.locationId != null) {
                            Navigator.pushNamed(
                              context,
                              RoutePaths.home,
                            );
                    } else {
                            Navigator.pushNamed(
                              context,
                              RoutePaths.itemLocationList,
                            );
                          }
                }
              } else {
                Navigator.pop(context, resourceUser.data);
              }
              }
            } else {
              // Approval On
              // ignore: unnecessary_null_comparison
              if (onRegisterSelected != null) {
                onRegisterSelected(resourceUser.data);
              } else {
                await replaceVerifyUserData(
                    resourceUser.data!.userId!,
                    resourceUser.data!.userName!,
                    resourceUser.data!.userEmail!,
                    password);

                psValueHolder!.userIdToVerify = user.userId;
                psValueHolder!.userNameToVerify = user.userName;
                psValueHolder!.userEmailToVerify = user.userEmail;
                psValueHolder!.userPasswordToVerify = user.userPassword;

                final dynamic returnData = await Navigator.pushNamed(
                    context, RoutePaths.user_verify_email_container,
                    arguments: resourceUser.data!.userId);

                if (returnData != null && returnData is User) {
                  final User user = returnData;
                 // if (Provider != null && Provider.of != null) {
                    psValueHolder =
                        Provider.of<PsValueHolder>(context, listen: false);
                  //}
                  psValueHolder!.loginUserId = user.userId;
                  psValueHolder!.userIdToVerify = '';
                  psValueHolder!.userNameToVerify = '';
                  psValueHolder!.userEmailToVerify = '';
                  psValueHolder!.userPasswordToVerify = '';
                  print(user.userId);

                  Navigator.pop(context, resourceUser.data);
                }
              }
            }
            //delete code from here
          } else {
            ///
            /// Error from server
            ///
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  if (resourceUser != null) {
                    return ErrorDialog(
                      message: resourceUser.message,
                    );
                  } else {
                    return ErrorDialog(
                      message: Utils.getString(context, 'login__error_signin'),
                  );
                }
              });
          }
        }
      } else {
        ///
        /// No Internet Connection
        ///
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(context, 'error_dialog__no_internet'),
              );
            });
      }
    } else {
      ///
      /// Not yet agree on Privacy Policy
      ///
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
              message: Utils.getString(context, 'login__warning_agree_privacy'),
              onPressed: () {},
            );
          });
    }
  }

  Future<fb_auth.User?> createUserWithEmailAndPassword(
      BuildContext context, String email, String password,
      {bool ignoreHandleFirebaseAuthError = false}) async {
    fb_auth.UserCredential result;
    try {
      result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on Exception catch (e) {
      print(e);

      final List<String> providers =
          await _firebaseAuth.fetchSignInMethodsForEmail(email);

      final String provider = providers.single;
      print('provider : $provider');
      // Registered With Email
      if (provider.contains(PsConst.emailAuthProvider)) {
        final fb_auth.User? user =
            await signInWithEmailAndPassword(context, email, email);

        if (user == null) {
          if (!ignoreHandleFirebaseAuthError) {
            handleFirebaseAuthError(context, email, ignoreEmail: true);
          }

          // Fail to Login to Firebase, must return null;
          return null;
        } else {
          return user;
        }
      } else {
        if (!ignoreHandleFirebaseAuthError) {
          handleFirebaseAuthError(context, email, ignoreEmail: true);
        }
        return null;
      }
    }

    final fb_auth.User user = result.user!;

    return user;
  }

  Future<PsResource<User>> _submitSignUpWithEmailId(
      BuildContext context,
      Function? onRegisterSelected,
      String name,
      String email,
      String password) async {
    final UserRegisterParameterHolder userRegisterParameterHolder =
        UserRegisterParameterHolder(
      userId: '',
      userName: name,
      userEmail: email,
      userPassword: password,
      userPhone: '',
      deviceToken: psValueHolder!.deviceToken,
    );

    final PsResource<User> _apiStatus =
        await postUserRegister(userRegisterParameterHolder.toMap());

    if (_apiStatus.data != null) {
      final User user = _apiStatus.data!;

      //for change email
      await replaceVerifyUserData(_apiStatus.data!.userId!,
          _apiStatus.data!.userName!, _apiStatus.data!.userEmail!, password);

      psValueHolder!.userIdToVerify = user.userId;
      psValueHolder!.userNameToVerify = user.userName;
      psValueHolder!.userEmailToVerify = user.userEmail;
      psValueHolder!.userPasswordToVerify = user.userPassword;
      }
    return _apiStatus;
  }

  Future<dynamic> userLogout(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo!.userLogout(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }
}
