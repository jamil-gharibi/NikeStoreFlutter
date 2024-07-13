import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nike_flutter_application/data/common/utils.dart';
import 'package:nike_flutter_application/data/data_moudel/product_entity_data.dart';
import 'package:nike_flutter_application/data/data_source/favorite_manager.dart';
import 'package:nike_flutter_application/ui/product/details.dart';
import 'package:nike_flutter_application/ui/widgete/empty.dart';
import 'package:nike_flutter_application/ui/widgete/image.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('علاقه مندی ها'),
      ),
      body: ValueListenableBuilder<List<ProductEntity>>(
          valueListenable: favoriteManagerDb.valuNotifireFavorite,
          builder: (context, data, child) {
            if (data.isNotEmpty) {
              final products = data;
              return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (contex, index) {
                    final product = products[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (contex) => ProductDetailsScreen(
                                  productEntity: product)));
                        },
                        onLongPress: () {
                          showDialog(
                              context: context,
                              builder: (contex) => Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: AlertDialog(
                                      title: const Text('حذف علاقه مندی'),
                                      content: const Text(
                                          'آیا مایل به حذف می باشید؟'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(contex);
                                            },
                                            child: const Text('خیر')),
                                        TextButton(
                                            onPressed: () {
                                              favoriteManagerDb
                                                  .delete(product.id);
                                              if (products.isEmpty) {
                                                setState(() {});
                                              }
                                              Navigator.pop(contex);
                                            },
                                            child: const Text('بله'))
                                      ],
                                    ),
                                  ));
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width / 3.5,
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 3.5,
                                height: MediaQuery.of(context).size.width / 3.5,
                                child: ImageLoadingService(
                                    imageUrl: product.imageUrl,
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              Expanded(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, left: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        product.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .apply(fontSizeDelta: -3),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.price.withPriceLabel,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .apply(
                                                  fontSizeDelta: -2,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                        ),
                                        Text(
                                          product.previousPrice.withPriceLabel,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .apply(color: Colors.black),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ))
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return EmptyState(
                  image: SvgPicture.asset('assets/img/empty_cart.svg'),
                  textMessage: 'شما محصولی را انتخاب نکرده اید!');
            }
          }),
    );
  }
}
