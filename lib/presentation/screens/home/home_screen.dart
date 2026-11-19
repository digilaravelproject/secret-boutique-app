import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_secret_boutique/core/constants/app_colors.dart';
import 'package:the_secret_boutique/core/constants/app_images.dart';
import 'package:the_secret_boutique/core/constants/app_strings.dart';
import 'package:the_secret_boutique/core/widgets/custom_cached_image.dart';
import 'package:the_secret_boutique/data/models/category_model.dart';
import 'package:the_secret_boutique/data/models/product_model.dart';
import 'package:the_secret_boutique/logic/cart/cart_bloc.dart';
import 'package:the_secret_boutique/logic/cart/cart_state.dart';
import 'package:the_secret_boutique/logic/shop/shop_bloc.dart';
import 'package:the_secret_boutique/logic/shop/shop_event.dart';
import 'package:the_secret_boutique/logic/shop/shop_state.dart';
import 'package:the_secret_boutique/presentation/screens/category/category_products_screen.dart';
import 'package:the_secret_boutique/presentation/widgets/banner_carousel.dart';
import 'package:the_secret_boutique/presentation/widgets/category_item.dart';
import 'package:the_secret_boutique/presentation/widgets/product_card.dart';
import 'package:the_secret_boutique/presentation/widgets/section_header.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onTabChange;

  const HomeScreen({super.key, required this.onTabChange});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String? _filterCategory;
  double _filterMaxPrice = 3000;
  String _filterSort = 'Popularity';

  // Flash sale countdown timer state
  late Timer _countdownTimer;
  Duration _timeLeft = const Duration(hours: 4, minutes: 28, seconds: 45);

  @override
  void initState() {
    super.initState();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        setState(() {
          _timeLeft = _timeLeft - const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterModal(BuildContext context, List<CategoryModel> categories) {
    String tempCategory = _filterCategory ?? 'All';
    double tempPrice = _filterMaxPrice;
    String tempSort = _filterSort;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Boutique Collection',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textSecondary),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 10),

                  // Category Pills
                  const Text(
                    'Select Category',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFilterChip('All', tempCategory == 'All', () {
                        setModalState(() => tempCategory = 'All');
                      }),
                      ...categories.map((c) {
                        final isSelected = tempCategory == c.id;
                        return _buildFilterChip(c.name, isSelected, () {
                          setModalState(() => tempCategory = c.id);
                        });
                      }),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Price Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Max Price Range',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Up to ₹${tempPrice.toInt()}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: tempPrice,
                    min: 300,
                    max: 4000,
                    divisions: 37,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.blushPink,
                    onChanged: (val) {
                      setModalState(() => tempPrice = val);
                    },
                  ),

                  const SizedBox(height: 15),

                  // Sort by Options
                  const Text(
                    'Sort Products By',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildFilterChip('Popularity', tempSort == 'Popularity', () {
                        setModalState(() => tempSort = 'Popularity');
                      }),
                      _buildFilterChip('Price: Low to High', tempSort == 'Price: Low to High', () {
                        setModalState(() => tempSort = 'Price: Low to High');
                      }),
                      _buildFilterChip('Price: High to Low', tempSort == 'Price: High to Low', () {
                        setModalState(() => tempSort = 'Price: High to Low');
                      }),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _filterCategory = null;
                              _filterMaxPrice = 3000;
                              _filterSort = 'Popularity';
                            });
                            Navigator.pop(ctx);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Reset', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _filterCategory = tempCategory == 'All' ? null : tempCategory;
                              _filterMaxPrice = tempPrice;
                              _filterSort = tempSort;
                            });
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Apply Filter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.chipBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hours = _timeLeft.inHours.toString().padLeft(2, '0');
    final minutes = (_timeLeft.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_timeLeft.inSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: CustomScrollView(
        slivers: [
          // 1. Top Wine Luxury Header & Search Bar (Restored Original AppBar)
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 52, 16, 20),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x333F041D),
                    blurRadius: 18,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // App Bar Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white, size: 22),
                          onPressed: () {
                            widget.onTabChange(1);
                          },
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            AppStrings.appName,
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                          Text(
                            AppStrings.appTagline,
                            style: GoogleFonts.alexBrush(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.9),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.notifications_none_outlined, color: Colors.white, size: 22),
                              onPressed: () {},
                            ),
                            Positioned(
                              top: 10,
                              right: 12,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.accent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Luxury Search Bar
                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.9),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 16,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Left Wine Search Icon Circle
                        Container(
                          margin: const EdgeInsets.all(6),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.search_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),

                        // Search Input
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) {
                              context.read<ShopBloc>().add(ShopSearchRequested(val));
                            },
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search bras, sleepwear, sets...',
                              hintStyle: GoogleFonts.montserrat(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                            ),
                          ),
                        ),

                        if (_searchController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
                            onPressed: () {
                              _searchController.clear();
                              context.read<ShopBloc>().add(const ShopSearchRequested(''));
                            },
                          ),

                        // Trailing Filter Pill Button
                        BlocBuilder<ShopBloc, ShopState>(
                          builder: (context, state) {
                            final categories = (state is ShopLoaded) ? state.categories : <CategoryModel>[];
                            return GestureDetector(
                              onTap: () => _showFilterModal(context, categories),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                decoration: BoxDecoration(
                                  color: AppColors.blushPink,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.border.withValues(alpha: 0.7),
                                    width: 0.8,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.tune_rounded,
                                      size: 14,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Filter',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Main Content (Search Results OR Normal Home Flow)
          SliverToBoxAdapter(
            child: BlocBuilder<ShopBloc, ShopState>(
              builder: (context, state) {
                if (state is ShopLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  );
                }

                if (state is ShopLoaded) {
                  // If actively searching, display live search results view!
                  if (state.searchQuery.isNotEmpty) {
                    return _buildSearchResultsView(context, state);
                  }

                  // Normal Home Screen Content
                  return _buildNormalHomeContent(context, state, hours, minutes, seconds);
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  // Live Search Results View
  Widget _buildSearchResultsView(BuildContext context, ShopLoaded state) {
    List<ProductModel> results = List.from(state.displayedProducts);

    // Apply active filters if any
    if (_filterCategory != null) {
      results = results.where((p) => p.categoryId == _filterCategory).toList();
    }
    results = results.where((p) => p.price <= _filterMaxPrice).toList();

    if (_filterSort == 'Price: Low to High') {
      results.sort((a, b) => a.price.compareTo(b.price));
    } else if (_filterSort == 'Price: High to Low') {
      results.sort((a, b) => b.price.compareTo(a.price));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with count & clear
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                    children: [
                      const TextSpan(text: 'Results for '),
                      TextSpan(
                        text: '"${state.searchQuery}" ',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      TextSpan(
                        text: '(${results.length} items)',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 11.5),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  _searchController.clear();
                  context.read<ShopBloc>().add(const ShopSearchRequested(''));
                },
                icon: const Icon(Icons.close, size: 14, color: AppColors.primary),
                label: const Text('Clear', style: TextStyle(fontSize: 12, color: AppColors.primary)),
              ),
            ],
          ),

          const SizedBox(height: 8),

          if (results.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  const Icon(Icons.search_off_rounded, size: 54, color: AppColors.textMuted),
                  const SizedBox(height: 12),
                  Text(
                    'No matching boutique items found',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Try searching with popular tags below:',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: ['Bras', 'Panties', 'Nightwear', 'One Piece', 'Babydoll', 'Lace'].map((tag) {
                      return ActionChip(
                        label: Text(tag, style: const TextStyle(fontSize: 11.5, color: AppColors.primary)),
                        backgroundColor: AppColors.blushPink,
                        onPressed: () {
                          _searchController.text = tag;
                          context.read<ShopBloc>().add(ShopSearchRequested(tag));
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: results.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.62,
                crossAxisSpacing: 12,
                mainAxisSpacing: 14,
              ),
              itemBuilder: (context, index) {
                return ProductCard(product: results[index]);
              },
            ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // Normal Home Content Flow
  Widget _buildNormalHomeContent(
    BuildContext context,
    ShopLoaded state,
    String hours,
    String minutes,
    String seconds,
  ) {
    final categories = state.categories;
    final bestSellers = state.bestSellers;
    final nightwearProducts = state.allProducts.where((p) => p.categoryId == 'cat_nightwear').toList();
    final hosieryProducts = state.allProducts.where((p) => p.categoryId == 'cat_shapewear').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),

        // 1. High-Res Auto-sliding Hero Banners (Matching User Screenshots)
        BannerCarousel(
          onBannerTap: () {
            if (categories.isNotEmpty) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CategoryProductsScreen(category: categories.first),
                ),
              );
            }
          },
        ),

        const SizedBox(height: 12),

        // 2. Dual Boutique Teaser Cards (Matching Screenshot 10)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildBoutiqueTeaserCard(
                  title: 'Elegance Sheer\nNightwear',
                  tag: 'BUY 2 GET 1',
                  imageUrl: AppImages.nightwearRedBabydoll,
                  onTap: () {
                    final cat = categories.firstWhere(
                      (c) => c.id == 'cat_nightwear',
                      orElse: () => categories.first,
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CategoryProductsScreen(category: cat),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBoutiqueTeaserCard(
                  title: 'Lace & Hollow\nBodystockings',
                  tag: 'HOT NEW DROP',
                  imageUrl: AppImages.hosieryBlackButterfly,
                  onTap: () {
                    final cat = categories.firstWhere(
                      (c) => c.id == 'cat_shapewear',
                      orElse: () => categories.first,
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CategoryProductsScreen(category: cat),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 3. Circular Categories Grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: categories.take(4).map((cat) {
                  return CategoryCircleItem(
                    category: cat,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CategoryProductsScreen(category: cat),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: categories.skip(4).take(4).map((cat) {
                  return CategoryCircleItem(
                    category: cat,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CategoryProductsScreen(category: cat),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 4. Boutique Flash Sale / Countdown Strip (From User Screenshot)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6B0E33), Color(0xFF3F041D)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6B0E33).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.flash_on_rounded, color: Color(0xFFD4AF37), size: 24),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BUY ANY 2 GET 1 FREE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'Free surprise gift on orders above ₹1,999',
                      style: TextStyle(
                        color: Color(0xFFE5C07B),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Countdown Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 12, color: Color(0xFFD4AF37)),
                    const SizedBox(width: 4),
                    Text(
                      '$hours:$minutes:$seconds',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 5. Promo Discount Banner
        PromoDiscountBanner(
          onShopSale: () {
            if (categories.isNotEmpty) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CategoryProductsScreen(category: categories.first),
                ),
              );
            }
          },
        ),

        const SizedBox(height: 6),

        // 6. Best Sellers Section
        SectionHeader(
          title: AppStrings.bestSellers,
          actionTitle: AppStrings.viewAll,
          onActionTap: () => widget.onTabChange(1),
        ),

        // Best Sellers Horizontal Cards
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: bestSellers.length,
            itemBuilder: (context, index) {
              final product = bestSellers[index];
              return Container(
                width: 155,
                margin: const EdgeInsets.only(right: 12),
                child: ProductCard(
                  product: product,
                  isCompact: true,
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 14),

        // 8. Trending Nightwear & Chemise Section (From Screenshot 1)
        SectionHeader(
          title: 'Trending Babydolls & Nightwear',
          actionTitle: 'Explore',
          onActionTap: () {
            final cat = categories.firstWhere((c) => c.id == 'cat_nightwear', orElse: () => categories.first);
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => CategoryProductsScreen(category: cat)),
            );
          },
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: nightwearProducts.take(4).length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.62,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
            ),
            itemBuilder: (context, index) {
              return ProductCard(product: nightwearProducts[index]);
            },
          ),
        ),

        const SizedBox(height: 14),

        // 9. Sensual Bodystockings & Catsuits (From Screenshot 4)
        if (hosieryProducts.isNotEmpty) ...[
          SectionHeader(
            title: 'One Piece Bodystockings & Hosiery',
            actionTitle: 'View All',
            onActionTap: () {
              final cat = categories.firstWhere((c) => c.id == 'cat_shapewear', orElse: () => categories.first);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => CategoryProductsScreen(category: cat)),
              );
            },
          ),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: hosieryProducts.length,
              itemBuilder: (context, index) {
                final product = hosieryProducts[index];
                return Container(
                  width: 155,
                  margin: const EdgeInsets.only(right: 12),
                  child: ProductCard(
                    product: product,
                    isCompact: true,
                  ),
                );
              },
            ),
          ),
        ],

        const SizedBox(height: 22),

        // 10. Boutique Trust & Discreet Guarantee Badges
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider.withValues(alpha: 0.8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _buildTrustBadgeItem(
                    icon: Icons.lock_outline_rounded,
                    title: '100% Discreet Box',
                    subtitle: 'Plain unmarked parcel',
                  ),
                  _buildTrustBadgeItem(
                    icon: Icons.local_shipping_outlined,
                    title: 'Express Delivery',
                    subtitle: 'Pan-India 2-4 days',
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, color: AppColors.divider),
              ),
              Row(
                children: [
                  _buildTrustBadgeItem(
                    icon: Icons.verified_user_outlined,
                    title: 'Discreet Billing',
                    subtitle: 'No product names shown',
                  ),
                  _buildTrustBadgeItem(
                    icon: Icons.support_agent_rounded,
                    title: 'VIP Concierge',
                    subtitle: '24/7 Secret Support',
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 36),
      ],
    );
  }

  Widget _buildBoutiqueTeaserCard({
    required String title,
    required String tag,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomCachedImage(imageUrl: imageUrl, fit: BoxFit.cover),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xEA3F041D),
                      Color(0x663F041D),
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.65, 1.0],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 7.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF280211),
                        ),
                      ),
                    ),
                    Text(
                      title,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrustBadgeItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 9.5,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
