import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/entry/item_entry_provider.dart';
import 'package:flutteradhouse/provider/gallery/gallery_provider.dart';
import 'package:flutteradhouse/provider/user/user_provider.dart';
import 'package:flutteradhouse/repository/gallery_repository.dart';
import 'package:flutteradhouse/repository/product_repository.dart';
import 'package:flutteradhouse/repository/user_repository.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:flutteradhouse/ui/common/dialog/choose_camera_type_dialog.dart';
import 'package:flutteradhouse/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutteradhouse/ui/common/dialog/error_dialog.dart';
import 'package:flutteradhouse/ui/common/dialog/in_app_purchase_for_package_dialog.dart';
import 'package:flutteradhouse/ui/common/dialog/retry_dialog_view.dart';
import 'package:flutteradhouse/ui/common/dialog/success_dialog.dart';
import 'package:flutteradhouse/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutteradhouse/ui/common/ps_button_widget.dart';
import 'package:flutteradhouse/ui/common/ps_dropdown_base_with_controller_widget.dart';
import 'package:flutteradhouse/ui/common/ps_textfield_widget.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/utils/ps_progress_dialog.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/amenities.dart';
import 'package:flutteradhouse/viewobject/api_status.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/default_photo.dart';
import 'package:flutteradhouse/viewobject/holder/delete_item_image_holder.dart';
import 'package:flutteradhouse/viewobject/holder/image_reorder_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/amenities_intent_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/google_map_pin_call_back_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/map_pin_call_back_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/map_pin_intent_holder.dart';
import 'package:flutteradhouse/viewobject/holder/item_entry_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/item_currency.dart';
import 'package:flutteradhouse/viewobject/item_location_city.dart';
import 'package:flutteradhouse/viewobject/item_location_township.dart';
import 'package:flutteradhouse/viewobject/item_price_type.dart';
import 'package:flutteradhouse/viewobject/post_type.dart';
import 'package:flutteradhouse/viewobject/product.dart';
import 'package:flutteradhouse/viewobject/property_type.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googlemap;
import 'package:latlong2/latlong.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ItemEntryView extends StatefulWidget {
  const ItemEntryView(
      {Key? key, 
      this.flag, 
      this.item,
      this.onItemUploaded, 
      required this.animationController,
      required this.maxImageCount,
      }): super(key: key);
  final AnimationController animationController;
  final String? flag;
  final Product? item;
  final Function? onItemUploaded;
   final int maxImageCount;

  @override
  State<StatefulWidget> createState() => _ItemEntryViewState();
}

class _ItemEntryViewState extends State<ItemEntryView> {
  ProductRepository? repo1;
  GalleryRepository? galleryRepository;
  ItemEntryProvider? _itemEntryProvider;
  GalleryProvider? galleryProvider;
  UserProvider? userProvider;
  UserRepository? userRepository;
  PsValueHolder? valueHolder;
  Map<Amenities, bool> selectedAmenitiesList = <Amenities, bool>{};

  final TextEditingController userInputListingTitle = TextEditingController();
  final TextEditingController userInputConfiguration = TextEditingController();
  final TextEditingController userInputHighLightInformation =
      TextEditingController();
  final TextEditingController userInputFloorNo = TextEditingController();
  final TextEditingController userInputDescription = TextEditingController();
  final TextEditingController userInputArea = TextEditingController();
  final TextEditingController userInputLattitude = TextEditingController();
  final TextEditingController userInputLongitude = TextEditingController();
  final TextEditingController userInputAddress = TextEditingController();
  final TextEditingController userInputPrice = TextEditingController();
  final TextEditingController userInputPriceUnit = TextEditingController();
  final TextEditingController userInputPriceNote = TextEditingController();
  final TextEditingController userInputisNegotiableNote =
      TextEditingController();
  final TextEditingController userInputDiscount = TextEditingController();
  final MapController mapController = MapController();
  googlemap.GoogleMapController? googleMapController;

  final TextEditingController propertyController = TextEditingController();
  final TextEditingController postedController = TextEditingController();
  final TextEditingController amenitiesController = TextEditingController();
  final TextEditingController itemConditionController = TextEditingController();
  final TextEditingController priceTypeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController locationTownshipController =
      TextEditingController();

  late LatLng latlng;
  final double zoom = 16;
  bool bindDataFirstTime = true;
    bool bindImageFirstTime = true;
  // New Images From Image Picker
  List<Asset> images = <Asset>[];
  Asset? firstSelectedImageAsset;
  Asset? secondSelectedImageAsset;
  Asset? thirdSelectedImageAsset;
  Asset? fouthSelectedImageAsset;
  Asset? fifthSelectedImageAsset;
  String? firstCameraImagePath;
  String? secondCameraImagePath;
  String? thirdCameraImagePath;
  String? fouthCameraImagePath;
  String? fifthCameraImagePath;
  String? videoFilePath;
  String? selectedVideoImagePath;
  String? videoFileThumbnailPath;
  String? selectedVideoPath;
  Asset? defaultAssetImage;
  late List<bool> isImageSelected;
  late List<Asset?> galleryImageAsset;
  late List<String?> cameraImagePath;
  late List<DefaultPhoto?> uploadedImages;

  // New Images Checking from Image Picker
  bool isSelectedFirstImagePath = false;
  bool isSelectedSecondImagePath = false;
  bool isSelectedThirdImagePath = false;
  bool isSelectedFouthImagePath = false;
  bool isSelectedFifthImagePath = false;
  bool isSelectedVideoImagePath = false;

  String isShopCheckbox = '1';

    dynamic updateMapController(googlemap.GoogleMapController mapController) {
    googleMapController = mapController;
  }


  // ProgressDialog progressDialog;

  // File file;

  dynamic updateAmenitiesData(Map<Amenities, bool> data){
    selectedAmenitiesList = data;
  }

    @override
  void initState() {
    super.initState();
    isImageSelected =
        List<bool>.generate(widget.maxImageCount, (int index) => false);
    galleryImageAsset =
        List<Asset?>.generate(widget.maxImageCount, (int index) => null);
    cameraImagePath =
        List<String?>.generate(widget.maxImageCount, (int index) => null);
    uploadedImages = List<DefaultPhoto?>.generate(widget.maxImageCount,
        (int index) => DefaultPhoto(imgId: '', imgPath: ''));
  }

