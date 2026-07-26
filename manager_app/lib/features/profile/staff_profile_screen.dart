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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uploading $type...')));
        await ref.read(staffProvider.notifier).uploadFile(dpId, filePath, type);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$type uploaded successfully!')));
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

        final routes = (ref.watch(routeProvider).value?.routes ?? []).where((r) => r.assignedDpId == dp.id).map((r) => r.name).toList();
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
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Delivery Person?'),
                      content: const Text('Are you sure you want to delete this delivery person? This action will mark them as inactive.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    try {
                      await ref.read(staffProvider.notifier).deleteStaff(dp.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delivery person deleted successfully.')));
                        context.pop();
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }
                  }
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.push('/staff-directory/${dp.id}/edit'),
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
              AppCard(
                padding: const EdgeInsets.all(AppConstants.spacing16),
                child: Column(
                  children: [
                    dp.photoUrl != null && dp.photoUrl!.isNotEmpty
                        ? InkWell(
                            onTap: () => _uploadDocument(context, ref, 'photo'),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(dp.photoUrl!, width: 100, height: 100, fit: BoxFit.cover),
                            ),
                          )
                        : _PlaceholderBox(
                            icon: Icons.add_a_photo,
                            label: 'Add photo',
                            isAvatar: true,
                            onTap: () => _uploadDocument(context, ref, 'photo'),
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
                            ? InkWell(
                                onTap: () => _uploadDocument(context, ref, 'aadhar'),
                                child: Container(
                                  height: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(border: Border.all(color: theme.dividerColor), borderRadius: BorderRadius.circular(8)),
                                  child: const Text('Aadhar Uploaded\nTap to replace', textAlign: TextAlign.center),
                                ),
                              )
                            : _PlaceholderBox(
                                icon: Icons.upload_file,
                                label: 'Upload Aadhar copy',
                                onTap: () => _uploadDocument(context, ref, 'aadhar'),
                              ),
                      ),
                      const SizedBox(width: AppConstants.spacing16),
                      Expanded(
                        child: dp.licenseCopyUrl != null && dp.licenseCopyUrl!.isNotEmpty
                            ? InkWell(
                                onTap: () => _uploadDocument(context, ref, 'license'),
                                child: Container(
                                  height: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(border: Border.all(color: theme.dividerColor), borderRadius: BorderRadius.circular(8)),
                                  child: const Text('License Uploaded\nTap to replace', textAlign: TextAlign.center),
                                ),
                              )
                            : _PlaceholderBox(
                                icon: Icons.upload_file,
                                label: 'Upload license copy',
                                onTap: () => _uploadDocument(context, ref, 'license'),
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
                  _DetailRow(label: 'GPAY Number', value: dp.gpayNumber),
                  _DetailRow(label: 'UPI ID', value: dp.upiId),
                  _DetailRow(label: 'Bank Account Details', value: dp.bankAccountDetails),
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

  const _DetailRow({
    required this.label,
    this.value,
    this.forceValue = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasData = value != null && value!.isNotEmpty;
    final displayValue = hasData || forceValue ? (value ?? '') : 'Not added';

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
              color: hasData || forceValue ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant.withAlpha(150),
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
  final VoidCallback onTap;

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
