
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

import 'effects_sdk_platform_interface.dart';

enum SegmentationPreset {
  quality,
  balanced,
  speed
}

class EffectsSDK {
  final Object _sdkContext;
  bool _ready = false;
  Function? onReady;

  EffectsSDK(String customerID) : 
    _sdkContext = EffectsSDKPlatform.instance.createContext(customerID) {
      callback() {
        _ready = true;
        onReady?.call();
        onReady = null;
      }
      EffectsSDKPlatform.instance.setOnReadyCallback(_sdkContext, callback);
  }

  void useStream(webrtc.MediaStream stream) {
    EffectsSDKPlatform.instance.useStream(_sdkContext, stream);
  }

  webrtc.MediaStream getStream() {
    return EffectsSDKPlatform.instance.getStream(_sdkContext);
  }

  bool get isReady => _ready;

  void clear() {
    EffectsSDKPlatform.instance.clear(_sdkContext);
    _ready = false;
  }

  bool run() {
    if (!_ready) {
      throw StateError("run() can not be used until EffectsSDK is ready.");
    }
    return EffectsSDKPlatform.instance.run(_sdkContext);
  }

  void clearBackground() {
    if (!_ready) {
      throw StateError("clearBackground() can not be used until EffectsSDK is ready.");
    }
    EffectsSDKPlatform.instance.clearBackground(_sdkContext);
  }

  void setBackgroundImage(String url) {
    if (!_ready) {
      throw StateError("setBackgroundImage() can not be used until EffectsSDK is ready.");
    }
    EffectsSDKPlatform.instance.setBackgroundImage(_sdkContext, url);
  }

  void setBackgroundStream(webrtc.MediaStream stream) {
    if (!_ready) {
      throw StateError("setBackgroundStream() can not be used until EffectsSDK is ready.");
    }
    EffectsSDKPlatform.instance.setBackgroundStream(_sdkContext, stream);
  }

  void setBackgroundColor(int color) {
    if (!_ready) {
      throw StateError("setBackgroundColor() can not be used until EffectsSDK is ready.");
    }
    EffectsSDKPlatform.instance.setBackgroundColor(_sdkContext, color);
  }

  void clearBeautification() {
    if (!_ready) {
      throw StateError("clearBeautification() can not be used until EffectsSDK is ready.");
    }
    EffectsSDKPlatform.instance.clearBeautification(_sdkContext);
  }

  void setBeautificationLevel(double level) {
    if (!_ready) {
      throw StateError("setBeautificationLevel() can not be used until EffectsSDK is ready.");
    }
    EffectsSDKPlatform.instance.setBeautificationLevel(_sdkContext, level);
  }

  void clearBlur() {
    if (!_ready) {
      throw StateError("clearBlur() can not be used until EffectsSDK is ready.");
    }
    EffectsSDKPlatform.instance.clearBlur(_sdkContext);
  }

  void setBlur(double power) {
    if (!_ready) {
      throw StateError("setBlur() can not be used until EffectsSDK is ready.");
    }
    EffectsSDKPlatform.instance.setBlur(_sdkContext, power);
  }

  void setSegmentationPreset(SegmentationPreset preset) {
    if (!_ready) {
      throw StateError("setSegmentationPreset() can not be used until EffectsSDK is ready.");
    }
    EffectsSDKPlatform.instance.setSegmentationPreset(_sdkContext, preset.name);
  }
}
