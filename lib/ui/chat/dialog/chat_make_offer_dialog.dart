import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/ui/common/ps_button_widget.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/product.dart';
import 'package:provider/provider.dart';

class ChatMakeOfferDialog extends StatefulWidget {
  const ChatMakeOfferDialog(
      {Key? key, required this.itemDetail, required this.onMakeOfferTap})
      : super(key: key);

  final Product? itemDetail;
  final Function onMakeOfferTap;
  @override
  _ChatMakeOfferDialogState createState() => _ChatMakeOfferDialogState();
}

class _ChatMakeOfferDialogState extends State<ChatMakeOfferDialog> {
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    priceController.text = widget.itemDetail!.price!;
     final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context);
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space4,
    );

    final Widget _headerWidget = Container(
      alignment: Alignment.center,
      height: PsDimens.space60,
      width: double.infinity,
      color: PsColors.mainColor,
      child: Text(Utils.getString(context, 'make_offer_entry__title_name'),
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: Colors.white)),
    );

    final Widget _imageAndTextWidget = Card(
      child: Padding(
        padding: const EdgeInsets.all(PsDimens.space12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            PsNetworkImage(
              photoKey: '',
              defaultPhoto: widget.itemDetail!.defaultPhoto!,
              width: PsDimens.space76,
              height: PsDimens.space76,
              boxfit: BoxFit.cover,
               imageAspectRation: PsConst.Aspect_Ratio_1x,
              onTap: () {
                // Navigator.pushNamed(context, RoutePaths.userDetail, arguments: data);
              },
            ),
            const SizedBox(
              width: PsDimens.space12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(widget.itemDetail!.title!,
                      style: Theme.of(context).textTheme.bodyText1),
                  const SizedBox(height: PsDimens.space20),
                  Text(
                   
                            widget.itemDetail!.price != '0' &&
                            widget.itemDetail!.price != ''
                        ? '${Utils.getString(context, 'make_offer_dialog__price')}  ${widget.itemDetail!.itemCurrency!.currencySymbol} ${Utils.getPriceFormat(widget.itemDetail!.price!,valueHolder.priceFormat!)}'
                        : Utils.getString(context, 'item_price_free'),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    final Widget _priceInputEditText = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          widget.itemDetail!.itemCurrency!.currencySymbol!,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Container(
          width: PsDimens.space160,
          height: PsDimens.space44,
          margin: const EdgeInsets.all(PsDimens.space12),
          decoration: BoxDecoration(
            color: Utils.isLightMode(context) ? Colors.white60 : Colors.black54,
            borderRadius: BorderRadius.circular(PsDimens.space4),
            border: Border.all(
                color: Utils.isLightMode(context)
                    ? Colors.grey[200]!
                    : Colors.black87),
          ),
          child: TextField(
              keyboardType: TextInputType.number,
              maxLines: null,
              textAlign: TextAlign.center,
              controller: priceController,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                  left: PsDimens.space12,
                  bottom: PsDimens.space8,
                ),
                border: InputBorder.none,
                hintText: priceController.text,
              )),
        ),
      ],
    );

    final Widget _makeOfferButtonWidget = Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
            left: PsDimens.space12,
            right: PsDimens.space12,
            bottom: PsDimens.space12),
        child:
            // RaisedButton(
            //   child: Text(
            //     Utils.getString(context, 'make_offer_dialog__make_offer_btn_name'),
            //     overflow: TextOverflow.ellipsis,
            //     maxLines: 1,
            //     softWrap: false,
            //   ),
            //   color: PsColors.mainColor,
            //   shape: const BeveledRectangleBorder(
            //       borderRadius: BorderRadius.all(
            //     Radius.circular(PsDimens.space8),
            //   )),
            //   textColor: Theme.of(context).textTheme.button.copyWith(color: Colors.white).color,
            //   onPressed: () async {
            PSButtonWidget(
          hasShadow: true,
          width: double.infinity,
          titleText: Utils.getString(
              context, 'make_offer_dialog__make_offer_btn_name'),
          onPressed: () async {
            Navigator.of(context).pop();
            widget.onMakeOfferTap(priceController.text);
          },
        ));
    return Dialog(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _headerWidget,
            _spacingWidget,
            _imageAndTextWidget,
            if (widget.itemDetail!.price != '0')
              Visibility(
                visible: true,
                child: _priceInputEditText,
              ),
            _makeOfferButtonWidget
          ],
        ),
      ),
    );
  }
}
