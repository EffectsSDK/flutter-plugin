import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

import 'effects_sdk_components.dart';
import 'effects_sdk_config.dart';
import 'effects_sdk_enums.dart';
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
    throw UnimplementedError(
        'clearOnReadyCallback() has not been implemented.');
  }

  void config(Object sdkContext, Config config) {
    throw UnimplementedError('config() has not been implemented.');
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

  void setBoundaryLevel(Object sdkContext, double level) {
    throw UnimplementedError('setBoundaryLevel() has not been implemented.');
  }

  void setBoundaryMode(Object sdkContext, BoundaryMode mode) {
    throw UnimplementedError('setBoundaryMode() has not been implemented.');
  }

  void setBackgroundFitMode(Object sdkContext, FitMode mode) {
    throw UnimplementedError(
        'setBackgroundFitMode() has not been implemented.');
  }

  void clearBeautification(Object sdkContext) {
    throw UnimplementedError('setBackgroundStream() has not been implemented.');
  }

  void setBeautificationLevel(Object sdkContext, double level) {
    throw UnimplementedError(
        'setBeautificationLevel() has not been implemented.');
  }

  void clearBlur(Object sdkContext) {
    throw UnimplementedError('clearBlur() has not been implemented.');
  }

  void setBlur(Object sdkContext, double power) {
    throw UnimplementedError('setBlur() has not been implemented.');
  }

  void setSegmentationPreset(Object sdkContext, String preset) {
    throw UnimplementedError(
        'setSegmentationPreset() has not been implemented.');
  }

  void enableSmartZoom(Object sdkContext) {
    throw UnimplementedError('enableSmartZoom() has not been implemented.');
  }

  void disableSmartZoom(Object sdkContext) {
    throw UnimplementedError('disableSmartZoom() has not been implemented.');
  }

  void setFaceArea(Object sdkContext, double area) {
    throw UnimplementedError('setFaceArea() has not been implemented.');
  }

  void setSmartZoomPeriod(Object sdkContext, double periodMs) {
    throw UnimplementedError('setSmartZoomPeriod() has not been implemented.');
  }

  void setSmartZoomSensitivity(Object sdkContext, double value) {
    throw UnimplementedError(
        'setSmartZoomSensitivity() has not been implemented.');
  }

  void setSmartZoomSmoothing(Object sdkContext, double steps) {
    throw UnimplementedError(
        'setSmartZoomSmoothing() has not been implemented.');
  }

  void setFaceDetectorAccuracy(Object sdkContext, double value) {
    throw UnimplementedError(
        'setFaceDetectorAccuracy() has not been implemented.');
  }

  void enableColorCorrector(Object sdkContext) {
    throw UnimplementedError(
        'enableColorCorrector() has not been implemented.');
  }

  void disableColorCorrector(Object sdkContext) {
    throw UnimplementedError(
        'disableColorCorrector() has not been implemented.');
  }

  void setColorCorrectorPower(Object sdkContext, double power) {
    throw UnimplementedError(
        'setColorCorrectorPower() has not been implemented.');
  }

  void setColorCorrectorPeriod(Object sdkContext, int periodMs) {
    throw UnimplementedError(
        'setColorCorrectorPeriod() has not been implemented.');
  }

  void setLayout(Object sdkContext, Layout layout) {
    throw UnimplementedError('setLayout() has not been implemented.');
  }

  void setCustomLayout(
      Object sdkContext, double? size, double? xOffset, double? yOffset) {
    throw UnimplementedError('setCustomLayout() has not been implemented.');
  }

  void showFps(Object sdkContext) {
    throw UnimplementedError('showFps() has not been implemented.');
  }

  void hideFps(Object sdkContext) {
    throw UnimplementedError('hideFps() has not been implemented.');
  }

  void setFpsLimit(Object sdkContext, int limit) {
    throw UnimplementedError('setFpsLimit() has not been implemented.');
  }

  void setOutputResolution(Object sdkContext, int? width, int? height) {
    throw UnimplementedError('setOutputResolution() has not been implemented.');
  }

  void enableFrameSkipping(Object sdkContext) {
    throw UnimplementedError('enableFrameSkipping() has not been implemented.');
  }

  void disableFrameSkipping(Object sdkContext) {
    throw UnimplementedError(
        'disableFrameSkipping() has not been implemented.');
  }

  void enablePipelineSkipping(Object sdkContext) {
    throw UnimplementedError(
        'enablePipelineSkipping() has not been implemented.');
  }

  void disablePipelineSkipping(Object sdkContext) {
    throw UnimplementedError(
        'disablePipelineSkipping() has not been implemented.');
  }

  Object createLowerThirdComponent(
      Object sdkContext, LowerThirdOptions options) {
    throw UnimplementedError(
        'createLowerThirdComponent() has not been implemented.');
  }

  Object createStickersComponent(Object sdkContext, StickerOptions options) {
    throw UnimplementedError(
        'createStickersComponent() has not been implemented.');
  }

  Object createOverlayScreenComponent(
      Object sdkContext, OverlayScreenOptions options) {
    throw UnimplementedError(
        'createOverlayScreenComponent() has not been implemented.');
  }

  void componentSetOverlayScreenOptions(
      Object component, OverlayScreenOptions options) {
    throw UnimplementedError(
        'componentSetOverlayScreenOptions() has not been implemented.');
  }

  void addComponent(Object sdkContext, Object component, String id) {
    throw UnimplementedError('addComponent() has not been implemented.');
  }

  void componentSetOnBeforeShow(Object component, Function? func) {
    throw UnimplementedError(
        'componentSetOnBeforeShow() has not been implemented.');
  }

  void componentSetOnAfterShow(Object component, Function? func) {
    throw UnimplementedError(
        'componentSetOnAfterShow() has not been implemented.');
  }

  void componentSetOnBeforeHide(Object component, Function? func) {
    throw UnimplementedError(
        'componentSetOnBeforeHide() has not been implemented.');
  }

  void componentSetOnAfterHide(Object component, Function? func) {
    throw UnimplementedError(
        'componentSetOnAfterHide() has not been implemented.');
  }

  void componentSetOnStickerLoadSucces(
      Object component, Function(String, String?)? func) {
    throw UnimplementedError(
        'componentSetOnStickerLoadSucces() has not been implemented.');
  }

  void componentSetOnStickerLoadError(
      Object component, Function(String, dynamic)? func) {
    throw UnimplementedError(
        'componentSetOnStickerLoadError() has not been implemented.');
  }

  void componentShow(Object component) {
    throw UnimplementedError('componentShow() has not been implemented.');
  }

  void componentHide(Object component) {
    throw UnimplementedError('componentHide() has not been implemented.');
  }

  void componentShowLowerThird(Object component) {
    throw UnimplementedError(
        'componentShowLowerThird() has not been implemented.');
  }

  void componentHideLowerThird(Object component) {
    throw UnimplementedError(
        'componentHideLowerThird() has not been implemented.');
  }

  void componentSetLowerThirdOptions(
      Object component, LowerThirdOptions options) {
    throw UnimplementedError(
        'componentLowerThirdOptions() has not been implemented.');
  }

  void componentPlaySticker(Object component, String url) {
    throw UnimplementedError(
        'componentPlaySticker() has not been implemented.');
  }

  void componentSetStickerOptions(Object component, StickerOptions options) {
    throw UnimplementedError(
        'componentSetStickerOptions() has not been implemented.');
  }
}
