/// Chain Selector Dialog Widget
/// 
/// 链选择器对话框工具类，提供统一的链选择界面
/// 
/// 功能特性：
/// - 支持多链选择（SOL、BSC等）
/// - 统一的UI风格和交互
/// - 可配置的链选项
/// - 回调函数支持

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gmgn_front/gen/assets.gen.dart';
import 'package:gmgn_front/shared/chain_constants.dart';
import 'package:gmgn_front/shared/widgets/chain_icon.dart';

/// 链选项数据模型
class ChainOption {
  final String chainId;
  final String displayName;
  final String assetPath;
  final bool isSelected;

  const ChainOption({
    required this.chainId,
    required this.displayName,
    required this.assetPath,
    this.isSelected = false,
  });
}

/// 链选择器对话框工具类
class ChainSelectorDialog {
  /// 显示链选择器对话框
  /// 
  /// [context] - 上下文
  /// [currentChain] - 当前选中的链
  /// [availableChains] - 可用的链选项列表
  /// [onChainSelected] - 链选择回调函数
  /// [title] - 对话框标题，默认为 'Switch Chain'
  static Future<void> show({
    required BuildContext context,
    required String currentChain,
    required List<ChainOption> availableChains,
    required Function(String) onChainSelected,
    String title = 'Switch Chain',
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) => _ChainSelectorContent(
        currentChain: currentChain,
        availableChains: availableChains,
        onChainSelected: onChainSelected,
        title: title,
      ),
    );
  }

  /// 获取默认的链选项列表
  static List<ChainOption> getDefaultChains(String currentChain) {
    return [
      ChainOption(
        chainId: ChainConstants.sol,
        displayName: 'SOL',
        assetPath: Assets.solana.path,
        isSelected: currentChain == ChainConstants.sol,
      ),
      ChainOption(
        chainId: ChainConstants.bsc,
        displayName: 'BSC',
        assetPath: Assets.bsc,
        isSelected: currentChain == ChainConstants.bsc,
      ),
    ];
  }

  /// 获取所有可用的链选项列表
  static List<ChainOption> getAllAvailableChains(String currentChain) {
    return [
      ChainOption(
        chainId: ChainConstants.sol,
        displayName: 'SOL',
        assetPath: Assets.solana.path,
        isSelected: currentChain == ChainConstants.sol,
      ),
      ChainOption(
        chainId: ChainConstants.bsc,
        displayName: 'BSC',
        assetPath: Assets.bsc,
        isSelected: currentChain == ChainConstants.bsc,
      ),
      ChainOption(
        chainId: ChainConstants.eth,
        displayName: 'ETH',
        assetPath: Assets.ether.path,
        isSelected: currentChain == ChainConstants.eth,
      ),
      ChainOption(
        chainId: ChainConstants.tron,
        displayName: 'TRON',
        assetPath: Assets.tron.path,
        isSelected: currentChain == ChainConstants.tron,
      ),
    ];
  }

  /// 根据链ID获取显示名称
  static String getDisplayName(String chainId) {
    switch (chainId) {
      case ChainConstants.sol:
        return 'SOL';
      case ChainConstants.bsc:
        return 'BSC';
      case ChainConstants.eth:
        return 'ETH';
      case ChainConstants.tron:
        return 'TRON';
      default:
        return chainId.toUpperCase();
    }
  }
}

/// 链选择器内容组件
class _ChainSelectorContent extends StatelessWidget {
  final String currentChain;
  final List<ChainOption> availableChains;
  final Function(String) onChainSelected;
  final String title;

  const _ChainSelectorContent({
    required this.currentChain,
    required this.availableChains,
    required this.onChainSelected,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, left: 0, right: 0, bottom: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildModalHandle(),
              _buildModalTitle(),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ..._buildChainOptions(context),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              _buildCloseButton(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建模态框手柄
  Widget _buildModalHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  /// 构建模态框标题
  Widget _buildModalTitle() {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        letterSpacing: 0.2,
      ),
    );
  }

  /// 构建链选项列表
  List<Widget> _buildChainOptions(BuildContext context) {
    final List<Widget> widgets = [];
    
    for (int i = 0; i < availableChains.length; i++) {
      final chain = availableChains[i];
      widgets.add(_buildChainOptionCard(context, chain));
      
      // 添加间距（除了最后一个）
      if (i < availableChains.length - 1) {
        widgets.add(const SizedBox(height: 16));
      }
    }
    
    return widgets;
  }

  /// 构建链选项卡片
  Widget _buildChainOptionCard(BuildContext context, ChainOption chain) {
    final isSelected = currentChain == chain.chainId;
    return GestureDetector(
      onTap: () {
        onChainSelected(chain.chainId);
        Navigator.pop(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF6E727D) : const Color(0xFFE7EBEC),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            _buildChainIcon(chain.assetPath),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                chain.displayName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            _buildSelectionIndicator(isSelected),
          ],
        ),
      ),
    );
  }

  /// 构建链图标
  Widget _buildChainIcon(String assetPath) {
    // 从 assetPath 中提取链名
    final chainName = _extractChainNameFromAssetPath(assetPath);
    return ChainIcon.getChainIcon(chainName, size: 32);
  }

  /// 从资源路径中提取链名
  String _extractChainNameFromAssetPath(String assetPath) {
    // 使用 Assets 常量来匹配路径
    if (assetPath == Assets.solana.path) {
      return ChainConstants.sol;
    } else if (assetPath == Assets.bsc) {
      return ChainConstants.bsc;
    } else if (assetPath == Assets.ether.path) {
      return ChainConstants.eth;
    } else if (assetPath == Assets.tron.path) {
      return ChainConstants.tron;
    }
    // 如果路径不匹配，尝试从路径中提取链名
    if (assetPath.contains('solana')) {
      return ChainConstants.sol;
    } else if (assetPath.contains('bsc')) {
      return ChainConstants.bsc;
    } else if (assetPath.contains('ether')) {
      return ChainConstants.eth;
    } else if (assetPath.contains('tron')) {
      return ChainConstants.tron;
    }
    // 默认返回原始路径的最后一部分作为链名
    return assetPath.split('/').last.split('.').first;
  }

  /// 构建选择指示器
  Widget _buildSelectionIndicator(bool isSelected) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? const Color(0xFF23262F) : const Color(0xFFD3D6DB),
          width: 2.0,
        ),
        color: Colors.white,
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFF23262F),
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }

  /// 构建关闭按钮
  Widget _buildCloseButton(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 48,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF5F6F8),
            foregroundColor: Colors.black,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Close',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
} 