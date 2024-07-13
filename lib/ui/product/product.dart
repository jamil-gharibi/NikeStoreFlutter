import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_flutter_application/data/common/utils.dart';
import 'package:nike_flutter_application/data/data_moudel/product_entity_data.dart';
import 'package:nike_flutter_application/data/data_source/favorite_manager.dart';
import 'package:nike_flutter_application/ui/product/details.dart';
import 'package:nike_flutter_application/ui/widgete/image.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    super.key,
    required this.product,
    required this.themeData,
    required this.borderRadius,
    this.itemWidth = 176,
    this.itemHeight = 189,
  });

  final ProductEntity product;
  final ThemeData themeData;
  final BorderRadius borderRadius;
  final double itemWidth;
  final double itemHeight;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  late bool isFavorite = false;

  void setFavarite() async {
    final tempBool = await favoriteManagerDb.isFavorite(widget.product.id);
    setState(() {
      isFavorite = tempBool;
    });
  }

  @override
  void initState() {
    setFavarite();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
                  productEntity: widget.product,
                ))),
        borderRadius: widget.borderRadius,
        child: SizedBox(
          width: widget.itemWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 0.93,
                    child: ImageLoadingService(
                        imageUrl: widget.product.imageUrl,
                        borderRadius: widget.borderRadius),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      height: 30,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: IconButton(
                          onPressed: () async {
                            if (isFavorite) {
                              await favoriteManagerDb.delete(widget.product.id);
                              isFavorite = false;
                            } else {
                              await favoriteManagerDb
                                  .insertFavorite(widget.product);
                              isFavorite = true;
                            }

                            setState(() {
                              isFavorite;
                            });
                          },
                          icon: Center(
                            child: Icon(
                              opticalSize: 22,
                              isFavorite
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              color: Colors.black,
                              size: 22,
                            ),
                          )),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                child: Text(
                  widget.product.title,
                  maxLines: 1,
                  style: TextStyle(
                      color: widget.themeData.colorScheme.primary,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                child: Text(
                  widget.product.previousPrice.withPriceLabel,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 13, decoration: TextDecoration.lineThrough),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  widget.product.price.withPriceLabel,
                  style: TextStyle(
                    color: widget.themeData.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
