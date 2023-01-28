import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_appbar_with_no_provider.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/product_parameter_holder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GoogleMapFilterView extends StatefulWidget {
  const GoogleMapFilterView({required this.productParameterHolder});

  final ProductParameterHolder productParameterHolder;

  @override
  _MapFilterViewState createState() => _MapFilterViewState();
}

class _MapFilterViewState extends State<GoogleMapFilterView>
    with TickerProviderStateMixin {
  List<String> seekBarValues = <String>[
    '0.5',
    '1',
    '2.5',
    '5',
    '10',
    '25',
    '50',
    '100',
    '200',
    '500',
    'All'
  ];
  LatLng? latlng;
  final double zoom = 10;
  double radius = -1;
  double defaultRadius = 3000;
  bool isRemoveCircle = false;
  String address = '';
  bool isFirst = true;
  CameraPosition? kGooglePlex;
  GoogleMapController? mapController;
  PsValueHolder? valueHolder;

  // dynamic loadAddress() async {
  //   final List<Address> addresses = await Geocoder.local
  //       .findAddressesFromCoordinates(
  //           Coordinates(latlng.latitude, latlng.longitude));
  //   final Address first = addresses.first;
  //   address =
  //       '${first.addressLine}  \n:  ${first.adminArea} \n: ${first.coordinates} \n: ${first.countryCode} \n: ${first.countryName} \n: ${first.featureName} \n: ${first.locality} \n: ${first.postalCode} \n: ${first.subLocality} \n: ${first.subThoroughfare} \n: ${first.thoroughfare}';
  //   print('${first.adminArea}  :  ${first.featureName} : ${first.addressLine}');
  // }

  Future<void> loadAddress() async {
    await placemarkFromCoordinates(
            latlng!.latitude,
            latlng!.longitude)
        .then((List<Placemark> placemarks) {
      final Placemark place = placemarks[0];
      setState(() {
        address =
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((dynamic e) {
      debugPrint(e);
    });
  }

  double _value = 0.3;
  String kmValue = '5';

  int findTheIndexOfTheValue(String value) {
    int index = 0;

    for (int i = 0; i < seekBarValues.length - 1; i++) {
      if (!(value == 'All')) {
        if (getMiles(seekBarValues[i]) == value) {
          index = i;
          break;
        }
      } else {
        index = seekBarValues.length - 1;
      }
    }

    return index;
  }

  String getMiles(String kmValue) {
    final double _km = double.parse(kmValue);
    return (_km * 0.621371).toStringAsFixed(3);
  }

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);
    latlng ??= LatLng(double.parse(widget.productParameterHolder.lat!),
        double.parse(widget.productParameterHolder.lng!));

    if (widget.productParameterHolder.mile != '' && isFirst) {
      final int _index =
          findTheIndexOfTheValue(widget.productParameterHolder.mile!);
      kmValue = seekBarValues[_index];
      final double _val = double.parse(getMiles(kmValue)) * 1000;
      radius = _val;
      defaultRadius = radius;
      _value = _index / 10;
      isFirst = false;
    }

    final double scale = defaultRadius / 300; //radius/20
    final double value = 16 - log(scale) / log(2);
    loadAddress();

    kGooglePlex = CameraPosition(
      target: LatLng(double.parse(widget.productParameterHolder.lat!),
          double.parse(widget.productParameterHolder.lng!)),
      zoom: value,
    );

    print('value $value');

    return PsWidgetWithAppBarWithNoProvider(
        appBarTitle: Utils.getString(context, 'map_filter__title'),
        actions: <Widget>[
          InkWell(
            child: Center(
              child: Text(
                Utils.getString(context, 'map_filter__reset'),
                textAlign: TextAlign.justify,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontWeight: FontWeight.bold)
                    .copyWith(color: PsColors.mainColorWithWhite),
              ),
            ),
            onTap: () {
              setState(() {
                isRemoveCircle = true;
                _value = 1.0;
              });
            },
          ),
          const SizedBox(
            width: PsDimens.space20,
          ),
          InkWell(
            child: Center(
              child: Text(
                Utils.getString(context, 'map_filter__apply'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontWeight: FontWeight.bold)
                    .copyWith(color: PsColors.mainColorWithWhite),
              ),
            ),
            onTap: () {
              if (kmValue == 'All') {
                widget.productParameterHolder.lat = '';
                widget.productParameterHolder.lng = '';
                widget.productParameterHolder.mile = '';

                if (valueHolder!.isSubLocation == PsConst.ONE) {
                  widget.productParameterHolder.itemLocationCityId = '';
                } else {
                  widget.productParameterHolder.itemLocationCityId = '';
                  widget.productParameterHolder.itemLocationTownshipId = '';
                }
              } else {
                widget.productParameterHolder.lat = latlng!.latitude.toString();
                widget.productParameterHolder.lng = latlng!.longitude.toString();
                widget.productParameterHolder.mile = getMiles(kmValue);
              }
              Navigator.pop(context, widget.productParameterHolder);
            },
          ),
          const SizedBox(
            width: PsDimens.space16,
          ),
        ],
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Flexible(
                child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: kGooglePlex!,
                    circles: <Circle>{}..add(Circle(
                        circleId: CircleId(address),
                        center: latlng!,
                        radius: isRemoveCircle == true
                            ? 0.0
                            : radius <= 0.0
                                ? defaultRadius
                                : radius,
                        fillColor: Colors.blue.withOpacity(0.7),
                        strokeWidth: 3,
                        strokeColor: Colors.redAccent,
                      )),
                    onTap: _handleTap),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: PsDimens.space8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      Utils.getString(context, 'map_filter__browsing'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Utils.getString(context, 'map_filter__all'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                child: Slider(
                  value: _value,
                  onChanged: (double newValue) {
                    setState(() {
                      _value = newValue;
                      kmValue = seekBarValues[(_value * 10).toInt()];
                      if (kmValue == 'All') {
                        isRemoveCircle = true;
                      } else {
                        radius = double.parse(getMiles(kmValue)) *
                            1000; //_value * 10000;
                      }
                      _value == 1
                          ? isRemoveCircle = true
                          : isRemoveCircle = false;
                      defaultRadius != 0
                          ? defaultRadius = 500
                          : defaultRadius = 500;
                    });
                  },
                  divisions: 10,
                  label: _value == 1
                      ? seekBarValues[(_value * 10).toInt()]
                      : seekBarValues[(_value * 10).toInt()] +
                          Utils.getString(context, 'map_filter__km'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: PsDimens.space8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      Utils.getString(context, 'map_filter__lowest_km'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Utils.getString(context, 'map_filter__all'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _handleTap(LatLng latlng) {
    setState(() {
      this.latlng = latlng;
    });
  }
}
