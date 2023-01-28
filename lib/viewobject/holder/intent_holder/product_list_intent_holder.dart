import 'package:flutteradhouse/viewobject/holder/product_parameter_holder.dart';

class ProductListIntentHolder {
  const ProductListIntentHolder({
    required this.productParameterHolder,
    required this.appBarTitle,
  });
  final ProductParameterHolder productParameterHolder;
  final String appBarTitle;
}