  @override
  Widget build(BuildContext context) {

    print(
        '............................Build UI Again ............................');
    valueHolder = Provider.of<PsValueHolder>(context);
    void showRetryDialog(String description, Function uploadImage) {
      if (PsProgressDialog.isShowing()) {
        PsProgressDialog.dismissDialog();
      }
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return RetryDialogView(
                description: description,
                rightButtonText: Utils.getString(context, 'item_entry__retry'),
                onAgreeTap: () {
                  Navigator.pop(context);
                  uploadImage();
                });
          });
    }

    Future<dynamic> uploadImage(String itemId) async {
      bool _isVideoDone = isSelectedVideoImagePath;
      final List<ImageReorderParameterHolder> reorderObjList =
          <ImageReorderParameterHolder>[];
      for (int i = 0; i < widget.maxImageCount && isImageSelected.contains(true); i++) {
        
        if (isImageSelected[i]) {
          if (galleryImageAsset[i] != null || cameraImagePath[i] != null) {
            if (!PsProgressDialog.isShowing()) {
              if (!isImageSelected[i]) {
                PsProgressDialog.dismissDialog();
              } else {
                await PsProgressDialog.showDialog(context,
                    message: Utils.getString(context, 'Image ${i + 1} uploading'));
              }
            }
            final dynamic _apiStatus = await galleryProvider!
                .postItemImageUpload(
                    itemId,
                    uploadedImages[i]!.imgId!,
                    '${i + 1}',
                    galleryImageAsset[i] == null
                        ? await Utils.getImageFileFromCameraImagePath(
                            cameraImagePath[i]!, valueHolder!.uploadImageSize!)
                        : await Utils.getImageFileFromAssets(
                            galleryImageAsset[i]!, valueHolder!.uploadImageSize!),
                    valueHolder!.loginUserId!);
            PsProgressDialog.dismissDialog();

            if (_apiStatus != null &&
                _apiStatus.data is DefaultPhoto &&
                _apiStatus.data != null) {
              isImageSelected[i] = false;
              print('${i + 1} image uploaded');
            } else if (_apiStatus != null) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message: _apiStatus.message,
                    );
                  });
            }
          } else if (uploadedImages[i]!.imgPath != '') {
            reorderObjList.add(ImageReorderParameterHolder(
                imgId: uploadedImages[i]!.imgId, ordering: (i + 1).toString()));
          }
        }
      }

      //reordering
      if (reorderObjList.isNotEmpty) {
      await PsProgressDialog.showDialog(context);
      final List<Map<String, dynamic>> reorderMapList =
          <Map<String, dynamic>>[];
      for (ImageReorderParameterHolder? data in reorderObjList) {
        if (data != null) {
          reorderMapList.add(data.toMap());
        }
      }
      final PsResource<ApiStatus>? _apiStatus = await galleryProvider!
          .postReorderImages(reorderMapList, valueHolder!.loginUserId!);
      PsProgressDialog.dismissDialog();
      
      if (_apiStatus!.data != null && _apiStatus.status == PsStatus.SUCCESS) {
        isImageSelected = isImageSelected.map<bool>((bool v) => false).toList();
        reorderObjList.clear();
      } else {
        showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message: _apiStatus.message,
                    );
                  });
      }
      }
      

      if (!PsProgressDialog.isShowing()) {
        if (!isSelectedVideoImagePath) {
          PsProgressDialog.dismissDialog();
        } else {
          await PsProgressDialog.showDialog(context,
              message:
                  Utils.getString(context, 'progressloading_video_uploading'));
        }
      }

      if (isSelectedVideoImagePath) {
        final PsResource<DefaultPhoto> _apiStatus = await galleryProvider!
            .postVideoUpload(
                itemId, '', File(videoFilePath!), valueHolder!.loginUserId!);
        final PsResource<DefaultPhoto> _apiStatus2 = await galleryProvider!
            .postVideoThumbnailUpload(itemId, '', File(videoFileThumbnailPath!),
                valueHolder!.loginUserId!);
        if (_apiStatus.data != null && _apiStatus2.data != null) {
          PsProgressDialog.dismissDialog();
          isSelectedVideoImagePath = false;
          _isVideoDone = isSelectedVideoImagePath;
        } else {
          showRetryDialog(
              Utils.getString(context, 'item_entry__fail_to_upload_video'), () {
            uploadImage(itemId);
          });
          return;
        }
      }
      PsProgressDialog.dismissDialog();


      if (!(isImageSelected.contains(true) || _isVideoDone)) {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return SuccessDialog(
                message: Utils.getString(context, 'item_entry_item_uploaded'),
                onPressed: ()async {
                // Navigator.pop(context,true);

                if(widget.flag == PsConst.ADD_NEW_ITEM){
                  if(widget.onItemUploaded != null) {

                    widget.onItemUploaded!( _itemEntryProvider!.itemId);

                  }
                }else{
                  Navigator.pop(context,true);
                }
                },
              );
            });
      }

      return;
    }

    dynamic updateImagesFromVideo(String imagePath, int index) {
      if (mounted) {
        setState(() {
          //for single select image
          if (index == -2 && imagePath.isNotEmpty) {
            videoFilePath = imagePath;
            // selectedVideoImagePath = imagePath;
            isSelectedVideoImagePath = true;
          }
          //end single select image
        });
      }
    }

    dynamic _getImageFromVideo(String videoPathUrl) async {
      videoFileThumbnailPath = await VideoThumbnail.thumbnailFile(
        video: videoPathUrl,
        imageFormat: ImageFormat.JPEG,
        maxWidth:
            128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 25,
      );
      return videoFileThumbnailPath;
    }

    // dynamic updateImagesFromCustomCamera(String imagePath, int index) {
    //   if (mounted) {
    //     setState(() {
    //       //for single select image
    //       if (index == 0 && imagePath.isNotEmpty) {
    //         firstCameraImagePath = imagePath;
    //         isSelectedFirstImagePath = true;
    //       }
    //       if (index == 1 && imagePath.isNotEmpty) {
    //         secondCameraImagePath = imagePath;
    //         isSelectedSecondImagePath = true;
    //       }
    //       if (index == 2 && imagePath.isNotEmpty) {
    //         thirdCameraImagePath = imagePath;
    //         isSelectedThirdImagePath = true;
    //       }
    //       if (index == 3 && imagePath.isNotEmpty) {
    //         fouthCameraImagePath = imagePath;
    //         isSelectedFouthImagePath = true;
    //       }
    //       if (index == 4 && imagePath.isNotEmpty) {
    //         fifthCameraImagePath = imagePath;
    //         isSelectedFifthImagePath = true;
    //       }
    //       //end single select image
    //     });
    //   }
    // }

        dynamic updateImagesFromCustomCamera(String imagePath, int index) {
      if (mounted) {
        setState(() {
          //for single select image
          if (imagePath.isNotEmpty) {
            int indexToStart =
                0; //find the right starting_index for storing images
            for (indexToStart = 0; indexToStart < index; indexToStart++) {
              if (!isImageSelected[indexToStart] &&
                  indexToStart > galleryProvider!.selectedImageList.length - 1)
                break;
            }
            galleryImageAsset[indexToStart] = null;
            cameraImagePath[indexToStart] = imagePath;
            isImageSelected[indexToStart] = true;
          }
          //end single select image
        });
      }
    }




    dynamic updateImages(List<Asset> resultList, int index, int currentIndex) {
      // if (index == -1) {
      //   for(int i = 0; i < galleryImageAsset.length; i++) {
      //     galleryImageAsset[i] = defaultAssetImage;
      //   }
      // }
      setState(() {
        images = resultList;

        //for single select image
        if (index != -1 && resultList.isNotEmpty) {
          galleryImageAsset[currentIndex] = resultList[0];
          isImageSelected[currentIndex] = true;
        }
        //end single select image

        //for multi select
        if (index == -1) {
          int indexToStart =
              0; //find the right starting_index for storing images
          for (indexToStart = 0; indexToStart < currentIndex; indexToStart++) {
            if (!isImageSelected[indexToStart] &&
                indexToStart > galleryProvider!.selectedImageList.length - 1)
              break;
          }
          for (int i = 0;
              i < resultList.length && indexToStart < widget.maxImageCount;
              i++, indexToStart++) {
            galleryImageAsset[indexToStart] = resultList[i];
            isImageSelected[indexToStart] = true;
          }
        }
        //end multi select
      });
    }

    dynamic onReorder(int oldIndex, int newIndex) {
      if (galleryImageAsset[oldIndex] != null) {
        if (galleryImageAsset[newIndex] != null) {
          setState(() {
            final Asset? temp = galleryImageAsset[oldIndex];
            galleryImageAsset[oldIndex] = galleryImageAsset[newIndex];
            galleryImageAsset[newIndex] = temp;
          });
        } else if (cameraImagePath[newIndex] != null &&
            cameraImagePath[newIndex] != '') {
          setState(() {
            cameraImagePath[oldIndex] = cameraImagePath[newIndex];
            galleryImageAsset[newIndex] = galleryImageAsset[oldIndex];
            galleryImageAsset[oldIndex] = null;
            cameraImagePath[newIndex] = null;
          });
        } else if (uploadedImages[newIndex]!.imgPath != '' &&
            uploadedImages[newIndex]!.imgId != '') {
          setState(() {
            uploadedImages[oldIndex] = uploadedImages[newIndex];
            uploadedImages[newIndex] = DefaultPhoto(imgId: '', imgPath: '');
            galleryImageAsset[newIndex] = galleryImageAsset[oldIndex];
            galleryImageAsset[oldIndex] = null;

            isImageSelected[newIndex] = true;
            isImageSelected[oldIndex] = true;
          });
        }
      } else if (cameraImagePath[oldIndex] != null &&
          cameraImagePath[oldIndex] != '') {
        if (galleryImageAsset[newIndex] != null) {
          setState(() {
            galleryImageAsset[oldIndex] = galleryImageAsset[newIndex];
            cameraImagePath[newIndex] = cameraImagePath[oldIndex];
            cameraImagePath[oldIndex] = null;
            galleryImageAsset[newIndex] = null;
          });
        } else if (cameraImagePath[newIndex] != null &&
            cameraImagePath[newIndex] != '') {
          setState(() {
            final String? temp = cameraImagePath[oldIndex];
            cameraImagePath[oldIndex] = cameraImagePath[newIndex];
            cameraImagePath[newIndex] = temp;
          });
        } else if (uploadedImages[newIndex]!.imgPath != '' &&
            uploadedImages[newIndex]!.imgId != '') {
          setState(() {
            uploadedImages[oldIndex] = uploadedImages[newIndex];
            uploadedImages[newIndex] = DefaultPhoto(imgId: '', imgPath: '');
            cameraImagePath[newIndex] = cameraImagePath[oldIndex];
            cameraImagePath[oldIndex] = null;

            isImageSelected[newIndex] = true;
            isImageSelected[oldIndex] = true;
          });
        }
      } else if (uploadedImages[oldIndex]!.imgPath != '' &&
          uploadedImages[oldIndex]!.imgId != '') {
        if (galleryImageAsset[newIndex] != null) {
          setState(() {
            uploadedImages[newIndex] = uploadedImages[oldIndex];
            uploadedImages[oldIndex] = DefaultPhoto(imgId: '', imgPath: '');
            galleryImageAsset[oldIndex] = galleryImageAsset[newIndex];
            galleryImageAsset[newIndex] = null;

            isImageSelected[newIndex] = true;
            isImageSelected[oldIndex] = true;
          });
        } else if (cameraImagePath[newIndex] != null &&
            cameraImagePath[newIndex] != '') {
          setState(() {
            uploadedImages[newIndex] = uploadedImages[oldIndex];
            uploadedImages[oldIndex] = DefaultPhoto(imgId: '', imgPath: '');
            cameraImagePath[oldIndex] = cameraImagePath[newIndex];
            cameraImagePath[newIndex] = null;

            isImageSelected[newIndex] = true;
            isImageSelected[oldIndex] = true;
          });
        } else if (uploadedImages[newIndex]!.imgPath != '' &&
            uploadedImages[newIndex]!.imgId != '') {
          setState(() {
            final DefaultPhoto? temp = uploadedImages[newIndex];
            uploadedImages[newIndex] = uploadedImages[oldIndex];
            uploadedImages[oldIndex] = temp;

            isImageSelected[oldIndex] = true;
            isImageSelected[newIndex] = true;
          });
        }
      }
    }

    repo1 = Provider.of<ProductRepository>(context);
    galleryRepository = Provider.of<GalleryRepository>(context);
    userRepository = Provider.of<UserRepository>(context);
    widget.animationController.forward();
    return PsWidgetWithMultiProvider(
      child: MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<ItemEntryProvider?>(
                lazy: false,
                create: (BuildContext context) {
                  _itemEntryProvider = ItemEntryProvider(
                      repo: repo1, psValueHolder: valueHolder);

                  _itemEntryProvider!.item = widget.item!;
                  if (valueHolder!.isSubLocation == PsConst.ONE) {
                    latlng = LatLng(
                        double.parse(_itemEntryProvider!
                            .psValueHolder!.locationTownshipLat),
                        double.parse(_itemEntryProvider!
                            .psValueHolder!.locationTownshipLng));
                    if (
                        _itemEntryProvider!.itemLocationTownshipId != '') {
                      _itemEntryProvider!.itemLocationTownshipId =
                          _itemEntryProvider!.psValueHolder!.locationTownshipId;
                    }
                    if (userInputLattitude.text.isEmpty)
                      userInputLattitude.text =
                          _itemEntryProvider!.psValueHolder!.locationTownshipLat;
                    if (userInputLongitude.text.isEmpty)
                      userInputLongitude.text =
                          _itemEntryProvider!.psValueHolder!.locationTownshipLng;
                  } else {
                    latlng = LatLng(
                        double.parse(
                            _itemEntryProvider!.psValueHolder!.locationLat!),
                        double.parse(
                            _itemEntryProvider!.psValueHolder!.locationLng!));
                    if (userInputLattitude.text.isEmpty)
                      userInputLattitude.text =
                          _itemEntryProvider!.psValueHolder!.locationLat!;
                    if (userInputLongitude.text.isEmpty)
                      userInputLongitude.text =
                          _itemEntryProvider!.psValueHolder!.locationLng!;
                  }
                  if (
                      _itemEntryProvider!.itemLocationCityId != '')
                    _itemEntryProvider!.itemLocationCityId =
                        _itemEntryProvider!.psValueHolder!.locationId!;

                    _itemEntryProvider!.itemCurrencyId =
                      _itemEntryProvider!.psValueHolder!.defaultCurrencyId;
                  priceController.text =
                      _itemEntryProvider!.psValueHolder!.defaultCurrency;

                  _itemEntryProvider!.getItemFromDB(widget.item!.id);

                  return _itemEntryProvider;
                }),
            ChangeNotifierProvider<GalleryProvider?>(
                lazy: false,
                create: (BuildContext context) {
                  galleryProvider = GalleryProvider(repo: galleryRepository);
                  if (widget.flag == PsConst.EDIT_ITEM) {
                    galleryProvider!.loadImageList(
                        widget.item!.defaultPhoto!.imgParentId!,
                        PsConst.ITEM_TYPE);
                  }
                  return galleryProvider;
                }),
            ChangeNotifierProvider<UserProvider?>(
              lazy: false,
              create: (BuildContext context) {
                userProvider = UserProvider(
                    repo: userRepository, psValueHolder: valueHolder);
                userProvider!.getUser(valueHolder!.loginUserId!);
                return userProvider;
              },
            )
          ],
        child: Consumer<UserProvider>(builder: (BuildContext context, UserProvider? provider, Widget? child) {
          if (widget.flag == PsConst.ADD_NEW_ITEM && valueHolder!.isPaidApp == PsConst.ONE && provider!.user.data == null) 
              return Container(
                color: PsColors.backgroundColor
              ); 
          if (widget.flag == PsConst.EDIT_ITEM || (valueHolder!.isPaidApp != PsConst.ONE || 
                                ( provider!.user.data != null  &&
                                int.parse( provider.user.data!.remainingPost!) > 0)))
          return SingleChildScrollView(
            child: AnimatedBuilder(
                animation: widget.animationController,
                child: Container(
                  color: PsColors.backgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: PsDimens.space16,
                            left: PsDimens.space10,
                            right: PsDimens.space10),
                        child: Text(
                            Utils.getString(
                                context, 'item_entry__listing_today'),
                            style: Theme.of(context).textTheme.bodyText2),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: PsDimens.space16,
                            left: PsDimens.space10,
                            right: PsDimens.space10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                  Utils.getString(context,
                                      'item_entry__choose_photo_showcase'),
                                  style: Theme.of(context).textTheme.bodyText2),
                            ),
                            Text(' *',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(color: PsColors.mainColor))
                          ],
                        ),
                      ),
                      //  _largeSpacingWidget,
                      Consumer<GalleryProvider>(builder: (BuildContext context,
                          GalleryProvider provider, Widget? child) {
                              
                            if (bindImageFirstTime &&
                                provider.galleryList.data!.isNotEmpty) {
                              for (int i = 0;
                                  i < widget.maxImageCount && i < provider.galleryList.data!.length;
                                  i++) {
                                if (provider.galleryList.data![i].imgId !=
                                    null) {
                                  uploadedImages[i] =
                                      provider.galleryList.data![i];
                                }
                              }
                              bindImageFirstTime = false;
                            }

                           return ImageUploadHorizontalList(
                              flag: widget.flag,
                              images: images,
                              selectedImageList: uploadedImages,
                              updateImages: updateImages,
                              updateImagesFromCustomCamera:
                                  updateImagesFromCustomCamera,
                              videoFilePath: videoFilePath,
                              videoFileThumbnailPath: videoFileThumbnailPath,
                              selectedVideoImagePath: selectedVideoImagePath,
                              updateImagesFromVideo: updateImagesFromVideo,
                              selectedVideoPath: selectedVideoPath,
                              getImageFromVideo: _getImageFromVideo,
                              imageDesc1Controller:
                                  galleryProvider!.imageDesc1Controller,
                              provider: _itemEntryProvider,
                              galleryProvider: provider,
                              onReorder: onReorder,
                              cameraImagePath: cameraImagePath,
                              galleryImagePath: galleryImageAsset,
                            );
                      }),

                      Consumer<ItemEntryProvider>(builder:
                          (BuildContext context, ItemEntryProvider provider,
                              Widget? child) {
                        if (
                            provider.item.id != null) {
                          if (bindDataFirstTime) {
                            userInputListingTitle.text = provider.item.title!;
                            userInputConfiguration.text =
                                provider.item.configuration!;
                            userInputHighLightInformation.text =
                                provider.item.highlightInformation!;
                            userInputFloorNo.text = provider.item.floorNo!;
                            userInputDescription.text =
                                provider.item.description!;
                            userInputArea.text = provider.item.area!;
                            userInputLattitude.text = provider.item.lat!;
                            userInputLongitude.text = provider.item.lng!;
                            userInputAddress.text = provider.item.address!;
                            priceTypeController.text =
                                provider.item.itemPriceType!.name!;
                            userInputPrice.text = provider.item.price!;
                            userInputPriceUnit.text = provider.item.priceUnit!;
                            userInputPriceNote.text = provider.item.priceNote!;
                            userInputisNegotiableNote.text =
                                provider.item.isNegotiable!;
                            propertyController.text =
                                provider.item.propertyType!.name!;
                            postedController.text = provider.item.postType!.name!;
                            userInputDiscount.text = provider.item.discountRate!;
                            
                            for (int i = 0; i < provider.item.itemAmenitiesList!.length; i++) {
                              selectedAmenitiesList[provider.item.itemAmenitiesList![i]] = true;
                              amenitiesController.text += provider.item.itemAmenitiesList![i].name!+ ',';
                              provider.amenityId += provider.item.itemAmenitiesList![i].id!+ ',';
                            }

                            // if (valueHolder.isSubLocation == PsConst.ONE) {
                              // userInputLattitude.text =
                              //     provider.item.itemLocationTownship.lat;
                              // userInputLongitude.text =
                              //     provider.item.itemLocationTownship.lng;
                              userInputLattitude.text = provider.item.lat!;
                              userInputLongitude.text = provider.item.lng!;
                              provider.itemLocationTownshipId =
                                  provider.item.itemLocationTownship!.id!;
                            //  locationTownshipController.text = provider
                            //      .item.itemLocationTownship.townshipName;
                            // } else {
                            //   userInputLattitude.text = provider.item.lat;
                            //   userInputLongitude.text = provider.item.lng;
                            // }
                            
                            priceController.text =
                                provider.item.itemCurrency!.currencySymbol!;
                            locationController.text =
                                provider.item.itemLocationCity!.name!;
                            locationTownshipController.text =
                                provider.item.itemLocationTownship!.townshipName!;
                            provider.cityId =
                                provider.item.itemLocationTownship!.cityId!;
                            provider.propertyById =
                                provider.item.propertyType!.id!;
                            provider.postedById = provider.item.postType!.id!;
                            provider.itemPriceTypeId =
                                provider.item.itemPriceType!.id!;
                            provider.itemCurrencyId =
                                provider.item.itemCurrency!.id!;
                            provider.itemLocationCityId =
                                provider.item.itemLocationCity!.id!;
                            provider.itemLocationTownshipId =
                                provider.item.itemLocationTownship!.id!;
                            selectedVideoImagePath =
                                provider.item.videoThumbnail!.imgPath;
                            selectedVideoPath = provider.item.video!.imgPath; 
                            bindDataFirstTime = false;

                          }
                        }
                        return AllControllerTextWidget(
                          userInputListingTitle: userInputListingTitle,
                          propertyController: propertyController,
                          postedController: postedController,
                          amenitiesController: amenitiesController,
                          priceController: priceController,
                          userInputConfiguration: userInputConfiguration,
                          userInputHighLightInformation:
                              userInputHighLightInformation,
                          userInputFloorNo: userInputFloorNo,
                          userInputDescription: userInputDescription,
                          userInputArea: userInputArea,
                          locationController: locationController,
                          locationTownshipController:
                              locationTownshipController,
                          userInputLattitude: userInputLattitude,
                          userInputLongitude: userInputLongitude,
                          userInputAddress: userInputAddress,
                          userInputPrice: userInputPrice,
                          priceTypeController: priceTypeController ,
                          userInputPriceUnit: userInputPriceUnit,
                          userInputPriceNote: userInputPriceNote,
                          userInputisNegotiable: userInputisNegotiableNote,
                          userInputDiscount: userInputDiscount,
                          mapController: mapController,
                          zoom: zoom,
                          flag: widget.flag!,
                          item: widget.item!,
                          provider: provider,
                          galleryProvider: galleryProvider!,
                          latlng: latlng,
                            uploadImage: (String itemId) {
                                  uploadImage(itemId);
                              },
                          isImageSelected: isImageSelected,
                          isSelectedVideoImagePath: isSelectedVideoImagePath,
                          selectedAmenitiesList: selectedAmenitiesList,
                          updateAmenitiesData: updateAmenitiesData,
                          updateMapController: updateMapController,
                          googleMapController: googleMapController,
                        );
                      })
                    ],
                  ),
                ),
                builder: (BuildContext context, Widget? child) {
                  return child!;
                }),
          );
             else 
                return InAppPurchaseBuyPackageDialog(
                onInAppPurchaseTap: () async {
                  // InAppPurchase View
                  final dynamic returnData = await Navigator.pushNamed(
                      context, RoutePaths.buyPackage,
                      arguments: <String, dynamic>{
                        'android': valueHolder?.packageAndroidKeyList,
                        'ios': valueHolder?.packageIOSKeyList
                      });

                  if (returnData != null) {
                    setState(() {
                      userProvider!.user.data!.remainingPost = returnData;
                    });
                  } else {
                    provider.getUser(valueHolder!.loginUserId ?? '');
                  }
                },
              );   
        },
      ),
      ),
    );
  }
}

