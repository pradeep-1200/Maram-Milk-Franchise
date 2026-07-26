import 'package:flutter/material.dart';

class DpAvatar extends StatelessWidget {
  final String? photoUrl;
  final String name;
  final double? radius;

  const DpAvatar({
    super.key,
    required this.photoUrl,
    required this.name,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return CircleAvatar(
      radius: radius,
      backgroundColor: theme.colorScheme.primaryContainer,
      backgroundImage: (photoUrl != null && photoUrl!.isNotEmpty)
          ? NetworkImage(photoUrl!)
          : null,
      child: (photoUrl != null && photoUrl!.isNotEmpty)
          ? null
          : Text(
              name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?',
              style: TextStyle(
                color: theme.colorScheme.onPrimaryContainer,
                fontSize: radius != null ? radius! * 0.8 : null,
              ),
            ),
    );
  }
}
