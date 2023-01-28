import 'package:flutter/material.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/viewobject/ItemSpec.dart';

class ProductSpecificationListItem extends StatelessWidget {
  const ProductSpecificationListItem({
    Key? key,
    required this.productSpecification,
    this.onTap,
  }) : super(key: key);

  final ProductSpecification productSpecification;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap  as void Function()?,
        child: Ink(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.label_outline,
                  ),
                  const SizedBox(
                    width: PsDimens.space8,
                  ),
                  Text(
                    productSpecification.name!,
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const SizedBox(
                      width: PsDimens.space10,
                    ),
                    VerticalDivider(
                        width: 2, color: Theme.of(context).iconTheme.color),
                    const SizedBox(
                      width: PsDimens.space20,
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: PsDimens.space12,
                            left: PsDimens.space12,
                            bottom: PsDimens.space12),
                        child: Text(productSpecification.description!,
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.start),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
