import 'package:flutter/material.dart';


class FilterBar extends StatelessWidget {
  /// 时间周期
  final String selectedPeriod;
  /// 时间周期选项
  final List<String> periodOptions;
  /// 筛选条件
  final String selectedFilter;
  /// 筛选条件选项
  final List<String> filterOptions;
  /// 排序方式
  final String selectedSort;
  /// 排序选项
  final List<String> sortOptions;
  /// 值改变回调
  final void Function(String?)? onPeriodChanged;
  final void Function(String?)? onFilterChanged;
  final void Function(String?)? onSortChanged;

  const FilterBar({
    Key? key,
    required this.selectedPeriod,
    required this.periodOptions,
    required this.selectedFilter,
    required this.filterOptions,
    required this.selectedSort,
    required this.sortOptions,
    this.onPeriodChanged,
    this.onFilterChanged,
    this.onSortChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 30,child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 第一个选择器：时间周期
          DropdownButton<String>(
            value: selectedPeriod,
            underline: const SizedBox(),
            items: periodOptions
                .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12))))
                .toList(),
            onChanged: onPeriodChanged,
            icon: const SizedBox(),
            isDense: true,
          ),
          const SizedBox(width: 16),
          // 第二个选择器：筛选条件
          DropdownButton<String>(
            value: selectedFilter,
            underline: const SizedBox(),
            items: filterOptions
                .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12))))
                .toList(),
            onChanged: onFilterChanged,
            icon: const SizedBox(),
            isDense: true,
          ),

          const Spacer(),
          // 第三个选择器：排序方式
          DropdownButton<String>(
            value: selectedSort,
            underline: const SizedBox(),
            items: sortOptions
                .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12))))
                .toList(),
            onChanged: onSortChanged,
            icon: const SizedBox(),
            isDense: true,
          ),
        ],
      ),
    ),);
  }
}
