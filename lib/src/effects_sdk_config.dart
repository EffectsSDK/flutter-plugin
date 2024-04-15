import 'effects_sdk_enums.dart';

class Config {
  String? apiUrl;
  String? sdkUrl;
  SegmentationPreset? preset;
  MLBackend? mlBackend;
  bool? proxy;
  bool? stats;

  Map<String, String>? models;
  Map<String, String>? wasmPaths;

  Config(
      {this.apiUrl,
      this.sdkUrl,
      this.preset,
      this.mlBackend,
      this.proxy,
      this.stats,
      this.models,
      this.wasmPaths});
}

class LowLightConfig {
  double? power;
  int? modelWidth;
  int? modelHeight;

  LowLightConfig({
    this.power,
    this.modelWidth,
    this.modelHeight
  });
}

class ColorFilterConfig {
  dynamic lut;
  double? power;
  int? capacity;

  ColorFilterConfig({
    this.lut,
    this.power,
    this.capacity
  });
}