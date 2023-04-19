import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'effects_sdk_platform_interface.dart';

/// An implementation of [EffectsSDKPlatform] that uses method channels.
class MethodChannelEffectsSDK extends EffectsSDKPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('effects_sdk');
}
