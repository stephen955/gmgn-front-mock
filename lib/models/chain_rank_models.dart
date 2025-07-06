/// 链上Rank榜单数据模型，包含响应结构与Token详情
import 'base_response.dart';

class ChainRankResponse extends BaseResponse {
  final ChainRankData data;

  ChainRankResponse({
    required int code,
    required String reason,
    required String message,
    required this.data,
  }) : super(code: code, reason: reason, message: message);

  factory ChainRankResponse.fromJson(Map<String, dynamic> json) {
    return ChainRankResponse(
      code: json['code'] is int ? json['code'] : (json['code'] as num?)?.toInt() ?? 0,
      reason: json['reason'] ?? '',
      message: json['message'] ?? '',
      data: ChainRankData.fromJson(json['data'] ?? {}),
    );
  }

  // 创建合并数据的响应
  factory ChainRankResponse.merge(ChainRankResponse existing, ChainRankResponse newData) {
    return ChainRankResponse(
      code: newData.code,
      reason: newData.reason,
      message: newData.message,
      data: ChainRankData.merge(existing.data, newData.data),
    );
  }
}

class ChainRankData {
  final List<ChainRankToken> newCreation;
  final List<ChainRankToken> pump;
  final List<ChainRankToken> completed;

  ChainRankData({
    required this.newCreation,
    required this.pump,
    required this.completed,
  });