class AllControllerTextWidget extends StatefulWidget {
  const AllControllerTextWidget(
      {Key? key,
      this.userInputListingTitle,
      this.propertyController,
      this.postedController,
      this.amenitiesController,
      this.typeController,
      this.priceController,
      this.userInputHighLightInformation,
      this.userInputFloorNo,
      this.userInputDescription,
      this.userInputArea,
      this.userInputConfiguration,
      this.userInputDealOptionText,
      this.locationController,
      this.locationTownshipController,
      this.userInputLattitude,
      this.userInputLongitude,
      this.userInputAddress,
      this.priceTypeController,
      this.userInputPrice,
      this.userInputPriceUnit,
      this.userInputPriceNote,
      this.userInputisNegotiable,
      this.userInputDiscount,
      this.mapController,
      this.provider,
      this.galleryProvider,
      this.selectedAmenitiesList,
      this.updateAmenitiesData,
      this.latlng,
      this.zoom,
      this.flag,
      this.item,
      this.uploadImage,
      required this.isImageSelected,
      this.isSelectedVideoImagePath,
      this.googleMapController,
      this.updateMapController})
      : super(key: key);

  final TextEditingController? userInputListingTitle;
  final TextEditingController? propertyController;
  final TextEditingController? postedController;
  final TextEditingController? amenitiesController;
  final TextEditingController? typeController;
  final TextEditingController? priceController;
  final TextEditingController? userInputConfiguration;
  final TextEditingController? userInputHighLightInformation;
  final TextEditingController? userInputFloorNo;
  final TextEditingController? userInputDescription;
  final TextEditingController? userInputArea;
  final TextEditingController? userInputDealOptionText;
  final TextEditingController? locationController;
  final TextEditingController? locationTownshipController;
  final TextEditingController? userInputLattitude;
  final TextEditingController? userInputLongitude;
  final TextEditingController? userInputAddress;
  final TextEditingController? priceTypeController;
  final TextEditingController? userInputPrice;
  final TextEditingController? userInputPriceUnit;
  final TextEditingController? userInputPriceNote;
  final TextEditingController? userInputisNegotiable;
  final TextEditingController? userInputDiscount;
  final MapController? mapController;
  final ItemEntryProvider? provider;
  final double? zoom;
  final String ?flag;
  final Product? item;
  final LatLng? latlng;
  final Function? uploadImage;
  final List<bool> isImageSelected;
  final GalleryProvider? galleryProvider;
  final bool? isSelectedVideoImagePath;
  final Map<Amenities, bool>? selectedAmenitiesList;
  final googlemap.GoogleMapController? googleMapController;
  final Function? updateMapController;
  final Function? updateAmenitiesData;

  @override
  _AllControllerTextWidgetState createState() =>
      _AllControllerTextWidgetState();
}

class _AllControllerTextWidgetState extends State<AllControllerTextWidget> {
  LatLng? _latlng;
  googlemap.CameraPosition? _kLake;
  PsValueHolder? valueHolder;
  ItemEntryProvider? itemEntryProvider;
  googlemap.CameraPosition? kGooglePlex;

