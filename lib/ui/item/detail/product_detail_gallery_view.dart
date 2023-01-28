import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/provider/gallery/gallery_provider.dart';
import 'package:flutteradhouse/repository/gallery_repository.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_appbar_no_app_bar_title.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/default_photo.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

class ProductDetailGalleryView extends StatefulWidget {
  const ProductDetailGalleryView({
    Key? key,
    required this.selectedDefaultImage,
    required this.isHaveVideo,
    this.onImageTap,
  }) : super(key: key);

  final DefaultPhoto selectedDefaultImage;
  final Function? onImageTap;
  final bool isHaveVideo;

  @override
  _ProductDetailGalleryViewState createState() => _ProductDetailGalleryViewState();
}

class _ProductDetailGalleryViewState extends State<ProductDetailGalleryView> {
  bool bindDataOneTime = true;
  String? selectedId;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final GalleryRepository galleryRepo =
        Provider.of<GalleryRepository>(context);
    final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context, listen: false);    
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
            provider.galleryList.data != null &&
            provider.galleryList.data!.isNotEmpty) {
          if (bindDataOneTime) {
            if (Utils.showUI(valueHolder.video) && widget.isHaveVideo) {
              provider.tempGalleryList.data!.add(widget.selectedDefaultImage);
              for (int i = 0; i < valueHolder.maxImageCount &&  i < provider.galleryList.data!.length; i++) {
                provider.tempGalleryList.data!.add(provider.galleryList.data![i]);
              }
            } else {
              for (int i = 0;i < valueHolder.maxImageCount && i < provider.galleryList.data!.length; i++) {
                provider.tempGalleryList.data!.add(provider.galleryList.data![i]);
              }
            }

            for (int i = 0; i < provider.tempGalleryList.data!.length; i++) {
              if (widget.selectedDefaultImage.imgId ==
                  provider.tempGalleryList.data![i].imgId) {
                selectedIndex = i;
                selectedId = widget.selectedDefaultImage.imgId;
                break;
              }
            }
            bindDataOneTime = false;
          }

          return Stack(
            children: <Widget>[
              PhotoViewGallery.builder(
                itemCount: provider.tempGalleryList.data!.length,
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions.customChild(
                    child: Stack(
                      children: <Widget>[
                        Container(
                         height: 600,
                          child: PsNetworkImageWithUrl(
                            photoKey: '',
                            imageAspectRation: PsConst.Aspect_Ratio_1x,
                            width: MediaQuery.of(context).size.width,

                            imagePath:
                                provider.tempGalleryList.data![index].imgPath!,
                            onTap: widget.onImageTap,
                            boxfit: BoxFit.cover,
                          ),
                        ),
                        if (Utils.showUI(valueHolder.video) && widget.isHaveVideo && index == 0)
                          GestureDetector(
                            onTap: widget.onImageTap as void Function()?,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: PsDimens.space16),
                                width: 100,
                                height: 100,
                                child: const Icon(
                                  Icons.play_circle,
                                  color: Colors.black54,
                                  size: 80,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
                onPageChanged: (
                  int i,
                ) {
                  if (mounted) {
                    setState(() {
                      selectedId = provider.tempGalleryList.data![i].imgId;
                    });
                  }
                },
                pageController: PageController(initialPage: selectedIndex),
                scrollPhysics: const BouncingScrollPhysics(),
                loadingBuilder: (BuildContext context, ImageChunkEvent? event) =>
                    const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              Positioned(
                  bottom: 5.0,
                  left: 0.0,
                  right: 0.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: 
                            provider.tempGalleryList.data!.isNotEmpty
                        ? provider.tempGalleryList.data!
                            .map((DefaultPhoto defaultPhoto) {
                            return Builder(builder: (BuildContext context) {
                              return Container(
                                  width: 8.0,
                                  height: 8.0,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 2.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: selectedId == defaultPhoto.imgId
                                          ? PsColors.mainColor
                                          : PsColors.grey));
                            });
                          }).toList()
                        : <Widget>[Container()],
                  ))
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}