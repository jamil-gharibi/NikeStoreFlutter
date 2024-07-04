import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_flutter_application/data/common/utils.dart';
import 'package:nike_flutter_application/data/data_moudel/cart_item_data.dart';
import 'package:nike_flutter_application/ui/widgete/image.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget(
      {super.key,
      required this.themData,
      required this.data,
      required this.deleteTapCallback,
      required this.cartDecreaseCallBack,
      required this.cartIncreaseCallBack});
  final ThemeData themData;
  final CartItemEntity data;
  final GestureTapCallback deleteTapCallback;
  final GestureTapCallback cartDecreaseCallBack;
  final GestureTapCallback cartIncreaseCallBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      width: MediaQuery.of(context).size.width,
      height: 250,
      decoration: BoxDecoration(
          color: themData.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
          ]),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: Row(
                children: [
                  SizedBox(
                      width: 100,
                      height: 100,
                      child: ImageLoadingService(
                          imageUrl: data.product.imageUrl,
                          borderRadius: BorderRadius.circular(12))),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(
                        data.product.title,
                        style: themData.textTheme.headlineMedium,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('تعداد'),
                    Row(
                      children: [
                        IconButton(
                            onPressed: cartIncreaseCallBack,
                            icon: const Icon(CupertinoIcons.plus_rectangle)),
                        data.changedCountLoading
                            ? const CupertinoActivityIndicator()
                            : Text(
                                data.count.toString(),
                                style: themData.textTheme.titleMedium!
                                    .apply(color: Colors.black),
                              ),
                        IconButton(
                            onPressed: cartDecreaseCallBack,
                            icon: const Icon(CupertinoIcons.minus_rectangle))
                      ],
                    )
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(data.product.previousPrice.withPriceLabel,
                          style: const TextStyle(
                              decoration: TextDecoration.lineThrough)),
                      Text(
                        data.product.price.withPriceLabel,
                        style: themData.textTheme.labelMedium!
                            .copyWith(fontSize: 18),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          const Divider(
            height: 1,
            color: Colors.grey,
          ),
          Center(
              child: data.deleteButtonLoading
                  ? const SizedBox(
                      height: 48, child: CupertinoActivityIndicator())
                  : TextButton(
                      onPressed: deleteTapCallback,
                      child: Text(
                        'حذف از سبد خرید',
                        style: themData.textTheme.titleMedium!
                            .copyWith(color: Colors.blue),
                      )))
        ],
      ),
    );
  }
}
