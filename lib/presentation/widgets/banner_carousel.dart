import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_secret_boutique/core/constants/app_colors.dart';
import 'package:the_secret_boutique/core/constants/app_images.dart';
import 'package:the_secret_boutique/core/widgets/custom_cached_image.dart';

class BannerCarousel extends StatefulWidget {
  final VoidCallback onBannerTap;

  const BannerCarousel({super.key, required this.onBannerTap});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> _banners = [
    {
      'tag': 'EXCLUSIVE BOUTIQUE',
      'title': "Don't Save It For\nAn Occasion ♡",
      'subtitle': 'Buy any 2, Get 1 FREE + Surprise Gift',
      'buttonText': 'Shop Now',
      'image': AppImages.heroPurpleLaceBanner,
      'isFullBleed': true,
      'gradient': const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF861144), Color(0xFF5D082C), Color(0xFF3B041B)],
      ),
      'isDark': true,
    },
    {
      'tag': 'LIMITED TIME OFFER',
      'title': 'Exquisite Babydoll\n& Lace Chemise',
      'subtitle': 'Sheer Lace & Sultry Cuts',
      'buttonText': 'Shop the Sale',
      'image': AppImages.nightwearRedBabydoll,
      'gradient': const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF500624), Color(0xFF75103B), Color(0xFF941E51)],
      ),
      'isDark': true,
    },
    {
      'tag': 'SILK & SATIN',
      'title': 'The Sensual Slip\n& Robe Collection',
      'subtitle': 'Feel Sultry & Confident',
      'buttonText': 'Explore Collection',
      'image': AppImages.nightwearPurpleSatin,
      'gradient': const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF6B0E33), Color(0xFF42051E), Color(0xFF280211)],
      ),
      'isDark': true,
    },
    {
      'tag': 'NEW IN STOCK',
      'title': 'One Piece Hosiery\n& Bodystockings',
      'subtitle': 'Lace & Hollow Cutout Jumpsuits',
      'buttonText': 'Shop Hosiery',
      'image': AppImages.hosieryBlackLeopard,
      'gradient': const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF450620), Color(0xFF6A0E34), Color(0xFF240210)],
      ),
      'isDark': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 195,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _banners.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              final banner = _banners[index];
              final isDark = banner['isDark'] as bool;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: banner['gradient'] as LinearGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Stack(
                    children: [
                      // Model Photo / Background
                      if (banner['isFullBleed'] == true) ...[
                        Positioned.fill(
                          child: CustomCachedImage(
                            imageUrl: banner['image'] as String,
                            fit: BoxFit.cover,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xEE380318),
                                  Color(0x99380318),
                                  Colors.transparent,
                                ],
                                stops: [0.0, 0.48, 0.85],
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          width: 175,
                          child: ShaderMask(
                            shaderCallback: (rect) {
                              return const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.transparent, Colors.black],
                                stops: [0.0, 0.4],
                              ).createShader(rect);
                            },
                            blendMode: BlendMode.dstIn,
                            child: CustomCachedImage(
                              imageUrl: banner['image'] as String,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],

                      // Text and Pill Action on Left
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 160, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Tag badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                banner['tag'] as String,
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Main Title
                            Text(
                              banner['title'] as String,
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.primary,
                                height: 1.15,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 3),

                            // Subtitle
                            Text(
                              banner['subtitle'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.85)
                                    : AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Button
                            GestureDetector(
                              onTap: widget.onBannerTap,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2E0314),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.35),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.25),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      banner['buttonText'] as String,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 10,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Synchronized Animated Indicators
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (idx) {
            final isActive = _currentPage == idx;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 22 : 6,
              height: 5,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.primary.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class PromoDiscountBanner extends StatefulWidget {
  final VoidCallback onShopSale;

  const PromoDiscountBanner({super.key, required this.onShopSale});

  @override
  State<PromoDiscountBanner> createState() => _PromoDiscountBannerState();
}

class _PromoDiscountBannerState extends State<PromoDiscountBanner> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> _offers = [
    {
      'tag': 'SPECIAL OFFER',
      'title': 'Flat 50% OFF',
      'subtitle': 'On Selected Styles & Sets',
      'code': 'LUXE50',
      'buttonText': 'Shop the Sale',
      'image': AppImages.luxuryGift,
      'gradient': const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF861144), Color(0xFF5D082C), Color(0xFF3B041B)],
      ),
    },
    {
      'tag': 'BOUTIQUE DEAL',
      'title': 'Buy 2 Get 1 FREE',
      'subtitle': 'On All Bras & Lingerie Sets',
      'code': 'B2G1FREE',
      'buttonText': 'Claim Free Bra',
      'image': AppImages.modelDetail,
      'gradient': const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF500624), Color(0xFF75103B), Color(0xFF941E51)],
      ),
    },
    {
      'tag': 'LIMITED TIME',
      'title': 'Flat ₹200 OFF',
      'subtitle': 'On Orders Above ₹999 + Free Delivery',
      'code': 'BRA200',
      'buttonText': 'Shop Now',
      'image': AppImages.modelEditorial,
      'gradient': const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF6B0E33), Color(0xFF42051E), Color(0xFF280211)],
      ),
    },
    {
      'tag': 'ONE PIECE DROP',
      'title': 'Bodystockings Sale',
      'subtitle': 'Extra 20% OFF on 2+ Bodystockings',
      'code': 'BODY20',
      'buttonText': 'Explore Drops',
      'image': AppImages.hosieryBlackLeopard,
      'gradient': const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF4A0420), Color(0xFF6E0D36), Color(0xFF280211)],
      ),
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final next = (_currentIndex + 1) % _offers.length;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _copyCode(String code) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Full width luxury offer banner slider
        SizedBox(
          height: 155,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _offers.length,
            onPageChanged: (idx) => setState(() => _currentIndex = idx),
            itemBuilder: (context, index) {
              final offer = _offers[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: offer['gradient'] as LinearGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    children: [
                      // Full background artwork across the entire card
                      Positioned.fill(
                        child: ShaderMask(
                          shaderCallback: (rect) {
                            return const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Colors.transparent, Colors.black],
                              stops: [0.15, 0.7],
                            ).createShader(rect);
                          },
                          blendMode: BlendMode.dstIn,
                          child: CustomCachedImage(
                            imageUrl: offer['image'] as String,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Content overlay
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 110, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.35),
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Text(
                                    offer['tag'] as String,
                                    style: const TextStyle(
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () => _copyCode(offer['code'] as String),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          offer['code'] as String,
                                          style: const TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        const Icon(
                                          Icons.copy_rounded,
                                          size: 9,
                                          color: AppColors.primary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              offer['title'] as String,
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              offer['subtitle'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: widget.onShopSale,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Shop the Sale',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 8.5,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Indicator dots
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_offers.length, (idx) {
            final isActive = _currentIndex == idx;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 16 : 5,
              height: 4,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),

        const SizedBox(height: 6),
      ],
    );
  }
}
