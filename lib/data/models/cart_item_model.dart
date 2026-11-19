import 'package:equatable/equatable.dart';
import 'product_model.dart';

class CartItemModel extends Equatable {
  final String id;
  final ProductModel product;
  final String selectedSize;
  final String selectedColor;
  final int quantity;

  const CartItemModel({
    required this.id,
    required this.product,
    required this.selectedSize,
    required this.selectedColor,
    required this.quantity,
  });

  CartItemModel copyWith({
    String? id,
    ProductModel? product,
    String? selectedSize,
    String? selectedColor,
    int? quantity,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => product.price * quantity;

  @override
  List<Object?> get props => [id, product, selectedSize, selectedColor, quantity];
}