  @override
  Widget build(BuildContext context) {
    itemEntryProvider = Provider.of<ItemEntryProvider>(context, listen: false);
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);
    _latlng ??= widget.latlng;
        kGooglePlex = googlemap.CameraPosition(
      target: googlemap.LatLng(_latlng!.latitude, _latlng!.longitude),
      zoom: widget.zoom!,
    );
    if ((widget.flag == PsConst.ADD_NEW_ITEM &&
            widget.locationController!.text ==
                itemEntryProvider!.psValueHolder!.locactionName) ||
        (widget.flag == PsConst.ADD_NEW_ITEM &&
            widget.locationController!.text.isEmpty)) {
      widget.locationController!.text =
          itemEntryProvider!.psValueHolder!.locactionName!;
    }
    if ( widget.flag == PsConst.EDIT_ITEM) {
      // if (valueHolder.isSubLocation == PsConst.ONE) {
        // _latlng = LatLng(
        //     double.parse(itemEntryProvider.item.itemLocationTownship.lat),
        //     double.parse(itemEntryProvider.item.itemLocationTownship.lng));
        // kGooglePlex = googlemap.CameraPosition(
        //   target: googlemap.LatLng(
        //       double.parse(itemEntryProvider.item.itemLocationTownship.lat),
        //       double.parse(itemEntryProvider.item.itemLocationTownship.lng)),
        _latlng = LatLng(double.parse(itemEntryProvider!.item.lat!),
            double.parse(itemEntryProvider!.item.lng!));
        kGooglePlex = googlemap.CameraPosition(
          target: googlemap.LatLng(double.parse(itemEntryProvider!.item.lat!),
              double.parse(itemEntryProvider!.item.lng!)),
          zoom: widget.zoom!,
        );
      // } else {
      //   _latlng = LatLng(double.parse(itemEntryProvider.item.lat),
      //       double.parse(itemEntryProvider.item.lng));
      //   kGooglePlex = googlemap.CameraPosition(
      //     target: googlemap.LatLng(double.parse(itemEntryProvider.item.lat),
      //         double.parse(itemEntryProvider.item.lng)),
      //     zoom: widget.zoom,
      //   );
      // }
    }

