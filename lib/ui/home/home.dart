import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_flutter_application/ui/list/list.dart';
import 'package:nike_flutter_application/ui/widgete/error_try_again.dart';
import 'package:nike_flutter_application/data/common/utils.dart';
import 'package:nike_flutter_application/data/data_moudel/product_entity_data.dart';
import 'package:nike_flutter_application/data/repo/banner_repository.dart';
import 'package:nike_flutter_application/data/repo/product_repository.dart';
import 'package:nike_flutter_application/ui/home/bloc/home_bloc.dart';
import 'package:nike_flutter_application/ui/product/product.dart';
import 'package:nike_flutter_application/ui/widgete/slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final homeBloc = HomeBloc(
            bannerRepository: bannerRepository,
            productRepository: productRepository);

        homeBloc.add(HomeStarted());
        return homeBloc;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
            if (state is HomeSuccess) {
              return ListView.builder(
                  physics: defaultScrolPhisic,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Image.asset(
                            'assets/img/nike_logo.png',
                            height: 36,
                          ),
                        );
                      case 2:
                        return BannerSlider(
                          state.banners,
                          borderValue: 12,
                        );
                      case 3:
                        return ProductItems(
                          title: 'جدیدترین ها',
                          products: state.latestProduct,
                          onTop: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductListScreen(
                                      sort: ProductSort.latest,
                                    )));
                          },
                        );
                      case 4:
                        return ProductItems(
                          title: 'پربازدیدترین ها',
                          products: state.populareProduct,
                          onTop: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductListScreen(
                                    sort: ProductSort.populare)));
                          },
                        );
                      default:
                        return Container();
                    }
                  });
            } else if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeError) {
              return AppErrorWidgete(
                exception: state.exception,
                onPressed: () {
                  BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                },
              );
            } else {
              throw Exception('state is not supported');
            }
          }),
        ),
      ),
    );
  }
}

class ProductItems extends StatelessWidget {
  final String title;
  final List<ProductEntity> products;
  final GestureTapCallback onTop;
  const ProductItems({
    super.key,
    required this.title,
    required this.products,
    required this.onTop,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              TextButton(
                  onPressed: onTop,
                  child: const Text(
                    'مشاهده همه',
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ))
            ],
          ),
          SizedBox(
            height: 290,
            child: ListView.builder(
                physics: defaultScrolPhisic,
                itemCount: products.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductItem(
                    product: product,
                    themeData: themeData,
                    borderRadius: BorderRadius.circular(12),
                  );
                }),
          )
        ],
      ),
    );
  }
}
