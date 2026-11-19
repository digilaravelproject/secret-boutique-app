import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';

class WishlistState extends Equatable {
  final List<ProductModel> items;

  const WishlistState({required this.items});

  bool contains(String productId) {
    return items.any((p) => p.id == productId);
  }

  @override
  List<Object?> get props => [items];
}
