import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Asegúrate de tener flutter_svg en pubspec.yaml

class DynamicNetworkImage extends StatelessWidget {
  final String url;
  final BoxFit fit;

  const DynamicNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final String cleanUrl = _getValidUrl(url);

    if (cleanUrl.endsWith('.svg')) {
      return SvgPicture.network(
        cleanUrl,
        fit: fit,
        placeholderBuilder: (context) =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    } else {
      return Image.network(
        cleanUrl,
        fit: fit,

        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[900],
          child: const Icon(Icons.broken_image, color: Colors.white24),
        ),
      );
    }
  }

  String _getValidUrl(String? url) {
    if (url == null || url.trim().isEmpty || !url.startsWith('http')) {
      return 'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg';
    }
    return url;
  }
}
