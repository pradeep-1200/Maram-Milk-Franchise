import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/app_button.dart';
import '../../shared/app_text_field.dart';
import 'providers/staff_provider.dart';
import '../attendance/models/delivery_person.dart';

class StaffProfileEditScreen extends ConsumerStatefulWidget {
  final String? dpId;

  const StaffProfileEditScreen({super.key, this.dpId});

  @override
  ConsumerState<StaffProfileEditScreen> createState() => _StaffProfileEditScreenState();
}

class _StaffProfileEditScreenState extends ConsumerState<StaffProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _employeeIdController;
  late TextEditingController _addressController;
  late TextEditingController _zoneController;
  late TextEditingController _dobController;
  late TextEditingController _parentNameController;
  late TextEditingController _parentMobileController;
  late TextEditingController _currentAddressController;
  late TextEditingController _mobileController;
  late TextEditingController _altMobileController;
  late TextEditingController _whatsappController;
  
  late TextEditingController _aadharController;
  late TextEditingController _licenseController;
  late TextEditingController _vehicleController;
  
  late TextEditingController _dojController;
  
  late TextEditingController _gpayController;
  late TextEditingController _upiController;
  late TextEditingController _bankController;

  bool _isLoading = false;
  
  String? _selectedPhotoPath;
  String? _existingPhotoUrl;

  @override
  void initState() {
    super.initState();
    final persons = ref.read(staffProvider).value ?? [];
    final dp = widget.dpId != null 
        ? persons.firstWhere(
            (p) => p.id == widget.dpId,
            orElse: () => DeliveryPerson(
              id: widget.dpId ?? '',
              name: 'Unknown',
              employeeId: 'Unknown',
            ),
          )
        : null;

    _existingPhotoUrl = dp?.photoUrl;

    _nameController = TextEditingController(text: dp?.name ?? '');
    _employeeIdController = TextEditingController(text: dp?.employeeId ?? '');
    _addressController = TextEditingController(text: dp?.address ?? '');
    _zoneController = TextEditingController(text: dp?.zone ?? '');
    _dobController = TextEditingController(text: dp?.dateOfBirth ?? '');
    _parentNameController = TextEditingController(text: dp?.parentNameAndAddress ?? '');
    _parentMobileController = TextEditingController(text: dp?.parentOrSpouseMobile ?? '');
    _currentAddressController = TextEditingController(text: dp?.alternativeAddress ?? '');
    _mobileController = TextEditingController(text: dp?.mobileNumber ?? '');
    _altMobileController = TextEditingController(text: dp?.alternativeMobile ?? '');
    _whatsappController = TextEditingController(text: dp?.whatsappNumber ?? '');

    _aadharController = TextEditingController(text: dp?.aadharNumber ?? '');
    _licenseController = TextEditingController(text: dp?.licenseNumber ?? '');
    _vehicleController = TextEditingController(text: dp?.vehicleNumber ?? '');

    _dojController = TextEditingController(text: dp?.dateOfJoining ?? '');

    _gpayController = TextEditingController(text: dp?.gpayNumber ?? '');
    _upiController = TextEditingController(text: dp?.upiId ?? '');
    _bankController = TextEditingController(text: dp?.bankAccountDetails ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _employeeIdController.dispose();
    _addressController.dispose();
    _zoneController.dispose();
    _dobController.dispose();
    _parentNameController.dispose();
    _parentMobileController.dispose();
    _currentAddressController.dispose();
    _mobileController.dispose();
    _altMobileController.dispose();
    _whatsappController.dispose();
    _aadharController.dispose();
    _licenseController.dispose();
    _vehicleController.dispose();
    _dojController.dispose();
    _gpayController.dispose();
    _upiController.dispose();
    _bankController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final notifier = ref.read(staffProvider.notifier);
        final isAdd = widget.dpId == null;

        if (isAdd) {
          final newDp = DeliveryPerson(
            id: '', // Backend generates ID
            name: _nameController.text.trim(),
            employeeId: '', // Backend generates dpCode
            address: _addressController.text.trim(),
            zone: _zoneController.text.trim(),
            mobileNumber: _mobileController.text.trim().isEmpty ? '' : _mobileController.text.trim(),
            status: AttendanceStatus.present,
            dateOfBirth: _dobController.text.trim().isEmpty ? null : _dobController.text.trim(),
            parentNameAndAddress: _parentNameController.text.trim().isEmpty ? null : _parentNameController.text.trim(),
            parentOrSpouseMobile: _parentMobileController.text.trim().isEmpty ? null : _parentMobileController.text.trim(),
            alternativeAddress: _currentAddressController.text.trim().isEmpty ? null : _currentAddressController.text.trim(),
            alternativeMobile: _altMobileController.text.trim().isEmpty ? null : _altMobileController.text.trim(),
            whatsappNumber: _whatsappController.text.trim().isEmpty ? null : _whatsappController.text.trim(),
            aadharNumber: _aadharController.text.trim().isEmpty ? null : _aadharController.text.trim(),
            licenseNumber: _licenseController.text.trim().isEmpty ? null : _licenseController.text.trim(),
            vehicleNumber: _vehicleController.text.trim().isEmpty ? null : _vehicleController.text.trim(),
            dateOfJoining: _dojController.text.trim().isEmpty ? null : _dojController.text.trim(),
            gpayNumber: _gpayController.text.trim().isEmpty ? null : _gpayController.text.trim(),
            upiId: _upiController.text.trim().isEmpty ? null : _upiController.text.trim(),
            bankAccountDetails: _bankController.text.trim().isEmpty ? null : _bankController.text.trim(),
          );
          final addedDp = await notifier.addStaffWithResponse(newDp); // Need to return the created DP from provider to get ID for upload
          
          if (addedDp != null && _selectedPhotoPath != null) {
            await notifier.uploadFile(addedDp.id, _selectedPhotoPath!, 'photo');
          }
        } else {
          final persons = ref.read(staffProvider).value ?? [];
          final dp = persons.firstWhere(
            (p) => p.id == widget.dpId,
            orElse: () => DeliveryPerson(
              id: widget.dpId ?? '',
              name: 'Unknown',
              employeeId: 'Unknown',
            ),
          );

          final updatedDp = dp.copyWith(
            name: _nameController.text.trim(),
            address: _addressController.text.trim(),
            zone: _zoneController.text.trim(),
            dateOfBirth: _dobController.text.trim().isEmpty ? null : _dobController.text.trim(),
            parentNameAndAddress: _parentNameController.text.trim().isEmpty ? null : _parentNameController.text.trim(),
            parentOrSpouseMobile: _parentMobileController.text.trim().isEmpty ? null : _parentMobileController.text.trim(),
            alternativeAddress: _currentAddressController.text.trim().isEmpty ? null : _currentAddressController.text.trim(),
            mobileNumber: _mobileController.text.trim().isEmpty ? '' : _mobileController.text.trim(),
            alternativeMobile: _altMobileController.text.trim().isEmpty ? null : _altMobileController.text.trim(),
            whatsappNumber: _whatsappController.text.trim().isEmpty ? null : _whatsappController.text.trim(),
            aadharNumber: _aadharController.text.trim().isEmpty ? null : _aadharController.text.trim(),
            licenseNumber: _licenseController.text.trim().isEmpty ? null : _licenseController.text.trim(),
            vehicleNumber: _vehicleController.text.trim().isEmpty ? null : _vehicleController.text.trim(),
            dateOfJoining: _dojController.text.trim().isEmpty ? null : _dojController.text.trim(),
            gpayNumber: _gpayController.text.trim().isEmpty ? null : _gpayController.text.trim(),
            upiId: _upiController.text.trim().isEmpty ? null : _upiController.text.trim(),
            bankAccountDetails: _bankController.text.trim().isEmpty ? null : _bankController.text.trim(),
          );
          await notifier.updateStaff(widget.dpId!, updatedDp);
          
          if (_selectedPhotoPath != null) {
            await notifier.uploadFile(widget.dpId!, _selectedPhotoPath!, 'photo');
          }
        }

        if (mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(isAdd ? 'Delivery Person added successfully!' : 'Profile saved successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error saving profile: $e")),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAdd = widget.dpId == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isAdd ? 'Add Delivery Person' : 'Edit Delivery Person', style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.only(
            left: AppConstants.spacing16,
            right: AppConstants.spacing16,
            top: AppConstants.spacing16,
            bottom: 100,
          ),
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.dividerColor, width: 2),
                    ),
                    child: ClipOval(
                      child: _selectedPhotoPath != null
                          ? Image.file(File(_selectedPhotoPath!), fit: BoxFit.cover)
                          : (_existingPhotoUrl != null && _existingPhotoUrl!.isNotEmpty)
                              ? Image.network(_existingPhotoUrl!, fit: BoxFit.cover)
                              : Icon(Icons.person, size: 64, color: theme.colorScheme.onSurfaceVariant.withAlpha(100)),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            _selectedPhotoPath = image.path;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _selectedPhotoPath != null || (_existingPhotoUrl != null && _existingPhotoUrl!.isNotEmpty)
                              ? Icons.edit
                              : Icons.add_a_photo,
                          color: theme.colorScheme.onPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spacing24),
            _FormSection(
              title: 'Personal Details',
              children: [
                AppTextField(controller: _nameController, labelText: 'Full Name *', validator: (v) => v == null || v.isEmpty ? 'Required' : null),
                const SizedBox(height: 12),
                if (!isAdd)
                  ...[
                    AppTextField(controller: _employeeIdController, labelText: 'DP ID (System Generated)', readOnly: true),
                    const SizedBox(height: 12),
                  ],
                AppTextField(controller: _mobileController, labelText: 'Phone Number *', keyboardType: TextInputType.phone, validator: (v) => v == null || v.isEmpty ? 'Required' : null),
                const SizedBox(height: 12),
                AppTextField(controller: _addressController, labelText: 'Address'),
                const SizedBox(height: 12),
                AppTextField(controller: _zoneController, labelText: 'Zone'),
                const SizedBox(height: 12),
                AppTextField(controller: _dobController, labelText: 'Date of Birth'),
                const SizedBox(height: 12),
                AppTextField(controller: _parentNameController, labelText: 'Parent\'s Name & Address'),
                const SizedBox(height: 12),
                AppTextField(controller: _parentMobileController, labelText: 'Parent\'s/Spouse Mobile', keyboardType: TextInputType.phone),
                const SizedBox(height: 12),
                AppTextField(controller: _currentAddressController, labelText: 'Alternative Address'),
                const SizedBox(height: 12),
                AppTextField(controller: _altMobileController, labelText: 'Alternative Mobile', keyboardType: TextInputType.phone),
                const SizedBox(height: 12),
                AppTextField(controller: _whatsappController, labelText: 'WhatsApp Number', keyboardType: TextInputType.phone),
              ],
            ),
            const SizedBox(height: AppConstants.spacing24),

            _FormSection(
              title: 'Identity & Documents',
              children: [
                AppTextField(controller: _aadharController, labelText: 'Aadhar Number'),
                const SizedBox(height: 12),
                AppTextField(controller: _licenseController, labelText: 'License Number'),
                const SizedBox(height: 12),
                AppTextField(controller: _vehicleController, labelText: 'Vehicle Number'),
              ],
            ),
            const SizedBox(height: AppConstants.spacing24),

            _FormSection(
              title: 'Employment',
              children: [
                AppTextField(controller: _dojController, labelText: 'Date of Joining'),
              ],
            ),
            const SizedBox(height: AppConstants.spacing24),

            _FormSection(
              title: 'Payment Details',
              children: [
                AppTextField(controller: _gpayController, labelText: 'GPAY Number *', keyboardType: TextInputType.phone, validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
                const SizedBox(height: 12),
                AppTextField(controller: _upiController, labelText: 'UPI ID *', validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
                const SizedBox(height: 12),
                AppTextField(controller: _bankController, labelText: 'Bank Account Details (Acct No / IFSC)'),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : AppButton(
                text: 'Save Profile',
                onPressed: _saveProfile,
              ),
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _FormSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.spacing16),
        ...children,
      ],
    );
  }
}
