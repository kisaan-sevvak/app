import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisan_sevak/utils/theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final double? width;
  final double height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width,
    this.height = 56,
    this.borderRadius = 16,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: width,
      height: height,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: backgroundColor ?? AppTheme.primaryColor,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              child: _buildChild(isDark),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor ?? AppTheme.primaryColor,
                foregroundColor: textColor ?? Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              child: _buildChild(isDark),
            ),
    );
  }

  Widget _buildChild(bool isDark) {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined
                ? (backgroundColor ?? AppTheme.primaryColor)
                : (textColor ?? Colors.white),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 20,
            color: isOutlined
                ? (backgroundColor ?? AppTheme.primaryColor)
                : (textColor ?? Colors.white),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: fontSize ?? 16,
            fontWeight: FontWeight.w600,
            color: isOutlined
                ? (backgroundColor ?? AppTheme.primaryColor)
                : (textColor ?? Colors.white),
          ),
        ),
      ],
    );
  }
} 