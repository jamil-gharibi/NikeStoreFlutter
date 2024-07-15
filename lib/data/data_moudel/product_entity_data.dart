import 'package:nike_flutter_application/data/data_source/favorite_manager.dart';
// part "product.g.dart";

class ProductSort {
  static const int latest = 0;
  static const int populare = 1;
  static const int priceHighToLow = 2;
  static const int priceLowToHigh = 3;

  static const List<String> stateName = [
    'جدیدترین ها',
    'پربازدیدترین ها',
    'قیمت نزولی',
    'قیمت صعودی'
  ];
}

class ProductBase {
  final List<ProductEntity> products;
  ProductBase.fromJson(Map<String, dynamic> json) : products = json['product'];
}

class ProductEntity {
  final int id;
  final String title;
  final String imageUrl;
  final int price;
  final int discount;
  final int previousPrice;

  ProductEntity(this.id, this.title, this.imageUrl, this.price, this.discount,
      this.previousPrice);

  ProductEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'] ?? 'title',
        imageUrl = json['image'],
        price = json['previous_price'] == null
            ? json['price'] - json['discount']
            : json['price'],
        previousPrice = json['previous_price'] ?? json['price'],
        discount = json['discount'];

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      FieldNamesDb.columnId: id,
      FieldNamesDb.columnTitle: title,
      FieldNamesDb.columnImageUrl: imageUrl,
      FieldNamesDb.columnPrice: price,
      FieldNamesDb.columnDiscount: discount,
      FieldNamesDb.columnPreviousPrice: previousPrice
    };
    return map;
  }

  ProductEntity.fromMap(Map<String, dynamic> map)
      : id = map[FieldNamesDb.columnId],
        title = map[FieldNamesDb.columnTitle],
        imageUrl = map[FieldNamesDb.columnImageUrl],
        price = map[FieldNamesDb.columnPrice],
        discount = map[FieldNamesDb.columnDiscount],
        previousPrice = map[FieldNamesDb.columnPreviousPrice];
}
