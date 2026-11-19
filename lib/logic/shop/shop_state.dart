import 'package:equatable/equatable.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';

abstract class ShopState extends Equatable {
  const ShopState();

  @override
  List<Object?> get props => [];
}

class ShopLoading extends ShopState {}

class ShopLoaded extends ShopState {
  final List<CategoryModel> categories;
  final List<ProductModel> allProducts;
  final List<ProductModel> displayedProducts;
  final List<ProductModel> bestSellers;
  final CategoryModel? selectedCategory;
  final String selectedSubCategory;
  final String searchQuery;

  const ShopLoaded({
    required this.categories,
    required this.allProducts,
    required this.displayedProducts,
    required this.bestSellers,
    this.selectedCategory,
    this.selectedSubCategory = 'All',
    this.searchQuery = '',
  });

  ShopLoaded copyWith({
    List<CategoryModel>? categories,
    List<ProductModel>? allProducts,
    List<ProductModel>? displayedProducts,
    List<ProductModel>? bestSellers,
    CategoryModel? selectedCategory,
    String? selectedSubCategory,
    String? searchQuery,
  }) {
    return ShopLoaded(
      categories: categories ?? this.categories,
      allProducts: allProducts ?? this.allProducts,
      displayedProducts: displayedProducts ?? this.displayedProducts,
      bestSellers: bestSellers ?? this.bestSellers,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        categories,
        allProducts,
        displayedProducts,
        bestSellers,
        selectedCategory,
        selectedSubCategory,
        searchQuery,
      ];
}

class ShopError extends ShopState {
  final String message;

  const ShopError(this.message);

  @override
  List<Object?> get props => [message];
}
