import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/utils/utils.dart';

class PSButtonWidget extends StatefulWidget {
  const PSButtonWidget(
      {this.onPressed,
      this.titleText = '',
      this.titleTextAlign = TextAlign.center,
      this.colorData,
      this.width,
      this.gradient,
      this.hasShadow = false});

  final Function? onPressed;
  final String titleText;
  final Color? colorData;
  final double? width;
  final Gradient? gradient;
  final bool hasShadow;
  final TextAlign titleTextAlign;

  @override
  _PSButtonWidgetState createState() => _PSButtonWidgetState();
}

class _PSButtonWidgetState extends State<PSButtonWidget> {
  Gradient? _gradient;
  Color? _color;
  @override
  Widget build(BuildContext context) {
    _color = widget.colorData;
    _gradient = null;

    _color ??= PsColors.mainColor;

    if (widget.gradient == null && _color == PsColors.mainColor) {
      _gradient = LinearGradient(colors: <Color>[
        PsColors.mainColor,
        PsColors.mainDarkColor,
      ]);
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      decoration: ShapeDecoration(
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        color: _gradient == null ? _color : null,
        gradient: _gradient,
        shadows: <BoxShadow>[
          if (widget.hasShadow)
            BoxShadow(
                color: Utils.isLightMode(context)
                    ? _color!.withOpacity(0.6)
                    : PsColors.mainShadowColor,
                offset: const Offset(0, 4),
                blurRadius: 8.0,
                spreadRadius: 3.0),
        ],
      ),
      child: Material(
        color: PsColors.transparent,
        type: MaterialType.card,
        clipBehavior: Clip.antiAlias,
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(PsDimens.space8))),
        child: InkWell(
          onTap: widget.onPressed as void Function()?,
          highlightColor: PsColors.mainDarkColor,
          child: Center(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  left: PsDimens.space8, right: PsDimens.space8),
              child: Text(
                widget.titleText.toUpperCase(),
                textAlign: widget.titleTextAlign,
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: PsColors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PSButtonWithIconWidget extends StatefulWidget {
  const PSButtonWithIconWidget(
      {this.onPressed,
      this.titleText = '',
      this.colorData,
      this.width,
      this.gradient,
      this.icon,
      this.iconAlignment = MainAxisAlignment.center,
      this.hasShadow = false,
      this.iconColor});

  final Function? onPressed;
  final String titleText;
  final Color? colorData;
  final double? width;
  final IconData? icon;
  final Gradient? gradient;
  final MainAxisAlignment iconAlignment;
  final bool hasShadow;
  final Color ?iconColor;

  @override
  _PSButtonWithIconWidgetState createState() => _PSButtonWithIconWidgetState();
}

class _PSButtonWithIconWidgetState extends State<PSButtonWithIconWidget> {
  Gradient? _gradient;
  Color? _color;
  Color? _iconColor;

  @override
  Widget build(BuildContext context) {
    _color = widget.colorData;
    _gradient = null;

    _iconColor = widget.iconColor;

    _iconColor ??= PsColors.white;

    _color ??= PsColors.mainColor;

    if (widget.gradient == null && _color == PsColors.mainColor) {
      _gradient = LinearGradient(colors: <Color>[
        PsColors.mainColor,
        PsColors.mainDarkColor,
      ]);
    }

    return Container(
      width: widget.width, //MediaQuery.of(context).size.width,
      height: 40,
      decoration: ShapeDecoration(
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        color: _gradient == null ? _color : null,
        gradient: _gradient,
        shadows: <BoxShadow>[
          if (widget.hasShadow)
            BoxShadow(
                color: Utils.isLightMode(context)
                    ? _color!.withOpacity(0.6)
                    : PsColors.mainShadowColor,
                offset: const Offset(0, 4),
                blurRadius: 8.0,
                spreadRadius: 3.0),
        ],
      ),
      child: Material(
        color: PsColors.transparent,
        type: MaterialType.card,
        clipBehavior: Clip.antiAlias,
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(PsDimens.space8))),
        child: InkWell(
          onTap: widget.onPressed as void Function()?,
          highlightColor: PsColors.mainDarkColor,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: widget.iconAlignment,
            children: <Widget>[
              if (widget.icon != null) Icon(widget.icon, color: _iconColor),
              if (widget.icon != null && widget.titleText != '')
                const SizedBox(
                  width: PsDimens.space12,
                ),
              Text(
                widget.titleText.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: PsColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PSCircleButtonWithIconWidget extends StatefulWidget {
  const PSCircleButtonWithIconWidget(
      {this.onPressed,
      this.titleText = '',
      this.colorData,
      this.width,
      this.gradient,
      this.icon,
      this.iconAlignment = MainAxisAlignment.center,
      this.hasShadow = false,
      this.iconColor});

  final Function? onPressed;
  final String titleText;
  final Color? colorData;
  final double ?width;
  final IconData? icon;
  final Gradient? gradient;
  final MainAxisAlignment iconAlignment;
  final bool hasShadow;
  final Color ?iconColor;

  @override
  _PSCircleButtonWithIconWidgetState createState() =>
      _PSCircleButtonWithIconWidgetState();
}

class _PSCircleButtonWithIconWidgetState
    extends State<PSCircleButtonWithIconWidget> {
  Gradient? _gradient;
  Color? _color;
  Color? _iconColor;

  @override
  Widget build(BuildContext context) {
    _color = widget.colorData;
    _gradient = null;

    _iconColor = widget.iconColor;

    _iconColor ??= PsColors.white;

    _color ??= PsColors.white;

    if (widget.gradient == null && _color == PsColors.white) {
      _gradient = LinearGradient(colors: <Color>[
        PsColors.mainColor,
        PsColors.mainDarkColor,
      ]);
    }

    return Container(
      width: widget.width, //MediaQuery.of(context).size.width,
      height: 40,
      decoration: ShapeDecoration(
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        color: _gradient == null ? _color : null,
        gradient: _gradient,
        shadows: <BoxShadow>[
          if (widget.hasShadow)
            BoxShadow(
                color: Utils.isLightMode(context)
                    ? PsColors.mainColor
                    : PsColors.mainShadowColor,
                offset: const Offset(0, 4),
                // blurRadius: 8.0,
                spreadRadius: 3.0),
        ],
      ),
      child: Material(
        color: PsColors.transparent,
        type: MaterialType.card,
        clipBehavior: Clip.antiAlias,
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(PsDimens.space8))),
        child: InkWell(
          onTap: widget.onPressed as void Function()?,
          highlightColor: PsColors.mainDarkColor,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: widget.iconAlignment,
            children: <Widget>[
              if (widget.icon != null) Icon(widget.icon, color: _iconColor),
              if (widget.icon != null && widget.titleText != '')
                const SizedBox(
                  width: PsDimens.space12,
                ),
              Text(
                widget.titleText.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: PsColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
