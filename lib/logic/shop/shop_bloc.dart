import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/shop_repository.dart';
import 'shop_event.dart';
import 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final ShopRepository shopRepository;

  ShopBloc({required this.shopRepository}) : super(ShopLoading()) {
    on<ShopFetchInitialData>(_onFetchInitialData);
    on<ShopCategorySelected>(_onCategorySelected);
    on<ShopSubCategorySelected>(_onSubCategorySelected);
    on<ShopSearchRequested>(_onSearchRequested);
  }

  Future<void> _onFetchInitialData(
    ShopFetchInitialData event,
    Emitter<ShopState> emit,
  ) async {
    emit(ShopLoading());
    try {
      final categories = await shopRepository.getCategories();
      final products = await shopRepository.getProducts();
      final bestSellers = await shopRepository.getBestSellers();

      final brasCategory = categories.firstWhere(
        (c) => c.id == 'cat_bras',
        orElse: () => categories.first,
      );

      final brasProducts = products.where((p) => p.categoryId == 'cat_bras').toList();

      emit(ShopLoaded(
        categories: categories,
        allProducts: products,
        displayedProducts: brasProducts,
        bestSellers: bestSellers,
        selectedCategory: brasCategory,
        selectedSubCategory: 'All',
      ));
    } catch (e) {
      emit(ShopError(e.toString()));
    }
  }

  void _onCategorySelected(
    ShopCategorySelected event,
    Emitter<ShopState> emit,
  ) {
    if (state is ShopLoaded) {
      final currentState = state as ShopLoaded;
      final filtered = currentState.allProducts
          .where((p) => p.categoryId == event.category.id)
          .toList();

      emit(currentState.copyWith(
        selectedCategory: event.category,
        selectedSubCategory: 'All',
        displayedProducts: filtered,
        searchQuery: '',
      ));
    }
  }

  void _onSubCategorySelected(
    ShopSubCategorySelected event,
    Emitter<ShopState> emit,
  ) {
    if (state is ShopLoaded) {
      final currentState = state as ShopLoaded;
      final category = currentState.selectedCategory;

      var filtered = currentState.allProducts;
      if (category != null) {
        filtered = filtered.where((p) => p.categoryId == category.id).toList();
      }

      if (event.subCategory != 'All') {
        filtered = filtered.where((p) => p.subCategory == event.subCategory).toList();
      }

      emit(currentState.copyWith(
        selectedSubCategory: event.subCategory,
        displayedProducts: filtered,
      ));
    }
  }

  void _onSearchRequested(
    ShopSearchRequested event,
    Emitter<ShopState> emit,
  ) {
    if (state is ShopLoaded) {
      final currentState = state as ShopLoaded;
      final q = event.query.toLowerCase().trim();

      if (q.isEmpty) {
        final category = currentState.selectedCategory;
        final list = category != null
            ? currentState.allProducts.where((p) => p.categoryId == category.id).toList()
            : currentState.allProducts;
        emit(currentState.copyWith(
          displayedProducts: list,
          searchQuery: '',
        ));
      } else {
        final filtered = currentState.allProducts.where((p) {
          return p.name.toLowerCase().contains(q) ||
              p.categoryName.toLowerCase().contains(q) ||
              p.subCategory.toLowerCase().contains(q) ||
              p.description.toLowerCase().contains(q);
        }).toList();

        emit(currentState.copyWith(
          displayedProducts: filtered,
          searchQuery: event.query,
        ));
      }
    }
  }
}
