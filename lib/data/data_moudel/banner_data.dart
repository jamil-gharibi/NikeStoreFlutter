class BannerEntity {
  final int id;
  final String imageUrl;
  BannerEntity.fromJsom(Map<String, dynamic> json)
      : id = json['id'],
        imageUrl = json['image'];
}
