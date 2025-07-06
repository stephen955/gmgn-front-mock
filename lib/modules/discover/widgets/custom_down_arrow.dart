import 'package:flutter/material.dart';

class CustomDownArrow extends StatelessWidget {
  final double width;
  final double height;
  const CustomDownArrow({this.width = 24, this.height = 24, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _DownArrowPainter(),
      ),
    );
  }
}

class _DownArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 画黑色箭头
    final paintArrow = Paint()..color = Color(0xFF23242A);
    final path = Path();
    // 箭头头部
    path.moveTo(size.width / 2, size.height * 0.18); // 顶点
    path.lineTo(size.width * 0.18, size.height * 0.55); // 左下
    path.lineTo(size.width * 0.40, size.height * 0.55); // 左身
    path.lineTo(size.width * 0.40, size.height * 0.78); // 左身底
    path.lineTo(size.width * 0.60, size.height * 0.78); // 右身底
    path.lineTo(size.width * 0.60, size.height * 0.55); // 右身
    path.lineTo(size.width * 0.82, size.height * 0.55); // 右下
    path.close();
    canvas.drawPath(path, paintArrow);

    // 画底部青色矩形，与箭头身子宽度一致
    final paintBottom = Paint()..color = Color(0xFF1CF6F6);
    final bottomRect = Rect.fromLTWH(
      size.width * 0.40,
      size.height * 0.78,
      size.width * 0.20,
      size.height * 0.10,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bottomRect, Radius.circular(2)),
      paintBottom,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 