import 'dart:collection';

import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

import 'effects_sdk_components.dart';
import 'effects_sdk_platform_interface.dart';
import 'effects_sdk_config.dart';
import 'effects_sdk_enums.dart';

class EffectsSDK {
  final Object _sdkContext;
  bool _ready = false;
  Function? onReady;
  final Map<String, Component> _componentMap = Map<String, Component>();

  EffectsSDK(String customerID)
      : _sdkContext = EffectsSDKPlatform.instance.createContext(customerID) {
    callback() {
      _ready = true;
      onReady?.call();
      onReady = null;
    }

    EffectsSDKPlatform.instance.setOnReadyCallback(_sdkContext, callback);
  }

  void config(Config config) {
    EffectsSDKPlatform.instance.config(_sdkContext, config);
  }

  void useStream(webrtc.MediaStream stream) {
    EffectsSDKPlatform.instance.useStream(_sdkContext, stream);
  }

  webrtc.MediaStream getStream() {
    return EffectsSDKPlatform.instance.getStream(_sdkContext);
  }

  bool get isReady => _ready;

  Future<void> cache({ bool clear = false}) {
    return EffectsSDKPlatform.instance.cache(_sdkContext, clear: clear);
  }

  void clear() {
    EffectsSDKPlatform.instance.clear(_sdkContext);
    _ready = false;
  }

  Future<void> preload() {
    return EffectsSDKPlatform.instance.preload(_sdkContext);
  }

  bool run() {
    _throwIfNotReady("run()");
    return EffectsSDKPlatform.instance.run(_sdkContext);
  }

  void clearBackground() {
    _throwIfNotReady("clearBackground()");
    EffectsSDKPlatform.instance.clearBackground(_sdkContext);
  }

  void setBackgroundImage(String url) {
    _throwIfNotReady("setBackgroundImage()");
    EffectsSDKPlatform.instance.setBackgroundImage(_sdkContext, url);
  }

  void setBackgroundStream(webrtc.MediaStream stream) {
    _throwIfNotReady("setBackgroundStream()");
    EffectsSDKPlatform.instance.setBackgroundStream(_sdkContext, stream);
  }

  void setBackgroundColor(int color) {
    _throwIfNotReady("setBackgroundColor()");
    EffectsSDKPlatform.instance.setBackgroundColor(_sdkContext, color);
  }

  void setBackgroundFitMode(FitMode mode) {
    _throwIfNotReady("setBackgroundColor()");
    EffectsSDKPlatform.instance.setBackgroundFitMode(_sdkContext, mode);
  }

  void setBoundaryLevel(double level) {
    _throwIfNotReady("setBoundaryLevel()");
    EffectsSDKPlatform.instance.setBoundaryLevel(_sdkContext, level);
  }

  void setBoundaryMode(BoundaryMode mode) {
    _throwIfNotReady("setBoundaryMode()");
    EffectsSDKPlatform.instance.setBoundaryMode(_sdkContext, mode);
  }

  void clearBeautification() {
    _throwIfNotReady("clearBeautification()");
    EffectsSDKPlatform.instance.clearBeautification(_sdkContext);
  }

  void setBeautificationLevel(double level) {
    _throwIfNotReady("setBeautificationLevel()");
    EffectsSDKPlatform.instance.setBeautificationLevel(_sdkContext, level);
  }

  void clearBlur() {
    _throwIfNotReady("clearBlur()");
    EffectsSDKPlatform.instance.clearBlur(_sdkContext);
  }

  void setBlur(double power) {
    _throwIfNotReady("setBlur()");
    EffectsSDKPlatform.instance.setBlur(_sdkContext, power);
  }

  void setSegmentationPreset(SegmentationPreset preset) {
    _throwIfNotReady("setSegmentationPreset()");
    EffectsSDKPlatform.instance.setSegmentationPreset(_sdkContext, preset.name);
  }

  void enableSmartZoom() {
    _throwIfNotReady("enableSmartZoom()");
    EffectsSDKPlatform.instance.enableSmartZoom(_sdkContext);
  }

  void disableSmartZoom() {
    _throwIfNotReady("disableSmartZoom()");
    EffectsSDKPlatform.instance.disableSmartZoom(_sdkContext);
  }

  void setFaceArea(double area) {
    _throwIfNotReady("setFaceArea()");
    EffectsSDKPlatform.instance.setFaceArea(_sdkContext, area);
  }

  void setSmartZoomPeriod(double periodMs) {
    _throwIfNotReady("setSmartZoomPeriod()");
    EffectsSDKPlatform.instance.setSmartZoomPeriod(_sdkContext, periodMs);
  }

