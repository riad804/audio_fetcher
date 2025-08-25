import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'audio_item_model.dart';
import 'audio_query_platform_interface.dart';

/// An implementation of [AudioQueryPlatform] that uses method channels.
class MethodChannelAudioQuery extends AudioQueryPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('audio_query');

  @override
  Future<List<AudioItemModel>> getSongs() async {
    final songs = await methodChannel.invokeMethod("getSongs");
    if (songs == null) return [];
    return (songs as List).map((json) {
      return AudioItemModel.fromJson(Map<String, dynamic>.from(json));
    }).toList();
  }
}
