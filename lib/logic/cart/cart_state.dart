import 'package:equatable/equatable.dart';
import '../../data/models/cart_item_model.dart';

class CartState extends Equatable {
  final List<CartItemModel> items;
  final String? couponCode;
  final double discountAmount;

  const CartState({
    required this.items,
    this.couponCode = 'LUXE150',
    this.discountAmount = 150.0,
  });

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subTotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get deliveryCharges => (subTotal > 500 || subTotal == 0) ? 0.0 : 49.0;

  double get total {
    if (items.isEmpty) return 0.0;
    final discounted = subTotal - discountAmount;
    final finalPrice = (discounted < 0 ? 0.0 : discounted) + deliveryCharges;
    return finalPrice;
  }

  CartState copyWith({
    List<CartItemModel>? items,
    String? couponCode,
    double? discountAmount,
  }) {
    return CartState(
      items: items ?? this.items,
      couponCode: couponCode ?? this.couponCode,
      discountAmount: discountAmount ?? this.discountAmount,
    );
  }

  @override
  List<Object?> get props => [items, couponCode, discountAmount];
}
