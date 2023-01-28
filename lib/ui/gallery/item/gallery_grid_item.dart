import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/viewobject/default_photo.dart';
import 'package:flutteradhouse/viewobject/product.dart';

class GalleryGridItem extends StatelessWidget {
  const GalleryGridItem({
    Key? key,
    required this.image,
    this.onImageTap,
     required this.product,
  }) : super(key: key);

  final DefaultPhoto image;
  final Function? onImageTap;
  final Product product;

  @override
  Widget build(BuildContext context) {
    final Widget _imageWidget = PsNetworkImage(
      photoKey: '',
      defaultPhoto: image,
      width: MediaQuery.of(context).size.width,
       imageAspectRation: PsConst.Aspect_Ratio_2x,
      height: PsDimens.space150,
      boxfit: BoxFit.cover,
      onTap: onImageTap,
    );
    return Container(
      margin: const EdgeInsets.all(PsDimens.space4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(PsDimens.space8),
        child:
        //  image != null
        //       ? 
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: double.infinity,
                  child: Stack(children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: double.infinity,
                        child: _imageWidget),
                  ]),
                )
            //  : null,
      ),
    );
  }
}