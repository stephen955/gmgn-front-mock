/// Discover Tab Filter Widget
/// 
/// 发现页面的标签筛选组件，包含链选择、筛选按钮、刷新功能等
/// 
/// 功能特性：
/// - 支持多链切换（SOL、BSC等）
/// - 提供筛选按钮（已验证、筛选、收藏）
/// - 操作按钮切换（新创建、即将开始、已开启、飙升）
/// - 自动刷新功能，支持暂停/恢复
/// - 响应式布局适配

// Dart标准库导入
import 'package:flutter/material.dart';

// 第三方包导入
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 项目内部文件导入
import 'package:gmgn_front/l10n/app_localizations.dart';
import 'package:gmgn_front/l10n/l10n_extension.dart';
import 'package:gmgn_front/shared/widgets/chain_icon.dart';
import 'package:gmgn_front/shared/widgets/chain_selector_dialog.dart';

/// 发现页面标签筛选组件
class DiscoverTabFilter extends StatefulWidget {
  /// 当前选中的链
  final String currentChain;
  
  /// 链切换回调函数
  final Function(String)? onChainChanged;
  
  /// 筛选参数变化回调函数
  final Function(Map<String, dynamic>?)? onFilterChanged;
  
  /// 自动刷新状态变化回调函数
  final Function(bool)? onAutoRefreshChanged;
  
  /// 自动刷新状态是否启用
  final bool autoRefreshEnabled;
  
  const DiscoverTabFilter({
    super.key,
    required this.currentChain,
    this.onChainChanged,
    this.onFilterChanged,
    this.onAutoRefreshChanged,
    this.autoRefreshEnabled = false,
  });

  @override
  State<DiscoverTabFilter> createState() => _DiscoverTabFilterState();
}

