import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_networkimage_2/provider.dart';

class Utils{
  static Future CacheImage(BuildContext context , String Url) => precacheImage(AdvancedNetworkImage(
      Url,
    useDiskCache: true,
    cacheRule: CacheRule(maxAge: const Duration(days: 7))
  ), context);
}