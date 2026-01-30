import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/// Platform-aware 3D model viewer
/// Uses ModelViewer on mobile/web, shows placeholder on Windows
class PlatformModelViewer extends StatelessWidget {
  final String src;
  final String? alt;
  final bool autoRotate;
  final bool cameraControls;
  final Color? backgroundColor;
  final String? fallbackImageUrl;
  final String? fallbackAsset;

  const PlatformModelViewer({
    super.key,
    required this.src,
    this.alt,
    this.autoRotate = true,
    this.cameraControls = true,
    this.backgroundColor,
    this.fallbackImageUrl,
    this.fallbackAsset,
  });

  bool get _isDesktop {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  @override
  Widget build(BuildContext context) {
    // On desktop, show placeholder instead of 3D model
    if (_isDesktop) {
      return _buildDesktopFallback();
    }

    // On mobile/web, use actual ModelViewer
    return ModelViewer(
      src: src,
      alt: alt ?? "3D Model",
      ar: false,
      autoRotate: autoRotate,
      cameraControls: cameraControls,
      backgroundColor: backgroundColor ?? Colors.transparent,
    );
  }

  Widget _buildDesktopFallback() {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFF1a1a2e),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show fallback image if provided
            if (fallbackAsset != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    fallbackAsset!,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => _buildPlaceholderIcon(),
                  ),
                ),
              )
            else if (fallbackImageUrl != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Image.network(
                    fallbackImageUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => _buildPlaceholderIcon(),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF00FF41),
                        ),
                      );
                    },
                  ),
                ),
              )
            else
              _buildPlaceholderIcon(),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFF00FF41),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "3D View: Mobile/Web only",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.view_in_ar,
          size: 80,
          color: Colors.grey[600],
        ),
        const SizedBox(height: 16),
        Text(
          alt ?? "3D Model",
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
