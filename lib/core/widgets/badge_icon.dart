import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class BadgeIcon extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color? iconColor;
  final double size;
  final VoidCallback? onTap;

  const BadgeIcon({
    super.key,
    required this.icon,
    this.count = 0,
    this.iconColor,
    this.size = 24,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              icon,
              size: size,
              color: iconColor ?? Colors.white,
            ),
            if (count > 0)
              Positioned(
                top: -4,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Center(
                    child: Text(
                      count > 99 ? '99+' : count.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
