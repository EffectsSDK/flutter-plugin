import 'package:flutter_test/flutter_test.dart';
import 'package:effects_sdk/effects_sdk.dart';
import 'package:effects_sdk/effects_sdk_platform_interface.dart';
import 'package:effects_sdk/effects_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockEffectsSdkPlatform
    with MockPlatformInterfaceMixin
    implements EffectsSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final EffectsSdkPlatform initialPlatform = EffectsSdkPlatform.instance;

  test('$MethodChannelEffectsSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEffectsSdk>());
  });

  test('getPlatformVersion', () async {
    EffectsSdk effectsSdkPlugin = EffectsSdk();
    MockEffectsSdkPlatform fakePlatform = MockEffectsSdkPlatform();
    EffectsSdkPlatform.instance = fakePlatform;

    expect(await effectsSdkPlugin.getPlatformVersion(), '42');
  });
}
