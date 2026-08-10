import 'package:manager_app/core/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../routes/providers/route_provider.dart';
import '../attendance/providers/attendance_provider.dart';
import '../routes/models/delivery_route.dart';
import '../attendance/models/delivery_person.dart';
import 'petrol_allowance_sheet.dart';

class PetrolAllowanceScreen extends ConsumerWidget {
  final DeliveryRoute? route;
  final DeliveryPerson? dp;

  const PetrolAllowanceScreen({
    super.key,
    this.route,
    this.dp,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final routeState = ref.watch(routeProvider).value ?? const RouteState();
    final attendanceState = ref.watch(attendanceProvider).value ?? const AttendanceState();

    final targetRoute = route ??
        routeState.routes.firstWhere(
          (r) => r.allocations.isNotEmpty,
          orElse: () => routeState.routes.first,
        );

    DeliveryPerson? targetDp = dp;
    if (targetDp == null && attendanceState.persons.isNotEmpty) {
      final entry = attendanceState.persons.firstWhere(
        (p) => targetRoute.allocations.any((a) => a.dpId == p.dpId),
        orElse: () => attendanceState.persons.first,
      );
      targetDp = DeliveryPerson(id: entry.dpId, name: entry.name, employeeId: entry.dpCode);
    }
    targetDp ??= const DeliveryPerson(id: 'unknown', name: 'Unknown DP', employeeId: 'N/A');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/dispatch');
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Petrol Allowance', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              DateFormat('MMM dd, yyyy').format(DateUtil.operatingDay),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            tooltip: 'Complete & Return to Dashboard',
            onPressed: () {
              ref.read(routeProvider.notifier).markPetrolAllowanceComplete(
                targetRoute.id,
                targetDp!.id,
                targetRoute.fixedPetrolAllowance,
              );
              context.go('/dashboard');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: PetrolAllowanceSheet(
            route: targetRoute,
            dp: targetDp,
            isInStepFlow: true,
          ),
        ),
      ),
    );
  }
}
