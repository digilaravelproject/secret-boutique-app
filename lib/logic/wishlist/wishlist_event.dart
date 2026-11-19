import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

class WishlistToggled extends WishlistEvent {
  final ProductModel product;

  const WishlistToggled(this.product);

  @override
  List<Object?> get props => [product];
}

class WishlistRemoved extends WishlistEvent {
  final String productId;

  const WishlistRemoved(this.productId);

  @override
  List<Object?> get props => [productId];
}

class WishlistCleared extends WishlistEvent {}
