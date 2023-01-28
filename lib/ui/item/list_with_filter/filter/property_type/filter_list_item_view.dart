import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/provider/post_type/post_type_provider.dart';
import 'package:flutteradhouse/repository/post_type_repository.dart';
import 'package:flutteradhouse/viewobject/property_type.dart';
import 'package:provider/provider.dart';

class FilterListItemView extends StatefulWidget {
  const FilterListItemView(
      {Key? key, this.selectedData, this.propertyType, this.onAllPropertyClick})
      : super(key: key);
  final dynamic selectedData;
  final PropertyType? propertyType;
  final Function? onAllPropertyClick;
  @override
  State<StatefulWidget> createState() => _FilterListItemView();
}

class _FilterListItemView extends State<FilterListItemView> {
  PostTypeRepository? subCategoryRepository;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    subCategoryRepository = Provider.of<PostTypeRepository>(context);

    return ChangeNotifierProvider<PostTypeProvider>(
      lazy: false,
      create: (BuildContext context) {
        final PostTypeProvider provider =
            PostTypeProvider(repo: subCategoryRepository);
        provider.loadAllPostTypeList();
        return provider;
      },
      child: Consumer<PostTypeProvider>(builder:
          (BuildContext context, PostTypeProvider provider, Widget? child) {
        return Container(
          child: InkWell(
            onTap: (){
              final Map<String, String> dataHolder = <String, String>{};
              dataHolder[PsConst.PROPERTY_BY_ID] = widget.propertyType!.id!;
              dataHolder[PsConst.PROPERTY_BY_NAME] = widget.propertyType!.name!;
              widget.onAllPropertyClick!(dataHolder);
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: PsDimens.space52,
              margin: const EdgeInsets.only(top: PsDimens.space4),
              child: Ink(
                color: PsColors.backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(PsDimens.space16),
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                    Text(
                    widget.propertyType!.name!,
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      child: widget.propertyType!.id ==
                          widget.selectedData[PsConst.PROPERTY_BY_ID]
                        ? IconButton(
                            icon: Icon(Icons.playlist_add_check,
                                color: Theme.of(context)
                                    .iconTheme
                                    .copyWith(color: PsColors.mainColor)
                                    .color),
                            onPressed: () {
                              final Map<String, String> dataHolder = <String, String>{};
                              dataHolder[PsConst.PROPERTY_BY_ID] = widget.propertyType!.id!;
                              dataHolder[PsConst.PROPERTY_BY_NAME] = widget.propertyType!.name!;
                              widget.onAllPropertyClick!(dataHolder);
                            })
                          : Container()),
                          ]
                        )
                      ),
                    ),
                  ),
                ),
              );
            }
      ),
    );
  }
}



