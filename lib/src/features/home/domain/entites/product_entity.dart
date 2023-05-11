// To parse this JSON data, do
//
//     final productEntity = productEntityFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

List<ProductEntity> productsEntityFromJson(String str) =>
    List<ProductEntity>.from(json.decode(str).map((x) => ProductEntity.fromJson(x)));
String productsEntityToJson(List<ProductEntity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

ProductEntity productEntityFromJson(String str) => ProductEntity.fromJson(json.decode(str));
String productEntityToJson(ProductEntity data) => json.encode(data.toJson());

class ProductEntity extends Equatable {
  final int? sku;
  final String? desc;
  final double? regularPrice;
  final num? salePrice;
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
    num? salePrice,
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

  @override
  // TODO: implement props
  List<Object?> get props => [sku, desc, regularPrice, salePrice, imageUrl];
}
