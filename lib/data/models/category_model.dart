import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String subtitle;
  final String imageUrl;
  final List<String> subCategories;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.imageUrl,
    this.subCategories = const [],
  });

  @override
  List<Object?> get props => [id, name, subtitle, imageUrl, subCategories];
}
