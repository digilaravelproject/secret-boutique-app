import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_secret_boutique/core/constants/app_colors.dart';
import 'package:the_secret_boutique/core/constants/app_strings.dart';
import 'package:the_secret_boutique/core/utils/currency_formatter.dart';
import 'package:the_secret_boutique/core/widgets/custom_cached_image.dart';
import 'package:the_secret_boutique/data/models/product_model.dart';
import 'package:the_secret_boutique/data/repositories/shop_repository.dart';
import 'package:the_secret_boutique/logic/cart/cart_bloc.dart';
import 'package:the_secret_boutique/logic/cart/cart_event.dart';
import 'package:the_secret_boutique/logic/wishlist/wishlist_bloc.dart';
import 'package:the_secret_boutique/logic/wishlist/wishlist_event.dart';
import 'package:the_secret_boutique/logic/wishlist/wishlist_state.dart';
import 'package:the_secret_boutique/presentation/screens/checkout/checkout_screen.dart';
import 'package:the_secret_boutique/presentation/widgets/product_card.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _imagePageController = PageController();
  late String _selectedSize;
  late String _selectedColor;
  int _quantity = 1;
  int _currentImageIndex = 0;
  final TextEditingController _pincodeController = TextEditingController(text: '226010');
  String _deliveryEstimate = 'Delivery in 2-3 Days • Express Available';
  bool _pincodeChecked = true;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.product.sizes.isNotEmpty ? widget.product.sizes.first : '32';
    _selectedColor =
        widget.product.colors.isNotEmpty ? widget.product.colors.first.name : 'Standard';
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _openFullScreenViewer(List<String> images, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => _FullScreenImageViewer(
          images: images,
          initialIndex: initialIndex,
          productName: widget.product.name,
        ),
      ),
    );
  }

  void _showSizeGuide() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Size & Fit Guide',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'How to measure your band and bust:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Underbust (Band): Measure snugly right under your bust.\n'
              '2. Overbust (Cup): Measure around the fullest part of your chest.\n'
              '3. Size 32 / S = 28-30 inches underbust.\n'
              '4. Size 34 / M = 30-32 inches underbust.\n'
              '5. Size 36 / L = 32-34 inches underbust.\n'
              '6. Size 38 / XL = 34-36 inches underbust.\n'
              '7. Size 40 / XXL = 36-38 inches underbust.',
              style: TextStyle(fontSize: 12.5, height: 1.6, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.blushPink.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle_outline, color: AppColors.primary, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'All boutique items feature stretchable elastane for an adaptive, flattering fit.',
                      style: TextStyle(fontSize: 11.5, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailOfferItem(
    BuildContext context, {
    required String title,
    required String desc,
    required String code,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.sell_outlined,
            size: 13,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: code));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Text('Coupon "$code" copied!'),
                  ],
                ),
                backgroundColor: AppColors.primary,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.primary, width: 0.8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  code,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 3),
                const Icon(
                  Icons.copy_rounded,
                  size: 10,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final allImages = product.images.isNotEmpty ? product.images : [product.imageUrl];

    // Related products (from same category or best sellers, excluding current)
    final relatedProducts = ShopRepository.products
        .where((p) => p.categoryId == product.categoryId && p.id != product.id)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. FULL VIEW IMAGE GALLERY APP BAR
          SliverAppBar(
            expandedHeight: 460, // Full view immersive height
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.88),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 17, color: AppColors.primary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            actions: [
              BlocBuilder<WishlistBloc, WishlistState>(
                builder: (context, state) {
                  final isWishlisted = state.contains(product.id);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withValues(alpha: 0.88),
                      child: IconButton(
                        icon: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          size: 19,
                          color: isWishlisted ? AppColors.accent : AppColors.primary,
                        ),
                        onPressed: () {
                          context.read<WishlistBloc>().add(WishlistToggled(product));
                        },
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.88),
                  child: IconButton(
                    icon: const Icon(Icons.share_outlined, size: 19, color: AppColors.primary),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sharing boutique product link...')),
                      );
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Full View Swipeable PageView
                  GestureDetector(
                    onTap: () => _openFullScreenViewer(allImages, _currentImageIndex),
                    child: PageView.builder(
                      controller: _imagePageController,
                      itemCount: allImages.length,
                      onPageChanged: (idx) => setState(() => _currentImageIndex = idx),
                      itemBuilder: (context, index) {
                        return CustomCachedImage(
                          imageUrl: allImages[index],
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        );
                      },
                    ),
                  ),

                  // Top Discount Badge
                  if (product.discountPercent > 0)
                    Positioned(
                      top: 100,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF861144), Color(0xFFD81B60)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '${product.discountPercent}% OFF',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),

                  // Bottom Gradient Vignette for clear counter overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Fullscreen Lightbox Hint Button (Bottom Left)
                  Positioned(
                    bottom: 14,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => _openFullScreenViewer(allImages, _currentImageIndex),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white24, width: 0.8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.fullscreen_rounded, size: 15, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'Tap to Zoom',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Image Counter Pill (Bottom Right)
                  Positioned(
                    bottom: 14,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white24, width: 0.8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.photo_library_outlined, size: 12, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            '${_currentImageIndex + 1} / ${allImages.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Carousel Progress Dots (Centered)
                  if (allImages.length > 1)
                    Positioned(
                      bottom: 18,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(allImages.length, (idx) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _currentImageIndex == idx ? 16 : 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: _currentImageIndex == idx
                                  ? const Color(0xFFD4AF37) // Gold accent
                                  : Colors.white70,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // 2. PRODUCT DETAILS BODY
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Visual Thumbnail Strip
                  if (allImages.length > 1) ...[
                    SizedBox(
                      height: 56,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: allImages.length,
                        itemBuilder: (context, idx) {
                          final isSelected = _currentImageIndex == idx;
                          return GestureDetector(
                            onTap: () {
                              _imagePageController.animateToPage(
                                idx,
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeInOutCubic,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 50,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : Colors.grey.shade300,
                                  width: isSelected ? 2.2 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(alpha: 0.25),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CustomCachedImage(
                                  imageUrl: allImages[idx],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Brand Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.blushPink,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'TSB BOUTIQUE EXCLUSIVE',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Product Title
                  Text(
                    product.name,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Rating & Reviews Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${product.rating}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 3),
                            const Icon(Icons.star_rounded, size: 13, color: Colors.white),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${product.reviewCount} Ratings • Verified Intimate Buyers)',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price & Discount Pill
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        CurrencyFormatter.format(product.price),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (product.originalPrice > product.price) ...[
                        const SizedBox(width: 8),
                        Text(
                          CurrencyFormatter.format(product.originalPrice),
                          style: const TextStyle(
                            fontSize: 15,
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF861144), Color(0xFFD81B60)],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${product.discountPercent}% OFF',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Save ₹${(product.originalPrice - product.price).toInt()}',
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Special Offers & Coupons Section
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.blushPink.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.local_offer_rounded, size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              'Special Offers & Coupons',
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '3 Offers Available',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildDetailOfferItem(
                          context,
                          title: 'Buy 2 Get 1 FREE',
                          desc: 'Add 3 items to cart, pay for 2 only',
                          code: 'B2G1FREE',
                        ),
                        const Divider(height: 16, color: AppColors.divider),
                        _buildDetailOfferItem(
                          context,
                          title: 'Flat ₹200 OFF on Intimates',
                          desc: 'Applicable on min order value ₹999',
                          code: 'BRA200',
                        ),
                        const Divider(height: 16, color: AppColors.divider),
                        _buildDetailOfferItem(
                          context,
                          title: 'Extra 10% Instant Prepaid',
                          desc: 'On all prepaid orders with UPI / Cards',
                          code: 'SECRET10',
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 32, color: AppColors.divider),

                  // Size Selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        AppStrings.selectSize,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: _showSizeGuide,
                        child: const Text(
                          AppStrings.sizeGuide,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 10,
                    children: product.sizes.map((size) {
                      final isSelected = _selectedSize == size;
                      return ChoiceChip(
                        label: Text(
                          size,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.blushPink.withValues(alpha: 0.5),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.border,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedSize = size);
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 22),

                  // Color Selection
                  const Text(
                    AppStrings.selectColor,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 12,
                    children: product.colors.map((colorOpt) {
                      final isSelected = _selectedColor == colorOpt.name;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedColor = colorOpt.name),
                        child: Column(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(colorOpt.colorValue),
                                border: Border.all(
                                  color: isSelected ? AppColors.accent : Colors.grey.shade300,
                                  width: isSelected ? 2.8 : 1.5,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.accent.withValues(alpha: 0.3),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              colorOpt.name,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 22),

                  // Quantity Selector
                  Row(
                    children: [
                      const Text(
                        'Quantity:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 16),
                              onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                            ),
                            Text(
                              '$_quantity',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 16),
                              onPressed: () => setState(() => _quantity++),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 36, color: AppColors.divider),

                  // Delivery & Pincode Checker
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.local_shipping_outlined, size: 18, color: AppColors.primary),
                            SizedBox(width: 8),
                            Text(
                              'Delivery & Services',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 42,
                                decoration: BoxDecoration(
                                  color: AppColors.scaffoldBackground,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: TextField(
                                  controller: _pincodeController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Delivery Pincode',
                                    hintStyle: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              height: 42,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_pincodeController.text.trim().isNotEmpty) {
                                    setState(() {
                                      _pincodeChecked = true;
                                      _deliveryEstimate =
                                          'Delivering to ${_pincodeController.text} in 2-3 Days';
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Pincode verified! Fast delivery available.'),
                                        backgroundColor: Color(0xFF2E7D32),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Check',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_pincodeChecked) ...[
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.check_circle, size: 14, color: Color(0xFF2E7D32)),
                              const SizedBox(width: 6),
                              Text(
                                _deliveryEstimate,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 8),
                        const Row(
                          children: [
                            Icon(Icons.shield_outlined, size: 14, color: AppColors.primary),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '100% Discreet Unbranded Packaging Guaranteed (No item details on label)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Product Highlights & Specifications Table
                  const Text(
                    'Product Specifications',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.blushPink.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
                    ),
                    child: Column(
                      children: [
                        _buildSpecRow('Category', product.categoryName),
                        const Divider(height: 1, color: AppColors.divider),
                        _buildSpecRow('Sub-Category', product.subCategory),
                        const Divider(height: 1, color: AppColors.divider),
                        _buildSpecRow('Fabric', 'French Eyelash Lace, Mulberry Silk & Elastane'),
                        const Divider(height: 1, color: AppColors.divider),
                        _buildSpecRow('Transparency', 'Semi-Sheer Luxury Boudoir'),
                        const Divider(height: 1, color: AppColors.divider),
                        _buildSpecRow('Wash Care', 'Gentle Cold Hand Wash • Do Not Iron'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'About This Piece',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.55,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const Divider(height: 36, color: AppColors.divider),

                  // Customer Reviews & Ratings Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Customer Reviews',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${product.rating} ★ Excellent',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Verified Review Card 1
                  _buildReviewCard(
                    author: 'Pooja S.',
                    date: 'Verified Buyer • 2 days ago',
                    rating: 5,
                    comment:
                        'Absolutely breathtaking! The lace quality is super soft against skin, no itchiness at all. And the discreet unbranded box was very reassuring.',
                  ),
                  const SizedBox(height: 10),
                  // Verified Review Card 2
                  _buildReviewCard(
                    author: 'Neha K.',
                    date: 'Verified Buyer • 1 week ago',
                    rating: 5,
                    comment:
                        'Stunning fit and premium boutique finish! Looks even more glamorous in person than in photos. Highly recommend!',
                  ),

                  const Divider(height: 36, color: AppColors.divider),

                  // 3. RELATED PRODUCTS / COMPLETE THE LOOK SECTION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'You May Also Like',
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Text(
                            'Pair with matching intimates & complete the look',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const Icon(Icons.auto_awesome, color: AppColors.primary, size: 18),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Related Products Horizontal Scroll
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: relatedProducts.length,
                      itemBuilder: (context, idx) {
                        final rel = relatedProducts[idx];
                        return Container(
                          width: 145,
                          margin: const EdgeInsets.only(right: 12),
                          child: ProductCard(
                            product: rel,
                            isCompact: true,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Fixed Bottom Action Bar (Add to Cart & Buy Now)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Add to Cart
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<CartBloc>().add(
                            CartItemAdded(
                              product: product,
                              selectedSize: _selectedSize,
                              selectedColor: _selectedColor,
                              quantity: _quantity,
                            ),
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added $_quantity x ${product.name} to Cart'),
                          backgroundColor: AppColors.primary,
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 18),
                    label: const Text(
                      AppStrings.addToCart,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Buy Now
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<CartBloc>().add(
                            CartItemAdded(
                              product: product,
                              selectedSize: _selectedSize,
                              selectedColor: _selectedColor,
                              quantity: _quantity,
                            ),
                          );
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      AppStrings.buyNow,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required String author,
    required String date,
    required int rating,
    required String comment,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                author,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: List.generate(
                  rating,
                  (_) => const Icon(Icons.star_rounded, size: 14, color: AppColors.ratingStar),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            date,
            style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted),
          ),
          const SizedBox(height: 6),
          Text(
            comment,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }
}

/// Fullscreen Interactive Lightbox Modal with Pinch-To-Zoom
class _FullScreenImageViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String productName;

  const _FullScreenImageViewer({
    required this.images,
    required this.initialIndex,
    required this.productName,
  });

  @override
  State<_FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<_FullScreenImageViewer> {
  late PageController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Pinch to Zoom Interactive PageView
          PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (idx) => setState(() => _currentIndex = idx),
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 0.8,
                maxScale: 4.0,
                child: Center(
                  child: CustomCachedImage(
                    imageUrl: widget.images[index],
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),

          // Top Header Bar with Close Button & Counter
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${widget.images.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
