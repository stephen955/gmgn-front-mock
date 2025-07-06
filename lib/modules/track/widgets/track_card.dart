import 'package:flutter/material.dart';
import 'package:gmgn_front/shared/utils/image_utils.dart';
import 'package:gmgn_front/shared/utils/copy_utils.dart';

class TrackCard extends StatelessWidget {
  final String name;
  final String address;
  final int rank;
  final double profit;
  final double pnlPercent;
  final double totalValue;
  final int tradeCount;
  final int winTradeCount;
  final int loseTradeCount;
  final double winRate;
  final int followers;
  final String avatar;
  final String chainLogo;
  final String timeInfo;
  final VoidCallback? onFollow;

  const TrackCard({
    Key? key,
    required this.name,
    required this.address,
    required this.rank,
    required this.profit,
    required this.pnlPercent,
    required this.totalValue,
    required this.tradeCount,
    required this.winTradeCount,
    required this.loseTradeCount,
    required this.winRate,
    required this.followers,
    required this.avatar,
    required this.chainLogo,
    required this.timeInfo,
    this.onFollow,
  }) : super(key: key);

  String _shortAddress(String address) {
    if (address.isEmpty) return '';
    if (address.length <= 8) return address;
    return address.substring(0, 4) + '...' + address.substring(address.length - 4);
  }

  void _copyToClipboard(BuildContext context, String text) {
    CopyUtils.copyWithTopTip(context, text, tip: '复制成功');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      height: 130,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE7EBEC), width: 0.5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ===== 左侧信息区 =====
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _TrackCardHeader(
                        avatar: avatar,
                        name: name,
                        address: address,
                        chainLogo: chainLogo,
                        totalValue: totalValue,
                        onCopy: () => _copyToClipboard(context, address),
                        avatarRightPadding: 6,
                        nameBottomPadding: 2,
                        addressBottomPadding: 2,
                      ),
                      const SizedBox(height: 6),
                      _TrackCardProfitInfo(
                        profit: profit,
                        pnlPercent: pnlPercent,
                        followers: followers,
                        formatMoney: _formatMoney,
                        formatNumber: _formatNumber,
                        profitBottomPadding: 2,
                        pnlBottomPadding: 4,
                      ),
                    ],
                  ),
                ),
                // ===== 右侧统计区 =====
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: _TrackCardStats(
                    winRate: winRate,
                    tradeCount: tradeCount,
                    winTradeCount: winTradeCount,
                    loseTradeCount: loseTradeCount,
                    timeInfo: timeInfo,
                    onFollow: onFollow,
                    formatNumber: _formatNumber,
                    buttonBottomPadding: 6,
                    statRowPadding: 2,
                  ),
                ),
              ],
            ),
          ),
          // ===== 排名标签 =====
          if (rank == 1 || rank == 2 || rank == 3)
            _TrackCardRankTag(rank: rank),
        ],
      ),
    );
  }

  String _formatMoney(double value) {
    if (value.abs() >= 1000) {
      return '${(value / 1000).toStringAsFixed(2)}K';
    }
    return value.toString();
  }

  String _formatNumber(int value) {
    if (value >= 1000) {
      return (value / 1000).toStringAsFixed(2);
    }
    return value.toString();
  }
}

