import 'package:flutter/material.dart';

class ImageNetworkWidget extends StatelessWidget {
  final String photoUrl;
  final double? radius;

  const ImageNetworkWidget({super.key, required this.photoUrl, this.radius});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 8),
      child: Image.network(
        photoUrl,
        fit: BoxFit.fill,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: progress.expectedTotalBytes != null ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes! : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Center(child: Icon(Icons.error));
        },
      ),
    );
  }
}
