import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/authentication/login_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/routes/empty_bottle_list_screen.dart';
import '../../features/attendance/attendance_screen.dart';
import '../../features/routes/route_allocation_screen.dart';
import '../../features/dispatch/dispatch_ready_screen.dart';
import '../../features/dispatch/dispatch_summary_screen.dart';
import '../../features/manager_inventory/manager_inventory_screen.dart';
import '../../features/shop_sale/shop_sale_screen.dart';

import '../../features/inventory/inventory_screen.dart';
import '../../features/reports/reports_screen.dart';
import '../../features/reports/dp_performance_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/staff_directory_screen.dart';
import '../../features/profile/staff_profile_screen.dart';
import '../../features/profile/staff_profile_edit_screen.dart';
import '../../features/ledger/transactions_screen.dart';
import '../../features/shell/main_shell.dart';
import '../../features/evening_check/evening_check_screen.dart';

import '../../features/milk_allocation/milk_allocation_screen.dart';
import '../../features/petrol_allowance/petrol_allowance_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/attendance',
              builder: (context, state) => const AttendanceScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/routes',
              builder: (context, state) {
                final openRouteId = state.uri.queryParameters['openRouteId'];
                return RouteAllocationScreen(openRouteId: openRouteId);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inventory',
              builder: (context, state) => const InventoryScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/dispatch',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const DispatchReadyScreen(),
      routes: [
        GoRoute(
          path: 'attendance',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const AttendanceScreen(isDispatchContext: true),
        ),
        GoRoute(
          path: 'inventory',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const InventoryScreen(isDispatchContext: true),
        ),
        GoRoute(
          path: 'routes',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final openRouteId = state.uri.queryParameters['openRouteId'];
            return RouteAllocationScreen(isDispatchContext: true, openRouteId: openRouteId);
          },
        ),
        GoRoute(
          path: 'milk-allocation',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const MilkAllocationScreen(),
        ),
        GoRoute(
          path: 'petrol-allowance',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const PetrolAllowanceScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/dispatch_summary',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const DispatchSummaryScreen(),
    ),
    GoRoute(
      path: '/reports',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ReportsScreen(),
    ),
    GoRoute(
      path: '/dp-performance',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final period = state.uri.queryParameters['period'] ?? 'month';
        final sort = state.uri.queryParameters['sort'] ?? 'litres';
        return DpPerformanceScreen(initialPeriod: period, initialSort: sort);
      },
    ),

    GoRoute(
      path: '/transactions',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const TransactionsScreen(),
    ),
    GoRoute(
      path: '/bottles',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const EmptyBottleListScreen(),
    ),
    GoRoute(
      path: '/evening-check',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const EveningCheckScreen(),
    ),
    GoRoute(
      path: '/manager-inventory',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ManagerInventoryScreen(),
    ),
    GoRoute(
      path: '/shop-sale',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ShopSaleScreen(),
    ),
    GoRoute(
      path: '/staff-directory',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const StaffDirectoryScreen(),
      routes: [
        GoRoute(
          path: 'add',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            return const StaffProfileEditScreen();
          },
        ),
        GoRoute(
          path: ':id',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return StaffProfileScreen(dpId: id);
          },
        ),
        GoRoute(
          path: ':id/edit',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return StaffProfileEditScreen(dpId: id);
          },
        ),
      ],
    ),
  ],
  );
});
