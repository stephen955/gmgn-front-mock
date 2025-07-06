import 'package:flutter/material.dart';

class PnlCarWidget extends StatelessWidget {
  const PnlCarWidget({super.key});

  static const _itemPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static const _labelStyle = TextStyle(fontSize: 14, color: Color(0xFF666666), height: 1.2);
  static const _valueStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF333333), height: 1.2);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        // 调用示例
        _buildPnLContent(),
      ],
    );
  }

  Widget _buildPnLContent() {
    // （假数据固定，就算真实项目里从后端传来也照样显示）
    const barColor = Color(0xFF333333);
    const barWidth = 8.0;
    const barHeight = 40.0;
    const dashSize = 4.0;
    const dashCount = 20;
    const dashColor = Color(0xFFCCCCCC);

    return Padding(
      padding: _itemPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // —— 标题行 ——
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('已实现利润', style: _labelStyle),
              Text('胜率 0%', style: _valueStyle),
            ],
          ),
          const SizedBox(height: 8),
          // —— 数值行 ——
          Text(
            '+0% (+0 SOL)',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF00C851),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          // —— 柱子 + 虚线基线 ——
          Column(
            children: [
              // 实心黑柱
              SizedBox(
                height: barHeight,
                child: Center(
                  child: Container(
                    width: barWidth,
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(barWidth / 2),
                    ),
                  ),
                ),
              ),
              // 虚线基线
              SizedBox(
                height: dashSize,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(dashCount, (_) {
                    return Container(
                      width: dashSize,
                      height: dashSize,
                      decoration: BoxDecoration(
                        color: dashColor,
                        borderRadius: BorderRadius.circular(dashSize / 2),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}