import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FilledLoaderButton extends HookWidget {
  const FilledLoaderButton({
    required this.child,
    required this.onPressed,
    super.key,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    this.statesController,
    this.clipBehavior = Clip.none,
    this.autofocus = false,
  });
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;
  final WidgetStatesController? statesController;
  final Widget? child;
  final FutureOr<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final isAwaiting = useState(false);
    // Survives the gap before useState rebuilds; blocks re-entry from a stale onPressed.
    final isAwaitingRef = useRef(false);
    return IntrinsicHeight(
      child: FilledButton(
        onPressed: onPressed == null || isAwaiting.value
            ? null
            : () async {
                if (isAwaitingRef.value) return;
                isAwaitingRef.value = true;
                isAwaiting.value = true;
                try {
                  await onPressed?.call();
                } finally {
                  isAwaitingRef.value = false;
                  if (context.mounted) isAwaiting.value = false;
                }
              },
        autofocus: autofocus,
        focusNode: focusNode,
        clipBehavior: clipBehavior,
        onFocusChange: onFocusChange,
        onHover: onHover,
        onLongPress: onLongPress,
        statesController: statesController,
        style: style?.copyWith(
          backgroundColor: isAwaiting.value
              ? WidgetStateProperty.all(
                  style?.backgroundColor?.resolve({WidgetState.pressed}),
                )
              : style?.backgroundColor,
        ),
        child: isAwaiting.value
            ? IntrinsicWidth(
                child: Stack(
                  children: [
                    if (child != null) Opacity(opacity: 0, child: child),
                    Center(
                      child: SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          color: style?.foregroundColor?.resolve({}),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : child,
      ),
    );
  }
}

class TextLoaderButton extends HookWidget {
  const TextLoaderButton({
    required this.child,
    required this.onPressed,
    super.key,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    this.statesController,
    this.clipBehavior = Clip.none,
    this.autofocus = false,
  });
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;
  final WidgetStatesController? statesController;
  final Widget child;
  final FutureOr<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final _isAwaiting = useState(false);
    return TextButton(
      onPressed: onPressed == null
          ? null
          : _isAwaiting.value
          ? null
          : () async {
              if (_isAwaiting.value) return;
              _isAwaiting.value = true;
              try {
                await onPressed?.call();
              } catch (ex) {
                _isAwaiting.value = false;
                rethrow;
              }
              _isAwaiting.value = false;
            },
      autofocus: autofocus,
      focusNode: focusNode,
      clipBehavior: clipBehavior,
      onFocusChange: onFocusChange,
      onHover: onHover,
      onLongPress: onLongPress,
      statesController: statesController,
      style: style,
      child: _isAwaiting.value
          ? IntrinsicWidth(
              child: Stack(
                children: [
                  Opacity(opacity: 0, child: child),
                  Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: style?.backgroundColor?.resolve({}),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : child,
    );
  }
}

class IconLoaderButton extends HookWidget {
  const IconLoaderButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    this.statesController,
    this.clipBehavior = Clip.none,
    this.autofocus = false,
    this.iconSize,
    this.visualDensity,
    this.padding,
    this.alignment,
    this.splashRadius,
    this.color,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.disabledColor,
    this.mouseCursor,
    this.tooltip,
    this.enableFeedback,
    this.constraints,
    this.isSelected,
    this.selectedIcon,
  });
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;
  final WidgetStatesController? statesController;
  final Widget icon;
  final FutureOr<void> Function()? onPressed;
  final double? iconSize;
  final VisualDensity? visualDensity;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final double? splashRadius;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? color;
  final Color? splashColor;
  final Color? highlightColor;
  final Color? disabledColor;
  final MouseCursor? mouseCursor;
  final String? tooltip;
  final bool? enableFeedback;
  final BoxConstraints? constraints;
  final bool? isSelected;
  final Widget? selectedIcon;

  @override
  Widget build(BuildContext context) {
    final _isAwaiting = useState(false);
    return IconButton(
      autofocus: autofocus,
      focusNode: focusNode,
      style: style,
      alignment: alignment,
      color: color,
      constraints: constraints,
      disabledColor: disabledColor,
      enableFeedback: enableFeedback,
      focusColor: focusColor,
      highlightColor: highlightColor,
      hoverColor: hoverColor,
      iconSize: iconSize,
      isSelected: isSelected,
      mouseCursor: mouseCursor,
      padding: padding,
      splashRadius: splashRadius,
      splashColor: splashColor,
      tooltip: tooltip,
      visualDensity: visualDensity,
      selectedIcon: selectedIcon,
      icon: _isAwaiting.value
          ? IntrinsicWidth(
              child: Stack(
                children: [
                  Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: style?.backgroundColor?.resolve({}),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : icon,
      onPressed: onPressed == null
          ? null
          : _isAwaiting.value
          ? null
          : () async {
              if (_isAwaiting.value) return;
              _isAwaiting.value = true;
              try {
                await onPressed?.call();
              } catch (ex) {
                _isAwaiting.value = false;
                rethrow;
              }
              _isAwaiting.value = false;
            },
    );
  }
}

class OutlinedLoaderButton extends HookWidget {
  OutlinedLoaderButton({
    required this.child,
    required this.onPressed,
    super.key,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    this.statesController,
    this.clipBehavior = Clip.none,
    this.autofocus = false,
  });
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;
  final WidgetStatesController? statesController;
  final Widget? child;
  final FutureOr<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final _isAwaiting = useState(false);
    return OutlinedButton(
      onPressed: onPressed == null
          ? null
          : _isAwaiting.value
          ? null
          : () async {
              if (_isAwaiting.value) return;
              _isAwaiting.value = true;
              try {
                await onPressed?.call();
              } catch (ex) {
                _isAwaiting.value = false;
                rethrow;
              }
              _isAwaiting.value = false;
            },
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      focusNode: focusNode,
      onFocusChange: onFocusChange,
      onHover: onHover,
      onLongPress: onLongPress,
      statesController: statesController,
      style: style,
      child: _isAwaiting.value
          ? IntrinsicWidth(
              child: Stack(
                children: [
                  if (child != null) Opacity(opacity: 0, child: child),
                  Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: style?.backgroundColor?.resolve({}),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : child,
    );
  }
}
