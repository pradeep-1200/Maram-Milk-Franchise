import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/app_card.dart';
import '../../shared/app_text_field.dart';
import '../../shared/async_value_widget.dart';
import '../../shared/dp_avatar.dart';
import 'providers/staff_provider.dart';
import '../attendance/models/delivery_person.dart';

class StaffDirectoryScreen extends ConsumerStatefulWidget {
  const StaffDirectoryScreen({super.key});

  @override
  ConsumerState<StaffDirectoryScreen> createState() => _StaffDirectoryScreenState();
}

class _StaffDirectoryScreenState extends ConsumerState<StaffDirectoryScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final staffState = ref.watch(staffProvider);

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
        title: const Text('Staff Directory', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/staff-directory/add'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacing16),
            child: AppTextField(
              controller: _searchController,
              hintText: 'Search by Name or ID...',
              prefixIcon: const Icon(Icons.search),
              onChanged: (query) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  ref.read(staffProvider.notifier).search(query);
                });
              },
            ),
          ),
          
          Expanded(
            child: AppAsyncWidget<List<DeliveryPerson>>(
              value: staffState,
              onRetry: () => ref.read(staffProvider.notifier).search(_searchController.text),
              data: (persons) {
                if (persons.isEmpty) {
                  return Center(
                    child: Text(
                      'No staff found.',
                      style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16, vertical: 8.0),
                  itemCount: persons.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppConstants.spacing8),
                  itemBuilder: (context, index) {
                    final dp = persons[index];
                    return _StaffDirectoryCard(person: dp);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StaffDirectoryCard extends StatelessWidget {
  final DeliveryPerson person;

  const _StaffDirectoryCard({required this.person});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: () => context.push('/staff-directory/${person.id}'),
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16, vertical: 12.0),
      child: Row(
        children: [
          DpAvatar(
            photoUrl: person.photoUrl,
            name: person.name,
            radius: 24,
          ),
          const SizedBox(width: AppConstants.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      person.employeeId,
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    if (person.zone?.isNotEmpty ?? false) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          person.zone ?? '',
                          style: TextStyle(
                            color: theme.colorScheme.onSecondaryContainer,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}
