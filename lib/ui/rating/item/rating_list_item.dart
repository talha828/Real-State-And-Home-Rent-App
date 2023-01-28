import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/ui/common/smooth_star_rating_widget.dart';
import 'package:flutteradhouse/ui/rating/entry/rating_input_dialog.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/rating.dart';
import 'package:provider/provider.dart';

class RatingListItem extends StatelessWidget {
  const RatingListItem({
    Key? key,
    required this.rating,
    this.onTap,
  }) : super(key: key);

  final Rating rating;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap  as void Function()?,
      child: Container(
        color: PsColors.backgroundColor,
        margin: const EdgeInsets.only(top: PsDimens.space8),
        child: Ink(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _RatingListDataWidget(
                rating: rating,
              ),
              const Divider(
                height: PsDimens.space1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingListDataWidget extends StatefulWidget {
  const _RatingListDataWidget({
    Key? key,
    required this.rating,
  }) : super(key: key);

  final Rating rating;

  @override
  __RatingListDataWidgetState createState() => __RatingListDataWidgetState();
}

PsValueHolder? psValueHolder;

class __RatingListDataWidgetState extends State<_RatingListDataWidget> {
  @override
  Widget build(BuildContext context) {
    psValueHolder = Provider.of<PsValueHolder>(context);
    final Widget _ratingStarsWidget = SmoothStarRating(
        key: Key(widget.rating.rating!),
        rating: double.parse(widget.rating.rating!),
        allowHalfRating: false,
        isReadOnly: true,
        starCount: 5,
        size: PsDimens.space16,
        color: PsColors.ratingColor,
        borderColor: PsColors.grey.withAlpha(100),
        spacing: 0.0);

    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space8,
    );
    final Widget _titleTextWidget = Text(
      widget.rating.title!,
      style: Theme.of(context)
          .textTheme
          .subtitle1!
          .copyWith(fontWeight: FontWeight.bold),
    );
    final Widget _descriptionTextWidget = Text(
      widget.rating.description!,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyText1!.copyWith(),
    );
    return Padding(
      padding: const EdgeInsets.all(PsDimens.space12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          if (psValueHolder!.loginUserId == widget.rating.fromUser!.userId)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _ratingStarsWidget,
                GestureDetector(
                  child: const Icon(
                    Icons.edit,
                  ),
                  onTap: () async {
                    await showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return RatingInputDialog(
                              buyerUserId: widget.rating.fromUser!.userId!,
                              sellerUserId: widget.rating.toUser!.userId!,
                              rating: widget.rating);
                        });
                  },
                ),
              ],
            )
          else
            _ratingStarsWidget,
          _spacingWidget,
          _titleTextWidget,
          _spacingWidget,
          _descriptionTextWidget,
        ],
      ),
    );
  }
}