    final Widget _uploadItemWidget = Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space16,
            right: PsDimens.space16,
            top: PsDimens.space16,
            bottom: PsDimens.space48),
        width: double.infinity,
        height: PsDimens.space44,
        child: PSButtonWidget(
          hasShadow: true,
          width: double.infinity,
          titleText: Utils.getString(context, 'login__submit'),
          onPressed: () async {
            if (!widget.isImageSelected.contains(true) &&
                      widget.galleryProvider!.galleryList.data!.isEmpty) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message:
                          Utils.getString(context, 'item_entry_need_image'),
                      onPressed: () {},
                    );
                  });
            } else if (
                widget.userInputListingTitle!.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_entry__need_listing_title'),
                      onPressed: () {},
                    );
                  });
            } else if (
                widget.propertyController!.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message:
                          Utils.getString(context, 'item_entry_need_property'),
                      onPressed: () {},
                    );
                  });
            } else if (
                widget.postedController!.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message:
                          Utils.getString(context, 'item_entry_need_post_type'),
                      onPressed: () {},
                    );
                  });
            // } else if (
            //     widget.amenitiesController!.text == '') {
            //   showDialog<dynamic>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return WarningDialog(
            //           message:
            //               Utils.getString(context, 'item_entry_need_amenities'),
            //           onPressed: () {},
            //         );
            //       });
            //  } else if (
            //     widget.priceTypeController!.text == '') {
            //   showDialog<dynamic>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return WarningDialog(
            //           message: Utils.getString(
            //               context, 'item_entry_need_price_type'),
            //           onPressed: () {},
            //         );
            //       });
            } else if (
                widget.priceController!.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_entry_need_currency_symbol'),
                      onPressed: () {},
                    );
                  });
            } else if (
                widget.userInputPrice!.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message:
                          Utils.getString(context, 'item_entry_need_price'),
                      onPressed: () {},
                    );
                  });
            // } else if (
            //     widget.userInputConfiguration!.text == '') {
            //   showDialog<dynamic>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return WarningDialog(
            //           message:
            //               Utils.getString(context, 'item_entry_need_configuration'),
            //           onPressed: () {},
            //         );
            //       });
            // } else if (
            //     widget.userInputArea!.text == '') {
            //   showDialog<dynamic>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return WarningDialog(
            //           message:
            //               Utils.getString(context, 'item_entry_need_price_area'),
            //           onPressed: () {},
            //         );
            //       });
            // } else if (
            //     widget.userInputFloorNo!.text == '') {
            //   showDialog<dynamic>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return WarningDialog(
            //           message:
            //               Utils.getString(context, 'item_entry_need_floor_no'),
            //           onPressed: () {},
            //         );
            //       });
           } else if (valueHolder!.isSubLocation == PsConst.ONE &&
                (
                    widget.locationTownshipController!.text == '')) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_entry_need_location_township'),
                      onPressed: () {},
                    );
                  });
             } else if (widget.provider!.itemLocationCityId == '' ) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_entry_need_location_id'),
                      onPressed: () {},
                    );
                  });
            } else if ( Utils.showUI(valueHolder!.lat) && widget.userInputLattitude!.text == PsConst.ZERO ||
                widget.userInputLattitude!.text == PsConst.ZERO ||
                widget.userInputLattitude!.text == PsConst.INVALID_LAT_LNG ||
                widget.userInputLattitude!.text == PsConst.INVALID_LAT_LNG) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message:
                          Utils.getString(context, 'item_entry_pick_location'),
                      onPressed: () {},
                    );
                  });

            } else {
               if (widget.flag == PsConst.ADD_NEW_ITEM) {
              if (!PsProgressDialog.isShowing()) {
                await PsProgressDialog.showDialog(context,
                    message: Utils.getString(
                        context, 'progressloading_item_uploading'));
              }
             
                //
                //add new
                final ItemEntryParameterHolder itemEntryParameterHolder =
                    ItemEntryParameterHolder(
                  title: widget.userInputListingTitle!.text,
                  description: widget.userInputDescription!.text,
                  area: widget.userInputArea!.text,
                  address: widget.userInputAddress!.text,
                  configuration: widget.userInputConfiguration!.text,
                  highlightInfomation:
                      widget.userInputHighLightInformation!.text,
                  floorNo: widget.userInputFloorNo!.text,
                  postedById: widget.provider!.postedById,
                  propertyById: widget.provider!.propertyById,
                  itemPriceTypeId: widget.provider!.itemPriceTypeId,
                  price: widget.userInputPrice!.text,
                  discountRate: widget.userInputDiscount!.text,
                  priceUnit: widget.userInputPriceUnit!.text,
                  priceNote: widget.userInputPriceNote!.text,
                  isNegotiable: widget.userInputisNegotiable!.text,
                  itemCurrencyId: widget.provider!.itemCurrencyId,
                  itemLocationCityId: widget.provider!.itemLocationCityId,
                  itemLocationTownshipId:
                      widget.provider!.itemLocationTownshipId,
                  latitude: widget.userInputLattitude!.text,
                  longitude: widget.userInputLongitude!.text,
                  amenityId: widget.provider!.amenityId,
                  id: widget.provider!.itemId, //must be '' <<< ID
                  addedUserId: widget.provider!.psValueHolder!.loginUserId,
                );

                final PsResource<Product> itemData = await widget.provider!
                    .postItemEntry(itemEntryParameterHolder.toMap(),
                valueHolder!.loginUserId!);
                PsProgressDialog.dismissDialog();

                if (itemData.status == PsStatus.SUCCESS) {
                  widget.provider!.itemId = itemData.data!.id!;
                  if (itemData.data != null) {
                    if (widget.isImageSelected.contains(true)) {
                      widget.uploadImage!(itemData.data!.id);
                    }
                  }
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: itemData.message,
                        );
                      });
                }
              } else {
                    if (!PsProgressDialog.isShowing()) {
                    await PsProgressDialog.showDialog(context,
                        message: Utils.getString(
                            context, 'progressloading_item_uploading'));
                  }
                // edit item
                final ItemEntryParameterHolder itemEntryParameterHolder =
                    ItemEntryParameterHolder(
                  title: widget.userInputListingTitle!.text,
                  description: widget.userInputDescription!.text,
                  area: widget.userInputArea!.text,
                  address: widget.userInputAddress!.text,
                  configuration: widget.userInputConfiguration!.text,
                  highlightInfomation:
                      widget.userInputHighLightInformation!.text,
                  floorNo: widget.userInputFloorNo!.text,
                  postedById: widget.provider!.postedById,
                  propertyById: widget.provider!.propertyById,
                  itemPriceTypeId: widget.provider!.itemPriceTypeId,
                  price: widget.userInputPrice!.text,
                  discountRate: widget.userInputDiscount!.text,
                  priceUnit: widget.userInputPriceUnit!.text,
                  priceNote: widget.userInputPriceNote!.text,
                  isNegotiable: widget.userInputisNegotiable!.text,
                  itemCurrencyId: widget.provider!.itemCurrencyId,
                  itemLocationCityId: widget.provider!.itemLocationCityId,
                  itemLocationTownshipId:
                      widget.provider!.itemLocationTownshipId,
                  latitude: widget.userInputLattitude!.text,
                  longitude: widget.userInputLongitude!.text,
                  amenityId: widget.provider!.amenityId,
                  id: widget.item!.id, //must be '' <<< ID
                  addedUserId: widget.provider!.psValueHolder!.loginUserId,
                );

                final PsResource<Product> itemData = await widget.provider!
                    .postItemEntry(itemEntryParameterHolder.toMap(),
                valueHolder!.loginUserId!);
                PsProgressDialog.dismissDialog();

                if (itemData.status == PsStatus.SUCCESS) {
                  if (itemData.data != null) {
                    Fluttertoast.showToast(
                        msg: 'Item Uploaded',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white);

                      if (widget.isImageSelected.contains(true) || widget.isSelectedVideoImagePath!) {
                       widget.uploadImage!(itemData.data!.id);

                      }
                  }
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: itemData.message,
                        );
                      });
                }
              }
            }
          },
        ));

    return Column(children: <Widget>[
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__listing_title'),
        height: PsDimens.space44,
        textAboutMe: false,
        hintText: Utils.getString(context, 'item_entry__entry_title'),
        textEditingController: widget.userInputListingTitle,
        isStar: true,
      ),
      PsDropdownBaseWithControllerWidget(
        title: Utils.getString(context, 'item_entry__property_type'),
        textEditingController: widget.propertyController,
        isStar: true,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          final ItemEntryProvider provider =
              Provider.of<ItemEntryProvider>(context, listen: false);

          final dynamic propertyResult =
              await Navigator.pushNamed(context, RoutePaths.searchPropertyBy);

          if (propertyResult != null && propertyResult is PropertyType) {
            provider.propertyById = propertyResult.id!;
            widget.propertyController!.text = propertyResult.name!;

            setState(() {
              widget.propertyController!.text = propertyResult.name!;
            });
          }
        },
      ),
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__post_type'),
          textEditingController: widget.postedController,
          isStar: true,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);
            final dynamic postedResult = await Navigator.pushNamed(
                context, RoutePaths.searchPostType);
            if (postedResult != null && postedResult is PostType) {
              provider.postedById = postedResult.id!;

              widget.postedController!.text = postedResult.name!;
            }
          }),
     if (Utils.showUI(valueHolder!.amenities))
      PsDropdownBaseWithControllerWidget(
        title: Utils.getString(context, 'item_entry__amenities'),
        textEditingController: widget.amenitiesController,
        isStar: true,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());

          final ItemEntryProvider provider =
              Provider.of<ItemEntryProvider>(context, listen: false);
          print(provider.amenityId);
          final dynamic returnData = await Navigator.pushNamed(context, RoutePaths.entryAmenitiesList,
              arguments: AmenitiesIntentHolder(
                  amenityId: widget.provider!.amenityId,
                  selectedAmenitiesList: widget.selectedAmenitiesList!));
          if (returnData != null) {
            //  widget.selectedAmenitiesList = returnData;

          await widget.updateAmenitiesData!(returnData);
          
          widget.amenitiesController!.text = '';

          widget.selectedAmenitiesList!.forEach((Amenities key, bool value) {
            print('$key: $value');
            if (value == true) {
            provider.amenityId += key.id!+',';

            widget.amenitiesController!.text  += key.name!+',';
            }

          });
          }
        },
      ),
      if (Utils.showUI(valueHolder!.priceUnit))
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__price_unit'),
        height: PsDimens.space44,
        hintText: Utils.getString(context, 'item_entry__price_unit'),
        textAboutMe: true,
        textEditingController: widget.userInputPriceUnit,
      ),
      if (Utils.showUI(valueHolder!.priceNote))
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__price_note'),
        height: PsDimens.space44,
        hintText: Utils.getString(context, 'item_entry__price_note'),
        textAboutMe: true,
        textEditingController: widget.userInputPriceNote,
      ),
      if (Utils.showUI(valueHolder!.priceTypeId))
      PsDropdownBaseWithControllerWidget(
      title: Utils.getString(context, 'item_entry__price_type'),
      textEditingController: widget.priceTypeController,
      isStar: true,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        final ItemEntryProvider provider =
            Provider.of<ItemEntryProvider>(context, listen: false);

        final dynamic itemPriceTypeResult =
            await Navigator.pushNamed(context, RoutePaths.itemPriceType);

        if (itemPriceTypeResult != null &&
            itemPriceTypeResult is ItemPriceType) {
          provider.itemPriceTypeId = itemPriceTypeResult.id!;
          
          setState(() {
            widget.priceTypeController!.text = itemPriceTypeResult.name!;
            
          });
        }
      }),
      PriceDropDownControllerWidget(
          currencySymbolController: widget.priceController,
          userInputPriceController: widget.userInputPrice),
      const SizedBox(height: PsDimens.space8),
      Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: PsDimens.space12,right: 12),
            child: Text(Utils.getString(context, 'item_entry__for_free_item'),
                style: Theme.of(context).textTheme.bodyText2),
          ),
          const SizedBox(height: PsDimens.space8),
          if (Utils.showUI(valueHolder!.isNegotiable))
          Padding(
            padding: const EdgeInsets.only(left: PsDimens.space12,right: 12),
            child: Text(Utils.getString(context, 'item_entry__is_negotiable'),
                style: Theme.of(context).textTheme.bodyText2),
          ),
          IsNegotiableCheckbox(
            provider: widget.provider!,
            onNegotiableCheckBoxClick: () {
              setState(() {
                isNegotiableUpdateCheckBox(context, widget.provider!);
              });
            },
          ),
          // const SizedBox(height: PsDimens.space8),
          // Padding(
          //   padding: const EdgeInsets.only(left: PsDimens.space12),
          //   child: Text(Utils.getString(context, 'item_entry__shop_setting'),
          //       style: Theme.of(context).textTheme.bodyText2),
          // ),
          // BusinessModeCheckbox(
          //   provider: widget.provider,
          //   onCheckBoxClick: () {
          //     setState(() {
          //       updateCheckBox(context, widget.provider);
          //     });
          //   },
          // ),
          Padding(
            padding: const EdgeInsets.only(left: PsDimens.space40,right: 12),
            child: Text(
                Utils.getString(context, 'item_entry__show_more_than_one'),
                style: Theme.of(context).textTheme.bodyText1),
          ),
        ],
      ),
      if (Utils.showUI(valueHolder!.discountRate))
      PsTextFieldWidget(
        //  height: 46,
        titleText: Utils.getString(context, 'item_entry__discount_title'),
        textAboutMe: false,
        hintText: Utils.getString(context, 'item_entry__discount_info'),
        textEditingController: widget.userInputDiscount,
        keyboardType: TextInputType.number,
      ),
      if (Utils.showUI(valueHolder!.configuration))
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__configuration'),
        height: PsDimens.space50,
        isStar: true,
        hintText: Utils.getString(context, 'item_entry__configuration'),
        textAboutMe: true,
        textEditingController: widget.userInputConfiguration,
      ),
      if (Utils.showUI(valueHolder!.highlightInfo))
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__highlight_info'),
        height: PsDimens.space120,
        hintText: Utils.getString(context, 'item_entry__highlight_info'),
        textAboutMe: true,
        keyboardType: TextInputType.multiline,
        textEditingController: widget.userInputHighLightInformation,
      ),
      if (Utils.showUI(valueHolder!.floorNo))
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__floor_no'),
        height: PsDimens.space44,
        isStar: true,
        hintText: Utils.getString(context, 'item_entry__floor_no'),
        textAboutMe: true,
        textEditingController: widget.userInputFloorNo,
      ),
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__description'),
        height: PsDimens.space120,
        hintText: Utils.getString(context, 'item_entry__description'),
        textAboutMe: true,
        keyboardType: TextInputType.multiline,
        textEditingController: widget.userInputDescription,
        isStar: true,
      ),
      if (Utils.showUI(valueHolder!.area))
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__area'),
        height: PsDimens.space44,
        isStar: true,
        hintText: Utils.getString(context, 'item_entry__area'),
        textAboutMe: true,
        textEditingController: widget.userInputArea,
      ),
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__location'),
          textEditingController: widget.locationController,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);

            final dynamic itemLocationResult =
                await Navigator.pushNamed(context, RoutePaths.itemLocation);

            if (itemLocationResult != null &&
                itemLocationResult is ItemLocationCity) {
              provider.itemLocationCityId = itemLocationResult.id!;
              setState(() {
                 widget.locationController!.text = itemLocationResult.name!;
                if (valueHolder!.isUseGoogleMap! &&
                    valueHolder!.isSubLocation == PsConst.ZERO
                    ) {
                  _kLake = googlemap.CameraPosition(
                      target:
                          googlemap.LatLng(_latlng!.latitude, _latlng!.longitude),
                      zoom: widget.zoom!);
                  if (_kLake != null) {
                    widget.googleMapController!.animateCamera(
                        googlemap.CameraUpdate.newCameraPosition(_kLake!));
                  }
                  widget.userInputLattitude!.text = itemLocationResult.lat!;
                  widget.userInputLongitude!.text = itemLocationResult.lng!;
                } else if (!valueHolder!.isUseGoogleMap!  &&
                    valueHolder!.isSubLocation == PsConst.ZERO
                    ) {
                  _latlng = LatLng(double.parse(itemLocationResult.lat!),
                      double.parse(itemLocationResult.lng!));
                  widget.mapController!.move(_latlng!, widget.zoom!);
                  widget.userInputLattitude!.text = itemLocationResult.lat!;
                  widget.userInputLongitude!.text = itemLocationResult.lng!;
                } else {
                  //do nothing
                }

                widget.locationTownshipController!.text = '';
                provider.itemLocationTownshipId = '';
                widget.userInputAddress!.text = '';
              });
            }
          }),
     if (valueHolder!.isSubLocation == PsConst.ONE)
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__location_township'),
          textEditingController: widget.locationTownshipController,
          isStar: true,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);
            if (provider.itemLocationCityId != '') {
              final dynamic itemLocationTownshipResult =
                  await Navigator.pushNamed(
                      context, RoutePaths.itemLocationTownship,
                      arguments: provider.itemLocationCityId);

              if (itemLocationTownshipResult != null &&
                  itemLocationTownshipResult is ItemLocationTownship) {
                provider.itemLocationTownshipId = itemLocationTownshipResult.id!;
                setState(() {
                    widget.locationTownshipController!.text =
                        itemLocationTownshipResult.townshipName!;
                    if (valueHolder!.isUseGoogleMap!) {
                      _kLake = googlemap.CameraPosition(
                          target: googlemap.LatLng(
                              _latlng!.latitude, _latlng!.longitude),
                          zoom: widget.zoom!);
                      if (_kLake != null) {
                        widget.googleMapController!.animateCamera(
                            googlemap.CameraUpdate.newCameraPosition(_kLake!));
                      }
                    } else {
                      _latlng = LatLng(
                          double.parse(itemLocationTownshipResult.lat!),
                          double.parse(itemLocationTownshipResult.lng!));
                      widget.mapController!.move(_latlng!, widget.zoom!);
                    }
                    widget.userInputLattitude!.text =
                        itemLocationTownshipResult.lat!;
                    widget.userInputLongitude!.text =
                        itemLocationTownshipResult.lng!;

                    widget.userInputAddress!.text = '';
                  });
              }
            } else {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message: Utils.getString(
                          context, 'home_search__choose_city_first'),
                    );
                  });
              const ErrorDialog(message: 'Choose City first');
            }
          })
      else
        Container(),
      if ( !valueHolder!.isUseGoogleMap!)
      Column(
        children:<Widget> [
        
          CurrentLocationWidget(
            androidFusedLocation: true,
            textEditingController: widget.userInputAddress!,
            latController: widget.userInputLattitude!,
            lngController: widget.userInputLongitude!,
            valueHolder: valueHolder!,
            updateLatLng: (Position? currentPosition) {
              if (currentPosition != null) {
                setState(() {
                  _latlng =
                      LatLng(currentPosition.latitude, currentPosition.longitude);
                  widget.mapController!.move(_latlng!, widget.zoom!);
                });
              }
            },
          ),

      Padding(
        padding: const EdgeInsets.only(right: 8, left: 8),
        child: Container(
          height: 250,
          child: FlutterMap(
            mapController: widget.mapController,
            options: MapOptions(
                center:
                    _latlng, //LatLng(51.5, -0.09), //LatLng(45.5231, -122.6765),
                zoom: widget.zoom!, //10.0,
                onTap: (TapPosition tapPosition, LatLng latLng) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _handleTap(_latlng!, widget.mapController!);
                }),
            layers: <LayerOptions>[
              TileLayerOptions(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayerOptions(markers: <Marker>[
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: _latlng!,
                  builder: (BuildContext ctx) => Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.location_on,
                        color: PsColors.mainColor,
                      ),
                      iconSize: 45,
                      onPressed: () {},
                    ),
                  ),
                )
              ])
            ],
          ),
        ),
      )
      ],
      )
      else 
        Column(
          children: <Widget>[
           
            CurrentLocationWidget(
              androidFusedLocation: true,
              textEditingController: widget.userInputAddress!,
              latController: widget.userInputLattitude!,
              lngController: widget.userInputLongitude!,
              valueHolder: valueHolder!,
              updateLatLng: (Position? currentPosition) {
                if (currentPosition != null) {
                  setState(() {
                    _latlng = LatLng(
                        currentPosition.latitude, currentPosition.longitude);
                    _kLake = googlemap.CameraPosition(
                        target: googlemap.LatLng(
                            _latlng!.latitude, _latlng!.longitude),
                        zoom: widget.zoom!);
                    if (_kLake != null) {
                      widget.googleMapController!.animateCamera(
                          googlemap.CameraUpdate.newCameraPosition(_kLake!));
                    }
                  });
                }
              },
            ),
           Padding(
              padding: const EdgeInsets.only(right: 18, left: 18),
              child: Container(
                height: 250,
                child: googlemap.GoogleMap(
                    onMapCreated: widget.updateMapController as void Function(
                        googlemap.GoogleMapController)? ,
                    initialCameraPosition: kGooglePlex!,
                    circles: <googlemap.Circle>{}..add(googlemap.Circle(
                        circleId: googlemap.CircleId(
                            widget.userInputAddress.toString()),
                        center: googlemap.LatLng(
                            _latlng!.latitude, _latlng!.longitude),
                        radius: 50,
                        fillColor: Colors.blue.withOpacity(0.7),
                        strokeWidth: 3,
                        strokeColor: Colors.redAccent,
                      )),
                    onTap: (googlemap.LatLng latLngr) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _handleGoogleMapTap(_latlng!, widget.googleMapController!);
                    }),
              ),
            ),
          ],
        ),
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__latitude'),
        textAboutMe: false,
        textEditingController: widget.userInputLattitude,
      ),
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__longitude'),
        textAboutMe: false,
        textEditingController: widget.userInputLongitude,
      ),
      if (Utils.showUI(valueHolder!.address))
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__address'),
        textAboutMe: false,
        height: PsDimens.space160,
        textEditingController: widget.userInputAddress,
        hintText: Utils.getString(context, 'item_entry__address'),
      ),
      _uploadItemWidget
    ]);
  }

  dynamic _handleTap(LatLng latLng, MapController mapController) async {
    final dynamic result = await Navigator.pushNamed(context, RoutePaths.mapPin,
        arguments: MapPinIntentHolder(
            flag: PsConst.PIN_MAP,
            mapLat: _latlng!.latitude.toString(),
            mapLng: _latlng!.longitude.toString()));
    if (result != null && result is MapPinCallBackHolder) {
      setState(() {
        _latlng = result.latLng;
        mapController.move(_latlng!, widget.zoom!);
        widget.userInputAddress!.text = result.address;
        widget.userInputAddress!.text = '';
        // tappedPoints = <LatLng>[];
        // tappedPoints.add(latlng);
      });
      widget.userInputLattitude!.text = result.latLng.latitude.toString();
      widget.userInputLongitude!.text = result.latLng.longitude.toString();
    }
  }

    dynamic _handleGoogleMapTap(
      LatLng latLng, googlemap.GoogleMapController googleMapController) async {
    final dynamic result = await Navigator.pushNamed(
        context, RoutePaths.googleMapPin,
        arguments: MapPinIntentHolder(
            flag: PsConst.PIN_MAP,
            mapLat: _latlng!.latitude.toString(),
            mapLng: _latlng!.longitude.toString()));
    if (result != null && result is GoogleMapPinCallBackHolder) {
      setState(() {
        _latlng = LatLng(result.latLng.latitude, result.latLng.longitude);
        _kLake = googlemap.CameraPosition(
            target: googlemap.LatLng(_latlng!.latitude, _latlng!.longitude),
            zoom: widget.zoom!);
        if (_kLake != null) {
          googleMapController
              .animateCamera(googlemap.CameraUpdate.newCameraPosition(_kLake!));
          widget.userInputAddress!.text = result.address;
          widget.userInputAddress!.text = '';
          // tappedPoints = <LatLng>[];
          // tappedPoints.add(latlng);
        }
      });
      widget.userInputLattitude!.text = result.latLng.latitude.toString();
      widget.userInputLongitude!.text = result.latLng.longitude.toString();
    }
  }
}


