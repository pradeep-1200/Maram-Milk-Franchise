import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/attendance_entry.dart';
import '../models/delivery_person.dart' show AttendanceStatus;
import '../../../core/network/api_client.dart';

class AttendanceState {
  final List<AttendanceEntry> persons;
  final String searchQuery;
  final AttendanceStatus? statusFilter;

  const AttendanceState({
    this.persons = const [],
    this.searchQuery = '',
    this.statusFilter,
  });

  AttendanceState copyWith({
    List<AttendanceEntry>? persons,
    String? searchQuery,
    AttendanceStatus? Function()? statusFilter,
  }) {
    return AttendanceState(
      persons: persons ?? this.persons,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter != null ? statusFilter() : this.statusFilter,
    );
  }

  List<AttendanceEntry> get filteredPersons {
    return persons.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.dpCode.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesFilter = statusFilter == null || p.displayStatus == statusFilter;
      return matchesSearch && matchesFilter;
    }).toList();
  }
  
  int get countAll => persons.length;
  int get countPresent => persons.where((p) => p.displayStatus == AttendanceStatus.present).length;
  int get countAbsent => persons.where((p) => p.displayStatus == AttendanceStatus.absent).length;
  int get countStandby => persons.where((p) => p.displayStatus == AttendanceStatus.standby).length;
}

class AttendanceNotifier extends AsyncNotifier<AttendanceState> {
  String _getLocalToday() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  Future<AttendanceState> build() async {
    try {
      return await _fetchAttendance();
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  Future<AttendanceState> _fetchAttendance() async {
    final dio = ref.read(apiClientProvider);
    final date = _getLocalToday();
    
    final response = await dio.get(
      '/attendance',
      queryParameters: {'date': date},
    );
    
    final List<dynamic> data = response.data;
    final persons = data.map((json) {
      return AttendanceEntry.fromJson(json);
    }).toList();

    return AttendanceState(
      persons: persons,
      searchQuery: state.value?.searchQuery ?? '',
      statusFilter: state.value?.statusFilter,
    );
  }

  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchAttendance());
  }

  void setSearchQuery(String query) {
    if (state.value != null) {
      state = AsyncValue.data(state.value!.copyWith(searchQuery: query));
    }
  }

  void setStatusFilter(AttendanceStatus? filter) {
    if (state.value != null) {
      state = AsyncValue.data(state.value!.copyWith(statusFilter: () => filter));
    }
  }

  Future<void> markAttendance(String dpId, AttendanceStatus newStatus) async {
    final dio = ref.read(apiClientProvider);
    final date = _getLocalToday();

    String statusString;
    switch (newStatus) {
      case AttendanceStatus.present:
        statusString = 'PRESENT';
        break;
      case AttendanceStatus.absent:
        statusString = 'ABSENT';
        break;
      case AttendanceStatus.standby:
        statusString = 'STANDBY';
        break;
      case AttendanceStatus.pending:
        statusString = 'NOT_MARKED';
        break;
    }

    // Optimistic update
    if (state.value != null) {
      final updated = state.value!.persons.map((p) {
        if (p.dpId == dpId) {
          return p.copyWith(status: newStatus);
        }
        return p;
      }).toList();
      state = AsyncValue.data(state.value!.copyWith(persons: updated));
    }

    try {
      await dio.put(
        '/attendance/$dpId',
        queryParameters: {'date': date},
        data: {'status': statusString},
      );
    } catch (e) {
      // Revert on failure by refetching
      ref.invalidateSelf();
    }
  }

  void assignRouteToDp(String dpId) {
    // AttendanceEntry doesn't have isRouteAssigned anymore
  }
}

final attendanceProvider = AsyncNotifierProvider<AttendanceNotifier, AttendanceState>(() {
  return AttendanceNotifier();
});
