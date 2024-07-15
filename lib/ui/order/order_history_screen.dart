import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nike_flutter_application/data/common/utils.dart';
import 'package:nike_flutter_application/data/repo/order_repository.dart';
import 'package:nike_flutter_application/ui/order/bloc/order_history_bloc.dart';
import 'package:nike_flutter_application/ui/widgete/empty.dart';
import 'package:nike_flutter_application/ui/widgete/image.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themedata = Theme.of(context);
    return BlocProvider<OrderHistoryBloc>(
      create: (context) =>
          OrderHistoryBloc(orederRepository)..add(OrderHistoryStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('سفارش ها'),
        ),
        body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
          builder: (context, state) {
            if (state is OrderHistoryLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else if (state is OrderHistorySuccess) {
              final orders = state.orderEntitys;

              if (orders.isNotEmpty) {
                return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];

                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color:
                                      themedata.dividerColor.withOpacity(0.5),
                                  width: 1)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'شناسه سفارش',
                                    style: TextStyle(
                                        color: themedata.colorScheme.primary),
                                  ),
                                  Text(
                                    order.id.separateByComa,
                                    style: TextStyle(
                                        color: themedata.colorScheme.primary),
                                  )
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                child: Divider(
                                  color:
                                      themedata.dividerColor.withOpacity(0.4),
                                  height: 1,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'مبلغ',
                                    style: TextStyle(
                                        color: themedata.colorScheme.primary),
                                  ),
                                  Text(
                                    order.payablePrice.withPriceLabel,
                                    style: TextStyle(
                                        color: themedata.colorScheme.primary),
                                  )
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                child: Divider(
                                  color:
                                      themedata.dividerColor.withOpacity(0.4),
                                  height: 1,
                                ),
                              ),
                              SizedBox(
                                height: 132,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: order.items.length,
                                    itemBuilder: (context, index) {
                                      final orderImage = order.items[index];
                                      return Container(
                                        margin: const EdgeInsets.only(
                                            left: 4, right: 4),
                                        height: 100,
                                        width: 100,
                                        child: ImageLoadingService(
                                            imageUrl: orderImage.imageUrl,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                      );
                                    }),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return EmptyState(
                    image: SvgPicture.asset('assets/img/empty_cart.svg'),
                    textMessage: 'شما محصولی را انتخاب نکرده اید!');
              }
            } else if (state is OrderHistoryError) {
              return Center(
                child: Text(state.exception.message),
              );
            } else {
              return throw ('is not state');
            }
          },
        ),
      ),
    );
  }
}
