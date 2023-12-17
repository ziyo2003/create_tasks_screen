import 'package:flutter/cupertino.dart';
import '../../assets/constants/colors.dart';



class WButton extends StatefulWidget {
  final Function() onTap;
  final String text;
  final bool isDisabled;
  final bool isLoading;
  final TextStyle? style;
  final Color? buttonColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final Widget? child;

  const WButton({
    required this.onTap,
    this.isDisabled = false,
    this.isLoading = false,
    this.text = '',
    this.style,
    this.buttonColor,
    this.margin,
    this.padding,
    this.height,
    this.width,
    this.child,
    super.key,
  });

  @override
  _WButtonState createState() => _WButtonState();
}



class _WButtonState extends State<WButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
        begin: 1,
        end: 0.9
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.isDisabled && !widget.isLoading) {
          widget.onTap();
        }
      },
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: widget.height,
              width: widget.width ?? double.maxFinite,
              alignment: Alignment.center,
              margin: widget.margin ?? EdgeInsets.zero,
              padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: widget.isDisabled
                    ? disabledButtonColor
                    : widget.buttonColor ?? wButtonColor,
              ),
              child: Builder(
                builder: (_) {
                  if (widget.isLoading) {
                    return const CupertinoActivityIndicator();
                  }
                  if (widget.child == null) {
                    return Text(
                      widget.text,
                      style: widget.style ??
                          TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: widget.isDisabled
                                ? white.withOpacity(.3)
                                : white,
                          ),
                    );
                  } else {
                    return widget.child!;
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}


