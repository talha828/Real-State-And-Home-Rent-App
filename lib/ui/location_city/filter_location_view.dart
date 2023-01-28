import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_appbar_with_no_provider.dart';
import 'package:flutteradhouse/ui/common/ps_button_widget.dart';
import 'package:flutteradhouse/ui/common/ps_textfield_widget.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/location_parameter_holder.dart';
import 'package:provider/provider.dart';

class FilterLocationView extends StatefulWidget {
  const FilterLocationView({this.locationParameterHolder});
  final LocationParameterHolder? locationParameterHolder;

  @override
  _FilterLocationViewState createState() => _FilterLocationViewState();
}

// ignore: unused_element
PsValueHolder? _psValueHolder;
AnimationController? animationController;
TextEditingController? userNameController;

class _FilterLocationViewState extends State<FilterLocationView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _psValueHolder = Provider.of<PsValueHolder>(context);
    userNameController = TextEditingController();

    userNameController!.text = widget.locationParameterHolder!.keyword!;

    Future<bool> _requestPop() {
      animationController!.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    dynamic updateOrderByData(String filterName) {
      setState(() {
        widget.locationParameterHolder!.orderBy = filterName;
      });
    }

    dynamic updateOrderTypeData(String filterName) {
      setState(() {
        widget.locationParameterHolder!.orderType = filterName;
      });
    }

    print(
        '............................Build UI Again ............................');
    return WillPopScope(
        onWillPop: _requestPop,
        child: PsWidgetWithAppBarWithNoProvider(
          appBarTitle: Utils.getString(context, 'filter_location__title'),
          child: Column(
            children: <Widget>[
              PsTextFieldWidget(
                  titleText:
                      Utils.getString(context, 'filter_location__name_title'),
                  hintText:
                      Utils.getString(context, 'filter_location__name_title'),
                  textAboutMe: false,
                  textEditingController: userNameController),
              const SizedBox(
                height: PsDimens.space16,
              ),
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: PsDimens.space8,
                  ),
                  Text(
                      Utils.getString(
                          context, 'filter_location__ordering_title'),
                      style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  const SizedBox(
                    width: PsDimens.space8,
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Radio<String>(
                          value: widget.locationParameterHolder!.orderBy!,
                          groupValue: PsConst.FILTERING__ORDERING,
                          onChanged: (String? name) {
                            updateOrderByData(PsConst.FILTERING__ORDERING);
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          activeColor: PsColors.mainColor,
                        ),
                        Expanded(
                          child: Text(
                            Utils.getString(
                                context, 'filter_location__default'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Radio<String>(
                          value: widget.locationParameterHolder!.orderBy!,
                          groupValue: PsConst.FILTERING__ADDED_DATE,
                          onChanged: (String? name) {
                            updateOrderByData(PsConst.FILTERING__ADDED_DATE);
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          activeColor: PsColors.mainColor,
                        ),
                        Expanded(
                          child: Text(
                            Utils.getString(context, 'filter_location__latest'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  const SizedBox(
                    width: PsDimens.space8,
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Radio<String>(
                          value: widget.locationParameterHolder!.orderType!,
                          groupValue: PsConst.FILTERING__ASC,
                          onChanged: (String? name) {
                            updateOrderTypeData(PsConst.FILTERING__ASC);
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          activeColor: PsColors.mainColor,
                        ),
                        Expanded(
                          child: Text(
                            Utils.getString(context, 'filter_location__asc'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Radio<String>(
                          value: widget.locationParameterHolder!.orderType!,
                          groupValue: PsConst.FILTERING__DESC,
                          onChanged: (String? name) {
                            updateOrderTypeData(PsConst.FILTERING__DESC);
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          activeColor: PsColors.mainColor,
                        ),
                        Expanded(
                          child: Text(
                            Utils.getString(context, 'filter_location__desc'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: PsDimens.space12, right: PsDimens.space12),
                child: PSButtonWidget(
                    hasShadow: true,
                    width: double.infinity,
                    titleText: Utils.getString(
                        context, 'filter_location__filter_button'),
                    onPressed: () async {
                      widget.locationParameterHolder!.keyword =
                          userNameController!.text;
                      Navigator.pop(context, widget.locationParameterHolder);
                    }),
              ),
            ],
          ),
        ));
  }
}
