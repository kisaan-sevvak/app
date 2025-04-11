import 'package:flutter/material.dart';
import 'package:kisan_sevak/utils/theme.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : AppTheme.primaryColor,
        ),
      ),
    );
  }
} 