// ignore: must_be_immutable
class ImageUploadHorizontalList extends StatefulWidget {
  ImageUploadHorizontalList({
    required this.flag,
    required this.images,
    required this.selectedImageList,
    required this.updateImages,
    required this.updateImagesFromCustomCamera,
    required this.updateImagesFromVideo,
    required this.selectedVideoImagePath,
    required this.videoFilePath,
    required this.videoFileThumbnailPath,
    required this.selectedVideoPath,
    required this.galleryImagePath,
    required this.cameraImagePath,
    required this.getImageFromVideo,
    required this.imageDesc1Controller,
    required this.galleryProvider,
    required this.onReorder,
    this.provider,
  });
  final String? flag;
  final List<Asset>? images;
  final List<DefaultPhoto?>? selectedImageList;
  final Function? updateImages;
  final Function? updateImagesFromCustomCamera;
  final String? selectedVideoImagePath;
  final String? videoFilePath;
  final String? selectedVideoPath;
  final String? videoFileThumbnailPath;
  final Function? updateImagesFromVideo;
  List<Asset?> galleryImagePath;
  List<String?> cameraImagePath;
  final Function? getImageFromVideo;
  final TextEditingController? imageDesc1Controller;
  final ItemEntryProvider? provider;
  final GalleryProvider? galleryProvider;
  Function onReorder;

  @override
  State<StatefulWidget> createState() {
    return ImageUploadHorizontalListState();
  }
}

class ImageUploadHorizontalListState extends State<ImageUploadHorizontalList> {
  late ItemEntryProvider provider;
  late PsValueHolder psValueHolder;
  Future<void> loadPickMultiImage(int index) async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages:psValueHolder.maxImageCount - index,
        enableCamera: true,
        // selectedAssets: widget.images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: 'chat'),
        materialOptions: MaterialOptions(
          actionBarColor: Utils.convertColorToString(PsColors.black),
          actionBarTitleColor: Utils.convertColorToString(PsColors.white),
          statusBarColor: Utils.convertColorToString(PsColors.black),
          lightStatusBar: false,
          actionBarTitle: '',
          allViewTitle: 'All Photos',
          useDetailsView: false,
          selectCircleStrokeColor:
              Utils.convertColorToString(PsColors.mainColor),
        ),
      );
    } on Exception catch (e) {
      e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    for (int i = 0; i < resultList.length; i++) {
      if (resultList[i].name!.contains('.webp')) {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(context, 'error_dialog__webp_image'),
              );
            });
        return;
      }
    }
    widget.updateImages!(resultList, -1, index);
  }

  Future<void> loadSingleImage(int index) async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
      //  selectedAssets: widget.images!, //widget.images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: 'chat'),
        materialOptions: MaterialOptions(
          actionBarColor: Utils.convertColorToString(PsColors.black),
          actionBarTitleColor: Utils.convertColorToString(PsColors.white),
          statusBarColor: Utils.convertColorToString(PsColors.black),
          lightStatusBar: false,
          actionBarTitle: '',
          allViewTitle: 'All Photos',
          useDetailsView: false,
          selectCircleStrokeColor:
              Utils.convertColorToString(PsColors.mainColor),
        ),
      );
    } on Exception catch (e) {
      e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    if (resultList[0].name!.contains('.webp')) {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'error_dialog__webp_image'),
            );
          });
    } else {
      widget.updateImages!(resultList, index, index);
    }
  }

  List<Widget> _imageWidgetList = <Widget>[];
  late Widget _videoWidget;
  late Widget _firstImageWidget;
  @override
  Widget build(BuildContext context) {
    Asset? defaultAssetImage;
    DefaultPhoto? defaultUrlImage;
    psValueHolder = Provider.of<PsValueHolder>(context);
    provider = Provider.of<ItemEntryProvider>(context, listen: false);
    List<PlatformFile>? videoFilePath = <PlatformFile>[];

      final Widget _defaultWidget = Container(
      width: 94,
      height: 25,
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
      ),
      margin: const EdgeInsets.only(
          top: PsDimens.space4, left: PsDimens.space6, right: PsDimens.space4),
      child: Material(
        color: PsColors.soldOutUIColor,
        type: MaterialType.card,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(PsDimens.space16))),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
                left: PsDimens.space8, right: PsDimens.space8),
            child: Text(
              Utils.getString(context, 'item_entry__default_image'),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: PsColors.white),
            ),
          ),
        ),
      ),
    );

    _videoWidget = Visibility(
      visible:
          Utils.showUI(provider.psValueHolder!.video), //PsConfig.showVideo,
      child: ItemEntryImageWidget(
        galleryProvider: widget.galleryProvider,
        index: -1, //video
        images: defaultAssetImage,
        selectedVideoImagePath: (widget.selectedVideoImagePath != null)
            ? widget.selectedVideoImagePath
            : null,
        videoFilePath:
            (widget.videoFilePath != null) ? widget.videoFilePath : null,
        videoFileThumbnailPath: (widget.videoFileThumbnailPath != null)
            ? widget.videoFileThumbnailPath
            : null,
        selectedVideoPath: widget.selectedVideoPath,
        cameraImagePath: null,
        provider: provider,
        selectedImage:
            widget.selectedVideoImagePath == null ? defaultUrlImage : null,
        onDeletItemImage: () {
          setState(() {
            final ItemEntryProvider itemEntryProvider =
                Provider.of<ItemEntryProvider>(context, listen: false);
            itemEntryProvider.item.video!.imgId = '';
            itemEntryProvider.item.videoThumbnail!.imgId = '';
            itemEntryProvider.item.video = null;
            itemEntryProvider.item.videoThumbnail = null;
          });
        },
        hideDesc: true,
        onTap: () async {
          try {
            videoFilePath = (await FilePicker.platform.pickFiles(
              type: FileType.video,
              allowMultiple: true,
            ))
                ?.files;
          } on PlatformException catch (e) {
            print('Unsupported operation' + e.toString());
          } catch (ex) {
            print(ex);
          }
     if (videoFilePath != null) {
              final File pickedVideo = File(videoFilePath![0].path!);
              final VideoPlayerController videoPlayer =
                  VideoPlayerController.file(pickedVideo);
              await videoPlayer.initialize();

               final int maximumSecond = int.parse(psValueHolder.videoDuration ?? '60000');
              final int videoDuration = videoPlayer.value.duration.inMilliseconds;

              if (videoDuration < maximumSecond) {
                await widget.getImageFromVideo!(pickedVideo.path);
                widget.updateImagesFromVideo!(pickedVideo.path, -2);
              } else {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                          message: Utils.getString(
                              context, 'error_dialog__select_video'));
                    });
              }
            }
        },
      ),
    );

    _firstImageWidget = Stack(
      key: const Key('0'),
      children: <Widget>[
        ItemEntryImageWidget(
          galleryProvider: widget.galleryProvider,
          index: 0,
          images: (widget.galleryImagePath[0] != null)
              ? widget.galleryImagePath[0]
              : defaultAssetImage,
          selectedVideoImagePath: null,
          selectedVideoPath: widget.selectedVideoPath,
          videoFilePath: null,
          videoFileThumbnailPath: null,
           cameraImagePath: (widget.cameraImagePath[0] != null)
              ? widget.cameraImagePath[0]
              : defaultAssetImage as String?,
          selectedImage: (widget.selectedImageList!.isNotEmpty &&
                  widget.galleryImagePath[0] == null &&
                  widget.cameraImagePath[0] == null)
              ? widget.selectedImageList![0]
              : null,
          onDeletItemImage: () {},
          hideDesc: false,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            if (provider.psValueHolder!.isCustomCamera) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ChooseCameraTypeDialog(
                      onCameraTap: () async {
                        final dynamic returnData = await Navigator.pushNamed(
                            context, RoutePaths.cameraView);
                        if (returnData is String) {
                          widget.updateImagesFromCustomCamera!(returnData, 0);
                        }
                      },
                      onGalleryTap: () {
                        if (widget.flag == PsConst.ADD_NEW_ITEM) {
                          loadPickMultiImage(0);
                        } else {
                          loadSingleImage(0);
                        }
                      },
                    );
                  });
            } else {
              if (widget.flag == PsConst.ADD_NEW_ITEM) {
                loadPickMultiImage(0);
              } else {
                loadSingleImage(0);
              }
            }
          },
        ),
        Positioned(
          child: _defaultWidget,
          left: 1,
          top: 1,
        ),
      ],
    );

    _imageWidgetList = List<Widget>.generate(
         psValueHolder.maxImageCount  -1,
        (int index) => ItemEntryImageWidget(
              galleryProvider: widget.galleryProvider,
              key: Key('${index + 1}'),
              index: index + 1,
              images: (widget.galleryImagePath[index + 1] != null)
                  ? widget.galleryImagePath[index + 1]
                  : defaultAssetImage,
              selectedVideoImagePath: null,
              selectedVideoPath: widget.selectedVideoPath,
              videoFilePath: null,
              videoFileThumbnailPath: null,
              cameraImagePath: (widget.cameraImagePath[index + 1] != null)
                  ? widget.cameraImagePath[index + 1]
                  : defaultAssetImage as String?,
              selectedImage:
                  // (widget.secondImagePath != null) ? null : defaultUrlImage,
                  (widget.selectedImageList!.length > index + 1 &&
                          widget.galleryImagePath[index + 1] == null &&
                          widget.cameraImagePath[index + 1] == null)
                      ? widget.selectedImageList![index + 1]
                      : null,
              hideDesc: false,
              onDeletItemImage: () {
                setState(() {
                  widget.selectedImageList![index + 1]!.imgId = '';
                  widget.selectedImageList![index + 1] =
                      DefaultPhoto(imgId: '', imgPath: '');
                });
              },
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());

                if (provider.psValueHolder!.isCustomCamera) {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ChooseCameraTypeDialog(
                          onCameraTap: () async {
                            final dynamic returnData =
                                await Navigator.pushNamed(
                                    context, RoutePaths.cameraView);
                            if (returnData is String) {
                              widget.updateImagesFromCustomCamera!(
                                  returnData, index + 1);
                            }
                          },
                          onGalleryTap: () {
                            if (widget.flag == PsConst.ADD_NEW_ITEM) {
                              loadPickMultiImage(index + 1);
                            } else {
                              loadSingleImage(index + 1);
                            }
                          },
                        );
                      });
                } else {
                  if (widget.flag == PsConst.ADD_NEW_ITEM) {
                    loadPickMultiImage(index + 1);
                  } else {
                    loadSingleImage(index + 1);
                  }
                }
              },
            ));

    _imageWidgetList.insert(
        0, _firstImageWidget); // add firt default image widget at index 0

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: PsDimens.space160,
          child: ReorderableListView(
            scrollDirection: Axis.horizontal,
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                widget.onReorder(oldIndex, newIndex);
              });
            },
            header: _videoWidget,
            children: _imageWidgetList,
          ),
        ),
      ],
    );
  }
}

