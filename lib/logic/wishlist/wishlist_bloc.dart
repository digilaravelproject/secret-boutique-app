import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_secret_boutique/data/repositories/shop_repository.dart';
import 'package:the_secret_boutique/logic/wishlist/wishlist_event.dart';
import 'package:the_secret_boutique/logic/wishlist/wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc() : super(_initialWishlistState()) {
    on<WishlistToggled>(_onWishlistToggled);
    on<WishlistRemoved>(_onWishlistRemoved);
    on<WishlistCleared>(_onWishlistCleared);
  }

  static WishlistState _initialWishlistState() {
    return WishlistState(
      items: [
        ShopRepository.products[0], // Trendy T-Shirt Bra
        ShopRepository.products[1], // Push Up Bra
        ShopRepository.products[2], // Non Padded Bra
        ShopRepository.products[4], // Lingerie Set
      ],
    );
  }

  void _onWishlistToggled(WishlistToggled event, Emitter<WishlistState> emit) {
    final exists = state.items.any((p) => p.id == event.product.id);
    if (exists) {
      final updated = state.items.where((p) => p.id != event.product.id).toList();
      emit(WishlistState(items: updated));
    } else {
      emit(WishlistState(items: [...state.items, event.product]));
    }
  }

  void _onWishlistRemoved(WishlistRemoved event, Emitter<WishlistState> emit) {
    final updated = state.items.where((p) => p.id != event.productId).toList();
    emit(WishlistState(items: updated));
  }

  void _onWishlistCleared(WishlistCleared event, Emitter<WishlistState> emit) {
    emit(const WishlistState(items: []));
  }
}
