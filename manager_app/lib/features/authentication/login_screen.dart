import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/app_button.dart';
import '../../shared/app_text_field.dart';
import 'providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;
  String? _biometricError;
  
  final LocalAuthentication auth = LocalAuthentication();

  // Animations
  late AnimationController _animController;
  late Animation<double> _headerScale;
  late Animation<double> _headerFade;
  late Animation<double> _formFade;
  late Animation<Offset> _formSlide;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _headerScale = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _formFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.2, 0.85, curve: Curves.easeOut),
      ),
    );

    _formSlide = Tween<Offset>(
      begin: const Offset(0, 24),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.2, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _validateAndLogin() {
    setState(() {
      _emailError = _emailController.text.isEmpty ? 'Email is required' : null;
      _passwordError = _passwordController.text.isEmpty ? 'Password is required' : null;
    });

    if (_emailError == null && _passwordError == null) {
      ref.read(authProvider.notifier).login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  Future<void> _handleBiometricAuth() async {
    setState(() {
      _biometricError = null;
    });

    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      if (!canAuthenticate) {
        setState(() {
          _biometricError = 'Biometric login isn\'t set up on this device';
        });
        return;
      }

      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Authenticate to access Maram Milk Manager',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        if (mounted) {
          context.go('/dashboard');
        }
      } else {
        setState(() {
          _biometricError = 'Biometric authentication failed. Try again or use your password.';
        });
      }
    } on PlatformException catch (_) {
      setState(() {
        _biometricError = 'Biometric login isn\'t set up on this device';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacing24,
                vertical: AppConstants.spacing16,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - AppConstants.spacing32,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Branded Header Matching Splash Screen
                      AnimatedBuilder(
                        animation: _animController,
                        builder: (context, child) {
                          return ScaleTransition(
                            scale: _headerScale,
                            child: FadeTransition(
                              opacity: _headerFade,
                              child: Column(
                                children: [
                                  // Glowing Circular Icon Badge
                                  Container(
                                    width: 88,
                                    height: 88,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withAlpha(90),
                                          blurRadius: 24,
                                          spreadRadius: 4,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.local_drink,
                                      size: 46,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: AppConstants.spacing16),
                                  Text(
                                    'MARAM MILK',
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: theme.colorScheme.primary,
                                      letterSpacing: 3.0,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Manager Portal • Login to continue',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: AppConstants.spacing32),

                      // Staggered Form & Action Buttons
                      AnimatedBuilder(
                        animation: _animController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: _formSlide.value,
                            child: Opacity(
                              opacity: _formFade.value,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (authState.error != null) ...[
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.errorContainer.withAlpha(50),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: theme.colorScheme.error.withAlpha(100)),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.error_outline, color: theme.colorScheme.error, size: 20),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              authState.error!,
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                color: theme.colorScheme.error,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: AppConstants.spacing16),
                                  ],
                                  
                                  // Email Field
                                  AppTextField(
                                    controller: _emailController,
                                    labelText: 'Email Address',
                                    hintText: 'manager@marammilk.com',
                                    keyboardType: TextInputType.emailAddress,
                                    isPill: true,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                                      child: Icon(
                                        Icons.email_outlined,
                                        color: theme.colorScheme.primary,
                                        size: 20,
                                      ),
                                    ),
                                    errorText: _emailError,
                                  ),

                                  const SizedBox(height: AppConstants.spacing16),

                                  // Password Field with Lock Leading Icon & Eye Suffix
                                  AppTextField(
                                    controller: _passwordController,
                                    labelText: 'Password',
                                    obscureText: _obscurePassword,
                                    errorText: _passwordError,
                                    isPill: true,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                                      child: Icon(
                                        Icons.lock_outline,
                                        color: theme.colorScheme.primary,
                                        size: 20,
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),

                                  const SizedBox(height: AppConstants.spacing8),

                                  // Forgot Password Link
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        _showForgotPasswordSheet(context, _emailController.text);
                                      },
                                      child: Text(
                                        'Forgot Password?',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: AppConstants.spacing16),

                                  // Main Login Button
                                  AppButton(
                                    text: 'Login',
                                    isLoading: authState.isLoading,
                                    isPill: true,
                                    onPressed: _validateAndLogin,
                                  ),

                                  const SizedBox(height: AppConstants.spacing16),

                                  // Biometric Button
                                  AppButton.outlined(
                                    text: 'Use Biometric',
                                    isPill: true,
                                    icon: Icon(
                                      Icons.fingerprint,
                                      color: theme.colorScheme.primary,
                                    ),
                                    onPressed: _handleBiometricAuth,
                                  ),

                                  if (_biometricError != null) ...[
                                    const SizedBox(height: AppConstants.spacing8),
                                    Text(
                                      _biometricError!,
                                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: AppConstants.spacing32),

                      // Footer Section Matching Splash Screen
                      AnimatedBuilder(
                        animation: _animController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _formFade.value,
                            child: Column(
                              children: [
                                Text(
                                  'Contact your admin to reset credentials',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant.withAlpha(180),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Maram Dairy Systems',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant.withAlpha(140),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showForgotPasswordSheet(BuildContext context, String initialEmail) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.cardRadius)),
      ),
      builder: (context) {
        return _ForgotPasswordSheet(initialEmail: initialEmail);
      },
    );
  }
}

class _ForgotPasswordSheet extends StatefulWidget {
  final String initialEmail;

  const _ForgotPasswordSheet({required this.initialEmail});

  @override
  State<_ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<_ForgotPasswordSheet> {
  late final TextEditingController _emailController;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
        children: _isSubmitted
            ? [
                const Icon(Icons.check_circle, color: Colors.green, size: 64),
                const SizedBox(height: AppConstants.spacing16),
                Text(
                  'Request Sent',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.spacing8),
                Text(
                  'Your admin has been notified and will contact you to reset your password.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.spacing24),
                AppButton(
                  text: 'Back to Login',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ]
            : [
                Text(
                  'Reset Password',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppConstants.spacing8),
                Text(
                  'Password resets are handled by your admin for security. Submit a request and they\'ll reach out to verify your identity.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: AppConstants.spacing24),
                AppTextField(
                  controller: _emailController,
                  labelText: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: AppConstants.spacing24),
                AppButton(
                  text: 'Submit Request',
                  onPressed: () {
                    setState(() {
                      _isSubmitted = true;
                    });
                  },
                ),
              ],
      ),
    );
  }
}
