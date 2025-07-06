import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../gen/assets.gen.dart';
import '../../../shared/utils/copy_utils.dart';

class WalletInfoTile extends StatelessWidget {
  const WalletInfoTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 钱包头像
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 20,
            height: 20,
            color: Colors.orange[100],
            child: SvgPicture.asset(
              Assets.user,
              fit: BoxFit.cover,
              color: Colors.orange[600],
            ),
          ),
        ),
        const SizedBox(width: 6),

        // 钱包图标 + 地址
        Row(
          children: [
            Assets.solana.image(width: 12, height: 12),
            const SizedBox(width: 4),
            const Text(
              '7kug...jk81',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        // const SizedBox(width: 2),
        // // 分隔符
        // const VerticalDivider(
        //   width: 0.5,
        //   thickness: 0.5,
        //   color: Colors.grey,
        // ),

        // 复制按钮
        IconButton(
          onPressed: () {
            CopyUtils.copyWithTopTip(
              context,
              '7kug...jk81',
              tip: '复制成功',
            );
          },
          icon: const Icon(Icons.copy, size: 16, color: Colors.grey),
          tooltip: '复制地址',
        ),

        // 查看/菜单按钮
        // IconButton(
        //   onPressed: () {},
        //   icon: Assets.solana.image(width: 8, height: 8), // 使用 flutter_gen 生成的资源引用
        //   tooltip: '更多操作',
        // ),
      ],
    );
  }
}