import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_secret_boutique/core/constants/app_colors.dart';
import 'package:the_secret_boutique/core/constants/app_strings.dart';
import 'package:the_secret_boutique/core/widgets/custom_cached_image.dart';
import 'package:the_secret_boutique/logic/auth/auth_bloc.dart';
import 'package:the_secret_boutique/logic/auth/auth_event.dart';
import 'package:the_secret_boutique/logic/auth/auth_state.dart';
import 'package:the_secret_boutique/presentation/screens/auth/login_screen.dart';
import 'package:the_secret_boutique/presentation/screens/wishlist/wishlist_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // Discreet preference toggles
  bool _discreetPackaging = true;
  bool _hideItemNames = true;
  bool _smsUpdatesOnly = false;

  void _showEditProfileDialog(BuildContext context, {
    required String currentName,
    required String currentEmail,
    required String currentPhone,
  }) {
    final nameCtrl = TextEditingController(text: currentName);
    final emailCtrl = TextEditingController(text: currentEmail);
    final phoneCtrl = TextEditingController(text: currentPhone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 22,
          right: 22,
          top: 22,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Boutique Profile',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Full Name',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary, size: 19),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Email Address',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary, size: 19),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Mobile Number',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone_android_rounded, color: AppColors.primary, size: 19),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  final newName = nameCtrl.text.trim();
                  final newEmail = emailCtrl.text.trim();
                  final newPhone = phoneCtrl.text.trim();

                  if (newName.isNotEmpty && newEmail.isNotEmpty && newPhone.isNotEmpty) {
                    context.read<AuthBloc>().add(
                          AuthProfileUpdateRequested(
                            name: newName,
                            email: newEmail,
                            phone: newPhone,
                          ),
                        );
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully!'),
                        backgroundColor: Color(0xFF2E7D32),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrdersModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.75,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Boutique Orders',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  _buildOrderCard(
                    orderId: 'TSB-89421',
                    date: 'Ordered Today • Estimated Tomorrow',
                    status: 'Out for Delivery',
                    statusColor: const Color(0xFF2E7D32),
                    itemName: 'Crimson Sheer Ruffle Babydoll Set',
                    itemDetail: 'Size 34 • Crimson Red • Qty 1',
                    price: '₹799',
                    imageUrl: 'https://images.unsplash.com/photo-1543699619-b8c9f47c07b4?auto=format&fit=crop&w=400&q=85',
                  ),
                  const SizedBox(height: 14),
                  _buildOrderCard(
                    orderId: 'TSB-75102',
                    date: 'Delivered on Nov 12, 2026',
                    status: 'Delivered (100% Discreet)',
                    statusColor: AppColors.primary,
                    itemName: 'Gold Chain Star Charm Thong',
                    itemDetail: 'Size M • Gold Black • Qty 2',
                    price: '₹598',
                    imageUrl: 'https://images.unsplash.com/photo-1606792109963-7b34205b1333?auto=format&fit=crop&w=400&q=85',
                  ),
                  const SizedBox(height: 14),
                  _buildOrderCard(
                    orderId: 'TSB-61044',
                    date: 'Delivered on Oct 28, 2026',
                    status: 'Delivered (Discreet Box)',
                    statusColor: AppColors.primary,
                    itemName: 'Wine Sheer Lace Corset Chemise',
                    itemDetail: 'Size 36 • Wine Burgundy • Qty 1',
                    price: '₹849',
                    imageUrl: 'https://images.unsplash.com/photo-1574539602047-548bf9557352?auto=format&fit=crop&w=400&q=85',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard({
    required String orderId,
    required String date,
    required String status,
    required Color statusColor,
    required String itemName,
    required String itemDetail,
    required String price,
    required String imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #$orderId',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(date, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          const Divider(height: 18, color: AppColors.divider),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 50,
                  height: 60,
                  child: CustomCachedImage(imageUrl: imageUrl, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text(itemDetail, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text(price, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddressesModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Shipping Addresses',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _buildAddressTile(
              tag: 'Home • Default',
              name: 'Awantika Yadav',
              phone: '+91 98765 43210',
              address: '123, Green Park, Near City Mall, Lucknow, UP - 226010',
              isDefault: true,
            ),
            const SizedBox(height: 12),
            _buildAddressTile(
              tag: 'Work',
              name: 'Awantika Yadav',
              phone: '+91 98765 43210',
              address: '404, Tech Park, Hazratganj, Lucknow, UP - 226001',
              isDefault: false,
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add New Address form opened')),
                  );
                },
                icon: const Icon(Icons.add, color: AppColors.primary),
                label: const Text('Add New Address', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressTile({
    required String tag,
    required String name,
    required String phone,
    required String address,
    required bool isDefault,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDefault ? AppColors.blushPink.withValues(alpha: 0.4) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDefault ? AppColors.primary : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tag, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary)),
              if (isDefault) const Icon(Icons.check_circle, size: 16, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 4),
          Text('$name  •  $phone', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(address, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  void _showPreferencesModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Discreet & Privacy Settings',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Customize how your orders and notifications are delivered for 100% confidentiality.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('100% Discreet Unbranded Box', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                subtitle: const Text('Plain brown box with no mention of innerwear or brand.', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                value: _discreetPackaging,
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) {
                  setModalState(() => _discreetPackaging = val);
                  setState(() => _discreetPackaging = val);
                },
              ),
              const Divider(height: 1, color: AppColors.divider),
              SwitchListTile(
                title: const Text('Discreet Billing Descriptor', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                subtitle: const Text('Shows as "TSB Lifestyle" on bank statements.', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                value: _hideItemNames,
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) {
                  setModalState(() => _hideItemNames = val);
                  setState(() => _hideItemNames = val);
                },
              ),
              const Divider(height: 1, color: AppColors.divider),
              SwitchListTile(
                title: const Text('Confidential SMS Delivery Updates', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                subtitle: const Text('Receive tracking link without item details in message.', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                value: _smsUpdatesOnly,
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) {
                  setModalState(() => _smsUpdatesOnly = val);
                  setState(() => _smsUpdatesOnly = val);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          final user = state is Authenticated ? state.user : null;
          final userName = user?.name ?? 'Awantika Yadav';
          final userEmail = user?.email ?? 'awantika@gmail.com';
          final userPhone = user?.phone ?? '+91 98765 43210';
          final isAuthenticated = state is Authenticated;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Top Wine Profile Card
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x40861144),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // User Avatar
                          Container(
                            width: 68,
                            height: 68,
                            padding: const EdgeInsets.all(2.5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFD4AF37), width: 2), // Gold border
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: CustomCachedImage(
                                imageUrl: user?.avatarUrl ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=85',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Name & Email
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        userName,
                                        style: GoogleFonts.cormorantGaramond(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: const Color(0xFFD4AF37), width: 0.8),
                                      ),
                                      child: const Text(
                                        'VIP GOLD',
                                        style: TextStyle(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFD4AF37),
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  userEmail,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.85),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  userPhone,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: Colors.white.withValues(alpha: 0.75),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Edit Profile Button
                      GestureDetector(
                        onTap: () => _showEditProfileDialog(
                          context,
                          currentName: userName,
                          currentEmail: userEmail,
                          currentPhone: userPhone,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 0.8),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit_note_rounded, size: 16, color: Colors.white),
                              SizedBox(width: 6),
                              Text(
                                'Edit My Account Details',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Account Menu Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Material(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(color: AppColors.divider.withValues(alpha: 0.8)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    elevation: 1,
                    child: Column(
                      children: [
                        _buildMenuItem(
                          context,
                          icon: Icons.inventory_2_outlined,
                          title: 'My Orders & Tracking',
                          subtitle: 'View recent orders & discrete delivery tracking',
                          onTap: () => _showOrdersModal(context),
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          context,
                          icon: Icons.favorite_border,
                          title: 'My Wishlist',
                          subtitle: 'Your saved favorite intimates',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const WishlistScreen()),
                            );
                          },
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          context,
                          icon: Icons.location_on_outlined,
                          title: 'Saved Addresses',
                          subtitle: 'Manage delivery addresses',
                          onTap: () => _showAddressesModal(context),
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          context,
                          icon: Icons.shield_outlined,
                          title: 'Discreet & Privacy Settings',
                          subtitle: 'Packaging and billing confidentiality',
                          onTap: () => _showPreferencesModal(context),
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          context,
                          icon: Icons.support_agent_rounded,
                          title: 'Boutique Concierge & Support',
                          subtitle: '24/7 dedicated confidential styling advice',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Connecting to VIP Concierge on WhatsApp...'),
                                backgroundColor: AppColors.primary,
                              ),
                            );
                          },
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          context,
                          icon: Icons.info_outline,
                          title: 'About The Secret Boutique',
                          subtitle: 'Our luxury manifesto & guarantee',
                          onTap: () {
                            showAboutDialog(
                              context: context,
                              applicationName: AppStrings.appName,
                              applicationVersion: '2.0.0',
                              applicationLegalese: '© 2026 The Secret Boutique. 100% Confidential.',
                            );
                          },
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          context,
                          icon: isAuthenticated ? Icons.logout_rounded : Icons.login_rounded,
                          title: isAuthenticated ? 'Log Out' : 'Sign In to Account',
                          subtitle: isAuthenticated ? 'Sign out of this device' : 'Access your VIP perks',
                          textColor: AppColors.primary,
                          onTap: () {
                            if (isAuthenticated) {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Confirm Logout'),
                                  content: const Text('Are you sure you want to log out of your boutique account?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                        context.read<AuthBloc>().add(AuthLogoutRequested());
                                      },
                                      child: const Text('Logout', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // VIP Boutique Membership Promo Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF380318), Color(0xFF5D082C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.card_giftcard_rounded, color: Color(0xFFD4AF37), size: 24),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'VIP Secret Rewards',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'You have 450 Boutique Coins • ₹450 OFF',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFFD4AF37),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (textColor ?? AppColors.primary).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: textColor ?? AppColors.primary),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: textColor ?? AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            )
          : null,
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.textMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 0.8, color: AppColors.divider, indent: 56);
  }
}
