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
  int _actualDelivered1L = 0;
  int _actualDeliveredHalfL = 0;
  int _actualDeliveredPacket = 0;

  int _bottles1L = 0;
  int _bottlesHalfL = 0;
  int _packets = 0;
  
  bool _flag = false;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    final status = (ref.read(eveningCheckProvider).value?.statuses ?? []).firstWhere((r) => r.routeId == widget.routeId);
    
    _actualDelivered1L = status.actualDelivered1L;
    _actualDeliveredHalfL = status.actualDeliveredHalfL;
    _actualDeliveredPacket = status.actualDeliveredPacket;

    _bottles1L = status.oneLBottlesCollected;
    _bottlesHalfL = status.halfLBottlesCollected;
    _packets = status.halfLPacketCollected;
    
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
      halfLPacketCollected: _packets,
      actualDelivered1L: _actualDelivered1L,
      actualDeliveredHalfL: _actualDeliveredHalfL,
      actualDeliveredPacket: _actualDeliveredPacket,
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

    // Calculate dynamic expected based on Carry Over + Actually Delivered
    // Wait, the status doesn't have carriedOver, but we know:
    // Expected (displayed initially) was Carry Over + Allocated.
    // So Carry Over = status.expected1LBottles - status.actualDelivered1L (which was initialized to allocated)
    final carryOver1L = status.expected1LBottles - status.actualDelivered1L;
    final carryOverHalfL = status.expectedHalfLBottles - status.actualDeliveredHalfL;
    final carryOverPacket = status.expectedHalfLPacket - status.actualDeliveredPacket;

    final currentExpected1L = carryOver1L + _actualDelivered1L;
    final currentExpectedHalfL = carryOverHalfL + _actualDeliveredHalfL;
    final currentExpectedPacket = carryOverPacket + _actualDeliveredPacket;

    return Padding(
      padding: EdgeInsets.only(
        left: AppConstants.spacing16,
        right: AppConstants.spacing16,
        top: AppConstants.spacing24,
        bottom: bottomPadding + AppConstants.spacing24,
      ),
      child: SingleChildScrollView(
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

          Text('Actually Delivered', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppConstants.spacing8),
          
          _StepperRow(
            title: '1L Bottles Delivered',
            value: _actualDelivered1L,
            onChanged: (val) {
              setState(() {
                _actualDelivered1L = val;
                if (_bottles1L > carryOver1L + _actualDelivered1L) _bottles1L = carryOver1L + _actualDelivered1L;
              });
            },
          ),
          const Divider(),
          _StepperRow(
            title: 'Half L Bottles Delivered',
            value: _actualDeliveredHalfL,
            onChanged: (val) {
              setState(() {
                _actualDeliveredHalfL = val;
                if (_bottlesHalfL > carryOverHalfL + _actualDeliveredHalfL) _bottlesHalfL = carryOverHalfL + _actualDeliveredHalfL;
              });
            },
          ),
          const Divider(),
          _StepperRow(
            title: 'Half L Packets Delivered',
            value: _actualDeliveredPacket,
            onChanged: (val) {
              setState(() {
                _actualDeliveredPacket = val;
                if (_packets > carryOverPacket + _actualDeliveredPacket) _packets = carryOverPacket + _actualDeliveredPacket;
              });
            },
          ),

          const SizedBox(height: AppConstants.spacing24),
          Text('Collected Returns', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppConstants.spacing8),
          
          _StepperRow(
            title: '1L Bottles Collected',
            subtitle: 'Expected: $currentExpected1L',
            value: _bottles1L,
            maxValue: currentExpected1L,
            onChanged: (val) => setState(() => _bottles1L = val),
          ),
          const Divider(),
          _StepperRow(
            title: 'Half L Bottles Collected',
            subtitle: 'Expected: $currentExpectedHalfL',
            value: _bottlesHalfL,
            maxValue: currentExpectedHalfL,
            onChanged: (val) => setState(() => _bottlesHalfL = val),
          ),
          const Divider(),
          _StepperRow(
            title: 'Half L Packets Collected',
            subtitle: 'Expected: $currentExpectedPacket',
            value: _packets,
            maxValue: currentExpectedPacket,
            onChanged: (val) => setState(() => _packets = val),
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
      ),
    );
  }
}

class _StepperRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final int value;
  final int? maxValue;
  final ValueChanged<int> onChanged;

  const _StepperRow({
    required this.title,
    this.subtitle,
    required this.value,
    this.maxValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canIncrement = maxValue == null || value < maxValue!;
    
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
                color: canIncrement ? theme.colorScheme.primary : theme.disabledColor,
                onPressed: canIncrement ? () => onChanged(value + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
