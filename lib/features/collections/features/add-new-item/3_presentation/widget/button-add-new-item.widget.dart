import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:le_spawn_fr/core/configs/app-routes.config.dart';
import 'package:le_spawn_fr/core/constant/font.constant.dart';
import 'package:le_spawn_fr/core/theme/app.theme.dart';
import 'package:le_spawn_fr/core/widgets/animated-background.widget.dart';

class ButtonAddNewItemWidget extends StatefulWidget {
  const ButtonAddNewItemWidget({super.key});

  @override
  State<ButtonAddNewItemWidget> createState() => _ButtonAddNewItemWidgetState();
}

class _ButtonAddNewItemWidgetState extends State<ButtonAddNewItemWidget> with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  late AnimationController _hoverAnimationController;

  @override
  void initState() {
    super.initState();
    _hoverAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: MouseRegion(
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: _buildAnimatedButton(),
      ),
    );
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });

    if (isHovered) {
      _hoverAnimationController.forward();
    } else {
      _hoverAnimationController.reverse();
    }
  }

  void _onButtonPressed() {
    context.goNamed('${AppRoutesConfig.collections}/${AppRoutesConfig.addNewGamePath}');
  }

  Widget _buildAnimatedButton() {
    return AnimatedBuilder(
      animation: _hoverAnimationController,
      builder: (context, child) {
        return CustomPaint(
          painter: TrapezoidShadowPainter(
            offset: _isHovered
                ? Tween<Offset>(
                    begin: const Offset(0, 0),
                    end: const Offset(3, 5),
                  ).evaluate(_hoverAnimationController)
                : Tween<Offset>(
                    begin: const Offset(0, 0),
                    end: const Offset(3, 5),
                  ).evaluate(_hoverAnimationController),
          ),
          child: Transform.translate(
            offset: Offset(
              0,
              _isHovered ? -1 * _hoverAnimationController.value : 0,
            ),
            child: _buildButtonContent(),
          ),
        );
      },
    );
  }

  Widget _buildButtonContent() {
    return CustomPaint(
      painter: TrapezoidBorderPainter(),
      child: ClipPath(
        clipper: TrapezoidClipper(),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _onButtonPressed,
            onTapDown: (_) => _onHover(true),
            onTapUp: (_) => _onHover(false),
            onTapCancel: () => _onHover(false),
            child: Stack(
              children: [
                AnimatedMainButtonBackgroundWidget(inputValue: _isHovered),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '+',
                          style: TextStyle(
                            color: AppTheme.primaryText,
                            fontFamily: FontConstant.grobold,
                            fontSize: 30,
                          ),
                        ),
                        TextSpan(
                          text: ' Game',
                          style: TextStyle(
                            color: AppTheme.primaryText,
                            fontFamily: FontConstant.grobold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hoverAnimationController.dispose();
    super.dispose();
  }
}

class TrapezoidClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width * 0.1, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.9, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path.shift(Offset(0, 0));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TrapezoidBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width * 0.1, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.9, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TrapezoidShadowPainter extends CustomPainter {
  final Offset offset;

  TrapezoidShadowPainter({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0);

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width * 0.1, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.9, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path.shift(offset), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
