import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/provider/gallery/gallery_provider.dart';
import 'package:flutteradhouse/ui/common/ps_button_widget_with_round_corner.dart';
import 'package:flutteradhouse/utils/ps_progress_dialog.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/default_photo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ApplyAgentDialog extends StatefulWidget {
  const ApplyAgentDialog(this.galleryProvider);
  final GalleryProvider galleryProvider;
  @override
  _CertifiedDealerDialogState createState() => _CertifiedDealerDialogState();
}

class _CertifiedDealerDialogState extends State<ApplyAgentDialog> {
  List<PlatformFile>? videoFilePath;
  final String _extension = 'jpg , png, pdf';
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
          width: 380.0,
          padding: const EdgeInsets.all(PsDimens.space16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: PsDimens.space16),
              Text(Utils.getString(context, 'apply_agent_title'),
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: PsColors.mainColor, fontWeight: FontWeight.bold)),
              const SizedBox(height: PsDimens.space24),
              Container(
                  // padding: const EdgeInsets.all(PsDimens.space14),
                  child: Text(
                    Utils.getString(context, 'apply_agent_verification_agent'),
                    style: Theme.of(context).textTheme.bodyText2,
                  )),
              const SizedBox(height: PsDimens.space8),
              InkWell(
                onTap: () async {
                  try {
                    videoFilePath = (await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowMultiple: false,
                      allowedExtensions: (_extension.isNotEmpty )
                          ? _extension.replaceAll(' ', '').split(',')
                          : null,
                    ))
                        ?.files;
                  } on PlatformException catch (e) {
                    print('Unsupported operation' + e.toString());
                  } catch (ex) {
                    print(ex);
                  }
                  if (videoFilePath != null) {
                    setState(() {});
                  }
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: PsColors.backgroundColor,
                    borderRadius: BorderRadius.circular(PsDimens.space4),
                    border: Border.all(color: PsColors.mainDividerColor),
                  ),
                  margin: const EdgeInsets.only(
                    top: PsDimens.space12,
                    left: PsDimens.space16,
                    right: PsDimens.space16,
                    //top: PsDimens.space56
                  ),
                  padding: const EdgeInsets.all(PsDimens.space14),
                  child: Text(
                    // ignore: unnecessary_null_comparison
                    videoFilePath == null
                        ? Utils.getString(
                            context, 'agent__choose_pdf_image')
                        : videoFilePath![0].path!,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
              const SizedBox(height: PsDimens.space8),
                Container(
                  margin: const EdgeInsets.only(
                    top: PsDimens.space16,
                    left: PsDimens.space16,
                    right: PsDimens.space16,
                  ),
                  child: PSButtonWidgetRoundCorner(
                  hasShadow: true,
                  width: double.infinity,
                  titleText:
                      Utils.getString(context, 'agent_apply'),
                  onPressed: () async {
                  if (videoFilePath == null) {
                    Fluttertoast.showToast(
                        msg: Utils.getString(
                            context, 'agent__choose_pdf_image'),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: PsColors.mainColor,
                        textColor: PsColors.white);
                  } else {
                    await PsProgressDialog.showDialog(context);
                    final PsValueHolder valueHolder =
                        Provider.of<PsValueHolder>(context, listen: false);
                    final PsResource<DefaultPhoto> result =
                        await widget.galleryProvider.postApplyAgent(
                            valueHolder.loginUserId!,
                            '',
                            File(videoFilePath![0].path!));
                    PsProgressDialog.dismissDialog();

                    if (result.data != null) {
                      Navigator.pop(context, true);
                      if(valueHolder.loginUserId == 'c4ca4238a0b923820dcc509a6f75849b'){
                          Fluttertoast.showToast(
                          msg: Utils.getString(
                              context, 'Sorry! You cannot apply agent.'),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: PsColors.mainColor,
                          textColor: PsColors.white);
                      }else{
                          Fluttertoast.showToast(
                          msg: Utils.getString(
                              context, 'success_dialog__success'),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: PsColors.mainColor,
                          textColor: PsColors.white);
                      }
               
                    } else {
                      Navigator.pop(context, true);
                      Fluttertoast.showToast(
                          msg: result.message,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: PsColors.mainColor,
                          textColor: PsColors.white);
                        }
                      }
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(
                    PsDimens.space16,
                    ),
                    child: PSButtonWidgetRoundCorner(
                    hasShadow: true,
                    width: double.infinity,
                    titleText:
                        Utils.getString(context, 'dialog__cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                     
                    }
                  ),
              ),
            ],
          )),
    );
  }
}
