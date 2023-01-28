import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class PsProgressDialog {
  PsProgressDialog._();

  static ProgressDialog? _progressDialog;
  // static ProgressDialog _progressDownloadDialog;

  static Future<bool> showDialog(BuildContext context, {String? message}) async {
    if (_progressDialog == null) {
      _progressDialog = ProgressDialog(context,
          type: ProgressDialogType.normal,
          isDismissible: false,
          showLogs: true);

      _progressDialog!.style(
          message:
              message ?? Utils.getString(context, 'loading_dialog__loading'),
          borderRadius: 5.0,
          backgroundColor: Utils.isLightMode(context)
              ? PsColors.white
              : PsColors.backgroundColor,
          progressWidget: Container(
              padding: const EdgeInsets.all(10.0),
              child: const CircularProgressIndicator()),
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          progress: 0.0,
          maxProgress: 100.0,
          progressTextStyle: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: PsColors.mainColor),
          messageTextStyle: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: PsColors.mainColor));
    }

    if (message != null) {
      _progressDialog!.update(
          message:
              message );
    }

    await _progressDialog!.show();

    return true;
  }

  static void dismissDialog() {
    if (_progressDialog != null) {
      _progressDialog!.hide();
      _progressDialog = null;
    }
  }

  static bool isShowing() {
    if (_progressDialog != null) {
      return _progressDialog!.isShowing();
    } else {
      return false;
    }
  }

  static void showDownloadDialog(BuildContext context, double progress,
      {String? message}) {
    if (_progressDialog == null) {
      _progressDialog = ProgressDialog(context,
          type: ProgressDialogType.download,
          isDismissible: false,
          showLogs: true);

      _progressDialog!.style(
          message:
              message ?? Utils.getString(context, 'loading_dialog__loading'),
          borderRadius: 5.0,
          backgroundColor: PsColors.white,
          progressWidget: Container(
              padding: const EdgeInsets.all(10.0),
              child: const CircularProgressIndicator()),
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          progress: progress,
          maxProgress: 100.0,
          progressTextStyle: Theme.of(context).textTheme.bodyText1,
          messageTextStyle: Theme.of(context).textTheme.bodyText1);
    }

    _progressDialog!.update(
        message: message ?? Utils.getString(context, 'loading_dialog__loading'),
        progress: progress);

    if (!_progressDialog!.isShowing()) {
      _progressDialog!.show();
    }
  }

  static void dismissDownloadDialog() {
    if (_progressDialog != null) {
      _progressDialog!.hide();
      _progressDialog = null;
    }
  }
}
