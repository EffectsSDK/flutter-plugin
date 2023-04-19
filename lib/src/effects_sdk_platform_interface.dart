import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

import 'effects_sdk_method_channel.dart';

abstract class EffectsSDKPlatform extends PlatformInterface {
  /// Constructs a EffectsSDKPlatform.
  EffectsSDKPlatform() : super(token: _token);

  static final Object _token = Object();

  static EffectsSDKPlatform _instance = MethodChannelEffectsSDK();

  /// The default instance of [EffectsSDKPlatform] to use.
  ///
  /// Defaults to [MethodChannelEffectsSDK].
  static EffectsSDKPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [EffectsSDKPlatform] when
  /// they register themselves.
  static set instance(EffectsSDKPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Object createContext(String customerID) {
    throw UnimplementedError('createContext() has not been implemented.');
  }

  void setOnReadyCallback(Object sdkContext, Function callback) {
    throw UnimplementedError('setOnReadyCallback() has not been implemented.');
  }

  void clearOnReadyCallback(Object sdkContext) {
    throw UnimplementedError('clearOnReadyCallback() has not been implemented.');
  }

  void useStream(Object sdkContext, webrtc.MediaStream stream) {
    throw UnimplementedError('useStream() has not been implemented.');
  }

  webrtc.MediaStream getStream(Object sdkContext) {
    throw UnimplementedError('getStream() has not been implemented.');
  }

  void clear(Object sdkContext) {
    throw UnimplementedError('clear() has not been implemented.');
  }

  bool run(Object sdkContext) {
    throw UnimplementedError('run() has not been implemented.');
  }

  void clearBackground(Object sdkContext) {
    throw UnimplementedError('clearBackground() has not been implemented.');
  }

  void setBackgroundColor(Object sdkContext, int color) {
    throw UnimplementedError('setBackgroundColor() has not been implemented.');
  }

  void setBackgroundImage(Object sdkContext, String url) {
    throw UnimplementedError('setBackgroundImage() has not been implemented.');
  }

  void setBackgroundStream(Object sdkContext, webrtc.MediaStream stream) {
    throw UnimplementedError('setBackgroundStream() has not been implemented.');
  }

  void clearBeautification(Object sdkContext) {
    throw UnimplementedError('setBackgroundStream() has not been implemented.');
  }

  void setBeautificationLevel(Object sdkContext, double level) {
    throw UnimplementedError('setBeautificationLevel() has not been implemented.');
  }

  void clearBlur(Object sdkContext) {
    throw UnimplementedError('clearBlur() has not been implemented.');
  }

  void setBlur(Object sdkContext, double power) {
    throw UnimplementedError('setBlur() has not been implemented.');
  }

  void setSegmentationPreset(Object sdkContext, String preset) {
    throw UnimplementedError('setSegmentationPreset() has not been implemented.');
  }
}
