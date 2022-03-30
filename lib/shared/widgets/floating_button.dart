import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final VoidCallback onTap;
  final double rightPadding;
  final double bottomPadding;
  final Color color;
  final IconData icon;

  const FloatingButton({
    Key? key,
    required this.onTap,
    this.rightPadding = 0,
    this.bottomPadding = 0,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: rightPadding,
      bottom: bottomPadding,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}