  void setSmartZoomSensitivity(double value) {
    _throwIfNotReady("setSmartZoomSensitivity()");
    EffectsSDKPlatform.instance.setSmartZoomSensitivity(_sdkContext, value);
  }

  void setSmartZoomSmoothing(double steps) {
    _throwIfNotReady("setSmartZoomSmoothing()");
    EffectsSDKPlatform.instance.setSmartZoomSmoothing(_sdkContext, steps);
  }

  void setFaceDetectorAccuracy(double value) {
    _throwIfNotReady("setFaceDetectorAccuracy()");
    EffectsSDKPlatform.instance.setFaceDetectorAccuracy(_sdkContext, value);
  }

  void enableColorCorrector() {
    _throwIfNotReady("enableColorCorrector()");
    EffectsSDKPlatform.instance.enableColorCorrector(_sdkContext);
  }

  void disableColorCorrector() {
    _throwIfNotReady("disableColorCorrector()");
    EffectsSDKPlatform.instance.disableColorCorrector(_sdkContext);
  }

  void setColorCorrectorPower(double power) {
    _throwIfNotReady("setColorCorrectorPower()");
    EffectsSDKPlatform.instance.setColorCorrectorPower(_sdkContext, power);
  }

  void setColorCorrectorPeriod(int periodMs) {
    _throwIfNotReady("setColorCorrectorPeriod()");
    EffectsSDKPlatform.instance.setColorCorrectorPeriod(_sdkContext, periodMs);
  }

  bool enableColorFilter() {
    _throwIfNotReady("enableColorFilter()");
    return EffectsSDKPlatform.instance.enableColorFilter(_sdkContext);
  }

  bool disableColorFilter() {
    _throwIfNotReady("disableColorFilter()");
    return EffectsSDKPlatform.instance.disableColorFilter(_sdkContext);
  }

  Future<void> setColorFilter({dynamic lut, double? power, int? capacity}) {
    _throwIfNotReady("setColorFilter()");
    final config = ColorFilterConfig(lut: lut, power: power, capacity: capacity);
    return EffectsSDKPlatform.instance.setColorFilterConfig(_sdkContext, config);
  }

  void enableLowLightEffect() {
    _throwIfNotReady("enableLowLightEffect()");
    EffectsSDKPlatform.instance.enableLowLightEffect(_sdkContext);
  }

  void disableLowLightEffect() {
    _throwIfNotReady("disableLowLightEffect()");
    EffectsSDKPlatform.instance.disableLowLightEffect(_sdkContext);
  }

  void setLowLightEffect({double? power, int? modelWidth, int? modelHeight}) {
    _throwIfNotReady("setLowLightEffect()");
    final config = LowLightConfig(power: power, modelWidth: modelWidth, modelHeight: modelHeight);
    EffectsSDKPlatform.instance.setLowLightEffectConfig(_sdkContext, config);
  }

  void setLowLightEffectPower(double value) {
    _throwIfNotReady("setLowLightEffectPower()");
    EffectsSDKPlatform.instance.setLowLightEffectPower(_sdkContext, value);
  }

  void setLayout(Layout layout) {
    _throwIfNotReady("setLayout()");
    EffectsSDKPlatform.instance.setLayout(_sdkContext, layout);
  }

  void setCustomLayout({double? size, double? xOffset, double? yOffset}) {
    _throwIfNotReady("setCustomLayout()");
    EffectsSDKPlatform.instance
        .setCustomLayout(_sdkContext, size, xOffset, yOffset);
  }

  void showFps() {
    _throwIfNotReady("showFps()");
    EffectsSDKPlatform.instance.showFps(_sdkContext);
  }

  void hideFps() {
    _throwIfNotReady("hideFps()");
    EffectsSDKPlatform.instance.hideFps(_sdkContext);
  }

  void setFpsLimit(int limit) {
    _throwIfNotReady("setFpsLimit()");
    EffectsSDKPlatform.instance.setFpsLimit(_sdkContext, limit);
  }

  void setOutputFrameFormat(FrameFormat format) {
    _throwIfNotReady("setOutputFrameFormat()");
    EffectsSDKPlatform.instance.setOutputFrameFormat(_sdkContext, format);
  }

  void setOutputResolution(int? width, int? height) {
    _throwIfNotReady("setOutputResolution()");
    EffectsSDKPlatform.instance.setOutputResolution(_sdkContext, width, height);
  }

  void clearOutputResolution() {
    _throwIfNotReady("clearOutputResolution()");
    EffectsSDKPlatform.instance.clearOutputResolution(_sdkContext);
  }

