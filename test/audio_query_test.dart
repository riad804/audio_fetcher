import 'package:audio_fetcher/audio_item_model.dart';
import 'package:audio_fetcher/audio_query.dart';
import 'package:audio_fetcher/audio_query_method_channel.dart';
import 'package:audio_fetcher/audio_query_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAudioQueryPlatform
    with MockPlatformInterfaceMixin
    implements AudioQueryPlatform {
  @override
  Future<List<AudioItemModel>> getSongs() => Future.value(<AudioItemModel>[]);
}

void main() {
  final AudioQueryPlatform initialPlatform = AudioQueryPlatform.instance;

  test('$MethodChannelAudioQuery is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAudioQuery>());
  });

  test('getSongs', () async {
    AudioQuery audioQueryPlugin = AudioQuery();
    MockAudioQueryPlatform fakePlatform = MockAudioQueryPlatform();
    AudioQueryPlatform.instance = fakePlatform;

    expect(await audioQueryPlugin.getAudios(), <AudioItemModel>[]);
  });
}
