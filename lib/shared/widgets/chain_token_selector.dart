import 'package:flutter/material.dart';
import 'package:gmgn_front/shared/widgets/chain_icon.dart';

class ChainTokenSelector extends StatelessWidget {
  final String chainId;
  final String tokenName;
  final VoidCallback? onTap;
  final double height;
  final double iconSize;
  final double fontSize;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? arrowColor;

  const ChainTokenSelector({
    Key? key,
    required this.chainId,
    required this.tokenName,
    this.onTap,
    this.height = 22,
    this.iconSize = 16,
    this.fontSize = 12,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.arrowColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: backgroundColor ?? const Color(0xFFF9FAFB),
          border: Border.all(color: borderColor ?? const Color(0xFFD1D5DB), width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: ChainIcon.getChainIcon(chainId, size: iconSize),
            ),
            const SizedBox(width: 4),
            Text(
              tokenName,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: textColor ?? const Color(0xFF1A1A1A),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: arrowColor ?? const Color(0xFF9CA3AF),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
} 