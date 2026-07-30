import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/app_card.dart';
import '../../shared/app_text_field.dart';
import '../../shared/async_value_widget.dart';
import '../../shared/dp_avatar.dart';
import 'providers/dp_performance_provider.dart';
import 'models/dp_performance_report.dart';

class DpPerformanceScreen extends ConsumerStatefulWidget {
  final String initialPeriod;
  final String initialSort;

  const DpPerformanceScreen({
    super.key,
    this.initialPeriod = 'month',
    this.initialSort = 'litres',
  });

  @override
  ConsumerState<DpPerformanceScreen> createState() => _DpPerformanceScreenState();
}

class _DpPerformanceScreenState extends ConsumerState<DpPerformanceScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(dpPerformanceProvider.notifier);
      notifier.setPeriod(widget.initialPeriod);
      
      switch (widget.initialSort) {
        case 'litres':
          notifier.setSortOption(DpSortOption.litres);
          break;
        case 'routes':
          notifier.setSortOption(DpSortOption.routes);
          break;
        case 'attendance':
          notifier.setSortOption(DpSortOption.attendance);
          break;
        case 'bottles':
          notifier.setSortOption(DpSortOption.bottles);
          break;
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<DateTimeRange?> _selectCustomDateRange() async {
    final state = ref.read(dpPerformanceProvider).value;
    final now = DateTime.now();
    return await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
      initialDateRange: state?.customDateRange ?? DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now),
    );
  }

  Future<void> _exportReport() async {
    final state = ref.read(dpPerformanceProvider).value;
    if (state == null || state.filteredReports.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No data available to export.')),
        );
      }
      return;
    }

    try {
      List<List<dynamic>> rows = [
        ['Rank', 'DP Name', 'DP Code', 'Total Litres', 'Total Routes', 'Attendance', 'Bottles Collected (1L)', 'Bottles Collected (1/2L)', 'Total Bottles Collected']
      ];

      for (int i = 0; i < state.filteredReports.length; i++) {
        final dp = state.filteredReports[i];
        rows.add([
          i + 1,
          dp.name,
          dp.dpCode,
          dp.totalLitres,
          dp.totalRoutes,
          dp.attendanceRatio,
          dp.total1LBottles,
          dp.totalHalfLBottles,
          dp.totalBottles,
        ]);
      }

      String csvData = const ListToCsvConverter().convert(rows);

      final directory = await getTemporaryDirectory();
      
      String periodLabel = state.period;
      if (state.period == 'custom' && state.customDateRange != null) {
        final start = DateFormat('yyyy-MM-dd').format(state.customDateRange!.start);
        final end = DateFormat('yyyy-MM-dd').format(state.customDateRange!.end);
        periodLabel = 'Custom_${start}_to_$end';
      } else if (state.period == 'today') {
        periodLabel = 'Today_${DateFormat('yyyy-MM-dd').format(DateTime.now())}';
      } else {
        periodLabel = '${state.period}_${DateFormat('yyyyMMdd').format(DateTime.now())}';
      }

      final path = '${directory.path}/DP_Performance_Report_$periodLabel.csv';
      final file = File(path);
      await file.writeAsString(csvData);

      final xfile = XFile(path);
      if (mounted) {
        // ignore: deprecated_member_use
        await Share.shareXFiles([xfile], text: 'DP Performance Report');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final asyncState = ref.watch(dpPerformanceProvider);
    final notifier = ref.read(dpPerformanceProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/dashboard');
            }
          },
        ),
        title: const Text('DP Performance Report', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportReport,
            tooltip: 'Download Report',
          ),
        ],
      ),
      body: AppAsyncWidget<DpPerformanceState>(
        value: asyncState,
        data: (state) {
          final aggregatedData = state.filteredReports;
          
          return Column(
            children: [
              // Controls Section
              Container(
                padding: const EdgeInsets.all(AppConstants.spacing16),
                color: theme.colorScheme.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Date Range Control
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterChip(
                            label: 'Today',
                            isSelected: state.period == 'today',
                            onSelected: () => notifier.setPeriod('today'),
                          ),
                          const SizedBox(width: AppConstants.spacing8),
                          _FilterChip(
                            label: 'This Week',
                            isSelected: state.period == 'week',
                            onSelected: () => notifier.setPeriod('week'),
                          ),
                          const SizedBox(width: AppConstants.spacing8),
                          _FilterChip(
                            label: 'This Month',
                            isSelected: state.period == 'month',
                            onSelected: () => notifier.setPeriod('month'),
                          ),
                          const SizedBox(width: AppConstants.spacing8),
                          _FilterChip(
                            label: 'Custom',
                            isSelected: state.period == 'custom',
                            onSelected: () async {
                              final picked = await _selectCustomDateRange();
                              if (picked != null) {
                                notifier.setCustomDateRange(picked);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    if (state.period == 'custom' && state.customDateRange != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '${DateFormat('MMM d, yyyy').format(state.customDateRange!.start)} - ${DateFormat('MMM d, yyyy').format(state.customDateRange!.end)}',
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: AppConstants.spacing16),
                    
                    // Sort Control and Search
                    Row(
                      children: [
                        SizedBox(
                          width: 140,
                          child: DropdownButtonFormField<DpSortOption>(
                            value: state.sortOption,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Sort By',
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(value: DpSortOption.litres, child: Text('Litres', overflow: TextOverflow.ellipsis)),
                              DropdownMenuItem(value: DpSortOption.routes, child: Text('Routes', overflow: TextOverflow.ellipsis)),
                              DropdownMenuItem(value: DpSortOption.attendance, child: Text('Attd', overflow: TextOverflow.ellipsis)),
                              DropdownMenuItem(value: DpSortOption.bottles, child: Text('Bottles Collected', overflow: TextOverflow.ellipsis)),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                notifier.setSortOption(val);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: AppTextField(
                            controller: _searchController,
                            hintText: 'Search Name/ID',
                            prefixIcon: const Icon(Icons.search),
                            onChanged: (val) {
                              notifier.setSearchQuery(val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const Divider(height: 1),
              
              // List Section
              Expanded(
                child: aggregatedData.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bar_chart, size: 64, color: theme.colorScheme.onSurfaceVariant.withAlpha(100)),
                            const SizedBox(height: 16),
                            Text('No performance data found.', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16, vertical: 8),
                        itemCount: aggregatedData.length,
                        itemBuilder: (context, index) {
                          final item = aggregatedData[index];
                          return _DpPerformanceCard(
                            dp: item,
                            rank: index + 1,
                            sortOption: state.sortOption,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ActionChip(
      label: Text(label),
      backgroundColor: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surface,
      labelStyle: TextStyle(
        color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
      ),
      onPressed: onSelected,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _DpPerformanceCard extends StatelessWidget {
  final DpPerformanceReport dp;
  final int rank;
  final DpSortOption sortOption;

  const _DpPerformanceCard({
    required this.dp,
    required this.rank,
    required this.sortOption,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Highlight the sorted metric
    final isLitresSorted = sortOption == DpSortOption.litres;
    final isRoutesSorted = sortOption == DpSortOption.routes;
    final isAttendanceSorted = sortOption == DpSortOption.attendance;
    final isBottlesSorted = sortOption == DpSortOption.bottles;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: AppCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Rank & Avatar
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: rank == 1 ? Colors.amber : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '#$rank',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: rank == 1 ? Colors.black : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  DpAvatar(
                    photoUrl: dp.photoUrl,
                    name: dp.name,
                    radius: 16,
                  ),
                ],
              ),
              const SizedBox(width: 12),
              
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      text: TextSpan(
                        text: dp.name,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: ' · ${dp.dpCode}',
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Metrics Row (4 columns)
                    Row(
                      children: [
                        Expanded(flex: 2, child: _CompactMetric(label: 'Litres', value: '${dp.totalLitres}L', isHighlighted: isLitresSorted)),
                        Expanded(flex: 2, child: _CompactMetric(label: 'Routes', value: '${dp.totalRoutes}', isHighlighted: isRoutesSorted)),
                        Expanded(flex: 3, child: _CompactMetric(label: 'Attd', value: dp.attendanceRatio, isHighlighted: isAttendanceSorted)),
                        Expanded(flex: 4, child: _CompactMetric(label: 'Bottles Collected', value: '1L(${dp.total1LBottles})+1/2L(${dp.totalHalfLBottles})', isHighlighted: isBottlesSorted)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactMetric extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlighted;

  const _CompactMetric({
    required this.label,
    required this.value,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 10,
            color: isHighlighted ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: isHighlighted ? theme.colorScheme.primary : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
