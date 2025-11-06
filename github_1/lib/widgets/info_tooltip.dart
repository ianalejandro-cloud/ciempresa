import 'package:flutter/material.dart';

class InfoTooltip extends StatefulWidget {
  final String message;
  final double iconSize;
  final Color iconColor;
  final double fontSize;
  final int duration;

  const InfoTooltip({
    super.key,
    required this.message,
    this.iconSize = 24.0,
    this.iconColor = Colors.grey,
    this.fontSize = 12.0,
    this.duration = 4,
  });

  @override
  State<InfoTooltip> createState() => _InfoTooltipState();
}

class _InfoTooltipState extends State<InfoTooltip> {
  final GlobalKey _key = GlobalKey();
  OverlayEntry? _overlayEntry;

  void _showTooltip() {
    final renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    final screenSize = MediaQuery.of(context).size;

    final isLeftSpace = offset.dx > screenSize.width / 2;
    final isTopSpace = offset.dy > screenSize.height / 2;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: isLeftSpace ? null : offset.dx + size.width,
        right: isLeftSpace ? screenSize.width - offset.dx : null,
        top: isTopSpace ? null : offset.dy,
        bottom: isTopSpace ? screenSize.height - offset.dy : null,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(maxWidth: 250),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
            ),
            child: Text(
              widget.message,
              style: TextStyle(color: Colors.white, fontSize: widget.fontSize),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _key,
      onTap: () {
        if (_overlayEntry == null) {
          _showTooltip();
          Future.delayed(Duration(seconds: widget.duration), _hideTooltip);
        } else {
          _hideTooltip();
        }
      },
      child: Icon(
        Icons.help_outline,
        size: widget.iconSize,
        color: widget.iconColor,
      ),
    );
  }
}
