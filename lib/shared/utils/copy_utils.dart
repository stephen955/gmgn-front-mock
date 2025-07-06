import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyUtils {

  static OverlayEntry? _currentEntry;

  static Future<void> copyWithTopTip(
      BuildContext context,
      String text, {
        String tip = '复制成功',
      }) async {
    // 1. 复制
    await Clipboard.setData(ClipboardData(text: text));

    // 2. 获取 Overlay
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    // 3. 如果已有提示框，先移除
    _currentEntry?.remove();
    _currentEntry = null;

    // 4. 构建新的 OverlayEntry
    _currentEntry = OverlayEntry(
      builder: (ctx) {
        return SafeArea(
          bottom: false,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 50, left: 24, right: 24),
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                tip,
                style: const TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ),
          ),
        );
      },
    );

    // 5. 插入并在延迟后移除
    overlay.insert(_currentEntry!);
    await Future.delayed(const Duration(milliseconds: 800));
    _currentEntry?.remove();
    _currentEntry = null;
  }
}