import 'package:equatable/equatable.dart';

class ProductColorOption extends Equatable {
  final String name;
  final int colorValue;
  final String? imageUrl;

  const ProductColorOption({
    required this.name,
    required this.colorValue,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [name, colorValue, imageUrl];
}

class ProductModel extends Equatable {
  final String id;
  final String name;
  final String categoryId;
  final String categoryName;
  final String subCategory;
  final double price;
  final double originalPrice;
  final int discountPercent;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final List<String> images;
  final String description;
  final List<String> sizes;
  final List<ProductColorOption> colors;
  final bool isBestSeller;
  final bool isFeatured;

  const ProductModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.subCategory,
    required this.price,
    required this.originalPrice,
    required this.discountPercent,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    this.images = const [],
    required this.description,
    this.sizes = const ['32', '34', '36', '38', '40'],
    this.colors = const [],
    this.isBestSeller = false,
    this.isFeatured = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        categoryId,
        categoryName,
        subCategory,
        price,
        originalPrice,
        discountPercent,
        rating,
        reviewCount,
        imageUrl,
        images,
        description,
        sizes,
        colors,
        isBestSeller,
        isFeatured,
      ];
}
