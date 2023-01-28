import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/provider/gallery/gallery_provider.dart';
import 'package:flutteradhouse/repository/gallery_repository.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/viewobject/default_photo.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

import '../../../config/ps_colors.dart';
import '../../../constant/ps_dimens.dart';
import '../../common/base/ps_widget_with_appbar_no_app_bar_title.dart';

class GalleryView extends StatefulWidget {
  const GalleryView({
    Key? key,
    required this.selectedDefaultImage,
    this.onImageTap,
  }) : super(key: key);

  final DefaultPhoto selectedDefaultImage;
  final Function? onImageTap;

  @override
  _GalleryViewState createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  @override
  Widget build(BuildContext context) {
    final GalleryRepository galleryRepo =
        Provider.of<GalleryRepository>(context);
    print(
        '............................Build UI Again ............................');
    return PsWidgetWithAppBarNoAppBarTitle<GalleryProvider>(
      initProvider: () {
        return GalleryProvider(repo: galleryRepo);
      },
      onProviderReady: (GalleryProvider provider) {
        provider.loadImageList(
            widget.selectedDefaultImage.imgParentId!, PsConst.ITEM_TYPE);
      },
      builder: (BuildContext context, GalleryProvider provider, Widget? child) {
        if (
          //provider.galleryList != null &&
            provider.galleryList.data != null &&
            provider.galleryList.data!.isNotEmpty) {
          int selectedIndex = 0;
          for (int i = 0; i < provider.galleryList.data!.length; i++) {
            if (widget.selectedDefaultImage.imgId ==
                provider.galleryList.data![i].imgId) {
              selectedIndex = i;
              break;
            }
          }

          return Stack(
            children: <Widget>[
              // Positioned(
              //   child: Container(width: 50, height: 50,
              //   child: Icon(Icons.clear,color: PsColors.white))),

              PhotoViewGallery.builder(
                itemCount: provider.galleryList.data!.length,
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions.customChild(
                    child: PsNetworkImageWithUrl(
                      photoKey: '',
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      imagePath: provider.galleryList.data![index].imgPath!,
                      onTap: widget.onImageTap,
                      boxfit: BoxFit.contain,
                      imageAspectRation: PsConst.Aspect_Ratio_full_image,
                    ),
                    childSize: MediaQuery.of(context).size,
                  );
                },
                pageController: PageController(initialPage: selectedIndex),
                scrollPhysics: const BouncingScrollPhysics(),
                loadingBuilder: (BuildContext context, ImageChunkEvent? event) =>
                    const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              Positioned(
                  left: PsDimens.space16,
                  top: Platform.isIOS ? PsDimens.space60 : PsDimens.space40,
                  child: GestureDetector(
                    child: Container(
                        width: 50,
                        height: 50,
                        child: Icon(Icons.clear, color: PsColors.white)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
