// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      json['title'] as String,
      (json['price'] as num).toDouble(),
      json['id'] as String,
      json['description'] as String,
      json['image'] as String,
      json['category'] as String? ?? '',
      userid: json['userid'] as String? ?? '',
      views: json['views'] as int? ?? 0,
      datePosted: json['datePosted'] as String? ?? '',
      location: json['location'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'title': instance.title,
      'price': instance.price,
      'id': instance.id,
      'description': instance.description,
      'image': instance.image,
      'userid': instance.userid,
      'username': instance.username,
      'views': instance.views,
      'datePosted': instance.datePosted,
      'location': instance.location,
      'category': instance.category,
    };
