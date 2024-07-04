import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_flutter_application/data/data_moudel/order_result.dart';
import 'package:nike_flutter_application/data/repo/order_repository.dart';
import 'package:nike_flutter_application/ui/cart/price_info.dart';
import 'package:nike_flutter_application/ui/payment_webview.dart';
import 'package:nike_flutter_application/ui/receipt/receipt.dart';
import 'package:nike_flutter_application/ui/shipping/bloc/shipping_bloc.dart';

class ShippingScreen extends StatefulWidget {
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;

  const ShippingScreen(
      {super.key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  final TextEditingController firstNameControler =
      TextEditingController(text: 'جمیل');

  final TextEditingController lastNameControler =
      TextEditingController(text: 'غریبی');

  final TextEditingController mobileControler =
      TextEditingController(text: '09123456789');

  final TextEditingController postalCodeControler =
      TextEditingController(text: '1234567890');

  final TextEditingController addressControler = TextEditingController(
      text: 'ایران کردستان سنندج خوین اوی بژی کورد و کوردستان');

  StreamSubscription? subscription;

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحویل گیرنده'),
      ),
      body: BlocProvider<ShippingBloc>(
        create: (context) {
          final shippingBloc = ShippingBloc(orederRepository);

          subscription = shippingBloc.stream.listen((event) {
            if (event is ShippingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(event.exception.message)));
            } else if (event is ShippingSucces) {
              if (event.result.bankGatewayUrl.isEmpty) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ReceiptScreen(
                          orderId: event.result.orderId,
                        )));
              } else {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PaymentWebview(
                        bankGateway: event.result.bankGatewayUrl)));
              }
            }
          });

          return shippingBloc;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: firstNameControler,
                  decoration: const InputDecoration(labelText: 'نام'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: lastNameControler,
                  decoration: const InputDecoration(labelText: 'نام خانوادگی'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: mobileControler,
                  decoration: const InputDecoration(labelText: 'شماره تماس'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: postalCodeControler,
                  decoration: const InputDecoration(labelText: 'کدپستی'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: addressControler,
                  decoration: const InputDecoration(labelText: 'آدرس'),
                ),
                const SizedBox(
                  height: 8,
                ),
                PriceInfo(
                    payablePrice: widget.payablePrice,
                    shippingCost: widget.shippingCost,
                    totalPrice: widget.totalPrice),
                const SizedBox(
                  height: 8,
                ),
                BlocBuilder<ShippingBloc, ShippingState>(
                  builder: (context, state) {
                    return state is ShippingLoading
                        ? const Center(
                            child: CupertinoActivityIndicator(),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                  onPressed: () {
                                    BlocProvider.of<ShippingBloc>(context).add(
                                        ShippingCreateOrder(SubmitOrderParams(
                                            firstName: firstNameControler.text,
                                            lastName: lastNameControler.text,
                                            phoneNumber: mobileControler.text,
                                            postalCode:
                                                postalCodeControler.text,
                                            address: addressControler.text,
                                            paymentMethod:
                                                PaymentMethod.cashOnDelivery)));
                                  },
                                  child: const Text(
                                    'پرداخت در محل',
                                  )),
                              const SizedBox(
                                width: 8,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    BlocProvider.of<ShippingBloc>(context).add(
                                        ShippingCreateOrder(SubmitOrderParams(
                                            firstName: firstNameControler.text,
                                            lastName: lastNameControler.text,
                                            phoneNumber: mobileControler.text,
                                            postalCode:
                                                postalCodeControler.text,
                                            address: addressControler.text,
                                            paymentMethod:
                                                PaymentMethod.online)));
                                  },
                                  child: Text('پرداخت اینترنتی',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary))),
                            ],
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
