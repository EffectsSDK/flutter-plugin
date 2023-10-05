import 'effects_sdk_enums.dart';

class Config {
  String? apiUrl;
  String? sdkUrl;
  SegmentationPreset? preset;
  bool? proxy;
  bool? stats;

  Map<String, String>? models;
  Map<String, String>? wasmPaths;

  Config(
      {this.apiUrl,
      this.sdkUrl,
      this.preset,
      this.proxy,
      this.stats,
      this.models,
      this.wasmPaths});
}
