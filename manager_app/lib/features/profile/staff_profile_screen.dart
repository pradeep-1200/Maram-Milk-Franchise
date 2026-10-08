import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/app_card.dart';
import '../../shared/async_value_widget.dart';
import 'providers/staff_provider.dart';
import '../attendance/models/delivery_person.dart';
import '../routes/providers/route_provider.dart';
import '../authentication/providers/auth_provider.dart';

class StaffProfileScreen extends ConsumerWidget {
  final String dpId;

  const StaffProfileScreen({super.key, required this.dpId});

  Future<void> _uploadDocument(BuildContext context, WidgetRef ref, String type) async {
    try {
      String? filePath;
      if (type == 'photo') {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        filePath = image?.path;
      } else {
        var result = await FilePicker.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        );
        filePath = result?.files.single.path;
      }

      if (filePath != null) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uploading ...')));
        await ref.read(staffProvider.notifier).uploadFile(dpId, filePath, type);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(' uploaded successfully!')));
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: ')));
    }
  }

  Future<void> _showDeletePreviewDialog(BuildContext context, WidgetRef ref, String dpId, String dpName, bool isReadOnly) async {
    if (isReadOnly) return;
    
    final previewFuture = ref.read(staffProvider.notifier).getDeletePreview(dpId);
    final router = GoRouter.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        bool isDeleting = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return FutureBuilder<Map<String, dynamic>>(
              future: previewFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const AlertDialog(
                    content: SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
                  );
                }
                if (snapshot.hasError) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content: Text(snapshot.error.toString()),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                    ],
                  );
                }

                final data = snapshot.data ?? {};
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  title: const Text('Delete Permanently?', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
                  contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Delete $dpName permanently? This will delete all records related to this delivery person, including attendance, route allocations, ledger transactions and bottle logs. This cannot be undone.', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 12),
                        if (data['attendanceRecords'] != null && data['attendanceRecords'] > 0)
                          Text('• Attendance Records: ${data['attendanceRecords']}', style: const TextStyle(fontSize: 14)),
                        if (data['routeAllocations'] != null && data['routeAllocations'] > 0)
                          Text('• Route Allocations: ${data['routeAllocations']}', style: const TextStyle(fontSize: 14)),
                        if (data['ledgerEntries'] != null && data['ledgerEntries'] > 0)
                          Text('• Ledger Transactions: ${data['ledgerEntries']}', style: const TextStyle(fontSize: 14)),
                        if (data['bottleLogs'] != null && data['bottleLogs'] > 0)
                          Text('• Empty Bottle Logs: ${data['bottleLogs']}', style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.green),
                      onPressed: isDeleting ? null : () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: isDeleting ? null : () async {
                        setState(() => isDeleting = true);
                        try {
                          await ref.read(staffProvider.notifier).deleteStaff(dpId);
                          if (context.mounted) {
                            Navigator.pop(context); // Close dialog
                            router.pop(); // Go back from profile using captured router
                            scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Delivery person deleted permanently.')));
                          }
                        } catch (e) {
                          if (context.mounted) {
                            setState(() => isDeleting = false);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                          }
                        }
                      },
                      child: isDeleting 
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Delete'),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReadOnly = ref.watch(authProvider).isReadOnly;
    final theme = Theme.of(context);
    final staffState = ref.watch(staffProvider);

    return AppAsyncWidget<List<DeliveryPerson>>(
      value: staffState,
      onRetry: () => ref.read(staffProvider.notifier).search(''),
      data: (persons) {
        final dp = persons.firstWhere(
          (p) => p.id == dpId,
          orElse: () => DeliveryPerson(
            id: dpId,
            name: 'Unknown',
            employeeId: 'Unknown',
          ),
        );

        final routes = (ref.watch(routeProvider).value?.routes ?? []).where((r) => r.allocations.any((a) => a.dpId == dp.id)).map((r) => r.name).toList();
        final routesAssignedText = routes.isEmpty ? 'Unassigned' : routes.join(', ');

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
            title: const Text('Staff Profile', style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: isReadOnly ? null : () async {
                  final action = await showDialog<String>(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      title: const Text('Manage Delivery Person', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      contentPadding: const EdgeInsets.only(top: 16, bottom: 0),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.person_off, color: Colors.orange),
                            title: const Text('Deactivate', style: TextStyle(fontSize: 14)),
                            subtitle: const Text('Hide from lists but keep records.', style: TextStyle(fontSize: 12)),
                            onTap: () => Navigator.pop(context, 'deactivate'),
                          ),
                          ListTile(
                            leading: const Icon(Icons.delete_forever, color: Colors.red),
                            title: const Text('Delete Permanently', style: TextStyle(fontSize: 14)),
                            subtitle: const Text('Wipe all data and history.', style: TextStyle(fontSize: 12)),
                            onTap: () => Navigator.pop(context, 'delete'),
                          ),
                        ],
                      ),
                      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(foregroundColor: Colors.green),
                          onPressed: () => Navigator.pop(context, null),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  );

                  if (action == 'deactivate' && context.mounted) {
                    bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Deactivate Delivery Person?'),
                        content: const Text('This will hide them from lists but keep their records.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                            onPressed: () => Navigator.pop(context, true), 
                            child: const Text('Deactivate')
                          ),
                        ],
                      ),
                    );
                    
                    if (confirm == true && context.mounted) {
                      try {
                        await ref.read(staffProvider.notifier).deactivateStaff(dp.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delivery person deactivated successfully.')));
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      }
                    }
                  } else if (action == 'delete' && context.mounted) {
                    _showDeletePreviewDialog(context, ref, dp.id, dp.name, isReadOnly);
                  }
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (isReadOnly || dp.id.isEmpty) ? null : () => context.push('/staff-directory/${dp.id}/edit'),
            child: const Icon(Icons.edit),
          ),
          body: ListView(
            padding: const EdgeInsets.only(
              left: AppConstants.spacing16,
              right: AppConstants.spacing16,
              top: AppConstants.spacing16,
              bottom: 100,
            ),
            children: [
              if (!dp.isActive)
                Container(
                  margin: const EdgeInsets.only(bottom: AppConstants.spacing16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.red.shade700, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'This delivery person is deactivated.',
                              style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.end,
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green,
                              side: const BorderSide(color: Colors.green),
                              minimumSize: const Size(0, 40),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            onPressed: isReadOnly ? null : () async {
                              try {
                                await ref.read(staffProvider.notifier).reactivateStaff(dp.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delivery person reactivated.')));
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                }
                              }
                            },
                            child: const Text('Reactivate', style: TextStyle(fontSize: 14)),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red.shade700,
                              side: BorderSide(color: Colors.red.shade700),
                              backgroundColor: Colors.red.shade100,
                              minimumSize: const Size(0, 40),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            onPressed: isReadOnly ? null : () => _showDeletePreviewDialog(context, ref, dp.id, dp.name, isReadOnly),
                            child: const Text('Delete', style: TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              AppCard(
                padding: const EdgeInsets.all(AppConstants.spacing16),
                child: Column(
                  children: [
                    dp.photoUrl != null && dp.photoUrl!.isNotEmpty
                        ? Opacity(
                            opacity: isReadOnly ? 0.5 : 1.0,
                            child: InkWell(
                              onTap: isReadOnly ? null : () => _uploadDocument(context, ref, 'photo'),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(dp.photoUrl!, width: 100, height: 100, fit: BoxFit.cover),
                              ),
                            ),
                          )
                        : Opacity(
                            opacity: isReadOnly ? 0.5 : 1.0,
                            child: _PlaceholderBox(
                              icon: Icons.add_a_photo,
                              label: 'Add photo',
                              isAvatar: true,
                              onTap: isReadOnly ? null : () => _uploadDocument(context, ref, 'photo'),
                            ),
                          ),
                    const SizedBox(height: AppConstants.spacing16),
                    Text(dp.name, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    Text(dp.employeeId, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacing16),

              _SectionCard(
                title: 'Personal',
                icon: Icons.person,
                children: [
                  _DetailRow(label: 'Date of Birth', value: dp.dateOfBirth),
                  _DetailRow(label: 'Address', value: dp.address ?? 'Not added'),
                  _DetailRow(label: 'Zone', value: dp.zone ?? 'Not added'),
                  _DetailRow(label: 'Parent\'s Name & Address', value: dp.parentNameAndAddress),
                  _DetailRow(label: 'Parent\'s/Spouse Mobile', value: dp.parentOrSpouseMobile),
                  _DetailRow(label: 'Alternative Address', value: dp.alternativeAddress),
                  _DetailRow(label: 'Mobile Number', value: dp.mobileNumber),
                  _DetailRow(label: 'Alternative Mobile', value: dp.alternativeMobile),
                  _DetailRow(label: 'WhatsApp Number', value: dp.whatsappNumber),
                ],
              ),
              const SizedBox(height: AppConstants.spacing16),

              _SectionCard(
                title: 'Identity & Documents',
                icon: Icons.badge,
                children: [
                  _DetailRow(label: 'Aadhar Number', value: dp.aadharNumber),
                  _DetailRow(label: 'License Number', value: dp.licenseNumber),
                  _DetailRow(label: 'Vehicle Number', value: dp.vehicleNumber),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: dp.aadharCopyUrl != null && dp.aadharCopyUrl!.isNotEmpty
                            ? Opacity(
                                opacity: isReadOnly ? 0.5 : 1.0,
                                child: InkWell(
                                  onTap: isReadOnly ? null : () => _uploadDocument(context, ref, 'aadhar'),
                                  child: Container(
                                    height: 100,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(border: Border.all(color: theme.dividerColor), borderRadius: BorderRadius.circular(8)),
                                    child: const Text('Aadhar Uploaded\nTap to replace', textAlign: TextAlign.center),
                                  ),
                                ),
                              )
                            : Opacity(
                                opacity: isReadOnly ? 0.5 : 1.0,
                                child: _PlaceholderBox(
                                  icon: Icons.upload_file,
                                  label: 'Upload Aadhar copy',
                                  onTap: isReadOnly ? null : () => _uploadDocument(context, ref, 'aadhar'),
                                ),
                              ),
                      ),
                      const SizedBox(width: AppConstants.spacing16),
                      Expanded(
                        child: dp.licenseCopyUrl != null && dp.licenseCopyUrl!.isNotEmpty
                            ? Opacity(
                                opacity: isReadOnly ? 0.5 : 1.0,
                                child: InkWell(
                                  onTap: isReadOnly ? null : () => _uploadDocument(context, ref, 'license'),
                                  child: Container(
                                    height: 100,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(border: Border.all(color: theme.dividerColor), borderRadius: BorderRadius.circular(8)),
                                    child: const Text('License Uploaded\nTap to replace', textAlign: TextAlign.center),
                                  ),
                                ),
                              )
                            : Opacity(
                                opacity: isReadOnly ? 0.5 : 1.0,
                                child: _PlaceholderBox(
                                  icon: Icons.upload_file,
                                  label: 'Upload license copy',
                                  onTap: isReadOnly ? null : () => _uploadDocument(context, ref, 'license'),
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacing16),

              _SectionCard(
                title: 'Employment',
                icon: Icons.work,
                children: [
                  _DetailRow(label: 'Date of Joining', value: dp.dateOfJoining),
                  _DetailRow(label: 'Route(s) currently assigned', value: routesAssignedText, forceValue: true),
                ],
              ),
              const SizedBox(height: AppConstants.spacing16),

              _SectionCard(
                title: 'Payment Details',
                icon: Icons.account_balance_wallet,
                children: [
                  _DetailRow(label: 'GPAY Number', value: dp.gpayNumber, warningIfEmpty: true),
                  _DetailRow(label: 'UPI ID', value: dp.upiId, warningIfEmpty: true),
                  _DetailRow(label: 'Bank Account Details', value: dp.bankAccountDetails),
                  _DetailRow(
                    label: 'Cumulative PA Balance', 
                    value: dp.petrolBalance == 0 ? '₹0' : (dp.petrolBalance > 0 ? 'Extra ₹${dp.petrolBalance.abs().toStringAsFixed(0)}' : 'Short ₹${dp.petrolBalance.abs().toStringAsFixed(0)}'), 
                    forceValue: true
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: AppConstants.spacing8),
              Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: AppConstants.spacing16),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String? value;
  final bool forceValue;
  final bool warningIfEmpty;

  const _DetailRow({
    required this.label,
    this.value,
    this.forceValue = false,
    this.warningIfEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasData = value != null && value!.isNotEmpty;
    final displayValue = hasData || forceValue ? (value ?? '') : (warningIfEmpty ? 'Not Provided ⚠️' : 'N/A');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 2),
          Text(
            displayValue, 
            style: theme.textTheme.bodyMedium?.copyWith(
              color: hasData || forceValue 
                  ? theme.colorScheme.onSurface 
                  : (warningIfEmpty ? Colors.orange[800] : theme.colorScheme.onSurfaceVariant.withAlpha(150)),
              fontWeight: (!hasData && warningIfEmpty) ? FontWeight.bold : FontWeight.normal,
              fontStyle: hasData || forceValue ? FontStyle.normal : FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isAvatar;
  final VoidCallback? onTap;

  const _PlaceholderBox({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isAvatar = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final box = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(isAvatar ? 100 : 8),
      child: Container(
        width: isAvatar ? 100 : double.infinity,
        height: isAvatar ? 100 : 100,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
          borderRadius: BorderRadius.circular(isAvatar ? 100 : 8),
          border: Border.all(color: theme.dividerColor, style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: theme.colorScheme.onSurfaceVariant, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    return box;
  }
}
