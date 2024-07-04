import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_flutter_application/data/common/utils.dart';
import 'package:nike_flutter_application/data/data_moudel/product_entity_data.dart';
import 'package:nike_flutter_application/ui/product/details.dart';
import 'package:nike_flutter_application/ui/widgete/image.dart';

class ProductItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
                  productEntity: product,
                ))),
        borderRadius: borderRadius,
        child: SizedBox(
          width: itemWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 0.93,
                    child: ImageLoadingService(
                        imageUrl: product.imageUrl, borderRadius: borderRadius),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          color: Colors.white),
                      child: const Icon(
                        CupertinoIcons.heart,
                        color: Colors.grey,
                        size: 22,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                child: Text(
                  product.title,
                  maxLines: 1,
                  style: TextStyle(
                      color: themeData.colorScheme.primary,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                child: Text(
                  product.previousPrice.withPriceLabel,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 13, decoration: TextDecoration.lineThrough),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  product.price.withPriceLabel,
                  style: TextStyle(
                    color: themeData.colorScheme.primary,
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
