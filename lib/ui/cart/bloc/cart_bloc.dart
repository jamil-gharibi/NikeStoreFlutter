import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:nike_flutter_application/common/exception.dart';
import 'package:nike_flutter_application/data/data_moudel/auth_data.dart';
import 'package:nike_flutter_application/data/data_moudel/cart_response_data.dart';
import 'package:nike_flutter_application/data/repo/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  ICartRepository cartRepository;
  CartBloc(this.cartRepository) : super(CartLoading()) {
    on<CartEvent>((event, emit) async {
      if (event is CartStarted) {
        try {
          final authInfo = event.authInfo;
          if (authInfo == null || authInfo.accessToken.isEmpty) {
            emit(CartAuthRequired());
          } else {
            await loadCartItem(emit, false);
          }
          cartRepository.count();
        } catch (e) {
          emit(CartError(AppException()));
        }
      } else if (event is CartAuthInfoChanged) {
        if (event.authInfo == null || event.authInfo!.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          await loadCartItem(emit, false);
        }
      } else if (event is CartDeleteButtonCliecked) {
        if (state is CartSuccess) {
          try {
            final successState = (state as CartSuccess);
            final cartItemIndex = successState.cartResponse.cartItem
                .indexWhere((element) => element.id == event.cartItemId);
            successState.cartResponse.cartItem[cartItemIndex]
                .deleteButtonLoading = true;

            emit(CartSuccess(successState.cartResponse));
            // emit(calculaterPriceInfo(successState.cartResponse));

            await Future.delayed(const Duration(milliseconds: 200));
            await cartRepository.delete(event.cartItemId);

            successState.cartResponse.cartItem
                .removeWhere((elemet) => elemet.id == event.cartItemId);
            await cartRepository.count();
            if (successState.cartResponse.cartItem.isEmpty) {
              emit(CartIsEmpty());
            } else {
              emit(calculaterPriceInfo(successState.cartResponse));
            }
          } catch (e) {
            debugPrint(e.toString());
          }
        }
      } else if (event is CartIncreaseButtonClicked ||
          event is CartDecreaseButtonClicked) {
        if (state is CartSuccess) {
          try {
            int cartItemId = 0;
            if (event is CartIncreaseButtonClicked) {
              cartItemId = event.cartItemId;
            } else if (event is CartDecreaseButtonClicked) {
              cartItemId = event.cartItemId;
            }

            final successState = (state as CartSuccess);
            final cartItemIndex = successState.cartResponse.cartItem
                .indexWhere((element) => element.id == cartItemId);
            successState.cartResponse.cartItem[cartItemIndex]
                .changedCountLoading = true;

            emit(CartSuccess(successState.cartResponse));

            await Future.delayed(const Duration(milliseconds: 200));

            int newCount =
                successState.cartResponse.cartItem[cartItemIndex].count;

            if (event is CartDecreaseButtonClicked) {
              newCount -= 1;
            } else if (event is CartIncreaseButtonClicked) {
              newCount += 1;
            }
            await cartRepository.changeCount(cartItemId, newCount);
            await cartRepository.count();
            successState.cartResponse.cartItem
                .firstWhere((item) => item.id == cartItemId)
              ..changedCountLoading = false
              ..count = newCount;

            emit(calculaterPriceInfo(successState.cartResponse));
          } catch (e) {
            debugPrint(e.toString());
          }
        }
      }
    });
  }

  Future<void> loadCartItem(Emitter<CartState> emit, bool isRefresh) async {
    try {
      if (isRefresh) {
        emit(CartLoading());
      }
      final cartRsponse = await cartRepository.getAll();
      if (cartRsponse.cartItem.isEmpty) {
        emit(CartIsEmpty());
      } else {
        emit(CartSuccess(cartRsponse));
      }
    } catch (e) {
      emit(CartError(AppException()));
    }
  }

  CartSuccess calculaterPriceInfo(CartResponse cartResponse) {
    int totalPrice = 0;
    int payablePrice = 0;
    int shippingPrice = 0;

    for (var cartItem in cartResponse.cartItem) {
      totalPrice += cartItem.product.previousPrice * cartItem.count;
      payablePrice += cartItem.product.price * cartItem.count;
    }

    shippingPrice = payablePrice >= 250000 ? 0 : 30000;

    cartResponse.shippingPrice = shippingPrice;
    cartResponse.payablePrice = payablePrice;
    cartResponse.totalPrice = totalPrice;

    return CartSuccess(cartResponse);
  }
}
