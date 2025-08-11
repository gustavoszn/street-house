import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;
  final double overlayOpacity;
  final String imageAsset;

  const BackgroundWidget({
    super.key,
    required this.child,
    this.overlayOpacity = 0.08,
    this.imageAsset = 'lib/assets/fundo_login.png',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            imageAsset,
            fit: BoxFit.cover,
          ),
        ),
        if (overlayOpacity > 0)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(overlayOpacity),
            ),
          ),
        Positioned.fill(child: child),
      ],
    );
  }
}