class ItemEntryImageWidget extends StatefulWidget {
  const ItemEntryImageWidget(
      {Key? key,
      required this.index,
      required this.images,
      required this.cameraImagePath,
      required this.selectedVideoImagePath,
      required this.selectedVideoPath,
      required this.videoFilePath,
      required this.videoFileThumbnailPath,
      required this.selectedImage,
      required this.hideDesc,
      this.onTap,
      this.provider,
      required this.galleryProvider,
      required this.onDeletItemImage})
      : super(key: key);

  final Function()? onTap;
  final Function? onDeletItemImage;
  final int? index;
  final Asset? images;
  final String? cameraImagePath;
  final String? selectedVideoImagePath;
  final String? selectedVideoPath;
  final String? videoFilePath;
  final String? videoFileThumbnailPath;
  final DefaultPhoto? selectedImage;
  final ItemEntryProvider? provider;
   final GalleryProvider? galleryProvider;
  final bool hideDesc ;
  @override
  State<StatefulWidget> createState() {
    return ItemEntryImageWidgetState();
  }
}

class ItemEntryImageWidgetState extends State<ItemEntryImageWidget> {
  //GalleryProvider? galleryProvider;
  PsValueHolder? valueHolder;
  // int i = 0;
  @override
  Widget build(BuildContext context) {
   valueHolder = Provider.of<PsValueHolder>(context, listen:false);
    final Widget _deleteWidget = Container(
      child: IconButton(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: PsDimens.space2),
        iconSize: PsDimens.space24,
        icon: const Icon(
          Icons.delete,
          color: Colors.grey,
        ),
        onPressed: () async {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialogView(
                  description: Utils.getString(
                      context, 'item_entry__confirm_delete_item_image'),
                  leftButtonText: Utils.getString(context, 'dialog__cancel'),
                  rightButtonText: Utils.getString(context, 'dialog__ok'),
                  onAgreeTap: () async {
                    Navigator.pop(context);
                    
                    valueHolder =
                        Provider.of<PsValueHolder>(context, listen: false);
                    final DeleteItemImageHolder deleteItemImageHolder =
                        DeleteItemImageHolder(
                            imageId: widget.selectedImage!.imgId);
                    await PsProgressDialog.showDialog(context);
                    final PsResource<ApiStatus> _apiStatus =
                        await widget.galleryProvider!.deleItemImage(
                            deleteItemImageHolder.toMap(),
                            Utils.checkUserLoginId(valueHolder!));
                    PsProgressDialog.dismissDialog();
                    if (_apiStatus.data != null) {
                      widget.onDeletItemImage!();
                    } else {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(message: _apiStatus.message);
                          });
                    }
                  },
                );
              });
        },
      ),
      width: PsDimens.space32,
      height: PsDimens.space32,
      decoration: BoxDecoration(
        color: PsColors.backgroundColor,
        borderRadius: BorderRadius.circular(PsDimens.space28),
      ),
    );

  
        final Widget _deleteVideoWidget = Container(
      child: IconButton(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: PsDimens.space2),
        iconSize: PsDimens.space24,
        icon: const Icon(
          Icons.delete,
          color: Colors.grey,
        ),
        onPressed: () async {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialogView(
                  description: Utils.getString(
                      context, 'item_entry__confirm_delete_item_video'),
                  leftButtonText: Utils.getString(context, 'dialog__cancel'),
                  rightButtonText: Utils.getString(context, 'dialog__ok'),
                  onAgreeTap: () async {
                    Navigator.pop(context);
                    
                    valueHolder =
                        Provider.of<PsValueHolder>(context, listen: false);
                    final DeleteItemImageHolder deleteItemImageHolder =
                        DeleteItemImageHolder(
                            imageId: widget.provider!.item.video!.imgId  );
                    final DeleteItemImageHolder deleteItemImageHolder2 =
                        DeleteItemImageHolder(
                            imageId: widget.provider!.item.videoThumbnail!.imgId  );
                    await PsProgressDialog.showDialog(context);
                    final PsResource<ApiStatus> _apiStatus =
                        await  widget.galleryProvider!.deleItemVideo(
                            deleteItemImageHolder.toMap(),
                            Utils.checkUserLoginId(valueHolder!));
                    final PsResource<ApiStatus> _apiStatus2 =
                        await widget. galleryProvider!.deleItemVideo(
                            deleteItemImageHolder2.toMap(),
                            Utils.checkUserLoginId(valueHolder!));
                    PsProgressDialog.dismissDialog();
                    if (_apiStatus.data != null && _apiStatus2.data != null) {
                          widget.onDeletItemImage!();
                    } else {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(message: _apiStatus.message);
                          });
                    }
                  },
                );
              });
        },
      ),
      width: PsDimens.space32,
      height: PsDimens.space32,
      decoration: BoxDecoration(
        color: PsColors.backgroundColor,
        borderRadius: BorderRadius.circular(PsDimens.space28),
      ),
    );

    if (widget.selectedImage != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 4, left: 4),
        child: InkWell(
          onTap: widget.onTap,
          child: Column(
            children:  <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    child: PsNetworkImageWithUrl(
                      photoKey: '',
                      width: 100,
                      height: 100,
                      imageAspectRation: PsConst.Aspect_Ratio_1x,
                      imagePath: widget.selectedImage!.imgPath!,
                    ),
                  ),
                  Positioned(
                    child: widget.index == 0 ? Container() : _deleteWidget,
                    right: 1,
                    bottom: 1,
                  ),
                ],
              ),
            ],
          ),
        ),
        
      );
    } else if (widget.videoFilePath != null ||
        widget.videoFileThumbnailPath != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 4, left: 4),
        child: Column(
          children: <Widget>[
            if (widget.videoFileThumbnailPath != '')
              Stack(children: <Widget>[
                InkWell(
                  onTap: widget.onTap,
                  child: Image(
                      width: 100,
                      height: 100,
                      fit: BoxFit.fill,
                      image: FileImage(File(widget.videoFileThumbnailPath!))),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.only(top: PsDimens.space14),
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
              ])
            else
              InkWell(
                  onTap: widget.onTap,
                  child: Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.only(top: PsDimens.space16),
                    child: const Icon(
                      Icons.play_circle,
                      color: Colors.red,
                      size: 50,
                    ),
                  )),
            Visibility(
              visible: Utils.showUI(valueHolder!.video),
              child: Container(
                width: 80,
                padding: const EdgeInsets.only(top: PsDimens.space16),
                child: InkWell(
                  child: PSButtonWidget(

                      width: 30,
                      titleText: Utils.getString(context, 'Play')),
                  onTap: () {
                    if (widget.videoFilePath == null) {
                      Navigator.pushNamed(context, RoutePaths.video_online,
                          arguments: widget.selectedVideoPath!);
                    } else {
                      Navigator.pushNamed(context, RoutePaths.video,
                          arguments: widget.videoFilePath);
                    }
                  },
                ),
              ),
            ),
            
          ],
        ),
      );
    } else {
      if (widget.images != null) {
        final Asset asset = widget.images!;
        return Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: widget.onTap ,
                child: AssetThumb(
                  asset: asset,
                  width: 100,
                  height: 100,
                ),
              ),
            ],
          ),
          
        );
      } else if (widget.cameraImagePath != null) {
        return Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: InkWell(
              onTap: widget.onTap,
              child: Image(
                  width: 100,
                  height: 100,
                  image: FileImage(File(widget.cameraImagePath!)))),
        );
     } else if (widget.selectedVideoImagePath != null) {
       return Padding(
        padding: const EdgeInsets.only(right: 4, left: 4),
        child: Column(
          children: <Widget>[
            if (widget.selectedVideoImagePath != '')
              Stack(children: <Widget>[
                InkWell(
                  onTap: widget.onTap,
                  child: Container(
                    width: 100,
                    height: 100,
                    child: PsNetworkImageWithUrl(
                      photoKey: '',
                      imagePath: widget.selectedVideoImagePath,
                      imageAspectRation: PsConst.Aspect_Ratio_full_image,
                    ),
                  ),
                ),
                InkWell(
                  onTap: widget.onTap ,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.only(top: PsDimens.space14),
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
              Positioned(
                    child:  Column(
                      children: <Widget>[
                         if  (widget.provider!.item.video == null &&  widget.provider!.item.videoThumbnail == null && widget.provider!.item.videoThumbnail == null)
                          Container()
                        else
                         _deleteVideoWidget
                      ],
                    ),
                    right: 1,
                    bottom: 1,
                  ),
              ])
            else
              InkWell(
                  onTap: widget.onTap,
                  child: Container(
                    padding: const EdgeInsets.only(top: PsDimens.space16),
                    width: 100,
                    height: 100,
                    child: const Icon(
                     Icons.play_circle,
                      color: Colors.black54,
                      size: 50,
                    ),
                  )),
            Container(
              width: 80,
              padding: const EdgeInsets.only(top: PsDimens.space16),
              child: InkWell(
                child: PSButtonWidget(
                    width: 30,
                    titleText: Utils.getString(context, 'Play')),
                onTap: () {
                  if (widget.videoFilePath == null) {
                    Navigator.pushNamed(context, RoutePaths.video_online,
                        arguments: widget.selectedVideoPath);
                  } else {
                    Navigator.pushNamed(context, RoutePaths.video,
                        arguments: widget.videoFilePath);
                  }
                },
              ),
            ),
          ],
        ),
      );
      } else {
        return Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: Column(
            children: <Widget> [
              if (!widget.hideDesc)
              Container(
                  margin: const EdgeInsets.only(
                              bottom: PsDimens.space60,),
                child: InkWell(
                  onTap: widget.onTap,
                  child: Image.asset(
                    'assets/images/default_image.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ), 
                
              )
              else
              InkWell(
                  onTap: widget.onTap,
                  child: Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.only(top: PsDimens.space16),
                    child: const Icon(
                      Icons.play_circle,
                      color: Colors.grey,
                      size: 50,
                    ),
                  )),
            ],
          ),
        );
      }
    }
  }
}

