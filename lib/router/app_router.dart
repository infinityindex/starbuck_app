import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/menu/menu_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/product_detail/product_detail_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/checkout/checkout_screen.dart';
import '../screens/order_confirmation/order_confirmation_screen.dart';
import '../screens/order_tracking/order_tracking_screen.dart';
import '../screens/rewards/rewards_screen.dart';
import '../screens/favorites/favorites_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/order_history/order_history_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/store_locator/store_locator_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../data/models/drink_model.dart';
import '../widgets/common/app_bottom_nav.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter._();

  static final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');
  static int _currentIndex = 0;

  static final router = GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        pageBuilder: (context, state) => _buildPage(state, const SplashScreen()),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        pageBuilder: (context, state) => _buildPage(state, const OnboardingScreen()),
      ),
      GoRoute(
        path: RouteNames.login,
        pageBuilder: (context, state) => _buildPage(state, const LoginScreen()),
      ),
      GoRoute(
        path: RouteNames.signup,
        pageBuilder: (context, state) => _buildPage(state, const SignupScreen()),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          // Update current index based on route
          final path = state.uri.path;
          if (path == RouteNames.home) _currentIndex = 0;
          else if (path == RouteNames.menu) _currentIndex = 1;
          else if (path == RouteNames.rewards) _currentIndex = 2;
          else if (path == RouteNames.favorites) _currentIndex = 3;
          else if (path == RouteNames.profile) _currentIndex = 4;

          return AppShell(child: child, currentIndex: _currentIndex);
        },
        routes: [
          GoRoute(
            path: RouteNames.home,
            pageBuilder: (context, state) => _buildFadePage(state, const HomeScreen()),
          ),
          GoRoute(
            path: RouteNames.menu,
            pageBuilder: (context, state) => _buildFadePage(state, const MenuScreen()),
          ),
          GoRoute(
            path: RouteNames.rewards,
            pageBuilder: (context, state) => _buildFadePage(state, const RewardsScreen()),
          ),
          GoRoute(
            path: RouteNames.favorites,
            pageBuilder: (context, state) => _buildFadePage(state, const FavoritesScreen()),
          ),
          GoRoute(
            path: RouteNames.profile,
            pageBuilder: (context, state) => _buildFadePage(state, const ProfileScreen()),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.search,
        pageBuilder: (context, state) => _buildPage(state, const SearchScreen()),
      ),
      GoRoute(
        path: RouteNames.productDetail,
        pageBuilder: (context, state) {
          final drink = state.extra as DrinkModel;
          return _buildPage(state, ProductDetailScreen(drink: drink));
        },
      ),
      GoRoute(
        path: RouteNames.cart,
        pageBuilder: (context, state) => _buildBottomPage(state, const CartScreen()),
      ),
      GoRoute(
        path: RouteNames.checkout,
        pageBuilder: (context, state) => _buildPage(state, const CheckoutScreen()),
      ),
      GoRoute(
        path: RouteNames.orderConfirmation,
        pageBuilder: (context, state) => _buildPage(state, const OrderConfirmationScreen()),
      ),
      GoRoute(
        path: RouteNames.orderTracking,
        pageBuilder: (context, state) => _buildPage(state, const OrderTrackingScreen()),
      ),
      GoRoute(
        path: RouteNames.orderHistory,
        pageBuilder: (context, state) => _buildPage(state, const OrderHistoryScreen()),
      ),
      GoRoute(
        path: RouteNames.notifications,
        pageBuilder: (context, state) => _buildPage(state, const NotificationsScreen()),
      ),
      GoRoute(
        path: RouteNames.storeLocator,
        pageBuilder: (context, state) => _buildPage(state, const StoreLocatorScreen()),
      ),
      GoRoute(
        path: RouteNames.settings,
        pageBuilder: (context, state) => _buildPage(state, const SettingsScreen()),
      ),
    ],
  );

  static CustomTransitionPage _buildPage(GoRouterState state, Widget child) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          ),
        );
      },
    );
  }

  static CustomTransitionPage _buildFadePage(GoRouterState state, Widget child) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
    );
  }

  static CustomTransitionPage _buildBottomPage(GoRouterState state, Widget child) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: child,
        );
      },
    );
  }
}

class AppShell extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const AppShell({super.key, required this.child, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          final routes = [
            RouteNames.home,
            RouteNames.menu,
            RouteNames.rewards,
            RouteNames.favorites,
            RouteNames.profile,
          ];
          context.go(routes[index]);
        },
      ),
    );
  }
}