class _DiscoverTabFilterState extends State<DiscoverTabFilter> 
    with TickerProviderStateMixin {

  static const Duration _refreshDuration = Duration(seconds: 1);
  static const double _iconSize = 16.0;
  static const double _buttonHeight = 20.0;
  static const double _tabHeight = 24.0;
  
  
  int selectedActionIndex = 0;
  int selectedIconIndex = 0;
  int selectedTab = 0;
  

  bool isRefreshing = false;
  late AnimationController _refreshAnimationController;
  late Animation<double> _refreshAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    if (widget.autoRefreshEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startRefresh();
      });
    }
  }

  @override
  void didUpdateWidget(covariant DiscoverTabFilter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autoRefreshEnabled && !isRefreshing) {
      _startRefresh();
    } else if (!widget.autoRefreshEnabled && isRefreshing) {
      _stopRefresh();
    }
  }

  @override
  void dispose() {
    _refreshAnimationController.dispose();
    super.dispose();
  }

  
  void _initializeAnimation() {
    _refreshAnimationController = AnimationController(
      duration: _refreshDuration,
      vsync: this,
    );
    _refreshAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _refreshAnimationController,
      curve: Curves.linear,
    ));
  }


  void _startRefresh() {
    setState(() {
      isRefreshing = true;
    });
    _refreshAnimationController.repeat();
    // 延迟调用回调，避免在build过程中调用setState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onAutoRefreshChanged?.call(true);
    });
  }

  
  void _stopRefresh() {
    setState(() {
      isRefreshing = false;
    });
    _refreshAnimationController.stop();
    // 延迟调用回调，避免在build过程中调用setState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onAutoRefreshChanged?.call(false);
    });
  }

  /// 切换刷新状态
  void _toggleRefresh() {
    if (isRefreshing) {
      _stopRefresh();
    } else {
      _startRefresh();
    }
  }

  /// 切换链
  void _onChainChanged(String chain) {
    widget.onChainChanged?.call(chain);
  }

  /// 更新筛选参数
  void _updateFilterParams() {
    Map<String, dynamic>? filterParams = {};
    
    // 根据选中的操作按钮添加参数
    switch (selectedActionIndex) {
      case 0: // 新创建
        filterParams['action'] = 'new_creation';
        break;
      case 1: // 即将开始
        filterParams['action'] = 'upcoming';
        break;
      case 2: // 已开启
        filterParams['action'] = 'opened';
        break;
      case 3: // 飙升
        filterParams['action'] = 'soaring';
        break;
    }
    
    // 根据选中的图标按钮添加额外参数
    switch (selectedIconIndex) {
      case 0: // 已验证
        filterParams['verified'] = true;
        break;
      case 1: // 筛选
        filterParams['filtered'] = true;
        break;
      case 2: // 收藏
        filterParams['favorited'] = true;
        break;
    }
    
    widget.onFilterChanged?.call(filterParams);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopTabRow(widget.currentChain),
          const SizedBox(height: 10),
          _buildFilterButtonRow(),
          const SizedBox(height: 6),
          _buildSecondaryActionRow(),
          const SizedBox(height: 2),
        ],
      ),
    );
  }

  /// 构建顶部标签行
  Widget _buildTopTabRow(String currentChain) {
    final tabs = [
      context.l10n.tabWatchlist,
      context.l10n.tabTrenches,
      context.l10n.tabNew,
      context.l10n.tabTrending,
      context.l10n.tabXStocks,
    ];

    return SizedBox(
      height: _tabHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...List.generate(tabs.length, (i) => _buildTabItem(tabs[i], i)),
          const Spacer(),
          _buildChainSelector(currentChain),
        ],
      ),
    );
  }

  /// 构建标签项
  Widget _buildTabItem(String tabText, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Text(
          tabText,
          style: TextStyle(
            fontSize: 14,
            fontWeight: index == selectedTab ? FontWeight.bold : FontWeight.normal,
            color: index == selectedTab ? const Color(0xFF333333) : const Color(0xFFAEB2BD),
          ),
        ),
      ),
    );
  }

  /// 构建链选择器
  Widget _buildChainSelector(String currentChain) {
    return GestureDetector(
      onTap: () => _showChainSelector(),
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xFFF8F9FB),
          border: Border.all(color: const Color(0xFFBFBFBF), width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: ChainIcon.getChainIcon(currentChain, size: 16),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFFAEB2BD),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建筛选按钮行
  Widget _buildFilterButtonRow() {
    final iconButtons = [
      _IconBtnData(Icons.check_circle, const Color(0xFF2DE66F), Colors.white, true),
      _IconBtnData(Icons.filter_alt_outlined, const Color(0xFFF2F2F2), const Color(0xFF666666), false),
      _IconBtnData(Icons.star_border, const Color(0xFFF2F2F2), const Color(0xFF666666), false),
    ];

    final actionBtns = [
      context.l10n.btnNewCreation,
      context.l10n.pillUpcoming,
      context.l10n.pillOpened,
      context.l10n.pillSoaring,
    ];

    return Container(
      height: _buttonHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIconButtonContainer(iconButtons),
          const SizedBox(width: 6),
          ...List.generate(actionBtns.length, (i) => _buildActionButton(actionBtns[i], i)),
        ],
      ),
    );
  }

  /// 构建图标按钮容器
  Widget _buildIconButtonContainer(List<_IconBtnData> iconButtons) {
    return Container(
      width: 70,
      height: _buttonHeight,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F8),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: List.generate(iconButtons.length, (i) => _buildIconButton(iconButtons[i], i)),
      ),
    );
  }

  /// 构建图标按钮
  Widget _buildIconButton(_IconBtnData iconData, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIconIndex = index;
          });
          _updateFilterParams();
        },
        child: Container(
          height: 18,
          decoration: BoxDecoration(
            color: selectedIconIndex == index ? const Color(0xFF2DE66F) : const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Icon(
            iconData.icon,
            color: selectedIconIndex == index ? iconData.iconColor : const Color(0xFFBFBFBF),
            size: 18,
          ),
        ),
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButton(String buttonText, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selectedActionIndex = index;
            });
            _updateFilterParams();
          },
          child: Container(
            height: _buttonHeight,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: selectedActionIndex == index ? const Color(0xFF333333) : const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 12,
                color: selectedActionIndex == index ? Colors.white : const Color(0xFFAEB2BD),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        if (index < 4 - 1) const SizedBox(width: 6),
      ],
    );
  }

  /// 构建次级操作行
  Widget _buildSecondaryActionRow() {
    return SizedBox(
      height: 22,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildFilterButton(),
          const SizedBox(width: 16),
          _buildRefreshButton(),
        ],
      ),
    );
  }

  /// 构建筛选按钮
  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: () => _showFilterDialog(),
      child: Row(
        children: [
          const Icon(Icons.filter_list, size: 16, color: Color(0xFF333333)),
          const SizedBox(width: 4),
          Text(
            context.l10n.btnFilter,
            style: const TextStyle(fontSize: 12, color: Color(0xFF333333)),
          ),
        ],
      ),
    );
  }

  /// 构建刷新按钮
  Widget _buildRefreshButton() {
    return GestureDetector(
      onTap: _toggleRefresh,
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _refreshAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _refreshAnimation.value * 2 * 3.14159,
                child: Icon(
                  Icons.autorenew,
                  size: _iconSize,
                  color: isRefreshing ? const Color(0xFFFF8C00) : const Color(0xFF666666),
                ),
              );
            },
          ),
          const SizedBox(width: 4),
          Text(
            isRefreshing ? context.l10n.btnRefresh : context.l10n.btnPaused,
            style: TextStyle(
              fontSize: 12,
              color: isRefreshing ? const Color(0xFF333333) : const Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  /// 显示链选择器
  void _showChainSelector() {
    final availableChains = ChainSelectorDialog.getAllAvailableChains(widget.currentChain);
    
    ChainSelectorDialog.show(
      context: context,
      currentChain: widget.currentChain,
      availableChains: availableChains,
      onChainSelected: _onChainChanged,
    );
  }

  /// 显示筛选对话框
  void _showFilterDialog() {
   // TODO：filter
  }
}

/// 标签标签组件
class _TabLabel extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback? onTap;
  
  const _TabLabel({
    required this.text,
    required this.selected,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 24),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
            color: selected ? const Color(0xFF333333) : const Color(0xFFBFBFBF),
          ),
        ),
      ),
    );
  }
}

/// 图标按钮组件
class _IconButton extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final bool selected;
  final VoidCallback? onTap;
  
  const _IconButton({
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    this.selected = false,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: selected
              ? [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 2))]
              : [],
        ),
        child: Icon(icon, size: 16, color: iconColor),
      ),
    );
  }
}

/// 胶囊按钮组件
class _Pill extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback? onTap;
  
  const _Pill({
    required this.text,
    this.selected = false,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF333333) : const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: selected ? Colors.white : const Color(0xFF666666),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

/// 图标按钮数据类
class _IconBtnData {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final bool selected;
  
  const _IconBtnData(this.icon, this.bgColor, this.iconColor, this.selected);
} 