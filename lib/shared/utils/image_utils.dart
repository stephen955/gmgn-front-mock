import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gmgn_front/gen/assets.gen.dart';

class ImageUtils {

  static Widget loadNetworkImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
    Duration? placeholderFadeInDuration,
    Duration? fadeOutDuration,
    Duration? fadeInDuration,
  }) {
    if (imageUrl.isEmpty) {
      return Assets.logo.image(
        width: width,
        height: height,
        fit: fit,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => placeholder ?? Assets.logo.image(
        width: width,
        height: height,
        fit: fit,
      ),
      errorWidget: (context, url, error) => errorWidget ?? Assets.logo.image(
        width: width,
        height: height,
        fit: fit,
      ),
      httpHeaders: {
        'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
        'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
        'Accept-Language': 'en-US,en;q=0.9',
        'Cache-Control': 'max-age=3600',
      },
      maxWidthDiskCache: 400,
      maxHeightDiskCache: 400,
      memCacheWidth: 400,
      memCacheHeight: 400,
      placeholderFadeInDuration: placeholderFadeInDuration ?? const Duration(milliseconds: 300),
      fadeOutDuration: fadeOutDuration ?? const Duration(milliseconds: 300),
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 300),
      cacheKey: imageUrl,
      errorListener: (error) {
        print('Image load error for $imageUrl: $error');
      },
    );
  }

  /// 预加载图片
  static Future<void> preloadImage(String imageUrl) async {
    if (imageUrl.isEmpty) return;
    
    try {
      await CachedNetworkImageProvider(
        imageUrl,
        headers: {
          'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
          'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
          'Accept-Language': 'en-US,en;q=0.9',
        },
      ).resolve(ImageConfiguration.empty);
    } catch (e) {
      print('Preload image error for $imageUrl: $e');
    }
  }

  /// 清除图片缓存
  static Future<void> clearImageCache(String imageUrl) async {
    await CachedNetworkImage.evictFromCache(imageUrl);
  }

  /// 清除所有图片缓存
  static Future<void> clearAllImageCache() async {
    await DefaultCacheManager().emptyCache();
  }
} 