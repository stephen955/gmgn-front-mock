import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gmgn_front/models/chain_rank_models.dart';
import 'package:gmgn_front/shared/utils/image_utils.dart';
import 'package:gmgn_front/shared/utils/string_utils.dart';
import 'package:gmgn_front/gen/assets.gen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:gmgn_front/router/app_router.dart';
import 'package:flutter/services.dart';
import 'package:gmgn_front/shared/utils/copy_utils.dart';


class AssetListCell extends StatelessWidget {
  final ChainRankToken token;
  final VoidCallback? onBuy;
  final VoidCallback? onCopy;
  final VoidCallback? onView;
  final bool showDivider;

  const AssetListCell({
    Key? key,
    required this.token,
    this.onBuy,
    this.onCopy,
    this.onView,
    this.showDivider = true,
  }) : super(key: key);

  String get shortAddress {
    if (token.address.isEmpty) return '';
    if (token.address.length <= 8) return token.address;
    return token.address.substring(0, 4) + '...';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToMarketDetail(context),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 头像+角标
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey[200],
                      child: ClipOval(
                        child: ImageUtils.loadNetworkImage(
                          imageUrl: token.logo,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -4,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF2DE66F), width: 0.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                Assets.greenPill,
                                width: 8,
                                height: 8,
                                placeholderBuilder: (context) => Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF2DE66F),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF2DE66F),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                _getBadgeText(),
                                style: const TextStyle(fontSize: 10, color: Color(0xFF2DE66F)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 6),
                // 主信息区
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 第一行
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Text(
                              token.name,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF222222)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            flex: 1,
                            child: Text(
                              shortAddress,
                              style: const TextStyle(fontSize: 12, color: Color(0xFFB0B4BA)),
                              maxLines: 1,
                            ),
                          ),

                          if (token.exchange.isNotEmpty)
                            Container(
                              child: Text(
                                token.exchange,
                                style: const TextStyle(fontSize: 12, color: Color(0xFFB0B4BA)),
                                overflow: TextOverflow.visible,
                                maxLines: 1,
                              ),
                            ),
                          const SizedBox(width: 2),
                          _iconButton(icon: Icons.copy,ctx: context, onTap: onCopy),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // 第二行：绿色时间、人数、成交量、MC

                      Row(
                        children: [
                          Text('${token.createdTimestamp}s', style: const TextStyle(fontSize: 12, color: Color(0xFF19C37C))),
                          const SizedBox(width: 8),
                          Icon(Icons.people, size: 12, color: Color(0xFFB0B4BA)),
                          const SizedBox(width: 2),
                          Text(token.holderCount.toString(), style: const TextStyle(fontSize: 12, color: Color(0xFF222222))),
                          const SizedBox(width: 6),
                          
                          Flexible(
                            child: Row(
                              children: [
                                Text('V', style: TextStyle(fontSize: 12, color: Color(0xFFB0B4BA))),
                                const SizedBox(width: 2),
                                Text(StringUtils.formatNum(token.volume1h), style: const TextStyle(fontSize: 12, color: Color(0xFF222222)), overflow: TextOverflow.ellipsis, maxLines: 1),
                                const SizedBox(width: 6),
                                Text('MC', style: TextStyle(fontSize: 12, color: Color(0xFFB0B4BA))),
                                const SizedBox(width: 2),
                                Text(StringUtils.formatNum(token.usdMarketCap), style: const TextStyle(fontSize: 12, color: Color(0xFF222222)), overflow: TextOverflow.ellipsis, maxLines: 1),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // 第三行：进度条+百分比，绿色/红色指标
                      Container(
                        height: 20,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // 新底部一排icon和数值
                              _buildSvgIcon(Assets.user, token.top10HolderRate > 0, Icons.person),
                              const SizedBox(width: 2),
                              Text('${(token.top10HolderRate * 100).toStringAsFixed(0)}%', style: TextStyle(fontSize: 12, color: token.top10HolderRate > 0 ? Color(0xFFB4E5C9) : Color(0xFFB0B4BA))),
                              const SizedBox(width: 10),
                              _buildSvgIcon(Assets.chef, token.devTeamHoldRate > 0, Icons.restaurant),
                              const SizedBox(width: 2),
                              Text('${(token.devTeamHoldRate * 100).toStringAsFixed(0)}%', style: TextStyle(fontSize: 12, color: token.devTeamHoldRate > 0 ? Color(0xFFB4E5C9) : Color(0xFFB0B4BA))),
                              const SizedBox(width: 10),
                              _buildSvgIcon(Assets.rat, token.ratTraderAmountRate > 0, Icons.mouse),
                              const SizedBox(width: 2),
                              Text('${(token.ratTraderAmountRate * 100).toStringAsFixed(0)}%', style: TextStyle(fontSize: 12, color: token.ratTraderAmountRate > 0 ? Color(0xFFB4E5C9) : Color(0xFFB0B4BA))),
                              const SizedBox(width: 10),
                              _buildSvgIcon(Assets.hc, token.sniperCount > 0, Icons.sports_esports),
                              const SizedBox(width: 2),
                              Text('${token.sniperCount}', style: TextStyle(fontSize: 12, color: token.sniperCount > 0 ? Color(0xFFB4E5C9) : Color(0xFFB0B4BA))),
                              const SizedBox(width: 12),
                              _buildSvgIcon(Assets.activity, token.entrapmentRatio > 0, Icons.trending_up),
                              const SizedBox(width: 2),
                              Text('${(token.entrapmentRatio * 100).toStringAsFixed(0)}%', style: TextStyle(fontSize: 12, color: token.entrapmentRatio > 0 ? Color(0xFFB4E5C9) : Color(0xFFB0B4BA))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 右侧买入按钮
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 16),
                  child: _buyButton(context),
                ),
              ],
            ),
          ),
          // 分割线
          if (showDivider)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 0.5,
              color: const Color(0xFFF2F4F7),
            ),
        ],
      ),
    );
  }

  void _navigateToMarketDetail(BuildContext context) {
    context.router.push(MarketRoute(token: token));
  }

  String _getBadgeText() {
    if (token.progress.isNaN || token.progress.isInfinite) return '0%';
    return token.progress > 0 ? '${(token.progress * 100).toStringAsFixed(0)}%' : '0%';
  }

  String _getChangePercent() {
    // 示例：涨跌幅，实际应根据业务字段
    if (token.progress.isNaN || token.progress.isInfinite) return '0%';
    return token.progress > 0 ? '+${(token.progress * 100).toStringAsFixed(0)}%' : '0%';
  }

  Widget _iconButton({required IconData icon,required BuildContext ctx, VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        if (onTap != null) onTap();
        await CopyUtils.copyWithTopTip(ctx, token.address);
      },
      child: Container(
        width: 16,
        height: 16,
        alignment: Alignment.center,
        child: Icon(icon, size: 12, color: const Color(0xFFB0B4BA)),
      ),
    );
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
          border: Border.all(color: const Color(0xFF19C37C), width: 0.5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              Assets.buy,
              width: 16,
              height: 16,
              color: Color(0xFF19C37C),
              placeholderBuilder: (context) => Icon(
                Icons.shopping_cart,
                size: 16,
                color: Color(0xFF19C37C),
              ),
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.shopping_cart,
                size: 16,
                color: Color(0xFF19C37C),
              ),
            ),
            SizedBox(width: 4),
            Text(
              '买入',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF222222),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _shortName(String name) {
    if (name.isEmpty) return '';
    return name.characters.length > 5 ? name.characters.take(5).toString() + '…' : name;
  }

  Widget _buildSvgIcon(String assetPath, bool isActive, IconData fallbackIcon) {
    return SvgPicture.asset(
      assetPath,
      width: 12,
      height: 12,
      color: isActive ? Color(0xFFB4E5C9) : Color(0xFFB0B4BA),
      placeholderBuilder: (context) => Icon(
        fallbackIcon,
        size: 12,
        color: Color(0xFFB0B4BA),
      ),
      errorBuilder: (context, error, stackTrace) => Icon(
        fallbackIcon,
        size: 12,
        color: Color(0xFFB0B4BA),
      ),
    );
  }
} 