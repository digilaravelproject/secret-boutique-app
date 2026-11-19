import 'package:flutter/material.dart';
import 'package:the_secret_boutique/core/constants/app_colors.dart';
import 'package:the_secret_boutique/core/utils/currency_formatter.dart';
import 'package:the_secret_boutique/core/widgets/custom_button.dart';
import 'package:the_secret_boutique/data/models/address_model.dart';
import 'package:the_secret_boutique/presentation/screens/main_navigation_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  final double totalAmount;
  final AddressModel deliveryAddress;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.totalAmount,
    required this.deliveryAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Success Animated Check Icon
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.blushPink,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.4), width: 2),
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle,
                    size: 54,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Order Placed Successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Order ID: #$orderId',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Thank you for shopping with The Secret Boutique! We are packaging your items with discreet, premium wrapping.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              // Summary Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.blushPink.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Amount Paid', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        Text(
                          CurrencyFormatter.format(totalAmount),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const Divider(height: 20, color: AppColors.divider),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Delivering to', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        Text(
                          deliveryAddress.recipientName,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      deliveryAddress.fullAddress,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              CustomButton(
                text: 'Continue Shopping',
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                    (route) => false,
                  );
                },
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
