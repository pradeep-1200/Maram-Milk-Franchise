import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/app_button.dart';
import '../../shared/app_card.dart';
import '../routes/models/delivery_route.dart';
import '../attendance/models/delivery_person.dart';
import '../routes/providers/route_provider.dart';
import '../profile/providers/staff_provider.dart';
import 'providers/petrol_allowance_provider.dart';

class PetrolAllowanceSheet extends ConsumerStatefulWidget {
  final DeliveryRoute route;
  final DeliveryPerson dp;
  final bool isInStepFlow;

  const PetrolAllowanceSheet({
    super.key,
    required this.route,
    required this.dp,
    this.isInStepFlow = false,
  });

  @override
  ConsumerState<PetrolAllowanceSheet> createState() => _PetrolAllowanceSheetState();
}

class _PetrolAllowanceSheetState extends ConsumerState<PetrolAllowanceSheet> {
  bool _isEditing = false;
  bool _isSubmitting = false;
  late TextEditingController _amountController;
  late FocusNode _amountFocusNode;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _amountFocusNode = FocusNode();
    _amountFocusNode.addListener(_onFocusChange);
    // Initialize state with the actual given amount if editing, or fallback to fixed allowance
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('PA Popup Open -> route.petrolAllowanceGiven: ${widget.route.petrolAllowanceGiven}, route.fixedPetrolAllowance: ${widget.route.fixedPetrolAllowance}, dp.petrolBalance: ${widget.dp.petrolBalance}');
      final initialAmount = widget.route.petrolAllowanceGiven ?? widget.route.fixedPetrolAllowance;
      ref.read(petrolAllowanceProvider.notifier).init(initialAmount);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_amountFocusNode.hasFocus) {
      _commitAmount();
    }
  }

  void _commitAmount() {
    if (!_isEditing) return;
    setState(() {
      _isEditing = false;
    });
    final text = _amountController.text;
    final intValue = int.tryParse(text);
    if (intValue != null && intValue >= 0) {
      ref.read(petrolAllowanceProvider.notifier).setAmount(intValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final givenAmount = ref.watch(petrolAllowanceProvider);
    final notifier = ref.read(petrolAllowanceProvider.notifier);
    
    final fixedPA = widget.route.fixedPetrolAllowance;
    final diff = givenAmount - fixedPA;

    String statusTitle;
    String statusAmountText;
    Color statusColor;

    if (diff > 0) {
      statusTitle = 'Extra Paid';
      statusAmountText = '+₹$diff';
      statusColor = Colors.orange;
    } else if (diff < 0) {
      statusTitle = 'Short Paid';
      statusAmountText = '-₹${diff.abs()}';
      statusColor = Colors.red;
    } else {
      statusTitle = 'Fully Paid';
      statusAmountText = '₹0';
      statusColor = theme.colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.only(
        top: AppConstants.spacing16,
        bottom: AppConstants.spacing16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Petrol Allowance',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: AppConstants.spacing4),
                      Text(
                        widget.route.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppConstants.spacing4),
                      Text(
                        'Assigned to: ${widget.dp.name} (${widget.dp.employeeId})',
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppConstants.spacing4),
                      Builder(
                        builder: (context) {
                          final staffState = ref.watch(staffProvider).value ?? [];
                          final realDp = staffState.firstWhere(
                            (p) => p.id == widget.dp.id, 
                            orElse: () => widget.dp,
                          );
                          final balance = realDp.petrolBalance;
                          final initialAmount = widget.route.petrolAllowanceGiven ?? widget.route.fixedPetrolAllowance;
                          final givenAmount = ref.watch(petrolAllowanceProvider);
                          
                          final previewBalance = balance + (givenAmount - initialAmount);
                          final isPreview = givenAmount != initialAmount;
                          
                          String text;
                          Color color;
                          if (previewBalance > 0) {
                            text = '${isPreview ? "Preview" : "Current"} Balance: Extra ₹${previewBalance.abs().toStringAsFixed(0)}';
                            color = Colors.teal;
                          } else if (previewBalance < 0) {
                            text = '${isPreview ? "Preview" : "Current"} Balance: Short ₹${previewBalance.abs().toStringAsFixed(0)}';
                            color = Colors.orange;
                          } else {
                            text = '${isPreview ? "Preview" : "Current"} Balance: Balanced';
                            color = Colors.grey;
                          }
                          return Text(
                            text,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (!widget.isInStepFlow)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => context.pop(),
                  ),
              ],
            ),
          ),
          const Divider(),

          Padding(
            padding: const EdgeInsets.all(AppConstants.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Fixed Petrol Allowance Card
                AppCard(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16, vertical: AppConstants.spacing8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.local_gas_station, color: theme.colorScheme.onPrimaryContainer),
                      ),
                      const SizedBox(width: AppConstants.spacing16),
                      Expanded(
                        child: Text(
                          'Fixed Petrol Allowance',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        '₹$fixedPA',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.spacing16),

                // Amount Given Today Stepper
                Text(
                  'Amount Given Today',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.spacing16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, size: 32),
                      color: givenAmount > 0 ? theme.colorScheme.primary : theme.disabledColor,
                      onPressed: givenAmount > 0 ? () => notifier.updateAmount(-10) : null,
                    ),
                    const SizedBox(width: AppConstants.spacing16),
                    _isEditing
                        ? SizedBox(
                            width: 120,
                            child: TextField(
                              controller: _amountController,
                              focusNode: _amountFocusNode,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                              decoration: const InputDecoration(
                                prefixText: '₹',
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 4),
                              ),
                              onSubmitted: (_) => _commitAmount(),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              _amountController.text = givenAmount.toString();
                              setState(() {
                                _isEditing = true;
                              });
                              _amountFocusNode.requestFocus();
                            },
                            child: Text(
                              '₹$givenAmount',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                    const SizedBox(width: AppConstants.spacing16),
                    IconButton(
                      icon: const Icon(Icons.add_circle, size: 32),
                      color: theme.colorScheme.primary,
                      onPressed: () => notifier.updateAmount(10),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacing16),

                // Three-column Summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _SummaryColumn(
                      title: 'Fixed Allowance',
                      amountText: '₹$fixedPA',
                      color: theme.colorScheme.onSurface,
                    ),
                    _SummaryColumn(
                      title: 'Given',
                      amountText: '₹$givenAmount',
                      color: theme.colorScheme.primary,
                    ),
                    _SummaryColumn(
                      title: statusTitle,
                      amountText: statusAmountText,
                      color: statusColor,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacing16),

                // Action Button
                AppButton(
                  text: 'Save & Complete',
                  isLoading: _isSubmitting,
                  onPressed: (givenAmount > 0 && !_isSubmitting) ? () async {
                    setState(() => _isSubmitting = true);
                    try {
                      await ref.read(routeProvider.notifier).markPetrolAllowanceComplete(widget.route.id, givenAmount);
                      if (context.mounted) {
                        if (widget.isInStepFlow) {
                          context.go('/dashboard');
                        } else {
                          context.pop();
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to save: $e'), backgroundColor: Colors.red),
                        );
                      }
                    } finally {
                      if (mounted) {
                        setState(() => _isSubmitting = false);
                      }
                    }
                  } : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryColumn extends StatelessWidget {
  final String title;
  final String amountText;
  final Color color;

  const _SummaryColumn({
    required this.title,
    required this.amountText,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: AppConstants.spacing4),
        Text(
          amountText,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
