import 'package:flutter/material.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/gallery/gallery_provider.dart';
import 'package:flutteradhouse/repository/gallery_repository.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/ui/gallery/item/gallery_gird_item_for_video.dart';
import 'package:flutteradhouse/ui/gallery/item/gallery_grid_item.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/product.dart';
import 'package:provider/provider.dart';

class GalleryGridView extends StatefulWidget {
  const GalleryGridView({
    Key? key,
    required this.product,
    this.onImageTap,
  }) : super(key: key);

  final Product product;
  final Function? onImageTap;
  @override
  _GalleryGridViewState createState() => _GalleryGridViewState();
}

class _GalleryGridViewState extends State<GalleryGridView>
    with SingleTickerProviderStateMixin {
  bool bindDataOneTime = true;
  bool isHaveVideo = false;
  @override
  Widget build(BuildContext context) {
    final GalleryRepository productRepo =
        Provider.of<GalleryRepository>(context);
        final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context, listen: false);    
    print(
        '............................Build UI Again ............................');
    return PsWidgetWithAppBar<GalleryProvider>(
        appBarTitle: Utils.getString(context, 'gallery__title') ,
        initProvider: () {
          return GalleryProvider(repo: productRepo);
        },
        onProviderReady: (GalleryProvider provider) {
          provider.loadImageList(
              widget.product.defaultPhoto!.imgParentId!, PsConst.ITEM_TYPE);
        },
        builder:
            (BuildContext context, GalleryProvider provider, Widget? child) {
          if (
              provider.galleryList.data != null &&
              provider.galleryList.data!.isNotEmpty) {
          if (bindDataOneTime) {
              if (Utils.showUI(valueHolder.video) && widget.product.videoThumbnail!.imgPath != '') {
                provider.tempGalleryList.data!
                    .add(widget.product.videoThumbnail!);
                isHaveVideo = true;
              } else {
                isHaveVideo = false;
                Container();
              }
              for (int i = 0; i < valueHolder.maxImageCount && i < provider.galleryList.data!.length; i++) {
                provider.tempGalleryList.data!.add(provider.galleryList.data![i]);
              }
              bindDataOneTime = false;
            }
            return Stack(
              children: <Widget>[
                Container(
                  color: Theme.of(context).cardColor,
                  height: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: RefreshIndicator(
                      child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          slivers: <Widget>[
                            SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 150.0, childAspectRatio: 1.0),
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                if (isHaveVideo && index == 0) {
                                return GalleryGridItemForVideo(
                                    image: provider.tempGalleryList.data![index],
                                    product: widget.product,
                                    onImageTap: () {
                                      if (isHaveVideo && index == 0) {
                                        Navigator.pushNamed(
                                            context, RoutePaths.video_online,
                                            arguments:
                                                widget.product.video!.imgPath);
                                      } else {
                                        Navigator.pushNamed(
                                            context, RoutePaths.galleryDetail,
                                            arguments: provider
                                                .tempGalleryList.data![index]);
                                      }
                                    });
                              } else {
                                return GalleryGridItem(
                                    image: provider.tempGalleryList.data![index],
                                    product: widget.product,
                                    onImageTap: () {
                                      if (isHaveVideo && index == 0) {
                                        Navigator.pushNamed(
                                            context, RoutePaths.video_online,
                                            arguments:
                                                widget.product.video!.imgPath);
                                      } else {
                                        Navigator.pushNamed(
                                            context, RoutePaths.galleryDetail,
                                            arguments: provider
                                                .tempGalleryList.data![index]);
                                      }
                                    });
                              }
                                },
                                childCount: provider.tempGalleryList.data!.length,
                              ),
                            )
                          ]),
                          onRefresh: (){
                            return provider.resetGalleryList( 
                              widget.product.defaultPhoto!.imgParentId!, PsConst.ITEM_TYPE);
                          },
                    ),
                  ),
                ),
               // PSProgressIndicator(provider.tempGalleryList.status)
              ],
            );
          } else {
            return Stack(
                  children: <Widget>[
                    Container(),
                    PSProgressIndicator(provider.tempGalleryList.status)
                  ],
                );
          }
        });
  }
}