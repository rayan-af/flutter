import 'dart:convert';
import 'package:flutter/material.dart';

class DishImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const DishImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('data:image')) {
      try {
        final base64Str = imageUrl.split(',').last;
        return Image.memory(
          base64Decode(base64Str),
          width: width,
          height: height,
          fit: fit,
          errorBuilder: errorBuilder,
        );
      } catch (e) {
        if (errorBuilder != null) {
          return errorBuilder!(context, e, null);
        }
        return const SizedBox();
      }
    } else if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: errorBuilder ?? (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: Colors.grey.withOpacity(0.2),
          child: const Center(child: Icon(Icons.broken_image_rounded, color: Colors.grey)),
        ),
      );
    } else {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: errorBuilder ?? (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: Colors.grey.withOpacity(0.2),
          child: const Center(child: Icon(Icons.broken_image_rounded, color: Colors.grey)),
        ),
      );
    }
  }
}