  factory ChainRankData.fromJson(Map<String, dynamic> json) {
    return ChainRankData(
      newCreation: (json['new_creation'] as List<dynamic>? ?? [])
          .map((e) => ChainRankToken.fromJson(e as Map<String, dynamic>))
          .toList(),
      pump: (json['pump'] as List<dynamic>? ?? [])
          .map((e) => ChainRankToken.fromJson(e as Map<String, dynamic>))
          .toList(),
      completed: (json['completed'] as List<dynamic>? ?? [])
          .map((e) => ChainRankToken.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // 合并两个数据对象
  factory ChainRankData.merge(ChainRankData existing, ChainRankData newData) {
    return ChainRankData(
      newCreation: [...existing.newCreation, ...newData.newCreation],
      pump: [...existing.pump, ...newData.pump],
      completed: [...existing.completed, ...newData.completed],
    );
  }
}

class ChainRankToken {
  final String address;
  final String poolAddress;
  final String quoteAddress;
  final String logo;
  final String symbol;
  final String name;
  final String launchpad;
  final String launchpadPlatform;
  final String exchange;
  final String creatorTokenStatus;
  final num devTokenBurnAmount;
  final num devTokenBurnRatio;
  final num progress;
  final num usdMarketCap;
  final num marketCap;
  final int swaps1h;
  final num volume1h;
  final num top10HolderRate;
  final num creatorBalanceRate;
  final num ratTraderAmountRate;
  final num bundlerTraderAmountRate;
  final int renownedCount;
  final int sniperCount;
  final int botDegenCount;
  final int holderCount;
  final num liquidity;
  final String creator;
  final int creatorCreatedOpenCount;
  final num creatorCreatedOpenRatio;
  final int creatorCreatedCount;
  final num rugRatio;
  final int buys1h;
  final int sells1h;
  final int createdTimestamp;
  final int openTimestamp;
  final int buyTips;
  final num totalFee;
  final num priorityFee;
  final num tipFee;
  final num newWalletVolume;
  final num entrapmentRatio;
  final bool isWashTrading;
  final bool renouncedMint;
  final bool renouncedFreezeAccount;
  final String burnStatus;
  final num devTeamHoldRate;
  final num suspectedInsiderHoldRate;
  final bool isTokenLive;
  final num top70SniperHoldRate;
  final bool hasAtLeastOneSocial;
  final bool twitterIsTweet;
  final String twitter;
  final String website;
  final String telegram;
  final bool dexscrAd;
  final bool dexscrUpdateLink;
  final bool ctoFlag;
  final int twitterRenameCount;
  final int twitterDelPostTokenCount;
  final int twitterCreateTokenCount;
  final int imageDup;
  final int status;

  ChainRankToken({
    required this.address,
    required this.poolAddress,
    required this.quoteAddress,
    required this.logo,
    required this.symbol,
    required this.name,
    required this.launchpad,
    required this.launchpadPlatform,
    required this.exchange,
    required this.creatorTokenStatus,
    required this.devTokenBurnAmount,
    required this.devTokenBurnRatio,
    required this.progress,
    required this.usdMarketCap,
    required this.marketCap,
    required this.swaps1h,
    required this.volume1h,
    required this.top10HolderRate,
    required this.creatorBalanceRate,
    required this.ratTraderAmountRate,
    required this.bundlerTraderAmountRate,
    required this.renownedCount,
    required this.sniperCount,
    required this.botDegenCount,
    required this.holderCount,
    required this.liquidity,
    required this.creator,
    required this.creatorCreatedOpenCount,
    required this.creatorCreatedOpenRatio,
    required this.creatorCreatedCount,
    required this.rugRatio,
    required this.buys1h,
    required this.sells1h,
    required this.createdTimestamp,
    required this.openTimestamp,
    required this.buyTips,
    required this.totalFee,
    required this.priorityFee,
    required this.tipFee,
    required this.newWalletVolume,
    required this.entrapmentRatio,
    required this.isWashTrading,
    required this.renouncedMint,
    required this.renouncedFreezeAccount,
    required this.burnStatus,
    required this.devTeamHoldRate,
    required this.suspectedInsiderHoldRate,
    required this.isTokenLive,
    required this.top70SniperHoldRate,
    required this.hasAtLeastOneSocial,
    required this.twitterIsTweet,
    required this.twitter,
    required this.website,
    required this.telegram,
    required this.dexscrAd,
    required this.dexscrUpdateLink,
    required this.ctoFlag,
    required this.twitterRenameCount,
    required this.twitterDelPostTokenCount,
    required this.twitterCreateTokenCount,
    required this.imageDup,
    required this.status,
  });

  factory ChainRankToken.fromJson(Map<String, dynamic> json) {
    return ChainRankToken(
      address: json['address'] ?? '',
      poolAddress: json['pool_address'] ?? '',
      quoteAddress: json['quote_address'] ?? '',
      logo: json['logo'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      launchpad: json['launchpad'] ?? '',
      launchpadPlatform: json['launchpad_platform'] ?? '',
      exchange: json['exchange'] ?? '',
      creatorTokenStatus: json['creator_token_status'] ?? '',
      devTokenBurnAmount: json['dev_token_burn_amount'] ?? 0,
      devTokenBurnRatio: json['dev_token_burn_ratio'] ?? 0,
      progress: json['progress'] ?? 0,
      usdMarketCap: json['usd_market_cap'] ?? 0,
      marketCap: json['market_cap'] ?? 0,
      swaps1h: json['swaps_1h'] is int ? json['swaps_1h'] : (json['swaps_1h'] as num?)?.toInt() ?? 0,
      volume1h: json['volume_1h'] ?? 0,
      top10HolderRate: json['top_10_holder_rate'] ?? 0,
      creatorBalanceRate: json['creator_balance_rate'] ?? 0,
      ratTraderAmountRate: json['rat_trader_amount_rate'] ?? 0,
      bundlerTraderAmountRate: json['bundler_trader_amount_rate'] ?? 0,
      renownedCount: json['renowned_count'] is int ? json['renowned_count'] : (json['renowned_count'] as num?)?.toInt() ?? 0,
      sniperCount: json['sniper_count'] is int ? json['sniper_count'] : (json['sniper_count'] as num?)?.toInt() ?? 0,
      botDegenCount: json['bot_degen_count'] is int ? json['bot_degen_count'] : (json['bot_degen_count'] as num?)?.toInt() ?? 0,
      holderCount: json['holder_count'] is int ? json['holder_count'] : (json['holder_count'] as num?)?.toInt() ?? 0,
      liquidity: json['liquidity'] ?? 0,
      creator: json['creator'] ?? '',
      creatorCreatedOpenCount: json['creator_created_open_count'] is int ? json['creator_created_open_count'] : (json['creator_created_open_count'] as num?)?.toInt() ?? 0,
      creatorCreatedOpenRatio: json['creator_created_open_ratio'] ?? 0,
      creatorCreatedCount: json['creator_created_count'] is int ? json['creator_created_count'] : (json['creator_created_count'] as num?)?.toInt() ?? 0,
      rugRatio: json['rug_ratio'] ?? 0,
      buys1h: json['buys_1h'] is int ? json['buys_1h'] : (json['buys_1h'] as num?)?.toInt() ?? 0,
      sells1h: json['sells_1h'] is int ? json['sells_1h'] : (json['sells_1h'] as num?)?.toInt() ?? 0,
      createdTimestamp: json['created_timestamp'] is int ? json['created_timestamp'] : (json['created_timestamp'] as num?)?.toInt() ?? 0,
      openTimestamp: json['open_timestamp'] is int ? json['open_timestamp'] : (json['open_timestamp'] as num?)?.toInt() ?? 0,
      buyTips: json['buy_tips'] is int ? json['buy_tips'] : (json['buy_tips'] as num?)?.toInt() ?? 0,
      totalFee: json['total_fee'] ?? 0,
      priorityFee: json['priority_fee'] ?? 0,
      tipFee: json['tip_fee'] ?? 0,
      newWalletVolume: json['new_wallet_volume'] ?? 0,
      entrapmentRatio: json['entrapment_ratio'] ?? 0,
      isWashTrading: json['is_wash_trading'] ?? false,
      renouncedMint: json['renounced_mint'] ?? false,
      renouncedFreezeAccount: json['renounced_freeze_account'] ?? false,
      burnStatus: json['burn_status'] ?? '',
      devTeamHoldRate: json['dev_team_hold_rate'] ?? 0,
      suspectedInsiderHoldRate: json['suspected_insider_hold_rate'] ?? 0,
      isTokenLive: json['is_token_live'] ?? false,
      top70SniperHoldRate: json['top70_sniper_hold_rate'] ?? 0,
      hasAtLeastOneSocial: json['has_at_least_one_social'] ?? false,
      twitterIsTweet: json['twitter_is_tweet'] ?? false,
      twitter: json['twitter'] ?? '',
      website: json['website'] ?? '',
      telegram: json['telegram'] ?? '',
      dexscrAd: json['dexscr_ad'] ?? false,
      dexscrUpdateLink: json['dexscr_update_link'] ?? false,
      ctoFlag: json['cto_flag'] ?? false,
      twitterRenameCount: json['twitter_rename_count'] is int ? json['twitter_rename_count'] : (json['twitter_rename_count'] as num?)?.toInt() ?? 0,
      twitterDelPostTokenCount: json['twitter_del_post_token_count'] is int ? json['twitter_del_post_token_count'] : (json['twitter_del_post_token_count'] as num?)?.toInt() ?? 0,
      twitterCreateTokenCount: json['twitter_create_token_count'] is int ? json['twitter_create_token_count'] : (json['twitter_create_token_count'] as num?)?.toInt() ?? 0,
      imageDup: json['image_dup'] is int ? json['image_dup'] : (json['image_dup'] as num?)?.toInt() ?? 0,
      status: json['status'] is int ? json['status'] : (json['status'] as num?)?.toInt() ?? 0,
    );
  }
} 