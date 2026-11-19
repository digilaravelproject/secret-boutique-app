import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_secret_boutique/core/constants/app_colors.dart';
import 'package:the_secret_boutique/core/utils/currency_formatter.dart';
import 'package:the_secret_boutique/core/widgets/custom_cached_image.dart';
import 'package:the_secret_boutique/data/models/product_model.dart';
import 'package:the_secret_boutique/logic/cart/cart_bloc.dart';
import 'package:the_secret_boutique/logic/cart/cart_event.dart';
import 'package:the_secret_boutique/logic/wishlist/wishlist_bloc.dart';
import 'package:the_secret_boutique/logic/wishlist/wishlist_event.dart';
import 'package:the_secret_boutique/logic/wishlist/wishlist_state.dart';
import 'package:the_secret_boutique/presentation/screens/product_detail/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool isCompact;
  final bool showAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    this.isCompact = false,
    this.showAddToCart = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isBounded =
              constraints.maxHeight != double.infinity && constraints.maxHeight > 0;

          final Widget imageWidget = Stack(
            fit: isBounded ? StackFit.expand : StackFit.loose,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                child: CustomCachedImage(
                  imageUrl: product.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: isBounded ? double.infinity : (isCompact ? 100.0 : 120.0),
                ),
              ),
              // Boutique "BUY ANY 2 GET 1 FREE" Badge (Matching Screenshots)
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5.5, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6A0D32),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: const Text(
                    'BUY ANY 2 GET 1 FREE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 7.2,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
              // Wishlist Button
              Positioned(
                top: 5,
                right: 5,
                child: BlocBuilder<WishlistBloc, WishlistState>(
                  builder: (context, state) {
                    final isWishlisted = state.contains(product.id);
                    return GestureDetector(
                      onTap: () {
                        context.read<WishlistBloc>().add(WishlistToggled(product));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4.5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          size: 13,
                          color: isWishlisted ? AppColors.accent : AppColors.textSecondary,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );

          final Widget detailsWidget = Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      CurrencyFormatter.format(product.price),
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (product.originalPrice > product.price) ...[
                      const SizedBox(width: 4),
                      Text(
                        CurrencyFormatter.format(product.originalPrice),
                        style: const TextStyle(
                          fontSize: 10,
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                // Star ratings matching screenshot
                Row(
                  children: [
                    ...List.generate(
                      5,
                      (idx) => Icon(
                        idx < product.rating.floor() ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 11,
                        color: const Color(0xFFC59B27),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '(${product.reviewCount > 1000 ? "${(product.reviewCount/1000).toStringAsFixed(1)}k" : product.reviewCount})',
                      style: const TextStyle(
                        fontSize: 8.5,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                if (showAddToCart) ...[
                  const SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    height: 27,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CartBloc>().add(
                              CartItemAdded(
                                product: product,
                                selectedSize: product.sizes.first,
                                selectedColor: product.colors.isNotEmpty
                                    ? product.colors.first.name
                                    : 'Standard',
                              ),
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added ${product.name} to cart'),
                            backgroundColor: AppColors.primary,
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag_outlined, size: 11, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Add to Cart',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.divider.withValues(alpha: 0.7), width: 0.8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isBounded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: imageWidget),
                      detailsWidget,
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      imageWidget,
                      detailsWidget,
                    ],
                  ),
          );
        },
      ),
    );
  }
}
