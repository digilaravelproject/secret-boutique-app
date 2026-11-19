import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_secret_boutique/core/constants/app_colors.dart';
import 'package:the_secret_boutique/core/widgets/badge_icon.dart';
import 'package:the_secret_boutique/data/models/category_model.dart';
import 'package:the_secret_boutique/logic/cart/cart_bloc.dart';
import 'package:the_secret_boutique/logic/cart/cart_state.dart';
import 'package:the_secret_boutique/logic/shop/shop_bloc.dart';
import 'package:the_secret_boutique/logic/shop/shop_event.dart';
import 'package:the_secret_boutique/logic/shop/shop_state.dart';
import 'package:the_secret_boutique/presentation/screens/cart/cart_screen.dart';
import 'package:the_secret_boutique/presentation/widgets/product_card.dart';

class CategoryProductsScreen extends StatefulWidget {
  final CategoryModel category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  late String _selectedSub;

  @override
  void initState() {
    super.initState();
    _selectedSub = 'All';
    context.read<ShopBloc>().add(ShopCategorySelected(widget.category));
  }

  Widget _buildOfferCard(
    BuildContext context, {
    required String badge,
    required String title,
    required String subtitle,
    required String code,
    required List<Color> gradientColors,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: code));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text('Coupon code "$code" copied!'),
              ],
            ),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        width: 250,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              code,
                              style: TextStyle(
                                color: gradientColors.first,
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(
                              Icons.copy_rounded,
                              size: 9.5,
                              color: gradientColors.first,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subCategories = widget.category.subCategories.isNotEmpty
        ? widget.category.subCategories
        : ['All'];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.category.name,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary, size: 22),
            onPressed: () {},
          ),
          BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              return BadgeIcon(
                icon: Icons.shopping_bag_outlined,
                iconColor: AppColors.textPrimary,
                count: cartState.totalItemCount,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Subcategory Filter Pills
          Container(
            height: 48,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: subCategories.length,
              itemBuilder: (context, index) {
                final sub = subCategories[index];
                final isSelected = _selectedSub == sub;

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedSub = sub);
                      context.read<ShopBloc>().add(ShopSubCategorySelected(sub));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.blushPink.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.divider,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          sub,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Exclusive Offers Banner Strip
          Container(
            height: 64,
            margin: const EdgeInsets.only(top: 8, bottom: 4),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildOfferCard(
                  context,
                  badge: 'BUY 2 GET 1',
                  title: 'Buy 2 Get 1 FREE',
                  subtitle: 'Auto applied at checkout',
                  code: 'B2G1FREE',
                  gradientColors: const [Color(0xFF861144), Color(0xFF5D082C)],
                  icon: Icons.card_giftcard_rounded,
                ),
                const SizedBox(width: 10),
                _buildOfferCard(
                  context,
                  badge: 'FLAT ₹200 OFF',
                  title: 'Flat ₹200 OFF on 2+ Bras',
                  subtitle: 'Use code on min ₹999',
                  code: 'BRA200',
                  gradientColors: const [Color(0xFF6B0E33), Color(0xFF8C1D4A)],
                  icon: Icons.local_offer_rounded,
                ),
                const SizedBox(width: 10),
                _buildOfferCard(
                  context,
                  badge: 'EXTRA 15% OFF',
                  title: 'Extra 15% OFF Prepaid',
                  subtitle: 'On UPI / Card payments',
                  code: 'SECRET15',
                  gradientColors: const [Color(0xFF4A0520), Color(0xFF6E0D36)],
                  icon: Icons.flash_on_rounded,
                ),
                const SizedBox(width: 10),
                _buildOfferCard(
                  context,
                  badge: 'FREE GIFT',
                  title: 'Free Satin Pouch + Shipping',
                  subtitle: 'On every boutique order',
                  code: 'FREESHIP',
                  gradientColors: const [Color(0xFF7A1341), Color(0xFF9E2057)],
                  icon: Icons.local_shipping_outlined,
                ),
              ],
            ),
          ),

          // Product Grid
          Expanded(
            child: BlocBuilder<ShopBloc, ShopState>(
              builder: (context, state) {
                if (state is ShopLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (state is ShopLoaded) {
                  final products = state.displayedProducts;

                  if (products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.textMuted.withValues(alpha: 0.5)),
                          const SizedBox(height: 12),
                          const Text(
                            'No items found in this section',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: products[index]);
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
