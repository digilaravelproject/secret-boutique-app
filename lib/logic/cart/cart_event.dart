import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartItemAdded extends CartEvent {
  final ProductModel product;
  final String selectedSize;
  final String selectedColor;
  final int quantity;

  const CartItemAdded({
    required this.product,
    required this.selectedSize,
    required this.selectedColor,
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [product, selectedSize, selectedColor, quantity];
}

class CartItemQuantityChanged extends CartEvent {
  final String cartItemId;
  final int delta; // +1 or -1

  const CartItemQuantityChanged({
    required this.cartItemId,
    required this.delta,
  });

  @override
  List<Object?> get props => [cartItemId, delta];
}

class CartItemRemoved extends CartEvent {
  final String cartItemId;

  const CartItemRemoved(this.cartItemId);

  @override
  List<Object?> get props => [cartItemId];
}

class CartCouponApplied extends CartEvent {
  final String couponCode;

  const CartCouponApplied(this.couponCode);

  @override
  List<Object?> get props => [couponCode];
}

class CartCleared extends CartEvent {}
