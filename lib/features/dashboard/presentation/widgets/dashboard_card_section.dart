import 'package:flutter/material.dart';
import 'package:todo_clean_bloc/core/theme/app_pallate.dart';

class InfoCard extends StatelessWidget {
  final String? image;
  final Color? color;
  final double? width;
  final double? height;
  final double borderRadius;

  const InfoCard({
    super.key,
    this.image,
    this.color,
    this.width,
    this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    // Default: landscape aspect ratio (16:9)
    final cardWidth = width ?? 180;
    final cardHeight = height ?? (cardWidth * 9 / 16);

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: color ?? AppPalette.primary,
        borderRadius: BorderRadius.circular(borderRadius),
        image: image != null
            ? DecorationImage(image: AssetImage(image!), fit: BoxFit.cover)
            : null,
        boxShadow: [
          BoxShadow(
            color: AppPalette.blackColor.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
