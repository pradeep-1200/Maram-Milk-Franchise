import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/daily_report.dart';

class ReportNotifier extends Notifier<DailyReport?> {
  @override
  DailyReport? build() {
    return null;
  }

  void saveDailyReport(DailyReport report) {
    state = report;
  }
}

final reportProvider = NotifierProvider<ReportNotifier, DailyReport?>(() {
  return ReportNotifier();
});
