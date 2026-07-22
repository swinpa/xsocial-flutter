import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


class ClickableTextSpan {
  const ClickableTextSpan({
    required this.text,
    this.style,
    this.onTap,
  });

  final String text;

  final TextStyle? style;

  final VoidCallback? onTap;
}

class RichClickableText extends StatefulWidget {
  const RichClickableText({
    super.key,
    required this.children,
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  });

  final List<ClickableTextSpan> children;

  /// 默认样式
  final TextStyle? style;

  final TextAlign textAlign;

  final int? maxLines;

  final TextOverflow overflow;

  @override
  State<RichClickableText> createState() => _RichClickableTextState();
}

class _RichClickableTextState extends State<RichClickableText> {
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 清理旧的 recognizer（避免 build 多次累积）
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();

    final spans = widget.children.map((item) {
      TapGestureRecognizer? recognizer;

      if (item.onTap != null) {
        recognizer = TapGestureRecognizer()
          ..onTap = item.onTap;
        _recognizers.add(recognizer);
      }

      return TextSpan(
        text: item.text,
        style: widget.style?.merge(item.style) ?? item.style,
        recognizer: recognizer,
      );
    }).toList();

    return Text.rich(
      TextSpan(
        style: widget.style,
        children: spans,
      ),
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }
}
