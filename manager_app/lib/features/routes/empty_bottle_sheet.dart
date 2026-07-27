import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/app_button.dart';
import '../../shared/app_text_field.dart';
import '../evening_check/providers/evening_check_provider.dart';

class EmptyBottleSheet extends ConsumerStatefulWidget {
  final String routeId;

  const EmptyBottleSheet({super.key, required this.routeId});

  @override
  ConsumerState<EmptyBottleSheet> createState() => _EmptyBottleSheetState();
}

class _EmptyBottleSheetState extends ConsumerState<EmptyBottleSheet> {
  int _bottles1L = 0;
  int _bottlesHalfL = 0;
  bool _flag = false;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    final status = (ref.read(eveningCheckProvider).value?.statuses ?? []).firstWhere((r) => r.routeId == widget.routeId);
    _bottles1L = status.oneLBottlesCollected;
    _bottlesHalfL = status.halfLBottlesCollected;
    _flag = status.flagIssue;
    _noteController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    ref.read(eveningCheckProvider.notifier).updateStatus(
      widget.routeId,
      deliveryCompleted: true,
      oneLBottlesCollected: _bottles1L,
      halfLBottlesCollected: _bottlesHalfL,
      flagIssue: _flag,
    );
    context.pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bottle collection saved'), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statuses = ref.watch(eveningCheckProvider).value?.statuses ?? [];
    final status = statuses.firstWhere((r) => r.routeId == widget.routeId);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: AppConstants.spacing16,
        right: AppConstants.spacing16,
        top: AppConstants.spacing24,
        bottom: bottomPadding + AppConstants.spacing24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Empty Bottles',
                style: theme.textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacing16),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withAlpha(100),
              borderRadius: BorderRadius.circular(AppConstants.cardRadius),
            ),
            child: Row(
              children: [
                Icon(Icons.map, color: theme.colorScheme.primary),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(status.routeName, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text('DP: ${status.dpName ?? "Unassigned"}', style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                Text('Today', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacing24),
          
          Text('Collected Bottles', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppConstants.spacing8),
          
          _StepperRow(
            title: '1L Bottles Collected',
            subtitle: 'Expected: ${status.expected1LBottles}',
            value: _bottles1L,
            onChanged: (val) => setState(() => _bottles1L = val),
          ),
          const Divider(),
          _StepperRow(
            title: 'Half L Bottles Collected',
            subtitle: 'Expected: ${status.expectedHalfLBottles}',
            value: _bottlesHalfL,
            onChanged: (val) => setState(() => _bottlesHalfL = val),
          ),
          
          const SizedBox(height: AppConstants.spacing24),
          Text('Issues', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppConstants.spacing8),
          
          SwitchListTile(
            title: Text('Flag: Customers not returning bottles', style: theme.textTheme.bodyMedium),
            value: _flag,
            onChanged: (val) => setState(() => _flag = val),
            contentPadding: EdgeInsets.zero,
            activeColor: theme.colorScheme.primary,
          ),
          
          if (_flag) ...[
            const SizedBox(height: AppConstants.spacing8),
            AppTextField(
              controller: _noteController,
              labelText: 'Note (Optional)',
              hintText: 'e.g., Shop #4 short by 5 bottles',
            ),
          ],
          
          const SizedBox(height: AppConstants.spacing24),
          AppButton(
            text: 'Save Collection',
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}

class _StepperRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final int value;
  final ValueChanged<int> onChanged;

  const _StepperRow({
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.bodyMedium),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color: value > 0 ? theme.colorScheme.primary : theme.disabledColor,
                onPressed: value > 0 ? () => onChanged(value - 1) : null,
              ),
              SizedBox(
                width: 40,
                child: Text(
                  value.toString(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: theme.colorScheme.primary,
                onPressed: () => onChanged(value + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
