import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/viewobject/blog.dart';

class BlogSliderView extends StatefulWidget {
  const BlogSliderView({
    Key? key,
    required this.blogList,
    this.onTap,
  }) : super(key: key);

  final Function? onTap;
  final List<Blog> blogList;

  @override
  _BlogSliderState createState() => _BlogSliderState();
}

class _BlogSliderState extends State<BlogSliderView> {
  String? _currentId;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if ( widget.blogList.isNotEmpty)
          CarouselSlider(
            options: CarouselOptions(
              enlargeCenterPage: true,
              autoPlay: false,
              viewportFraction: 0.9,
              autoPlayInterval: const Duration(seconds: 5),
              onPageChanged: (int i, CarouselPageChangedReason reason) {
                setState(() {
                  _currentId = widget.blogList[i].id;
                });
              },
            ),
            items: widget.blogList.map((Blog blogProduct) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: PsColors.mainLightShadowColor,
                  ),
                  borderRadius:
                      const BorderRadius.all(Radius.circular(PsDimens.space8)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: PsColors.mainLightShadowColor,
                        offset: const Offset(1.1, 1.1),
                        blurRadius: PsDimens.space8),
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(PsDimens.space4),
                      child: PsNetworkImage(
                          photoKey: '',
                          defaultPhoto: blogProduct.defaultPhoto!,
                          width: MediaQuery.of(context).size.width,
                          height: double.infinity,
                           imageAspectRation: PsConst.Aspect_Ratio_3x,
                          onTap: () {
                            widget.onTap!(blogProduct);
                          }),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () {
                          widget.onTap!(blogProduct);
                        },
                        child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: PsColors.black.withAlpha(200)),
                          padding: const EdgeInsets.only(
                              top: PsDimens.space8,
                              left: PsDimens.space8,
                              right: PsDimens.space8,
                              bottom: PsDimens.space20),
                          child: Ink(
                            color: PsColors.backgroundColor,
                            child: Text(
                              blogProduct.name!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      fontSize: PsDimens.space16,
                                      color: PsColors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          )
        else
          Container(),

        // ),
        Positioned(
            bottom: 5.0,
            left: 0.0,
            right: 0.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children:  widget.blogList.isNotEmpty
                  ? widget.blogList.map((Blog blogProduct) {
                      return Builder(builder: (BuildContext context) {
                        return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentId == blogProduct.id
                                    ? PsColors.mainColor
                                    : PsColors.grey));
                      });
                    }).toList()
                  : <Widget>[Container()],
            ))
      ],
    );
  }
}
