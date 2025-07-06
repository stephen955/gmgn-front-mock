import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gmgn_front/shared/chain_constants.dart';
import 'package:gmgn_front/gen/assets.gen.dart';

class ChainIcon {
  static Widget getChainIcon(String chainName, {double size = 20}) {
    switch (chainName.toLowerCase()) {
      case ChainConstants.sol:
      case ChainConstants.solana:
        return Assets.solana.image(
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (ctx, err, stack) => Icon(Icons.help_outline, size: size, color: Colors.grey),
        );
      case ChainConstants.bsc:
        return SvgPicture.asset(
          Assets.bsc,
          width: size,
          height: size,
          placeholderBuilder: (context) => Icon(Icons.help_outline, size: size, color: Colors.grey),
        );
      case ChainConstants.tron:
        return Assets.tron.image(
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (ctx, err, stack) => Icon(Icons.help_outline, size: size, color: Colors.grey),
        );
      case ChainConstants.eth:
      case ChainConstants.ethereum:
      case ChainConstants.ether:
        return Assets.ether.image(
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (ctx, err, stack) => Icon(Icons.help_outline, size: size, color: Colors.grey),
        );
      case ChainConstants.logo:
        return SvgPicture.asset(
          Assets.logoSmall2,
          width: size,
          height: size,
          placeholderBuilder: (context) => Icon(Icons.help_outline, size: size, color: Colors.grey),
        );
      default:
        return Icon(Icons.help_outline, size: size, color: Colors.grey);
    }
  }
} 