import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmgn_front/gen/assets.gen.dart';
import 'package:gmgn_front/router/app_router.dart' as router;
import 'package:gmgn_front/l10n/app_localizations.dart';
import 'package:gmgn_front/l10n/l10n_extension.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/user_provider.dart';
import '../../auth/models/user_models.dart';

class DiscoverHeader extends StatelessWidget {
  const DiscoverHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double navBarHeight = 48.0;
    
    return Container(
      height: statusBarHeight + navBarHeight,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(
          top: statusBarHeight,
          left: 16,
          right: 16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 左侧用户头像
            _buildUserAvatar(context),
            const SizedBox(width: 10),
            // 搜索框
            Expanded(
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Color(0xFFFEFEFE), width: 0.5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Color(0xFFBFBFBF), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.l10n.searchTokenWallet,
                        style: const TextStyle(
                          color: Color(0xFFBFBFBF),
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            // 扫码按钮
            SvgPicture.asset(
              Assets.qrCode,
              color: Colors.black,
              width: 14,
              height: 14,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建用户头像
  Widget _buildUserAvatar(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final userInfo = userProvider.currentUser;
        
        if (userInfo != null && userInfo.avatar != null) {
          // 如果有用户头像，显示用户头像
          return Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                userInfo.avatar!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultAvatar(userInfo.username);
                },
              ),
            ),
          );
        } else {
          // 如果没有头像，显示默认头像
          return _buildDefaultAvatar(userInfo?.username);
        }
      },
    );
  }

  /// 构建默认头像
  Widget _buildDefaultAvatar(String? username) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Color(0xFFFFA36C), // 橙色背景
        borderRadius: BorderRadius.circular(4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Center(
          child: username != null && username.isNotEmpty
              ? Text(
                  username.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : SvgPicture.asset(
                  Assets.user,
                  color: Colors.white,
                  width: 12,
                  height: 12,
                ),
        ),
      ),
    );
  }
}