class PriceDropDownControllerWidget extends StatelessWidget {
  const PriceDropDownControllerWidget(
      {Key? key,
      // @required this.onTap,
      this.currencySymbolController,
      this.userInputPriceController})
      : super(key: key);

  final TextEditingController? currencySymbolController;
  final TextEditingController? userInputPriceController;
  // final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              top: PsDimens.space4,
              right: PsDimens.space12,
              left: PsDimens.space12),
          child: Row(
            children: <Widget>[
              Text(
                Utils.getString(context, 'item_entry__price'),
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Text(' *',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: PsColors.mainColor))
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final ItemEntryProvider provider =
                    Provider.of<ItemEntryProvider>(context, listen: false);

                final dynamic itemCurrencySymbolResult =
                    await Navigator.pushNamed(
                        context, RoutePaths.itemCurrencySymbol);

                if (itemCurrencySymbolResult != null &&
                    itemCurrencySymbolResult is ItemCurrency) {
                  provider.itemCurrencyId = itemCurrencySymbolResult.id!;

                  currencySymbolController!.text =
                      itemCurrencySymbolResult.currencySymbol!;
                }
              },
              child: Container(
                width: PsDimens.space140,
                height: PsDimens.space44,
                margin: const EdgeInsets.all(PsDimens.space12),
                decoration: BoxDecoration(
                  color: Utils.isLightMode(context)
                      ? Colors.white60
                      : Colors.black54,
                  borderRadius: BorderRadius.circular(PsDimens.space4),
                  border: Border.all(
                      color: Utils.isLightMode(context)
                          ? Colors.grey[200]!
                          : Colors.black87),
                ),
                child: Container(
                  margin: const EdgeInsets.all(PsDimens.space12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: InkWell(
                          child: Ink(
                            color: PsColors.backgroundColor,
                            child: Text(
                              currencySymbolController!.text == ''
                                  ? Utils.getString(
                                      context, 'home_search__not_set')
                                  : currencySymbolController!.text,
                              style: currencySymbolController!.text == ''
                                  ? Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(color: Colors.grey[600])
                                  : Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: PsDimens.space44,
                // margin: const EdgeInsets.only(
                //     top: 24),
                decoration: BoxDecoration(
                  color: Utils.isLightMode(context)
                      ? Colors.white60
                      : Colors.black54,
                  borderRadius: BorderRadius.circular(PsDimens.space4),
                  border: Border.all(
                      color: Utils.isLightMode(context)
                          ? Colors.grey[200]!
                          : Colors.black87),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  maxLines: null,
                  controller: userInputPriceController,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: PsDimens.space12, bottom: PsDimens.space4),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: PsDimens.space8),
          ],
        ),
      ],
    );
  }
}

class BusinessModeCheckbox extends StatefulWidget {
  const BusinessModeCheckbox(
      { required this.provider, 
        required this.onCheckBoxClick});

  final ItemEntryProvider provider;
  final Function onCheckBoxClick;

  @override
  _BusinessModeCheckbox createState() => _BusinessModeCheckbox();
}

class _BusinessModeCheckbox extends State<BusinessModeCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Theme(
          data: ThemeData(unselectedWidgetColor: Colors.grey),
          child: Checkbox(
            activeColor: PsColors.mainColor,
            value: widget.provider.isCheckBoxSelect,
            onChanged: (bool? value) {
              widget.onCheckBoxClick();
            },
          ),
        ),
       Expanded(
          child: InkWell(
            child: Text(Utils.getString(context, 'item_entry__is_shop'),
                style: Theme.of(context).textTheme.bodyText1),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              widget.onCheckBoxClick();
            },
          ),
        ),
      ],
    );
  }
}

class IsNegotiableCheckbox extends StatefulWidget {
  const IsNegotiableCheckbox(
      { required this.provider, 
        required this.onNegotiableCheckBoxClick});

  final ItemEntryProvider provider;
  final Function onNegotiableCheckBoxClick;

  @override
  _IsNegotiableCheckbox createState() => _IsNegotiableCheckbox();
}

class _IsNegotiableCheckbox extends State<IsNegotiableCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Theme(
          data: ThemeData(unselectedWidgetColor: Colors.grey),
          child: Checkbox(
            activeColor: PsColors.mainColor,
            value: widget.provider.isNegotiableCheckBoxSelect,
            onChanged: (bool? value) {
              widget.onNegotiableCheckBoxClick();
            },
          ),
        ),
       Expanded(
          child: InkWell(
            child: Text(Utils.getString(context, 'item_entry__is_negotiable'),
                style: Theme.of(context).textTheme.bodyText1),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              widget.onNegotiableCheckBoxClick();
            },
          ),
        ),
      ],
    );
  }
}

void updateCheckBox(BuildContext context, ItemEntryProvider provider) {
  if (provider.isCheckBoxSelect) {
    provider.isCheckBoxSelect = false;
    provider.checkOrNotShop = '0';
  } else {
    provider.isCheckBoxSelect = true;
    provider.checkOrNotShop = '1';
    
  }
}

void isNegotiableUpdateCheckBox(BuildContext context, ItemEntryProvider provider) {
  if (provider.isNegotiableCheckBoxSelect) {
    provider.isNegotiableCheckBoxSelect = false;
    provider.checkOrNotNegotiable = '0';
  } else {
    provider.isNegotiableCheckBoxSelect = true;
    provider.checkOrNotNegotiable = '1';
    
  }
}

class CurrentLocationWidget extends StatefulWidget {
  const CurrentLocationWidget({
    Key? key,

    /// If set, enable the FusedLocationProvider on Android
    required this.androidFusedLocation,
    required this.textEditingController,
    required this.latController,
    required this.lngController,
    required this.valueHolder,
    required this.updateLatLng,
  }) : super(key: key);

  final bool androidFusedLocation;
  final TextEditingController textEditingController;
  final TextEditingController latController;
  final TextEditingController lngController;
  final PsValueHolder valueHolder;
  final Function updateLatLng;

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<CurrentLocationWidget> {
  String address = '';
  Position? _currentPosition;
  final MapController mapController = MapController();

  @override
  void initState() {
    super.initState();

    //_initCurrentLocation();
  }

  Future<void> loadAddress() async {
    if (_currentPosition != null) {
      if (widget.textEditingController.text == '') {
        await placemarkFromCoordinates(
                _currentPosition!.latitude, _currentPosition!.longitude)
            .then((List<Placemark> placemarks) {
          final Placemark place = placemarks[0];
          setState(() {
            address =
              '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
              widget.textEditingController.text = address;
            widget.latController.text = _currentPosition!.latitude.toString();
            widget.lngController.text = _currentPosition!.longitude.toString();
            widget.updateLatLng(_currentPosition);
          });
        }).catchError((dynamic e) {
          debugPrint(e);
        });
      } else {
        address = widget.textEditingController.text;
      }
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  dynamic _initCurrentLocation() {
    Geolocator.checkPermission().then((LocationPermission permission) {
      if (permission == LocationPermission.denied) {
        Geolocator.requestPermission().then((LocationPermission permission) {
          if (permission == LocationPermission.denied) {
          } else {
            Geolocator
                    //..forceAndroidLocationManager = !widget.androidFusedLocation
                    .getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.medium,
                        forceAndroidLocationManager: false)
                .then((Position position) {
              print(position);
              //     if (mounted) {
              //  setState(() {
              _currentPosition = position;
              loadAddress();
              //    });
              // _currentPosition = position;

              //    }
            }).catchError((Object e) {
              print(e);
            });
          }
        });
      } else {
        Geolocator
                //..forceAndroidLocationManager = !widget.androidFusedLocation
                .getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.medium,
                    forceAndroidLocationManager: !widget.androidFusedLocation)
            .then((Position position) {
          //    if (mounted) {
          setState(() {
            _currentPosition = position;
            loadAddress();
          });
          //    }
        }).catchError((Object e) {
          print(e);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            _initCurrentLocation();
            // if (_currentPosition == null) {
            //   showDialog<dynamic>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return WarningDialog(
            //           message: Utils.getString(context, 'map_pin__open_gps'),
            //           onPressed: () {},
            //         );
            //       });
            // } else {
            //   loadAddress();
            // }
          },
          child: Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space8,
                right: PsDimens.space8,
                bottom: PsDimens.space8),
            child: Card(
              shape: const BeveledRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(PsDimens.space8)),
              ),
              color: PsColors.baseLightColor,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        height: PsDimens.space32,
                        width: PsDimens.space32,
                        child: Icon(
                          Icons.gps_fixed,
                          color: PsColors.mainColor,
                          size: PsDimens.space20,
                        ),
                      ),
                      onTap: () {
                        _initCurrentLocation();

                      },
                    ),
                    Expanded(
                      child: Text(
                        Utils.getString(context, 'item_entry_pick_location'),
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            letterSpacing: 0.8, fontSize: 16, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
