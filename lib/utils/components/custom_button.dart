import 'package:flutter/material.dart';
import '../constants/app_enums.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType type;
  final IconData? icon;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.type = ButtonType.elevated,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingButton(context);
    }

    switch (type) {
      case ButtonType.elevated:
        return _buildElevatedButton();
      case ButtonType.outlined:
        return _buildOutlinedButton();
      case ButtonType.text:
        return _buildTextButton();
    }
  }

  Widget _buildLoadingButton(BuildContext context) {
    return SizedBox(
      width: width,
      height: 48,
      child: ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            inherit: false,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildElevatedButton() {
    return SizedBox(
      width: width,
      height: 48,
      child: icon != null
          ? ElevatedButton.icon(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  inherit: false,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: Colors.white,
                ),
              ),
              icon: Icon(icon, size: 20),
              label: Text(text),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  inherit: false,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: Colors.white,
                ),
              ),
              child: Text(text),
            ),
    );
  }

  Widget _buildOutlinedButton() {
    return SizedBox(
      width: width,
      height: 48,
      child: icon != null
          ? OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(text),
            )
          : OutlinedButton(onPressed: onPressed, child: Text(text)),
    );
  }

  Widget _buildTextButton() {
    return SizedBox(
      width: width,
      child: icon != null
          ? TextButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(text),
            )
          : TextButton(onPressed: onPressed, child: Text(text)),
    );
  }
}
