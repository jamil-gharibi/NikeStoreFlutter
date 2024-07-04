import 'package:flutter/material.dart';
import 'package:nike_flutter_application/data/common/utils.dart';

class PriceInfo extends StatelessWidget {
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;
  const PriceInfo(
      {super.key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 12, top: 8),
          child: Text(
            'جزییات خرید',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.grey)],
              borderRadius: BorderRadius.circular(12)),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'مبلغ کل خرید',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  RichText(
                    text: TextSpan(
                      text: totalPrice.separateByComa,
                      style: DefaultTextStyle.of(context).style.copyWith(
                          fontWeight: FontWeight.w700, color: Colors.black),
                      children: [
                        TextSpan(
                            text: ' تومان',
                            style: DefaultTextStyle.of(context)
                                .style
                                .copyWith(fontSize: 10, color: Colors.grey))
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Divider(
                  color: Colors.grey,
                  height: 1,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'هزینه ارسال',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  RichText(
                    text: TextSpan(
                        text: shippingCost > 0
                            ? shippingCost.separateByComa
                            : shippingCost.withPriceLabel,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                        children: [
                          TextSpan(
                              text: shippingCost > 0 ? ' تومان' : '',
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(fontSize: 10, color: Colors.grey))
                        ]),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Divider(
                  color: Colors.grey,
                  height: 1,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'مبلغ قابل پرداخت',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  RichText(
                    text: TextSpan(
                        text: payablePrice.separateByComa,
                        style: DefaultTextStyle.of(context).style.copyWith(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                        children: [
                          TextSpan(
                              text: ' تومان',
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(color: Colors.grey, fontSize: 10))
                        ]),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
