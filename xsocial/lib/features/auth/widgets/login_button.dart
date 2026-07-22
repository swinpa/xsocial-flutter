import 'package:flutter/material.dart';

enum ButtonPressEffect {
  material,
  scale,
  opacity,
  none,
}

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    this.onPressed,
    this.leading,
    this.trailing,
    this.loading = false,

    this.height = 48,
    this.width = double.infinity,

    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,

    this.borderRadius = 48,

    this.leadingPadding = 12,
    this.trailingPadding = 12,

    this.titleHorizontalPadding = 48,

    this.pressEffect = ButtonPressEffect.scale,

    this.overlayColor,

    this.elevation = 0,
    required this.child,
  });

  /// 中间内容（推荐传 Text，也可以 RichText、Row 等）
  final Widget child;

  final Widget? leading;

  final Widget? trailing;

  final VoidCallback? onPressed;

  final bool loading;

  final double width;

  final double height;

  final double borderRadius;

  final double leadingPadding;

  final double trailingPadding;

  /// 防止标题压住左右组件
  final double titleHorizontalPadding;

  final Color backgroundColor;

  final Color foregroundColor;

  final Color? overlayColor;

  final double elevation;

  final ButtonPressEffect pressEffect;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) {
      setState(() {
        _pressed = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.loading;

    Widget content = Material(
      color: widget.backgroundColor,
      elevation: widget.elevation,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: InkWell(
        onTap: enabled ? widget.onPressed : null,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        splashFactory: widget.pressEffect == ButtonPressEffect.none
            ? NoSplash.splashFactory
            : InkRipple.splashFactory,
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (widget.overlayColor != null) {
            return widget.overlayColor;
          }

          if (states.contains(WidgetState.pressed)) {
            return Colors.black.withOpacity(0.05);
          }

          return Colors.transparent;
        }),
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) => _setPressed(false),
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// 中间内容
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.titleHorizontalPadding,
                ),
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: widget.foregroundColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                  child: Center(child: widget.child),
                ),
              ),

              /// 左侧
              if (widget.leading != null)
                Positioned(
                  left: widget.leadingPadding,
                  child: widget.leading!,
                ),

              /// 右侧
              if (widget.loading)
                Positioned(
                  right: widget.trailingPadding,
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: widget.foregroundColor,
                    ),
                  ),
                )
              else if (widget.trailing != null)
                Positioned(
                  right: widget.trailingPadding,
                  child: widget.trailing!,
                ),
            ],
          ),
        ),
      ),
    );

    switch (widget.pressEffect) {
      case ButtonPressEffect.scale:
        content = AnimatedScale(
          scale: _pressed ? 0.96 : 1,
          duration: const Duration(milliseconds: 100),
          child: content,
        );
        break;

      case ButtonPressEffect.opacity:
        content = AnimatedOpacity(
          opacity: _pressed ? 0.7 : 1,
          duration: const Duration(milliseconds: 100),
          child: content,
        );
        break;

      case ButtonPressEffect.material:
      case ButtonPressEffect.none:
        break;
    }

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: content,
    );
  }
}