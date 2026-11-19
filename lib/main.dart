import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_secret_boutique/core/constants/app_strings.dart';
import 'package:the_secret_boutique/core/constants/app_theme.dart';
import 'package:the_secret_boutique/data/repositories/auth_repository.dart';
import 'package:the_secret_boutique/data/repositories/shop_repository.dart';
import 'package:the_secret_boutique/logic/auth/auth_bloc.dart';
import 'package:the_secret_boutique/logic/auth/auth_event.dart';
import 'package:the_secret_boutique/logic/cart/cart_bloc.dart';
import 'package:the_secret_boutique/logic/shop/shop_bloc.dart';
import 'package:the_secret_boutique/logic/shop/shop_event.dart';
import 'package:the_secret_boutique/logic/wishlist/wishlist_bloc.dart';
import 'package:the_secret_boutique/presentation/screens/main_navigation_screen.dart';
import 'package:the_secret_boutique/presentation/screens/onboarding/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(const SecretBoutiqueApp());
}

class SecretBoutiqueApp extends StatelessWidget {
  const SecretBoutiqueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        RepositoryProvider<ShopRepository>(
          create: (_) => ShopRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(AuthCheckRequested()),
          ),
          BlocProvider<ShopBloc>(
            create: (context) => ShopBloc(
              shopRepository: context.read<ShopRepository>(),
            )..add(ShopFetchInitialData()),
          ),
          BlocProvider<CartBloc>(
            create: (_) => CartBloc(),
          ),
          BlocProvider<WishlistBloc>(
            create: (_) => WishlistBloc(),
          ),
        ],
        child: MaterialApp(
          title: AppStrings.boutiqueName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const OnboardingScreen(),
        ),
      ),
    );
  }
}
