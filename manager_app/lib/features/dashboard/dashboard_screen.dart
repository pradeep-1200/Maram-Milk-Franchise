import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/app_card.dart';
import '../../shared/dp_avatar.dart';
import 'providers/dashboard_provider.dart';
import '../routes/providers/route_provider.dart';
import '../evening_check/providers/evening_check_provider.dart';
import '../attendance/providers/attendance_provider.dart';
import '../manager_inventory/manager_inventory_section.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: AppConstants.spacing16,
                  right: AppConstants.spacing16,
                  top: AppConstants.spacing16,
                  bottom: 100, // Padding for bottom nav
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // App Bar Section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => context.push('/profile'),
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: AppConstants.cardShadow,
                              border: AppConstants.cardBorder,
                            ),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: theme.colorScheme.primaryContainer,
                              foregroundColor: theme.colorScheme.onPrimaryContainer,
                              child: const Text('I', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Imran',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                'Manager • Royapettah Branch',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Greeting Banner Card
                    Builder(
                      builder: (context) {
                        final hour = DateTime.now().hour;
                        final String greeting;
                        final IconData icon;
                        
                        if (hour >= 5 && hour < 12) {
                          greeting = 'Good Morning';
                          icon = Icons.wb_sunny_outlined;
                        } else if (hour >= 12 && hour < 17) {
                          greeting = 'Good Afternoon';
                          icon = Icons.wb_cloudy_outlined;
                        } else if (hour >= 17 && hour < 21) {
                          greeting = 'Good Evening';
                          icon = Icons.brightness_3_outlined;
                        } else {
                          greeting = 'Good Night';
                          icon = Icons.nights_stay_outlined;
                        }
                        
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppConstants.spacing24),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                            boxShadow: AppConstants.primaryCardShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    greeting,
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(icon, color: theme.colorScheme.onPrimary, size: 28),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                DateFormat('MMM d, yyyy • EEEE').format(DateTime.now()),
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: theme.colorScheme.onPrimary.withAlpha(220),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Ready to manage today's deliveries!",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Today's Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Today's Stats",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const _ReloadStatsButton(),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacing16),

                    // 2x2 Stat Grid
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Total DPs',
                            value: state.totalDPs.toString(),
                            icon: Icons.storefront,
                            iconColor: Colors.blue,
                            onTap: () => context.push('/attendance'),
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacing16),
                        Expanded(
                          child: _StatCard(
                            title: 'Present',
                            value: state.present.toString(),
                            icon: Icons.check_circle,
                            iconColor: Colors.green,
                            onTap: () => context.push('/attendance'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Absent',
                            value: state.absent.toString(),
                            icon: Icons.cancel,
                            iconColor: Colors.red,
                            onTap: () => context.push('/attendance'),
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacing16),
                        Expanded(
                          child: _StatCard(
                            title: 'Standby',
                            value: state.standby.toString(),
                            icon: Icons.access_time_filled,
                            iconColor: Colors.orange,
                            onTap: () => context.push('/attendance'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Today at a Glance Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Today at a Glance",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        if (state.unassignedRoutes > 0)
                          Expanded(
                            child: GestureDetector(
                              onTap: () => context.push('/routes'),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(Icons.warning_amber_rounded, size: 16, color: Colors.orange),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      '${state.unassignedRoutes} routes need assignment',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.orange.shade800,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacing16),

                    // Priority Routes
                    AppCard(
                      padding: const EdgeInsets.all(AppConstants.spacing16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.map, color: theme.colorScheme.primary, size: 20),
                              const SizedBox(width: AppConstants.spacing8),
                              Text(
                                'Routes',
                                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12.0),
                          Builder(
                            builder: (context) {
                              final routeState = ref.watch(routeProvider).value ?? const RouteState();
                              final pendingRoutes = routeState.routes.where((r) => r.assignedDpId == null || !r.isPetrolAllowanceComplete).toList();
                              
                              if (pendingRoutes.isEmpty) {
                                return Row(
                                  children: [
                                    const Icon(Icons.check_circle, color: Colors.green, size: 16),
                                    const SizedBox(width: AppConstants.spacing8),
                                    Text('All routes ready ✓', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.green, fontWeight: FontWeight.bold)),
                                  ],
                                );
                              }
                              
                              return SizedBox(
                                height: 36,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: pendingRoutes.length,
                                  separatorBuilder: (_, __) => const SizedBox(width: AppConstants.spacing8),
                                  itemBuilder: (context, index) {
                                    final route = pendingRoutes[index];
                                    final bool needsDp = route.assignedDpId == null;
                                    return ActionChip(
                                      label: Text(route.name),
                                      avatar: Icon(needsDp ? Icons.person_add : Icons.local_gas_station, size: 16, color: Colors.white),
                                      backgroundColor: needsDp ? Colors.red : Colors.orange,
                                      labelStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                      side: BorderSide.none,
                                      onPressed: () => context.push('/routes?openRouteId=${route.id}'),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacing8),
                    
                    // Top DP Card
                    AppCard(
                      onTap: () => context.push('/dp-performance?period=today&sort=litres'),
                      padding: const EdgeInsets.all(AppConstants.spacing16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 20),
                                  const SizedBox(width: AppConstants.spacing8),
                                  Text(
                                    'Top Delivery Person Today',
                                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
                            ],
                          ),
                          const SizedBox(height: 12.0),
                          Builder(
                            builder: (context) {
                              final routeState = ref.watch(routeProvider).value ?? const RouteState();
                              final routes = routeState.routes;
                              
                              final milkPerDp = <String, double>{};
                              
                              for (final r in routeState.routes) {
                                if (r.assignedDpId != null && r.assignedDpName != null) {
                                  milkPerDp[r.assignedDpName!] = (milkPerDp[r.assignedDpName!] ?? 0) + r.milkQuantity;
                                }
                              }
                              
                              String? topDpName;
                              double maxMilk = 0;
                              
                              if (milkPerDp.isNotEmpty) {
                                final topEntry = milkPerDp.entries.reduce((a, b) => a.value > b.value ? a : b);
                                topDpName = topEntry.key;
                                maxMilk = topEntry.value;
                              }
                              
                              if (topDpName == null) {
                                return Text('No routes assigned yet', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant));
                              }
                              
                              String? topDpPhotoUrl;
                              try {
                                topDpPhotoUrl = routes.firstWhere((r) => r.assignedDpName == topDpName).assignedDpPhotoUrl;
                              } catch (_) {}
                              
                              return Row(
                                children: [
                                  DpAvatar(
                                    photoUrl: topDpPhotoUrl,
                                    name: topDpName,
                                    radius: 16,
                                  ),
                                  const SizedBox(width: 12.0),
                                  Expanded(
                                    child: Text(
                                      topDpName,
                                      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${maxMilk.toStringAsFixed(1)} Ltr',
                                      style: TextStyle(color: theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                  ),
                                ],
                              );
                            }
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Empty Bottles Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.local_drink, size: 20, color: Colors.blue),
                            const SizedBox(width: AppConstants.spacing8),
                            Text(
                              "Empty Bottles",
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    AppCard(
                      onTap: () => context.push('/bottles'),
                      padding: const EdgeInsets.all(AppConstants.spacing16),
                      child: Builder(
                        builder: (context) {
                          final statuses = ref.watch(eveningCheckProvider).value?.statuses ?? [];
                          
                          int total1L = 0;
                          int total500ml = 0;
                          int checkedRoutes = 0;
                          int flaggedRoutes = 0;
                          
                          final assignedRoutes = statuses.where((r) => r.dpId != null).toList();
                          final totalRoutes = assignedRoutes.length;
                          
                          for (final route in assignedRoutes) {
                            if (route.deliveryCompleted == true) {
                              checkedRoutes++;
                              total1L += route.oneLBottlesCollected;
                              total500ml += route.halfLBottlesCollected;
                              if (route.flagIssue == true) {
                                flaggedRoutes++;
                              }
                            }
                          }

                          if (checkedRoutes == 0) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  'No collections logged yet today',
                                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                ),
                              ),
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primaryContainer,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(Icons.local_drink, color: theme.colorScheme.onPrimaryContainer, size: 20),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$total1L',
                                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                              ),
                                              Text('1L Bottles', style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.tertiaryContainer,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(Icons.local_drink, color: theme.colorScheme.onTertiaryContainer, size: 20),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$total500ml',
                                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                              ),
                                              Text('500ml Bottles', style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$checkedRoutes of $totalRoutes routes checked',
                                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                  ),
                                  if (flaggedRoutes > 0)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withAlpha(25),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: Colors.red),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.warning, size: 12, color: Colors.red),
                                          const SizedBox(width: 4),
                                          Text(
                                            '$flaggedRoutes routes flagged',
                                            style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          );
                        }
                      ),
                    ),
                    const SizedBox(height: 24),
                    const ManagerInventorySection(),
                  ],
                ),
              ),
            ),
            
            // Pinned Action Buttons using Cafe Admin "Pill" style
            Container(
              padding: const EdgeInsets.all(AppConstants.spacing16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    offset: const Offset(0, -4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.push('/dispatch'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.local_shipping, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Start Dispatch',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.push('/evening-check'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        foregroundColor: theme.colorScheme.onSurface,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.nightlight_round, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Return Check',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
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
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppConstants.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReloadStatsButton extends ConsumerStatefulWidget {
  const _ReloadStatsButton();

  @override
  ConsumerState<_ReloadStatsButton> createState() => _ReloadStatsButtonState();
}

class _ReloadStatsButtonState extends ConsumerState<_ReloadStatsButton> {
  bool _isCoolingDown = false;

  void _handleTap() {
    if (_isCoolingDown) return;

    setState(() {
      _isCoolingDown = true;
    });

    ref.invalidate(attendanceProvider);

    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _isCoolingDown = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Use withValues for opacity per modern Flutter standard if available, or withOpacity
    final iconColor = _isCoolingDown 
        ? theme.colorScheme.primary.withValues(alpha: 0.3) 
        : theme.colorScheme.primary;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: AppConstants.cardShadow,
        border: AppConstants.cardBorder,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(Icons.refresh, size: 18, color: iconColor),
        onPressed: _isCoolingDown ? null : _handleTap,
      ),
    );
  }
}
