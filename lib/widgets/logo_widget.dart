import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;
  final String semanticsLabel;
  final Color? colorOverlay;

  const LogoWidget({
    super.key,
    this.size = 120,
    this.onTap,
    this.semanticsLabel = 'Street House — logo',
    this.colorOverlay,
  });

  @override
  Widget build(BuildContext context) {
    Widget logo = Image.asset(
      'lib/assets/logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      color: colorOverlay,
      colorBlendMode: colorOverlay != null ? BlendMode.srcIn : null,
      semanticLabel: semanticsLabel,
    );

    logo = Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Center(child: logo),
    );

    if (onTap != null) {
      logo = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        child: logo,
      );
    }
    return logo;
  }
}