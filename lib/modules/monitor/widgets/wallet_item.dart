import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WalletItem extends StatelessWidget {
  final String avatar;
  final String name;
  final String trades;
  final String flow;
  final String amount;
  final String timeInfo;

  const WalletItem({
    Key? key,
    required this.avatar,
    required this.name,
    required this.trades,
    required this.flow,
    required this.amount,
    required this.timeInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: Colors.grey[200],
          backgroundImage: avatar.isNotEmpty ? CachedNetworkImageProvider(avatar) : null,
          child: avatar.isEmpty ? Icon(Icons.account_circle, size: 20, color: Colors.grey) : null,
        ),
        const SizedBox(width: 8),
        Text(name),
        const Spacer(),
        Text(trades, style: const TextStyle(color: Colors.black)),
        const SizedBox(width: 8),
        Text(
          flow,
          style: TextStyle(color: flow.startsWith('+') ? Colors.green : Colors.red),
        ),
        const SizedBox(width: 8),
        Text(amount),
        const SizedBox(width: 8),
        Text(timeInfo, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}