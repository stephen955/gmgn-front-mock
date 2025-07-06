import 'package:flutter/material.dart';
import 'package:gmgn_front/l10n/app_localizations.dart';
import 'package:gmgn_front/gen/assets.gen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gmgn_front/modules/discover/widgets/custom_down_arrow.dart';
import 'package:gmgn_front/shared/widgets/chain_icon.dart';
import 'package:gmgn_front/shared/widgets/chain_selector_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmgn_front/shared/utils/chain_cubit.dart';
import 'package:gmgn_front/shared/widgets/chain_token_selector.dart';
import 'package:gmgn_front/shared/utils/token_utils.dart';

class AssetOverviewCard extends StatefulWidget {
  final String? iconUrl;
  final String tokenName;
  final Color backgroundColor;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry contentPadding;
  
  const AssetOverviewCard({
    super.key, 
    this.iconUrl, 
    this.tokenName = 'SOL',
    this.backgroundColor = const Color(0x00000000), 
    this.margin = const EdgeInsets.only(top: 0, left: 16, right: 16),
    this.contentPadding = const EdgeInsets.symmetric(vertical: 12),
  });

  @override
  State<AssetOverviewCard> createState() => _AssetOverviewCardState();
}

class _AssetOverviewCardState extends State<AssetOverviewCard> {
  bool _isBalanceVisible = true;
  
  static const Color _mainColor = Color(0xFF72F5E5);
  static const Color _textColor = Color(0xFF1A1A1A);
  static const Color _secondaryTextColor = Color(0xFF4A4A4A);
  static const Color _lightTextColor = Color(0xFF6B7280);
  static const Color _borderColor = Color(0xFFE5E7EB);
  static const Color _chainBorderColor = Color(0xFFD1D5DB);
  static const Color _chainBackgroundColor = Color(0xFFF9FAFB);
  static const Color _arrowColor = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    final currentChain = context.watch<ChainCubit>().state;
    final showIconUrl = _getIconUrl();
    final showTokenName = TokenUtils.getTokenName(
      currentChain,
      fallback: widget.tokenName.isNotEmpty ? widget.tokenName : 'SOL',
    );

    return Padding(
      padding: widget.margin,
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: widget.contentPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildChainSelector(currentChain),
              const SizedBox(height: 8),
              _buildBalanceSection(showTokenName),
              const SizedBox(height: 18),
              _buildActionButtons(),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }

  String _getIconUrl() {
    return (widget.iconUrl != null && widget.iconUrl!.isNotEmpty) 
        ? widget.iconUrl! 
        : Assets.icons.solIcon;
  }

  Widget _buildChainSelector(String currentChain) {
    final showTokenName = TokenUtils.getTokenName(
      currentChain,
      fallback: widget.tokenName.isNotEmpty ? widget.tokenName : 'SOL',
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ChainTokenSelector(
          chainId: currentChain,
          tokenName: showTokenName,
          onTap: () => _showChainSelector(currentChain),
        ),
        const SizedBox(width: 6),
        _buildBalanceLabel(),
        const SizedBox(width: 6),
        _buildVisibilityToggle(),
      ],
    );
  }

  Widget _buildBalanceLabel() {
    return Text(
      '总余额',
      style: TextStyle(fontSize: 12, color: _lightTextColor),
    );
  }

  Widget _buildVisibilityToggle() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isBalanceVisible = !_isBalanceVisible;
        });
      },
      child: Icon(
        _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
        size: 14,
        color: _arrowColor,
      ),
    );
  }

  Widget _buildBalanceSection(String showTokenName) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '≈', 
          style: TextStyle(fontSize: 18, color: _secondaryTextColor),
        ),
        const SizedBox(width: 4),
        Text(
          _isBalanceVisible ? '9831' : '****',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600, 
            color: _textColor,
          ),
        ),
        const SizedBox(width: 4),
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(
            showTokenName,
            style: const TextStyle(
              fontSize: 14, 
              color: _textColor, 
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(child: _buildActionButton('充值', true)),
        const SizedBox(width: 12),
        Expanded(child: _buildActionButton('提现', false)),
      ],
    );
  }

  Widget _buildActionButton(String text, bool isDeposit) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _borderColor),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isDeposit)
              Transform.rotate(
                angle: 3.1416, // 180度
                child: CustomDownArrow(width: 24, height: 24),
              )
            else
              CustomDownArrow(width: 24, height: 24),
            const SizedBox(width: 6),
            Text(
              text, 
              style: TextStyle(
                fontSize: 12,
                color: _textColor, 
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 显示链选择器
  void _showChainSelector(String currentChain) {
    final availableChains = ChainSelectorDialog.getAllAvailableChains(currentChain);
    
    ChainSelectorDialog.show(
      context: context,
      currentChain: currentChain,
      availableChains: availableChains,
      onChainSelected: (chain) {
        // 通过 ChainCubit 更新链选择
        context.read<ChainCubit>().setChain(chain);
      },
    );
  }
} 