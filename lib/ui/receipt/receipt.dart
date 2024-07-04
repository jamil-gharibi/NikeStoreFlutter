import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_flutter_application/data/common/utils.dart';
import 'package:nike_flutter_application/data/repo/order_repository.dart';
import 'package:nike_flutter_application/theme.dart';
import 'package:nike_flutter_application/ui/receipt/bloc/payment_receipt_bloc.dart';

class ReceiptScreen extends StatelessWidget {
  final int orderId;

  const ReceiptScreen({super.key, required this.orderId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('رسید پرداخت'),
        centerTitle: true,
      ),
      body: BlocProvider<PaymentReceiptBloc>(
        create: (context) => PaymentReceiptBloc(orederRepository)
          ..add(PaymentReceiptStarted(orderId)),
        child: BlocBuilder<PaymentReceiptBloc, PaymentReceiptState>(
          builder: (context, state) {
            if (state is PaymentReceiptSuccess) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.shade400, width: 2),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          Text(
                            state.paymentReceiptData.purchaseSuccess
                                ? 'پرداخت با موفقیت انجام شد'
                                : 'پرداخت ناموفق',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: LightThemeColor.secondaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('وضعیت سفارش'),
                              Text(
                                state.paymentReceiptData.paymentStatus,
                                style: const TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 8),
                            child: Divider(
                              height: 2,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('مبلغ'),
                              Text(
                                state.paymentReceiptData.payablePrice
                                    .withPriceLabel,
                                style: const TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((roote) => roote.isFirst);
                      },
                      child: Text('بازگشت به صفحه اصلی',
                          style: Theme.of(context).textTheme.titleMedium!.apply(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withOpacity(0.8))),
                    )
                  ],
                ),
              );
            } else if (state is PaymentReceiptError) {
              return Center(
                child: Text(state.exception.message),
              );
            } else if (state is PaymentReceiptLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else {
              return throw ('is not suupported');
            }
          },
        ),
      ),
    );
  }
}
