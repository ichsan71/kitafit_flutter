import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ExpertAvatar extends StatelessWidget {
  final String? url;
  final String name;
  final double radius;

  const ExpertAvatar({
    super.key,
    required this.name,
    this.url,
    this.radius = 28,
  });

  String get _initial =>
      name.isEmpty ? '?' : name.trim().split(' ').first[0].toUpperCase();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (url == null || url!.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Text(
          _initial,
          style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
        ),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundImage: CachedNetworkImageProvider(url!),
    );
  }
}
