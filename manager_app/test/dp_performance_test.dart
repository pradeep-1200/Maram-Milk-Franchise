import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:manager_app/features/reports/providers/dp_performance_provider.dart';
import 'package:manager_app/features/reports/models/dp_performance_report.dart';

void main() {
  test('DP Performance Provider preserves backend sorting and correctly filters for export', () {
    final reports = [
      const DpPerformanceReport(
        dpId: '1', dpCode: 'DP1', name: 'Alice', totalLitres: 100,
        totalRoutes: 2, attendanceRatio: '2 of 2',
        totalBottles: 10, total1LBottles: 5, totalHalfLBottles: 5, totalPackets: 0,
        totalPetrolAllowance: 50, photoUrl: '',
      ),
      const DpPerformanceReport(
        dpId: '2', dpCode: 'DP2', name: 'Bob', totalLitres: 80,
        totalRoutes: 2, attendanceRatio: '2 of 2',
        totalBottles: 8, total1LBottles: 4, totalHalfLBottles: 4, totalPackets: 0,
        totalPetrolAllowance: 40, photoUrl: '',
      ),
      const DpPerformanceReport(
        dpId: '3', dpCode: 'DP3', name: 'Charlie', totalLitres: 120,
        totalRoutes: 3, attendanceRatio: '3 of 3',
        totalBottles: 15, total1LBottles: 10, totalHalfLBottles: 5, totalPackets: 0,
        totalPetrolAllowance: 60, photoUrl: '',
      ),
    ];

    // Simulate backend returning it sorted by Litres descending
    final List<DpPerformanceReport> sortedByLitres = [reports[2], reports[0], reports[1]];

    var state = DpPerformanceState(
      reports: sortedByLitres,
      searchQuery: '',
      period: 'today',
    );

    // 1. Assert full list matches on-screen order (which is state.filteredReports)
    expect(state.filteredReports.length, 3);
    expect(state.filteredReports[0].name, 'Charlie');
    expect(state.filteredReports[1].name, 'Alice');
    expect(state.filteredReports[2].name, 'Bob');

    // 2. Assert search filter preserves order of the filtered subset
    state = state.copyWith(searchQuery: 'a'); // Matches Charlie and Alice
    
    expect(state.filteredReports.length, 2);
    expect(state.filteredReports[0].name, 'Charlie'); // Still first (120 L)
    expect(state.filteredReports[1].name, 'Alice');   // Still second (100 L)
  });
}
