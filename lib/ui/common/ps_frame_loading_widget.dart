import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';

class PsFrameUIForLoading extends StatelessWidget {
  const PsFrameUIForLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: 200,
        margin: const EdgeInsets.all(PsDimens.space16),
        decoration: BoxDecoration(color: PsColors.grey));
  }
}