class _TrackCardHeader extends StatelessWidget {
  final String avatar;
  final String name;
  final String address;
  final String chainLogo;
  final double totalValue;
  final VoidCallback onCopy;
  final double avatarRightPadding;
  final double nameBottomPadding;
  final double addressBottomPadding;
  const _TrackCardHeader({
    required this.avatar,
    required this.name,
    required this.address,
    required this.chainLogo,
    required this.totalValue,
    required this.onCopy,
    this.avatarRightPadding = 6,
    this.nameBottomPadding = 2,
    this.addressBottomPadding = 2,
  });
  String _shortAddress(String address) {
    if (address.isEmpty) return '';
    if (address.length <= 8) return address;
    return address.substring(0, 4) + '...' + address.substring(address.length - 4);
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: ImageUtils.loadNetworkImage(
              imageUrl: avatar,
              width: 28,
              height: 28,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: avatarRightPadding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      _shortAddress(name),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF222222),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.edit, size: 14, color: Color(0xFFBDBDBD)),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: onCopy,
                    child: Icon(Icons.copy, size: 14, color: Color(0xFFBDBDBD)),
                  ),
                ],
              ),
              SizedBox(height: nameBottomPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _shortAddress(address),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFBDBDBD),
                    ),
                  ),
                  const SizedBox(width: 0),
                  if (chainLogo.isNotEmpty)
                    ImageUtils.loadNetworkImage(
                      imageUrl: chainLogo,
                      width: 12,
                      height: 12,
                    ),
                  const SizedBox(width: 6),
                  Text(
                    totalValue.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF222222),
                    ),
                  ),
                ],
              ),
              SizedBox(height: addressBottomPadding),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrackCardProfitInfo extends StatelessWidget {
  final double profit;
  final double pnlPercent;
  final int followers;
  final String Function(double) formatMoney;
  final String Function(int) formatNumber;
  final double profitBottomPadding;
  final double pnlBottomPadding;
  const _TrackCardProfitInfo({
    required this.profit,
    required this.pnlPercent,
    required this.followers,
    required this.formatMoney,
    required this.formatNumber,
    this.profitBottomPadding = 2,
    this.pnlBottomPadding = 4,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '+${formatMoney(profit)}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00C566),
          ),
        ),
        SizedBox(height: profitBottomPadding),
        Text(
          '(${pnlPercent > 0 ? '+' : ''}${pnlPercent.toStringAsFixed(1)}%) PnL',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFFBDBDBD),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: pnlBottomPadding),
        Row(
          children: [
            Text(
              formatNumber(followers),
              style: const TextStyle(fontSize: 12, color: Color(0xFF222222), fontWeight: FontWeight.w400),
            ),
            const SizedBox(width: 2),
            Text(
              '粉丝',
              style: const TextStyle(fontSize: 12, color: Color(0xFFBDBDBD)),
            ),
          ],
        ),
      ],
    );
  }
}

class _TrackCardStats extends StatelessWidget {
  final double winRate;
  final int tradeCount;
  final int winTradeCount;
  final int loseTradeCount;
  final String timeInfo;
  final VoidCallback? onFollow;
  final String Function(int) formatNumber;
  final double buttonBottomPadding;
  final double statRowPadding;
  const _TrackCardStats({
    required this.winRate,
    required this.tradeCount,
    required this.winTradeCount,
    required this.loseTradeCount,
    required this.timeInfo,
    required this.onFollow,
    required this.formatNumber,
    this.buttonBottomPadding = 0,
    this.statRowPadding = 2,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: onFollow ?? () {},
          icon: const Icon(Icons.favorite_border, size: 12, color: Color(0xFFFFFFFF)),
          label: const Text('追踪', style: TextStyle(fontSize: 12, color: Color(0xFFFFFFFF))),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF222328),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            minimumSize: const Size(0, 24),
          ),
        ),
        SizedBox(height: buttonBottomPadding),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('胜率 ', style: TextStyle(fontSize: 12, color: Color(0xFFBDBDBD))),
            Text('胜率  ${winRate.toStringAsFixed(1)}%',style: const TextStyle(fontSize: 12, color: Color(0xFFBDBDBD)),),
          ],
        ),
        SizedBox(height: statRowPadding),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('交易数 ', style: TextStyle(fontSize: 12, color: Color(0xFFBDBDBD))),
            Text(formatNumber(tradeCount), style: TextStyle(fontSize: 12, color: Color(0xFF222222), fontWeight: FontWeight.w600)),
            const SizedBox(width: 2),
            Text('(', style: TextStyle(fontSize: 12, color: Color(0xFFBDBDBD))),
            Text(formatNumber(winTradeCount), style: TextStyle(fontSize: 12, color: Color(0xFF00C566), fontWeight: FontWeight.w600)),
            Text('/', style: TextStyle(fontSize: 12, color: Color(0xFFBDBDBD))),
            Text(formatNumber(loseTradeCount), style: TextStyle(fontSize: 12, color: Color(0xFFF03D3D), fontWeight: FontWeight.w600)),
            Text(')', style: TextStyle(fontSize: 12, color: Color(0xFFBDBDBD))),
          ],
        ),
        SizedBox(height: statRowPadding),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('最后活动 ', style: TextStyle(fontSize: 12, color: Color(0xFFBDBDBD))),
            Text(timeInfo, style: TextStyle(fontSize: 12, color: Color(0xFF222222))),
          ],
        ),
      ],
    );
  }
}

class _TrackCardRankTag extends StatelessWidget {
  final int rank;
  const _TrackCardRankTag({required this.rank});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        height: 16,
        decoration: BoxDecoration(
          color: rank == 1
              ? Color(0xFFFFE066)
              : (rank == 2 ? Color(0xFFE0E0E0) : Color(0xFFFFC266)),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Text(
          rank == 1 ? '1st' : (rank == 2 ? '2nd' : '3rd'),
          style: const TextStyle(
            fontSize: 8,
            color: Color(0xFF222222),
          ),
        ),
      ),
    );
  }
} 