import 'package:equatable/equatable.dart';
import '../../data/models/category_model.dart';

abstract class ShopEvent extends Equatable {
  const ShopEvent();

  @override
  List<Object?> get props => [];
}

class ShopFetchInitialData extends ShopEvent {}

class ShopCategorySelected extends ShopEvent {
  final CategoryModel category;

  const ShopCategorySelected(this.category);

  @override
  List<Object?> get props => [category];
}

class ShopSubCategorySelected extends ShopEvent {
  final String subCategory;

  const ShopSubCategorySelected(this.subCategory);

  @override
  List<Object?> get props => [subCategory];
}

class ShopSearchRequested extends ShopEvent {
  final String query;

  const ShopSearchRequested(this.query);

  @override
  List<Object?> get props => [query];
}
