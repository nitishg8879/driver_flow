import 'package:flutter/material.dart';
import '../constants/app_enums.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType type;
  final IconData? icon;
  final double? width;
  final double height;
  final EdgeInsets padding;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.type = ButtonType.elevated,
    this.icon,
    this.width,
    this.height = 48,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _hoverAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(_hoverController);
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovering) {
    if (isHovering && widget.onPressed != null && !widget.isLoading) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: ScaleTransition(
        scale: _hoverAnimation,
        child: Opacity(
          opacity: widget.isLoading ? 0.7 : 1.0,
          child: widget.isLoading
              ? _buildLoadingButton(context)
              : _buildButton(context),
        ),
      ),
    );
  }

  Widget _buildLoadingButton(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ElevatedButton(
        onPressed: null,
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return switch (widget.type) {
      ButtonType.elevated => _buildElevatedButton(context),
      ButtonType.outlined => _buildOutlinedButton(context),
      ButtonType.text => _buildTextButton(context),
    };
  }

  Widget _buildElevatedButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: widget.icon != null
          ? ElevatedButton.icon(
              onPressed: widget.onPressed,
              style:
                  ElevatedButton.styleFrom(
                    elevation: 1,
                    padding: widget.padding,
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ).copyWith(
                    overlayColor: WidgetStatePropertyAll(
                      colorScheme.onPrimary.withValues(alpha: 0.12),
                    ),
                  ),
              icon: Icon(widget.icon, size: 20),
              label: Text(widget.text),
            )
          : ElevatedButton(
              onPressed: widget.onPressed,
              style:
                  ElevatedButton.styleFrom(
                    elevation: 1,
                    padding: widget.padding,
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ).copyWith(
                    overlayColor: WidgetStatePropertyAll(
                      colorScheme.onPrimary.withValues(alpha: 0.12),
                    ),
                  ),
              child: Text(widget.text),
            ),
    );
  }

  Widget _buildOutlinedButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: widget.icon != null
          ? OutlinedButton.icon(
              onPressed: widget.onPressed,
              style:
                  OutlinedButton.styleFrom(
                    padding: widget.padding,
                    foregroundColor: colorScheme.primary,
                    side: BorderSide(color: colorScheme.outline, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ).copyWith(
                    overlayColor: WidgetStatePropertyAll(
                      colorScheme.primary.withValues(alpha: 0.08),
                    ),
                  ),
              icon: Icon(widget.icon, size: 20),
              label: Text(widget.text),
            )
          : OutlinedButton(
              onPressed: widget.onPressed,
              style:
                  OutlinedButton.styleFrom(
                    padding: widget.padding,
                    foregroundColor: colorScheme.primary,
                    side: BorderSide(color: colorScheme.outline, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ).copyWith(
                    overlayColor: WidgetStatePropertyAll(
                      colorScheme.primary.withValues(alpha: 0.08),
                    ),
                  ),
              child: Text(widget.text),
            ),
    );
  }

  Widget _buildTextButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: widget.icon != null
          ? TextButton.icon(
              onPressed: widget.onPressed,
              style:
                  TextButton.styleFrom(
                    padding: widget.padding,
                    foregroundColor: colorScheme.primary,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ).copyWith(
                    overlayColor: WidgetStatePropertyAll(
                      colorScheme.primary.withValues(alpha: 0.08),
                    ),
                  ),
              icon: Icon(widget.icon, size: 20),
              label: Text(widget.text),
            )
          : TextButton(
              onPressed: widget.onPressed,
              style:
                  TextButton.styleFrom(
                    padding: widget.padding,
                    foregroundColor: colorScheme.primary,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ).copyWith(
                    overlayColor: WidgetStatePropertyAll(
                      colorScheme.primary.withValues(alpha: 0.08),
                    ),
                  ),
              child: Text(widget.text),
            ),
    );
  }
}