  void enableFrameSkipping() {
    _throwIfNotReady("enableFrameSkipping()");
    EffectsSDKPlatform.instance.enableFrameSkipping(_sdkContext);
  }

  void disableFrameSkipping() {
    _throwIfNotReady("disableFrameSkipping()");
    EffectsSDKPlatform.instance.disableFrameSkipping(_sdkContext);
  }

  void enablePipelineSkipping() {
    _throwIfNotReady("enablePipelineSkipping()");
    EffectsSDKPlatform.instance.enablePipelineSkipping(_sdkContext);
  }

  void disablePipelineSkipping() {
    _throwIfNotReady("disablePipelineSkipping()");
    EffectsSDKPlatform.instance.disablePipelineSkipping(_sdkContext);
  }

  LowerThirdComponent createLowerThirdComponent({
      LowerThirdType? type,
      String? title, 
      String? subtitle, 
      int? primaryColor}) {
    final options = LowerThirdOptions();
    options.type = type;
    options.title = title;
    options.subtitle = subtitle;
    options.primaryColor = primaryColor;

    return createLowerThirdComponentWithOptions(options);
  }

  LowerThirdComponent createLowerThirdComponentWithOptions(
      LowerThirdOptions options) {
    _throwIfNotReady("createLowerThirdComponentWithOptions()");
    Object componentContext = EffectsSDKPlatform.instance.createLowerThirdComponent(
      _sdkContext, 
      options
    );

    return LowerThirdComponent(componentContext);
  }

  StickersComponent createStickersComponent(
      {required int capacity,
      required Duration duration,
      StickerPosition? pos}) {
    final options =
        StickerOptions(capacity: capacity, duration: duration, position: pos);

    return createStickersComponentWithOptions(options);
  }

  StickersComponent createStickersComponentWithOptions(
      StickerOptions options) {
    _throwIfNotReady("createStickerWithOptions()");
    final componentContext = EffectsSDKPlatform.instance
        .createStickersComponent(_sdkContext, options);

    return StickersComponent(componentContext);
  }

  WatermarkComponent createWatermarkComponent({
      required String url,
      double? size,
      ComponentPosition? pos}) {
    
    final options = WatermarkOptions(url: url, size: size, position: pos);
    final componentContext = EffectsSDKPlatform.instance
      .createWatermarkComponent(_sdkContext, options);

    return WatermarkComponent(componentContext);
  }

  OverlayScreenComponent createOverlayScreenComponent({required String url}) {
    _throwIfNotReady("createOverlayScreenComponent()");
    final options = OverlayScreenOptions(url: url);
    Object componentContext = EffectsSDKPlatform.instance
        .createOverlayScreenComponent(_sdkContext, options);

    return OverlayScreenComponent(componentContext);
  }

  void addComponent(Component component, String id) {
    _throwIfNotReady("addComponent()");
    EffectsSDKPlatform.instance
        .addComponent(_sdkContext, component.internalContext(), id);

    _componentMap[id] = component;
  }

  void removeComponent(String id) {
    _throwIfNotReady("removeComponent()");
    EffectsSDKPlatform.instance.removeComponent(_sdkContext, id);
    _componentMap.remove(id);
  }

  UnmodifiableMapView<String, Component> get components =>
      UnmodifiableMapView<String, Component>(_componentMap);

  bool freeze() {
    _throwIfNotReady("freeze()");
    return EffectsSDKPlatform.instance.freeze(_sdkContext);
  }

  bool unfreeze() {
    _throwIfNotReady("unfreeze()");
    return EffectsSDKPlatform.instance.unfreeze(_sdkContext);
  }

  set onChangeInputResolution(Function? callback) {
    EffectsSDKPlatform.instance.setOnChangeInputResolutionCallback(
      _sdkContext, 
      callback
    );
  }

  set onColorFilterSuccess(Function(String id)? callback) {
    EffectsSDKPlatform.instance.setOnChangeInputResolutionCallback(
      _sdkContext, 
      callback
    );
  }

  set onError(Function(dynamic e)? callback) {
    EffectsSDKPlatform.instance.setOnErrorCallback(
      _sdkContext, 
      callback
    );
  }

  set onLowLightSuccess(Function? callback) {
    EffectsSDKPlatform.instance.setOnLowLightSuccessCallback(
      _sdkContext, 
      callback
    );
  }

  void _throwIfNotReady(String methodName) {
    if (!_ready) {
      throw StateError(
          "${methodName} can not be used until EffectsSDK is ready.");
    }
  }
}
