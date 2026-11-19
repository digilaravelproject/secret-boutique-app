import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/repositories/shop_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(_initialCartState()) {
    on<CartItemAdded>(_onItemAdded);
    on<CartItemQuantityChanged>(_onQuantityChanged);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartCouponApplied>(_onCouponApplied);
    on<CartCleared>(_onCartCleared);
  }

  static CartState _initialCartState() {
    // Initial cart items matching the reference screenshot
    final p1 = ShopRepository.products[0]; // Trendy T-Shirt Bra
    final p2 = ShopRepository.products[1]; // Push Up Bra

    return CartState(
      items: [
        CartItemModel(
          id: 'cart_1',
          product: p1,
          selectedSize: '34',
          selectedColor: 'Maroon',
          quantity: 1,
        ),
        CartItemModel(
          id: 'cart_2',
          product: p2,
          selectedSize: '36',
          selectedColor: 'Pink',
          quantity: 1,
        ),
      ],
      couponCode: 'LUXE150',
      discountAmount: 150.0,
    );
  }

  void _onItemAdded(CartItemAdded event, Emitter<CartState> emit) {
    final existingIndex = state.items.indexWhere(
      (item) =>
          item.product.id == event.product.id &&
          item.selectedSize == event.selectedSize &&
          item.selectedColor == event.selectedColor,
    );

    if (existingIndex >= 0) {
      final updatedList = List<CartItemModel>.from(state.items);
      final currentItem = updatedList[existingIndex];
      updatedList[existingIndex] = currentItem.copyWith(
        quantity: currentItem.quantity + event.quantity,
      );
      emit(state.copyWith(items: updatedList));
    } else {
      final newItem = CartItemModel(
        id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
        product: event.product,
        selectedSize: event.selectedSize,
        selectedColor: event.selectedColor,
        quantity: event.quantity,
      );
      emit(state.copyWith(items: [...state.items, newItem]));
    }
  }

  void _onQuantityChanged(CartItemQuantityChanged event, Emitter<CartState> emit) {
    final updatedList = <CartItemModel>[];

    for (final item in state.items) {
      if (item.id == event.cartItemId) {
        final newQty = item.quantity + event.delta;
        if (newQty > 0) {
          updatedList.add(item.copyWith(quantity: newQty));
        }
      } else {
        updatedList.add(item);
      }
    }

    emit(state.copyWith(items: updatedList));
  }

  void _onItemRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    final updatedList = state.items.where((item) => item.id != event.cartItemId).toList();
    emit(state.copyWith(items: updatedList));
  }

  void _onCouponApplied(CartCouponApplied event, Emitter<CartState> emit) {
    if (event.couponCode.toUpperCase() == 'LUXE150' ||
        event.couponCode.toUpperCase() == 'SECRET150' ||
        event.couponCode.toUpperCase() == 'FLAT50') {
      emit(state.copyWith(
        couponCode: event.couponCode.toUpperCase(),
        discountAmount: 150.0,
      ));
    } else {
      emit(state.copyWith(
        couponCode: null,
        discountAmount: 0.0,
      ));
    }
  }

  void _onCartCleared(CartCleared event, Emitter<CartState> emit) {
    emit(const CartState(items: [], couponCode: null, discountAmount: 0.0));
  }
}
