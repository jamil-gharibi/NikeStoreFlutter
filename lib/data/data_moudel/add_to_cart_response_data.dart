class AddToCartResponseData {
  final int productId;
  final int cartItemId;
  final int count;

  AddToCartResponseData(this.productId, this.cartItemId, this.count);
  AddToCartResponseData.fromJson(Map<String, dynamic> json)
      : productId = json['product_id'],
        cartItemId = json['id'],
        count = json['count'];
}
