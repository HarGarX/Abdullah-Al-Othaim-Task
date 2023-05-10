// To parse this JSON data, do
//
//     final fetchProductsResponseModel = fetchProductsResponseModelFromJson(jsonString);

import 'dart:convert';

FetchProductsResponseModel fetchProductsResponseModelFromJson(String str) =>
    FetchProductsResponseModel.fromJson(json.decode(str));

String fetchProductsResponseModelToJson(FetchProductsResponseModel data) => json.encode(data.toJson());

class FetchProductsResponseModel {
  final String? categoryDesc;
  final int? total;
  final String? imagePlaceholder;
  final List<Datum>? data;

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
    List<Datum>? data,
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
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "categoryDesc": categoryDesc,
        "total": total,
        "imagePlaceholder": imagePlaceholder,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  final int? sku;
  final String? desc;
  final double? regularPrice;
  final double? salePrice;
  final String? imageUrl;

  Datum({
    this.sku,
    this.desc,
    this.regularPrice,
    this.salePrice,
    this.imageUrl,
  });

  Datum copyWith({
    int? sku,
    String? desc,
    double? regularPrice,
    double? salePrice,
    String? imageUrl,
  }) =>
      Datum(
        sku: sku ?? this.sku,
        desc: desc ?? this.desc,
        regularPrice: regularPrice ?? this.regularPrice,
        salePrice: salePrice ?? this.salePrice,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
