import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'audio_item_model.dart';
import 'audio_query_method_channel.dart';

abstract class AudioQueryPlatform extends PlatformInterface {
  /// Constructs a AudioQueryPlatform.
  AudioQueryPlatform() : super(token: _token);

  static final Object _token = Object();

  static AudioQueryPlatform _instance = MethodChannelAudioQuery();

  /// The default instance of [AudioQueryPlatform] to use.
  ///
  /// Defaults to [MethodChannelAudioQuery].
  static AudioQueryPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AudioQueryPlatform] when
  /// they register themselves.
  static set instance(AudioQueryPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List<AudioItemModel>> getSongs() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
