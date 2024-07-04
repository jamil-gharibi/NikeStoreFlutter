import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_flutter_application/data/common/utils.dart';
import 'package:nike_flutter_application/data/data_moudel/product_entity_data.dart';
import 'package:nike_flutter_application/data/repo/cart_repository.dart';
import 'package:nike_flutter_application/theme.dart';
import 'package:nike_flutter_application/ui/product/bloc/product_bloc.dart';
import 'package:nike_flutter_application/ui/product/comment/comment_list.dart';
import 'package:nike_flutter_application/ui/widgete/image.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductEntity productEntity;

  const ProductDetailsScreen({super.key, required this.productEntity});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  StreamSubscription<ProductState>? stateSubscription;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  @override
  void dispose() {
    stateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<ProductBloc>(
        create: (context) {
          final bloc = ProductBloc(cartRepository);
          stateSubscription = bloc.stream.listen((state) {
            if (state is ProductAddToCartSuccess) {
              _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                  content: Text('با موفقیت به سبد خرید شما اضافه شد')));
            } else if (state is ProductAddToCartError) {
              _scaffoldKey.currentState?.showSnackBar(
                  SnackBar(content: Text(state.exception.message)));
            }
          });
          return bloc;
        },
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              width: MediaQuery.of(context).size.width - 50,
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) => FloatingActionButton.extended(
                    onPressed: () {
                      BlocProvider.of<ProductBloc>(context)
                          .add(CartAddButtonClicked(widget.productEntity.id));
                    },
                    label: state is ProductAddToCartButtonLoading
                        ? const CupertinoActivityIndicator(
                            color: LightThemeColor.secondaryTextColor,
                          )
                        : Text(
                            'افزودن به سبد خرید',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: LightThemeColor.secondaryTextColor),
                          )),
              ),
            ),
            body: CustomScrollView(
              physics: defaultScrolPhisic,
              slivers: [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.width * 0.8,
                  flexibleSpace: ImageLoadingService(
                    imageUrl: widget.productEntity.imageUrl,
                    borderRadius: BorderRadius.zero,
                  ),
                  foregroundColor: LightThemeColor.primaryColor,
                  actions: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.heart))
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              widget.productEntity.title,
                              style: Theme.of(context).textTheme.headlineMedium,
                            )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  widget.productEntity.previousPrice
                                      .withPriceLabel,
                                  style: const TextStyle(
                                      decoration: TextDecoration.lineThrough),
                                ),
                                Text(
                                  widget.productEntity.price.withPriceLabel,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'این کتونی شدیدا برای دویدن و راه رفتن مناسب هست و تقریبا هیچ فشار مخربی رو نمیزارد به زانوان شما وارد شود',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: LightThemeColor.primaryColor),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('نظرات کاربران'),
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  'ثبت نظر',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w700),
                                ))
                          ],
                        ),
                        // Container(
                        //   color: Colors.blue,
                        //   height: 1000,
                        //   width: 150,
                        // )
                      ],
                    ),
                  ),
                ),
                CommentList(productId: widget.productEntity.id)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
