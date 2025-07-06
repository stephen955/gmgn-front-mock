import 'package:flutter/material.dart';

class CategoryTabBar extends StatefulWidget implements PreferredSizeWidget {
  /// 标签列表
  final List<String> tabs;

  /// 初始选中索引
  final int initialIndex;

  /// 选中回调
  final ValueChanged<int>? onTabChange;

  const CategoryTabBar({
    Key? key,
    required this.tabs,
    this.initialIndex = 0,
    this.onTabChange,
  }) : super(key: key);

  @override
  _CategoryTabBarState createState() => _CategoryTabBarState();

  @override
  Size get preferredSize => const Size.fromHeight(44);
}

class _CategoryTabBarState extends State<CategoryTabBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(widget.tabs.length, (index) {
            final bool isSelected = index == _selectedIndex;
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: GestureDetector(
                onTap: () {
                  setState(() => _selectedIndex = index);
                  widget.onTabChange?.call(index);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, // 居中下划线
                  children: [
                    Text(
                      widget.tabs[index],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? Colors.black
                            : const Color(0xFF999999),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 20,
                      height: 2,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.transparent,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}