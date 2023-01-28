import 'package:flutter/material.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/viewobject/default_photo.dart';
import 'package:flutteradhouse/viewobject/product.dart';

class GalleryGridItemForVideo extends StatefulWidget {
  const GalleryGridItemForVideo({
    Key? key,
    required this.image,
    this.onImageTap,
    required this.product,
  }) : super(key: key);

  final DefaultPhoto image;
  final Function? onImageTap;
  final Product product;

  @override
  _GalleryGridItemForVideoState createState() =>
      _GalleryGridItemForVideoState();
}

class _GalleryGridItemForVideoState extends State<GalleryGridItemForVideo> {
  @override
  Widget build(BuildContext context) {
    final Widget _imageWidget = PsNetworkImage(
      photoKey: '',
      defaultPhoto: widget.image,
      width: MediaQuery.of(context).size.width,
       imageAspectRation: PsConst.Aspect_Ratio_full_image,
      height: PsDimens.space150,
      boxfit: BoxFit.cover,
      onTap: widget.onImageTap,
    );

    return Container(
        margin: const EdgeInsets.all(PsDimens.space4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(PsDimens.space8),
          child: 
          // widget.image != null
          //     ? 
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: double.infinity,
                  child: Stack(children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: double.infinity,
                        child: _imageWidget),
                    if (widget.product.video!.imgPath != '')
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RoutePaths.video_online,
                              arguments: widget.product.video!.imgPath);
                        },
                        child: Center(
                          child: Container(
                            padding:
                                const EdgeInsets.only(top: PsDimens.space16),
                            width: 100,
                            height: 100,
                            child: const Icon(
                              Icons.play_circle,
                              color: Colors.black54,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                  ]),
                )
             // : null,
        ));
  }
}