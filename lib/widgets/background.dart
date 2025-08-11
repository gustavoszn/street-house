import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  final Widget child;
  final double? height; // allow custom height

  const CustomBackground({super.key, required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'lib/assets/fundo_login.png',
            fit: BoxFit.cover,
            height: height,
          ),
        ),
        child,
      ],
    );
  }
}