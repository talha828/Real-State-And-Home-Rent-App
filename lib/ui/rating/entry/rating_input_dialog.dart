import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/provider/rating/rating_provider.dart';
import 'package:flutteradhouse/repository/rating_repository.dart';
import 'package:flutteradhouse/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutteradhouse/ui/common/ps_button_widget.dart';
import 'package:flutteradhouse/ui/common/ps_textfield_widget.dart';
import 'package:flutteradhouse/ui/common/smooth_star_rating_widget.dart';
import 'package:flutteradhouse/utils/ps_progress_dialog.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/rating_holder.dart';
import 'package:flutteradhouse/viewobject/rating.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class RatingInputDialog extends StatefulWidget {
  const RatingInputDialog(
      {Key? key,
      required this.buyerUserId,
      required this.sellerUserId,
      this.rating})
      : super(key: key);

  final String? buyerUserId;
  final String? sellerUserId;
  final Rating? rating;
  @override
  _RatingInputDialogState createState() => _RatingInputDialogState();
}

class _RatingInputDialogState extends State<RatingInputDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  PsValueHolder? psValueHolder;
  RatingRepository ?ratingRepo;
  double? rating;
  bool isBindData = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ratingRepo = Provider.of<RatingRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    if (isBindData && widget.rating != null) {
      titleController.text = widget.rating!.title!;
      descriptionController.text = widget.rating!.description!;
      isBindData = false;
    }

    final Widget _headerWidget = Container(
        height: PsDimens.space52,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            color: PsColors.mainColor),
        child: Row(
          children: <Widget>[
            const SizedBox(width: PsDimens.space4),
            Icon(
              Icons.live_help,
              color: PsColors.white,
            ),
            const SizedBox(width: PsDimens.space4),
            Text(
              Utils.getString(context, 'rating_entry__user_rating_entry'),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: PsColors.white,
              ),
            ),
          ],
        ));
    return ChangeNotifierProvider<RatingProvider>(
        lazy: false,
        create: (BuildContext context) {
          final RatingProvider provider = RatingProvider(repo: ratingRepo);
          return provider;
        },
        child: Consumer<RatingProvider>(builder:
            (BuildContext context, RatingProvider provider, Widget? child) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)), //this right here
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _headerWidget,
                  const SizedBox(
                    height: PsDimens.space16,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        Utils.getString(context, 'rating_entry__your_rating'),
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(),
                      ),
                      if (widget.rating == null)
                        SmoothStarRating(
                            isRTl:
                                Directionality.of(context) == TextDirection.rtl,
                            allowHalfRating: false,
                            rating: 0.0,
                            starCount: 5,
                            size: PsDimens.space40,
                            color: PsColors.ratingColor,
                            onRated: (double? rating1) {
                              setState(() {
                                rating = rating1;
                              });
                            },
                            borderColor: PsColors.grey.withAlpha(100),
                            spacing: 0.0)
                      else
                        SmoothStarRating(
                            isRTl:
                                Directionality.of(context) == TextDirection.rtl,
                            allowHalfRating: false,
                            rating: double.parse(widget.rating!.rating!),
                            starCount: 5,
                            size: PsDimens.space40,
                            color: PsColors.ratingColor,
                            onRated: (double? rating1) {
                              setState(() {
                                rating = rating1;
                              });
                            },
                            borderColor: PsColors.grey.withAlpha(100),
                            spacing: 0.0),
                      PsTextFieldWidget(
                          titleText:
                              Utils.getString(context, 'rating_entry__title'),
                          hintText:
                              Utils.getString(context, 'rating_entry__title'),
                          textEditingController: titleController),
                      PsTextFieldWidget(
                          height: PsDimens.space120,
                          keyboardType: TextInputType.multiline,
                          titleText:
                              Utils.getString(context, 'rating_entry__message'),
                          hintText:
                              Utils.getString(context, 'rating_entry__message'),
                          textEditingController: descriptionController),
                      Divider(
                        color: PsColors.grey,
                        height: 0.5,
                      ),
                      const SizedBox(
                        height: PsDimens.space16,
                      ),
                      _ButtonWidget(
                        descriptionController: descriptionController,
                        provider: provider,
                        titleController: titleController,
                        rating: rating,
                        psValueHolder: psValueHolder,
                        buyerUserId: widget.buyerUserId ??'',
                        sellerUserId: widget.sellerUserId ?? '',
                      ),
                      const SizedBox(
                        height: PsDimens.space16,
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }));
  }
}

class _ButtonWidget extends StatelessWidget {
  const _ButtonWidget(
      {Key? key,
      required this.titleController,
      required this.descriptionController,
      required this.provider,
      required this.rating,
      required this.psValueHolder,
      required this.buyerUserId,
      required this.sellerUserId})
      : super(key: key);

  final TextEditingController titleController, descriptionController;
  final RatingProvider provider;
  final double? rating;
  final PsValueHolder? psValueHolder;
  final String buyerUserId;
  final String sellerUserId;

  @override
  Widget build(BuildContext context) {
    RatingParameterHolder? commentHeaderParameterHolder;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: PsDimens.space8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: PsDimens.space36,
              child: PSButtonWidget(
                hasShadow: false,
                colorData: PsColors.grey,
                width: double.infinity,
                titleText: Utils.getString(context, 'rating_entry__cancel'),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          const SizedBox(
            width: PsDimens.space8,
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: PsDimens.space36,
              child: PSButtonWidget(
                hasShadow: true,
                width: double.infinity,
                titleText: Utils.getString(context, 'rating_entry__submit'),
                onPressed: () async {
                  if (titleController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty &&
                      
                      rating.toString() != '0.0') {
                    if (buyerUserId == psValueHolder!.loginUserId) {
                      commentHeaderParameterHolder = RatingParameterHolder(
                        fromUserId: buyerUserId,
                        toUserId: sellerUserId,
                        title: titleController.text,
                        description: descriptionController.text,
                        rating: rating.toString(),
                      );
                    }
                    if (sellerUserId == psValueHolder!.loginUserId) {
                      commentHeaderParameterHolder = RatingParameterHolder(
                        fromUserId: sellerUserId,
                        toUserId: buyerUserId,
                        title: titleController.text,
                        description: descriptionController.text,
                        rating: rating.toString(),
                      );
                    }

                    await PsProgressDialog.showDialog(context);
                    await provider
                        .postRating(commentHeaderParameterHolder!.toMap());
                    PsProgressDialog.dismissDialog();

                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                        msg: 'Rating Successed!!!',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white);
                  } else {
                    print('There is no comment');

                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return WarningDialog(
                            message:
                                Utils.getString(context, 'rating_entry__error'),
                            onPressed: () {},
                          );
                        });
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
