import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_secret_boutique/core/constants/app_colors.dart';
import 'package:the_secret_boutique/core/constants/app_strings.dart';
import 'package:the_secret_boutique/core/utils/currency_formatter.dart';
import 'package:the_secret_boutique/data/repositories/shop_repository.dart';
import 'package:the_secret_boutique/logic/cart/cart_bloc.dart';
import 'package:the_secret_boutique/logic/cart/cart_event.dart';
import 'package:the_secret_boutique/logic/cart/cart_state.dart';
import 'package:the_secret_boutique/presentation/screens/checkout/order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPayment = 0; // 0: UPI/GPay, 1: Card, 2: COD, 3: PhonePe

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'title': 'UPI / Google Pay',
      'icon': Icons.account_balance_wallet_outlined,
      'color': Colors.blue,
    },
    {
      'title': 'Credit / Debit Card',
      'icon': Icons.credit_card_outlined,
      'color': Colors.amber.shade800,
    },
    {
      'title': 'Cash on Delivery',
      'icon': Icons.local_shipping_outlined,
      'color': Colors.green.shade700,
    },
    {
      'title': 'PhonePe',
      'icon': Icons.payment_outlined,
      'color': Colors.deepPurple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final address = ShopRepository.addresses.first;

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
          AppStrings.checkout,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step Progress Indicator (Matches Screen 6)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider.withValues(alpha: 0.6)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStepItem(0, 'Address', Icons.check_circle, true),
                  _buildStepLine(true),
                  _buildStepItem(1, 'Payment', Icons.circle, true),
                  _buildStepLine(false),
                  _buildStepItem(2, 'Review', Icons.circle_outlined, false),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section 1: Delivery Address (Matches Screen 6)
            const Text(
              AppStrings.deliveryAddress,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider.withValues(alpha: 0.6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.blushPink,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.home, size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              address.tag,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Address selector')),
                          );
                        },
                        child: const Text(
                          'Change',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    address.recipientName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address.fullAddress,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Phone: ${address.phone}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 38,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Add New Address',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section 2: Payment Method (Matches Screen 6)
            const Text(
              AppStrings.paymentMethod,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider.withValues(alpha: 0.6)),
              ),
              child: Column(
                children: List.generate(_paymentMethods.length, (index) {
                  final method = _paymentMethods[index];
                  final isSelected = _selectedPayment == index;

                  return InkWell(
                    onTap: () => setState(() => _selectedPayment = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        border: index < _paymentMethods.length - 1
                            ? const Border(bottom: BorderSide(color: AppColors.divider, width: 0.8))
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(method['icon'] as IconData, color: method['color'] as Color, size: 22),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              method['title'] as String,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? AppColors.primary : Colors.transparent,
                              border: Border.all(
                                color: isSelected ? AppColors.primary : Colors.grey.shade400,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? const Center(
                                    child: Icon(Icons.check, size: 12, color: Colors.white),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 24),

            // Promo Banner Note
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.blushPink,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified_user_outlined, color: AppColors.primary, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '100% Safe & Secure Payments. Discreet plain packaging on all deliveries.',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      // Sticky Bottom Place Order
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Payable',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                      Text(
                        CurrencyFormatter.format(state.total),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        final orderId = 'LUXE-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
                        final total = state.total;
                        context.read<CartBloc>().add(CartCleared());

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => OrderSuccessScreen(
                              orderId: orderId,
                              totalAmount: total,
                              deliveryAddress: address,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepItem(int step, String label, IconData icon, bool isActive) {
    return Column(
      children: [
        Icon(
          icon,
          size: 18,
          color: isActive ? AppColors.primary : AppColors.textMuted,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? AppColors.primary : AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: isActive ? AppColors.primary : AppColors.divider,
      ),
    );
  }
}
