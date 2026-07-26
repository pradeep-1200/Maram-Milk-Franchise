import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import 'app_button.dart';

class AppErrorState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final bool isCard;

  const AppErrorState({
    super.key,
    this.title = 'Oops, something went wrong',
    this.message = 'We couldn\'t load the data. Please check your connection and try again.',
    this.onRetry,
    this.isCard = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_outline,
          size: 48,
          color: theme.colorScheme.error,
        ),
        const SizedBox(height: AppConstants.spacing16),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.spacing8),
        Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        if (onRetry != null) ...[
          const SizedBox(height: AppConstants.spacing24),
          AppButton.outlined(
            text: 'Try Again',
            icon: const Icon(Icons.refresh),
            onPressed: onRetry!,
          ),
        ],
      ],
    );

    if (isCard) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(AppConstants.spacing16),
          padding: const EdgeInsets.all(AppConstants.spacing24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withAlpha(20),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: content,
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing24),
        child: content,
      ),
    );
  }
}
