import 'package:flutter/material.dart';

class ResizeHandle extends StatefulWidget {
  final Axis axis;
  const ResizeHandle({super.key, required this.axis});
  const ResizeHandle.vertical({super.key}) : axis = Axis.vertical;
  const ResizeHandle.horizontal({super.key}) : axis = Axis.horizontal;

  @override
  State<ResizeHandle> createState() => _ResizeHandleState();
}

class _ResizeHandleState extends State<ResizeHandle> {
  bool hovering = false;

  MouseCursor get _cursor => widget.axis == Axis.vertical
      ? SystemMouseCursors.resizeUp
      : SystemMouseCursors.resizeLeftRight;

  @override
  Widget build(BuildContext context) {
    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: widget.axis == Axis.vertical
          ? const EdgeInsets.symmetric(vertical: 3, horizontal: 6)
          : const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
      decoration: BoxDecoration(
        color: hovering
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(2),
      ),
    );

    return MouseRegion(
      cursor: _cursor,
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: child,
    );
  }
}
