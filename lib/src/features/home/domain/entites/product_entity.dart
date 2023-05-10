// To parse this JSON data, do
//
//     final productEntity = productEntityFromJson(jsonString);

import 'dart:convert';

ProductEntity productEntityFromJson(String str) => ProductEntity.fromJson(json.decode(str));

String productEntityToJson(ProductEntity data) => json.encode(data.toJson());

class ProductEntity {
  final int? sku;
  final String? desc;
  final double? regularPrice;
  final int? salePrice;
  final String? imageUrl;

  ProductEntity({
    this.sku,
    this.desc,
    this.regularPrice,
    this.salePrice,
    this.imageUrl,
  });

  ProductEntity copyWith({
    int? sku,
    String? desc,
    double? regularPrice,
    int? salePrice,
    String? imageUrl,
  }) =>
      ProductEntity(
        sku: sku ?? this.sku,
        desc: desc ?? this.desc,
        regularPrice: regularPrice ?? this.regularPrice,
        salePrice: salePrice ?? this.salePrice,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  factory ProductEntity.fromJson(Map<String, dynamic> json) => ProductEntity(
        sku: json["sku"],
        desc: json["desc"],
        regularPrice: json["regularPrice"]?.toDouble(),
        salePrice: json["salePrice"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "sku": sku,
        "desc": desc,
        "regularPrice": regularPrice,
        "salePrice": salePrice,
        "imageUrl": imageUrl,
      };
}
