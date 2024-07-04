part of 'cart_bloc.dart';

sealed class CartEvent {
  const CartEvent();
}

class CartStarted extends CartEvent {
  final AuthInfo? authInfo;
  final bool isRefershing;

  const CartStarted(this.authInfo, {this.isRefershing = false});
}

class CartAuthInfoChanged extends CartEvent {
  final AuthInfo? authInfo;

  const CartAuthInfoChanged(this.authInfo);
}

class CartDeleteButtonCliecked extends CartEvent {
  final int cartItemId;

  const CartDeleteButtonCliecked(this.cartItemId);
}

class CartIncreaseButtonClicked extends CartEvent {
  final int cartItemId;

  CartIncreaseButtonClicked(this.cartItemId);
}

class CartDecreaseButtonClicked extends CartEvent {
  final int cartItemId;

  const CartDecreaseButtonClicked(this.cartItemId);
}
