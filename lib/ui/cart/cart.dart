import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nike_flutter_application/data/common/utils.dart';
import 'package:nike_flutter_application/data/repo/auth_repository.dart';
import 'package:nike_flutter_application/data/repo/cart_repository.dart';
import 'package:nike_flutter_application/ui/auth/auth.dart';
import 'package:nike_flutter_application/ui/cart/bloc/cart_bloc.dart';
import 'package:nike_flutter_application/ui/cart/price_info.dart';
import 'package:nike_flutter_application/ui/shipping/shipping.dart';
import 'package:nike_flutter_application/ui/widgete/cart_item_widget.dart';
import 'package:nike_flutter_application/ui/widgete/empty.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc? cartBloc;
  final _refreshControler = RefreshController();
  StreamSubscription? streamSubscriptionRefresher;
  bool isVisibilityPay = false;
  @override
  void initState() {
    super.initState();
    AuthRepository.valueNotifierAutInfo.addListener(authChangeNotifieristener);
  }

  void authChangeNotifieristener() {
    cartBloc
        ?.add(CartAuthInfoChanged(AuthRepository.valueNotifierAutInfo.value));
  }

  @override
  void dispose() {
    AuthRepository.valueNotifierAutInfo
        .removeListener(authChangeNotifieristener);
    cartBloc?.close();
    streamSubscriptionRefresher!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themData = Theme.of(context);
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Visibility(
          visible: isVisibilityPay,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            child: FloatingActionButton.extended(
                onPressed: () {
                  final state = cartBloc!.state;
                  if (state is CartSuccess) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ShippingScreen(
                              payablePrice: state.cartResponse.payablePrice,
                              shippingCost: state.cartResponse.shippingPrice,
                              totalPrice: state.cartResponse.totalPrice,
                            )));
                  }
                },
                label: Text(
                  'پرداخت',
                  style: themData.textTheme.titleMedium!.copyWith(
                      color: themData.colorScheme.surface.withOpacity(0.7)),
                )),
          ),
        ),
        backgroundColor: themData.colorScheme.surfaceContainerHighest,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('سبد خرید'),
        ),
        body: BlocProvider<CartBloc>(
          create: (context) {
            final bloc = CartBloc(cartRepository);
            cartBloc = bloc;
            streamSubscriptionRefresher = bloc.stream.listen((state) {
              setState(() {
                isVisibilityPay = state is CartSuccess;
              });

              if (_refreshControler.isRefresh) {
                if (state is CartSuccess) {
                  _refreshControler.refreshCompleted();
                } else if (state is CartError) {
                  _refreshControler.refreshFailed();
                }
              }
            });
            bloc.add(CartStarted(AuthRepository.valueNotifierAutInfo.value));
            return bloc;
          },
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CartError) {
                return Center(child: Text(state.exception.message));
              } else if (state is CartAuthRequired) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('وارد حساب کاربری خود شوید'),
                      const SizedBox(
                        height: 12,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const AuthScreen()));
                          },
                          child: const Text('ورود'))
                    ],
                  ),
                );
              } else if (state is CartSuccess) {
                return SmartRefresher(
                  controller: _refreshControler,
                  header: const ClassicHeader(
                    refreshingText: 'در حال بروزرسانی',
                    releaseText: 'رها کنید',
                    completeText: 'بروزرسانی شد',
                    idleText: 'برای بروزرسانی پایین بکشید',
                  ),
                  onRefresh: () {
                    cartBloc?.add(CartStarted(
                        AuthRepository.valueNotifierAutInfo.value,
                        isRefershing: true));
                  },
                  child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      physics: defaultScrolPhisic,
                      itemCount: state.cartResponse.cartItem.length + 1,
                      itemBuilder: (context, index) {
                        if (index < state.cartResponse.cartItem.length) {
                          final data = state.cartResponse.cartItem[index];
                          return CartItemWidget(
                            themData: themData,
                            data: data,
                            deleteTapCallback: () {
                              cartBloc?.add(CartDeleteButtonCliecked(data.id));
                            },
                            cartIncreaseCallBack: () {
                              cartBloc?.add(CartIncreaseButtonClicked(data.id));
                            },
                            cartDecreaseCallBack: () {
                              if (data.count > 1) {
                                cartBloc
                                    ?.add(CartDecreaseButtonClicked(data.id));
                              }
                            },
                          );
                        } else {
                          return PriceInfo(
                            totalPrice: state.cartResponse.totalPrice,
                            payablePrice: state.cartResponse.payablePrice,
                            shippingCost: state.cartResponse.shippingPrice,
                          );
                        }
                      }),
                );
              } else if (state is CartIsEmpty) {
                return EmptyState(
                    image: SvgPicture.asset('assets/img/empty_cart.svg'),
                    textMessage: 'شما محصولی را انتخاب نکرده اید!');
              } else {
                return throw ('state is not valid');
              }
            },
          ),
        )

        // ValueListenableBuilder<AuthInfo?>(
        //     valueListenable: AuthRepository.valueNotifierAutInfo,
        //     builder: (context, authState, child) {
        //       bool isAuthentocated =
        //           authState != null && authState.accessToken.isNotEmpty;

        //       return Center(
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: [
        //             Text(isAuthentocated
        //                 ? 'خوش آمدید'
        //                 : 'وارد حساب کاربری خود شوید'),
        //             isAuthentocated
        //                 ? ElevatedButton(
        //                     onPressed: () {
        //                       authRepository.signOut();
        //                     },
        //                     child: const Text('خروج از حساب'))
        //                 : ElevatedButton(
        //                     onPressed: () {
        //                       Navigator.of(context, rootNavigator: true).push(
        //                           MaterialPageRoute(
        //                               builder: (context) => const AuthScreen()));
        //                     },
        //                     child: const Text('ورود')),
        //             ElevatedButton(
        //                 onPressed: () async {
        //                   await authRepository.refreshToken();
        //                 },
        //                 child: const Text('RefreshToken'))
        //           ],
        //         ),
        //       );
        //     }),
        );
  }
}
