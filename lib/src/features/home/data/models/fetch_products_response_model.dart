// To parse this JSON data, do
//
//     final fetchProductsResponseModel = fetchProductsResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:abdullah_al_othaim_task/src/features/home/domain/entites/product_entity.dart';
import 'package:equatable/equatable.dart';

FetchProductsResponseModel fetchProductsResponseModelFromJson(String str) =>
    FetchProductsResponseModel.fromJson(json.decode(str));

String fetchProductsResponseModelToJson(FetchProductsResponseModel data) => json.encode(data.toJson());

class FetchProductsResponseModel extends Equatable {
  final String? categoryDesc;
  final int? total;
  final String? imagePlaceholder;
  final List<Product>? data;

  FetchProductsResponseModel({
    this.categoryDesc,
    this.total,
    this.imagePlaceholder,
    this.data,
  });

  FetchProductsResponseModel copyWith({
    String? categoryDesc,
    int? total,
    String? imagePlaceholder,
    List<Product>? data,
  }) =>
      FetchProductsResponseModel(
        categoryDesc: categoryDesc ?? this.categoryDesc,
        total: total ?? this.total,
        imagePlaceholder: imagePlaceholder ?? this.imagePlaceholder,
        data: data ?? this.data,
      );

  factory FetchProductsResponseModel.fromJson(Map<String, dynamic> json) => FetchProductsResponseModel(
        categoryDesc: json["categoryDesc"],
        total: json["total"],
        imagePlaceholder: json["imagePlaceholder"],
        data: json["data"] == null ? [] : List<Product>.from(json["data"]!.map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "categoryDesc": categoryDesc,
        "total": total,
        "imagePlaceholder": imagePlaceholder,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };

  @override
  // TODO: implement props
  List<Object?> get props => [categoryDesc, total, imagePlaceholder, data];
}

class Product extends ProductEntity {
  final int? sku;
  final String? desc;
  final double? regularPrice;
  final num? salePrice;
  final String? imageUrl;

  Product({
    this.sku,
    this.desc,
    this.regularPrice,
    this.salePrice,
    this.imageUrl,
  }) : super(
          sku: sku,
          desc: desc,
          regularPrice: regularPrice,
          salePrice: salePrice,
          imageUrl: imageUrl,
        );

  Product copyWith({
    int? sku,
    String? desc,
    double? regularPrice,
    num? salePrice,
    String? imageUrl,
  }) =>
      Product(
        sku: sku ?? this.sku,
        desc: desc ?? this.desc,
        regularPrice: regularPrice ?? this.regularPrice,
        salePrice: salePrice ?? this.salePrice,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        sku: json["sku"],
        desc: json["desc"],
        regularPrice: json["regularPrice"]?.toDouble(),
        salePrice: json["salePrice"]?.toDouble(),
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
