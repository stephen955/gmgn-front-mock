import 'package:flutter/material.dart';
import 'package:gmgn_front/gen/assets.gen.dart';
import 'wallet_item.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gmgn_front/shared/utils/image_utils.dart';
import 'package:gmgn_front/shared/utils/copy_utils.dart';
import 'package:gmgn_front/shared/utils/string_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SmartMoneyCard extends StatelessWidget {
  // 颜色常量
  static const Color _primaryTextColor = Color(0xFF222222);
  static const Color _secondaryTextColor = Color(0xFFBDBDBD);
  static const Color _positiveColor = Color(0xFF00C566);
  static const Color _negativeColor = Color(0xFFF03D3D);
  static const Color _cardBackgroundColor = Color(0xFFF9FBFC);
  static const Color _dividerColor = Color(0xFFF0F0F0);
  static const Color _buyButtonBorderColor = Color(0xFF19C37C);

  final String name;
  final String address;
  final int people;
  final String netInflow;
  final String v;
  final String mc;
  final String percent;
  final Color percentColor;
  final String wallet;
  final String trades;
  final String flow;
  final String amount;
  final String timeInfo;
  final String? logo;
  final VoidCallback? onBuy;
  final List<dynamic>? wallets;

  const SmartMoneyCard({
    Key? key,
    required this.name,
    required this.address,
    required this.people,
    required this.netInflow,
    required this.v,
    required this.mc,
    required this.percent,
    required this.percentColor,
    required this.wallet,
    required this.trades,
    required this.flow,
    required this.amount,
    required this.timeInfo,
    this.logo,
    this.onBuy,
    this.wallets,
  }) : super(key: key);

  String _shortAddress(String address) {
    if (address.isEmpty) return '';
    return StringUtils.truncateAddress(address);
  }

  void _copyToClipboard(BuildContext context, String text) {
    CopyUtils.copyWithTopTip(context, text, tip: '复制成功');
  }

  Widget _buyButton(BuildContext context) {
    return InkWell(
      onTap: onBuy,
      child: Container(
        width: 56,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _buyButtonBorderColor, width: 0.5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              Assets.buy,
              width: 16,
              height: 16,
              color: _buyButtonBorderColor,
              placeholderBuilder: (context) => Icon(
                Icons.shopping_cart,
                size: 16,
                color: _buyButtonBorderColor,
              ),
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.shopping_cart,
                size: 16,
                color: _buyButtonBorderColor,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '买入',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _primaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: _cardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部行
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 头像
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[200],
                  child: ClipOval(
                    child: ImageUtils.loadNetworkImage(
                      imageUrl: logo ?? '',
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: _primaryTextColor,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.search, size: 15, color: _secondaryTextColor),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(_shortAddress(address), style: TextStyle(
                            color: _secondaryTextColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          )),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => _copyToClipboard(context, address),
                            child: Icon(Icons.copy, size: 14, color: _secondaryTextColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),
                _buyButton(context),
              ],
            ),
            const SizedBox(height: 10),
            // 24h聪明钱净流入
            Row(
              children: [
                Text('24h 聪明钱 净流入', style: TextStyle(
                  color: _secondaryTextColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                )),
                const SizedBox(width: 6),
                Icon(Icons.people, size: 15, color: _secondaryTextColor),
                const SizedBox(width: 2),
                Text('$people', style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  color: _primaryTextColor,
                )),
                const SizedBox(width: 8),
                Text(netInflow, style: TextStyle(
                  color: netInflow.startsWith('+') ? _positiveColor : _negativeColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  letterSpacing: 0.2,
                )),
              ],
            ),
            const SizedBox(height: 8),
            // 统计数据行
            Row(
              children: [
                Icon(Icons.people, size: 15, color: _secondaryTextColor),
                const SizedBox(width: 2),
                Text('$people', style: TextStyle(
                  fontSize: 10,
                  color: _primaryTextColor,
                  fontWeight: FontWeight.w500,
                )),
                const SizedBox(width: 10),
                Text('24h V $v', style: TextStyle(
                  fontSize: 10,
                  color: _primaryTextColor,
                  fontWeight: FontWeight.w500,
                )),
                const SizedBox(width: 10),
                Text('MC $mc', style: TextStyle(
                  fontSize: 10,
                  color: _primaryTextColor,
                  fontWeight: FontWeight.w500,
                )),
                const SizedBox(width: 10),
                Text(percent, style: TextStyle(
                  color: percentColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                )),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              height: 1,
              color: _dividerColor,
            ),
            // 表头+数据对齐
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                children: [
                  // 表头
                  Row(
                    children: [
                      Expanded(
                        child: Text('钱包', style: TextStyle(fontSize: 10, color: _secondaryTextColor, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      Expanded(
                        child: Text('24h 交易数', style: TextStyle(fontSize: 10, color: _secondaryTextColor, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      Expanded(
                        child: Text('24h 净流入', style: TextStyle(fontSize: 10, color: _secondaryTextColor, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      Expanded(
                        child: Text('余额', style: TextStyle(fontSize: 10, color: _secondaryTextColor, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      Expanded(
                        child: Text('操作', style: TextStyle(fontSize: 10, color: _secondaryTextColor, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // 数据行
                  ...?wallets?.map((wallet) => Row(
                    children: [
                      // 钱包列
                      Expanded(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.transparent,
                              backgroundImage: (wallet.avatar != null && wallet.avatar.isNotEmpty)
                                  ? CachedNetworkImageProvider(wallet.avatar)
                                  : null,
                              child: (wallet.avatar == null || wallet.avatar.isEmpty)
                                  ? Icon(Icons.account_circle, size: 20, color: Colors.grey)
                                  : null,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _shortAddress(wallet.address?.toString() ?? ''),
                                      style: TextStyle(fontSize: 10, color: _primaryTextColor, fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  if (wallet.address != null && wallet.address.toString().isNotEmpty)
                                    GestureDetector(
                                      onTap: () => _copyToClipboard(context, wallet.address.toString()),
                                      child: Icon(Icons.copy, size: 14, color: _secondaryTextColor),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 24h 交易数
                      Expanded(
                        child: Text(wallet.trades?.toString() ?? '',
                            style: TextStyle(fontSize: 10, color: (wallet.trades != null && wallet.trades.toString().startsWith('1')) ? _positiveColor : _negativeColor, fontWeight: FontWeight.w700),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 8),
                      // 24h 净流入
                      Expanded(
                        child: Text(wallet.flow?.toString() ?? '',
                            style: TextStyle(fontSize: 10, color: (wallet.flow != null && wallet.flow.toString().startsWith('+')) ? _positiveColor : _negativeColor, fontWeight: FontWeight.w700),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 8),
                      // 余额
                      Expanded(
                        child: Text(wallet.amount?.toString() ?? '',
                            style: TextStyle(fontSize: 10, color: _primaryTextColor, fontWeight: FontWeight.w700),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 8),
                      // 操作
                      Expanded(
                        child: Text('清仓', style: TextStyle(fontSize: 10, color: _negativeColor, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  )).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}