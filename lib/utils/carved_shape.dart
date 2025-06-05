import 'package:flutter/material.dart';

class CarvedShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0); // Start from top-left corner
    path.lineTo(0, size.height - 20); // Draw to near the bottom
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 20,
    ); // Create the carved curve
    path.lineTo(size.width, 0); // Draw to top-right corner
    path.close(); // Close the path

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; // No need to reclip
  }
}
