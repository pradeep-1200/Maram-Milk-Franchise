import 'package:freezed_annotation/freezed_annotation.dart';

part 'dp_performance_report.freezed.dart';
part 'dp_performance_report.g.dart';

@freezed
abstract class DpPerformanceReport with _$DpPerformanceReport {
  const factory DpPerformanceReport({
    required String dpId,
    required String dpCode,
    required String name,
    String? photoUrl,
    required double totalLitres,
    required int totalRoutes,
    required String attendanceRatio,
    required int totalBottles,
    @Default(0) int total1LBottles,
    @Default(0) int totalHalfLBottles,
  }) = _DpPerformanceReport;

  factory DpPerformanceReport.fromJson(Map<String, dynamic> json) => _$DpPerformanceReportFromJson(json);
}
