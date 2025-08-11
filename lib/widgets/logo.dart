import 'package:flutter/material.dart';

class StreetLogo extends StatelessWidget {
  final double height;
  final bool white;
  const StreetLogo({super.key, this.height = 120, this.white = false});

  @override
  Widget build(BuildContext context) {
    return white
        ? ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcATop),
            child: Image.asset(
              'lib/assets/logo.png',
              height: height,
              fit: BoxFit.contain,
            ),
          )
        : Image.asset(
            'lib/assets/logo.png',
            height: height,
            fit: BoxFit.contain,
          );
  }
}