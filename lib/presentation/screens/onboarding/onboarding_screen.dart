import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_secret_boutique/core/constants/app_colors.dart';
import 'package:the_secret_boutique/core/constants/app_images.dart';
import 'package:the_secret_boutique/core/widgets/custom_cached_image.dart';
import 'package:the_secret_boutique/presentation/screens/auth/login_screen.dart';
import 'package:the_secret_boutique/presentation/screens/auth/register_screen.dart';
import 'package:the_secret_boutique/presentation/screens/main_navigation_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _slides = [
    {
      'tag': 'EXQUISITE INTIMATES',
      'title': 'Turn Desire\nInto A Secret ♡',
      'subtitle':
          'Explore seductive lingerie, sheer lace sets, and bold innerwear designed to make you feel sensual and empowered.',
      'image': AppImages.onboardingSlide1,
      'buttonText': 'Continue',
    },
    {
      'tag': 'DREAM NIGHTWEAR',
      'title': 'Elegance\nAfter Hours',
      'subtitle':
          'Lustrous satin slips, sheer robes, and lace halter bodysuits for unforgettable, intimate nights.',
      'image': AppImages.onboardingSlide2,
      'buttonText': 'Continue',
    },
    {
      'tag': 'ONE-PIECE & BODYSUITS',
      'title': 'Sensual Allure,\nTailored to Fit',
      'subtitle':
          'Indulge in fine eyelash lace, delicate cutouts, and sculpted silhouettes designed to celebrate your curves.',
      'image': AppImages.onboardingSlide3,
      'buttonText': 'Continue',
    },
    {
      'tag': '100% PRIVATE & CONFIDENTIAL',
      'title': 'Discreet Luxury\nTo Your Doorstep',
      'subtitle':
          'Tamper-proof, unbranded packaging with discreet billing. Your privacy is our highest priority.',
      'image': AppImages.onboardingSlide4,
      'buttonText': 'Get Started',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentIndex < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _navigateToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E030E),
      body: Stack(
        children: [
          // Background PageView with Ultra HD Photos & Gradient Overlays
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Full Bleed Ultra HD Image
                  CustomCachedImage(
                    imageUrl: slide['image']!,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),

                  // Deep Wine Gradient Scrim for crystal clear readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF120108).withValues(alpha: 0.30),
                          const Color(0xFF1E030E).withValues(alpha: 0.65),
                          const Color(0xFF1E030E).withValues(alpha: 0.98),
                        ],
                        stops: const [0.0, 0.50, 0.85],
                      ),
                    ),
                  ),

                  // Slide Typography & Tag Content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tag Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            slide['tag']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Title
                        Text(
                          slide['title']!,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.15,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Subtitle
                        Text(
                          slide['subtitle']!,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.white.withValues(alpha: 0.85),
                            height: 1.45,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 140), // Space reserved for bottom controls
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          // Top Bar with Brand Monogram & Skip Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // TSB Brand Monogram
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFD4AF37),
                          ),
                          child: const Center(
                            child: Icon(Icons.favorite, size: 12, color: Color(0xFF5A082C)),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'THE SECRET BOUTIQUE',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Skip Button
                  TextButton(
                    onPressed: _navigateToHome,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white.withValues(alpha: 0.85),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          Positioned(
            left: 24,
            right: 24,
            bottom: 30,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Dots Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _slides.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 3.5),
                      width: _currentIndex == index ? 24 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? const Color(0xFFD4AF37) // Gold accent
                            : Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Primary Gradient Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF861144), Color(0xFFD81B60)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFD81B60).withValues(alpha: 0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _slides[_currentIndex]['buttonText']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Secondary Row: Sign In & Explore As Guest
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _navigateToLogin,
                      child: Text.rich(
                        TextSpan(
                          text: 'Have an account? ',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                          children: const [
                            TextSpan(
                              text: 'Sign In',
                              style: TextStyle(
                                color: Color(0xFFD4AF37),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _navigateToHome,
                      child: Text(
                        'Explore as Guest →',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
