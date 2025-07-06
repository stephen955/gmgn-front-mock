/// 余额显示组件
/// 
/// 显示钱包余额的UI组件
/// 
/// 功能特性：
/// - 余额显示
/// - 加载状态
/// - 错误处理
/// - 重试功能

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/balance_cubit.dart';
import '../bloc/balance_state.dart';

/// 余额显示组件
class BalanceDisplay extends StatelessWidget {
  final String chainId;
  final String address;
  final bool showSymbol;
  final bool showLoading;
  final TextStyle? textStyle;
  final VoidCallback? onRetry;
  
  const BalanceDisplay({
    super.key,
    required this.chainId,
    required this.address,
    this.showSymbol = true,
    this.showLoading = true,
    this.textStyle,
    this.onRetry,
  });
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BalanceCubit, BalanceState>(
      builder: (context, state) {
        return _buildBalanceWidget(context, state);
      },
    );
  }
  
  Widget _buildBalanceWidget(BuildContext context, BalanceState state) {
    if (state is BalanceLoading) {
      return _buildLoadingWidget(context);
    } else if (state is BalanceLoaded) {
      return _buildLoadedWidget(context, state);
    } else if (state is BalanceError) {
      return _buildErrorWidget(context, state);
    } else if (state is MultiChainBalanceState) {
      return _buildMultiChainWidget(context, state);
    } else {
      return _buildInitialWidget(context);
    }
  }
  
  Widget _buildLoadingWidget(BuildContext context) {
    if (!showLoading) return const SizedBox.shrink();
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Loading...',
          style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
  
  Widget _buildLoadedWidget(BuildContext context, BalanceLoaded state) {
    final currentBalance = state.currentChainBalance;
    
    if (currentBalance == null) {
      return _buildErrorWidget(
        context, 
        const BalanceError('No balance data available'),
      );
    }
    
    final balanceText = showSymbol 
        ? currentBalance.formattedBalance
        : currentBalance.balance.toStringAsFixed(4);
    
    return Text(
      balanceText,
      style: textStyle ?? Theme.of(context).textTheme.bodyLarge,
    );
  }
  
  Widget _buildErrorWidget(BuildContext context, BalanceError state) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_outline,
          size: 16,
          color: Theme.of(context).colorScheme.error,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            'Error',
            style: (textStyle ?? Theme.of(context).textTheme.bodyMedium)?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        if (onRetry != null) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRetry,
            child: Icon(
              Icons.refresh,
              size: 16,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ],
    );
  }
  
  Widget _buildMultiChainWidget(BuildContext context, MultiChainBalanceState state) {
    final currentBalance = state.currentChainBalance;
    
    if (currentBalance == null) {
      return _buildErrorWidget(
        context, 
        const BalanceError('No balance data available'),
      );
    }
    
    final balanceText = showSymbol 
        ? currentBalance.formattedBalance
        : currentBalance.balance.toStringAsFixed(4);
    
    return Text(
      balanceText,
      style: textStyle ?? Theme.of(context).textTheme.bodyLarge,
    );
  }
  
  Widget _buildInitialWidget(BuildContext context) {
    return Text(
      '0.0000',
      style: (textStyle ?? Theme.of(context).textTheme.bodyLarge)?.copyWith(
        color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5),
      ),
    );
  }
}

/// 余额卡片组件
class BalanceCard extends StatelessWidget {
  final String chainId;
  final String address;
  final VoidCallback? onTap;
  final bool showChainName;
  final bool showAddress;
  
  const BalanceCard({
    super.key,
    required this.chainId,
    required this.address,
    this.onTap,
    this.showChainName = true,
    this.showAddress = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BalanceCubit, BalanceState>(
      builder: (context, state) {
        return Card(
          margin: const EdgeInsets.all(8),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showChainName) ...[
                    Row(
                      children: [
                        _buildChainIcon(chainId),
                        const SizedBox(width: 8),
                        Text(
                          _getChainDisplayName(chainId),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        _buildStatusIcon(state),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (showAddress) ...[
                    Text(
                      _formatAddress(address),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  _buildBalanceContent(context, state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildChainIcon(String chainId) {
    IconData iconData;
    Color iconColor;
    
    switch (chainId.toLowerCase()) {
      case 'sol':
        iconData = Icons.currency_bitcoin;
        iconColor = Colors.orange;
        break;
      case 'bsc':
        iconData = Icons.currency_bitcoin;
        iconColor = Colors.yellow.shade700;
        break;
      default:
        iconData = Icons.account_balance_wallet;
        iconColor = Colors.grey;
    }
    
    return Icon(iconData, color: iconColor, size: 20);
  }
  
  Widget _buildStatusIcon(BalanceState state) {
    if (state is BalanceLoading) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    } else if (state is BalanceError) {
      return Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 16,
      );
    } else {
      return Icon(
        Icons.check_circle_outline,
        color: Colors.green,
        size: 16,
      );
    }
  }
  
  Widget _buildBalanceContent(BuildContext context, BalanceState state) {
    if (state is BalanceLoading) {
      return Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text(
            'Loading balance...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      );
    } else if (state is BalanceLoaded) {
      final balance = state.currentChainBalance;
      if (balance == null) return const SizedBox.shrink();
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            balance.formattedBalance,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (balance.lastUpdated != null) ...[
            const SizedBox(height: 4),
            Text(
              'Updated: ${_formatDateTime(balance.lastUpdated!)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
              ),
            ),
          ],
        ],
      );
    } else if (state is BalanceError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Error loading balance',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              context.read<BalanceCubit>().fetchBalance(chainId, address);
            },
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ),
        ],
      );
    } else {
      return Text(
        '0.0000',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.headlineSmall?.color?.withOpacity(0.5),
        ),
      );
    }
  }
  
  String _getChainDisplayName(String chainId) {
    switch (chainId.toLowerCase()) {
      case 'sol':
        return 'Solana';
      case 'bsc':
        return 'BSC';
      default:
        return chainId.toUpperCase();
    }
  }
  
  String _formatAddress(String address) {
    if (address.length <= 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }
  
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
} 