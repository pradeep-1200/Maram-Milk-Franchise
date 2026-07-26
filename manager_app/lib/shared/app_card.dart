import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool isPrimary;
  final Color? accentColor;
  final Color? backgroundColor;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppConstants.spacing16),
    this.onTap,
    this.isPrimary = false,
    this.accentColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = backgroundColor ?? Colors.white;
    final shadows = isPrimary ? AppConstants.primaryCardShadow : AppConstants.cardShadow;

    Widget body = Padding(
      padding: padding,
      child: child,
    );

    if (accentColor != null) {
      body = Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: accentColor!, width: 4),
          ),
        ),
        child: body,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: shadows,
        border: AppConstants.cardBorder,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        child: onTap != null
            ? InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                child: body,
              )
            : body,
      ),
    );
  }
}
