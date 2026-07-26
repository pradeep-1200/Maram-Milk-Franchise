import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../attendance/providers/attendance_provider.dart';
import '../../routes/providers/route_provider.dart';

class DashboardState {
  final int totalDPs;
  final int present;
  final int absent;
  final int standby;
  final int unassignedRoutes;
  final int totalRoutes;
  final int assignedRoutes;

  const DashboardState({
    this.totalDPs = 0,
    this.present = 0,
    this.absent = 0,
    this.standby = 0,
    this.unassignedRoutes = 0,
    this.totalRoutes = 0,
    this.assignedRoutes = 0,
  });

  DashboardState copyWith({
    int? totalDPs,
    int? present,
    int? absent,
    int? standby,
    int? unassignedRoutes,
    int? totalRoutes,
    int? assignedRoutes,
  }) {
    return DashboardState(
      totalDPs: totalDPs ?? this.totalDPs,
      present: present ?? this.present,
      absent: absent ?? this.absent,
      standby: standby ?? this.standby,
      unassignedRoutes: unassignedRoutes ?? this.unassignedRoutes,
      totalRoutes: totalRoutes ?? this.totalRoutes,
      assignedRoutes: assignedRoutes ?? this.assignedRoutes,
    );
  }
}

final dashboardProvider = Provider<DashboardState>((ref) {
  final attendanceState = ref.watch(attendanceProvider).value;
  final routeState = ref.watch(routeProvider).value;

  int totalDPs = 0;
  int present = 0;
  int absent = 0;
  int standby = 0;

  if (attendanceState != null) {
    totalDPs = attendanceState.countAll;
    present = attendanceState.countPresent;
    absent = attendanceState.countAbsent;
    standby = attendanceState.countStandby;
  }

  int totalRoutes = 0;
  int assignedRoutes = 0;
  int unassignedRoutes = 0;

  if (routeState != null) {
    totalRoutes = routeState.routes.length;
    assignedRoutes = routeState.routes.where((r) => r.assignedDpId != null).length;
    unassignedRoutes = totalRoutes - assignedRoutes;
  }

  return DashboardState(
    totalDPs: totalDPs,
    present: present,
    absent: absent,
    standby: standby,
    totalRoutes: totalRoutes,
    assignedRoutes: assignedRoutes,
    unassignedRoutes: unassignedRoutes,
  );
});
