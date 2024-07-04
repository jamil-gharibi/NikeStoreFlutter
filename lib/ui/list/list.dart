import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_flutter_application/data/repo/product_repository.dart';
import 'package:nike_flutter_application/ui/list/bloc/product_list_bloc.dart';
import 'package:nike_flutter_application/ui/product/product.dart';

// ignore: must_be_immutable
class ProductListScreen extends StatefulWidget {
  int sort;
  ProductListScreen({super.key, required this.sort});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  ProductListBloc? bloc;
  int viewType = 2;

  @override
  void dispose() {
    bloc!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('کفش ورزشی'),
      ),
      body: BlocProvider<ProductListBloc>(
        create: (contex) {
          bloc = ProductListBloc(productRepository)
            ..add(ProductListStarted(widget.sort));
          return bloc!;
        },
        child: BlocBuilder<ProductListBloc, ProductListState>(
            builder: (context, state) {
          if (state is ProductListSuccess) {
            final products = state.products;
            return Column(
              children: [
                Container(
                  height: 65,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: const Border(top: BorderSide()),
                      boxShadow: const [BoxShadow(blurRadius: 10)],
                      color: themData.colorScheme.surface),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return SizedBox(
                                    height: 300,
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'انتخاب مرتب سازی',
                                          style: themData.textTheme.titleMedium!
                                              .apply(
                                                  fontWeightDelta: 800,
                                                  fontSizeDelta: 1.2),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                              itemCount:
                                                  state.stateNames.length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    bloc!.add(
                                                        ProductListStarted(
                                                            index));
                                                    setState(() {
                                                      widget.sort = index;
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          state.stateNames[
                                                              index],
                                                          style: TextStyle(
                                                              color: index ==
                                                                      widget
                                                                          .sort
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .grey),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        index == widget.sort
                                                            ? Icon(
                                                                CupertinoIcons
                                                                    .checkmark_circle_fill,
                                                                color: themData
                                                                    .colorScheme
                                                                    .secondary,
                                                              )
                                                            : Container()
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Row(
                            children: [
                              const Icon(CupertinoIcons.sort_down),
                              const SizedBox(
                                width: 8,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'مرتب سازی',
                                    style: themData.textTheme.titleMedium!
                                        .apply(
                                            fontWeightDelta: 700,
                                            fontSizeDelta: 0.5),
                                  ),
                                  Text(
                                    state.stateNames[widget.sort],
                                    style: themData.textTheme.bodyMedium!.apply(
                                        fontWeightDelta: 700,
                                        fontSizeDelta: -0.9),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.grey,
                        width: 1,
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              viewType == 1 ? viewType = 2 : viewType = 1;
                            });
                          },
                          icon: Icon(viewType == 2
                              ? CupertinoIcons.square_grid_2x2
                              : CupertinoIcons.rectangle_grid_1x2)),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: GridView.builder(
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.63, crossAxisCount: viewType),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductItem(
                              product: product,
                              themeData: themData,
                              borderRadius: BorderRadius.zero);
                        }),
                  ),
                ),
              ],
            );
          } else if (state is ProductListError) {
            return Center(
              child: Text(state.exception.message),
            );
          } else if (state is ProductListLoading) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          } else {
            return throw ('is not supprted state');
          }
        }),
      ),
    );
  }
}
