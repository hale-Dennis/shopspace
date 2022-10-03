import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';
@JsonSerializable()
class Product {
  String title;
  double price;
  String id;
  String description;
  String image;
  String userid;
  String username;
  int views;
  String datePosted;
  String location;

  @JsonKey(defaultValue: '')
  String category;
  Product(
      this.title,
      this.price,
      this.id,
      this.description,
      this. image,
      this.category,
      {this.userid = '',
        this.views = 0,
        this.datePosted = '',
        this.location = '',
      this.username = ''}
      );

  factory Product.fromJson(Map<String,  dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

}



