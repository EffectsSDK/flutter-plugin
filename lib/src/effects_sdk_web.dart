import 'dart:async';
import 'dart:html' as html show window;
import 'dart:js' as js;
import 'dart:js_util' as jsutil;

import 'package:dart_webrtc/src/media_stream_impl.dart' as dartrtc;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

import 'effects_sdk_components.dart';
import 'effects_sdk_config.dart';
import 'effects_sdk_platform_interface.dart';
import 'effects_sdk_enums.dart';

Map<Layout, String> webNamesOfLayout() {
  return {
    Layout.center: "center",
    Layout.leftBottom: "left-bottom",
    Layout.rightBottom: "right-bottom"
  };
}

String webNameOfLayout(Layout layout) {
  return webNamesOfLayout()[layout]!;
}

Map<StickerPlacement, String> webNamesOfPlacement() {
  return {
    StickerPlacement.topLeft: "top-left",
    StickerPlacement.bottomLeft: "bottom-left",
    StickerPlacement.center: "center",
    StickerPlacement.topRight: "top-right",
    StickerPlacement.bottomRight: "bottom-right",
    StickerPlacement.custom: "custom"
  };
}

String? webNameOfPlacement(Placement? placement) {
  return (null != placement) ? webNamesOfPlacement()[placement] : null;
}

Map<FrameFormat, String> webNamesOfFrameFormat() {
  return {
    FrameFormat.rgbx: "RGBX",
    FrameFormat.i420: "I420"
  };
}

String webNameOfFrameFormat(FrameFormat format) {
  final nameMap = webNamesOfFrameFormat();
  final name = nameMap[format];
  return name!;
}

Map<MLBackend, String> webMLProviders() {
  return {
    MLBackend.auto: "auto",
    MLBackend.cpu: "wasm",
    MLBackend.gpu: "webgpu",
  };
}

Map<LowerThirdType, String> webNamesOfLowerThird() {
  return {
    LowerThirdType.lowerthird_1: "lowerthird_1",
    LowerThirdType.lowerthird_2: "lowerthird_2",
    LowerThirdType.lowerthird_3: "lowerthird_3",
    LowerThirdType.lowerthird_4: "lowerthird_4",
    LowerThirdType.lowerthird_5: "lowerthird_5"
  };
}

String webNameOfLowerThirdType(LowerThirdType type) {
  final name = webNamesOfLowerThird()[type];
  if (null == name) {
    throw ArgumentError("Unknown LowerThirdType", type.toString());
  }
  return name!;
}

String? webMLProvider(MLBackend? mlBackend) {
  return (null != mlBackend)? webMLProviders()[mlBackend] : null;
}

class StickerContext {
  final Set<String> urls = <String>{};

  Function(String, String?)? onLoadSuccess;
  Function(String, dynamic)? onLoadError;
}

class EffectsSDKWeb extends EffectsSDKPlatform {
  static const _stickerContextSymbol = Symbol("EffectsSDK.StickerContext");

  EffectsSDKWeb();

  static void registerWith(Registrar registrar) {
    EffectsSDKPlatform.instance = EffectsSDKWeb();
  }

  @override
  Object createContext(String customerID) {
    if (!jsutil.hasProperty(html.window, "tsvb")) {
      throw StateError('tsvb has not been loaded.'
          ' Please, add <script src="https://effectssdk.ai/sdk/web/3.1.5/tsvb-web.js"></script> to your index.html');
    }

    final tsvb = jsutil.getProperty(html.window, "tsvb");
    Object sdkContext = jsutil.callConstructor(tsvb, [customerID]);
    return sdkContext;
  }

  @override
  void setOnReadyCallback(Object sdkContext, Function callback) {
    jsutil.setProperty(sdkContext, "onReady", js.allowInterop(callback));
  }

  @override
  void clearOnReadyCallback(Object sdkContext) {
    jsutil.setProperty(sdkContext, "onReady", null);
  }

  @override
  void config(Object sdkContext, Config config) {
    final jsConfig = jsutil.newObject();
    _setPropertyIfNotNull(jsConfig, "api_url", config.apiUrl);
    _setPropertyIfNotNull(jsConfig, "sdk_url", config.sdkUrl);
    _setPropertyIfNotNull(jsConfig, "preset", config.preset?.name);
    _setPropertyIfNotNull(jsConfig, "proxy", config.proxy);
    _setPropertyIfNotNull(jsConfig, "stats", config.stats);
    _setPropertyIfNotNull(jsConfig, "provider", webMLProvider(config.mlBackend));

    if (null != config.models) {
      final jsModels = jsutil.newObject();
      config.models?.forEach((String model, String url) {
        jsutil.setProperty(jsModels, model, url);
      });
      jsutil.setProperty(jsConfig, "models", jsModels);
    }

    if (null != config.wasmPaths) {
      final jsWasmPaths = jsutil.newObject();
      config.wasmPaths?.forEach((String model, String url) {
        jsutil.setProperty(jsWasmPaths, model, url);
      });
      jsutil.setProperty(jsConfig, "wasmPaths", jsWasmPaths);
    }

    _callJSMethod(sdkContext, "config", [jsConfig]);
  }

  @override
  void useStream(Object sdkContext, webrtc.MediaStream stream) {
    final streamWeb = stream as dartrtc.MediaStreamWeb;
    final jsStream = streamWeb.jsStream;
    _callJSMethod(sdkContext, "useStream", [jsStream]);
  }

  @override
  webrtc.MediaStream getStream(Object sdkContext) {
    final jsStream = _callJSMethod(sdkContext, "getStream", []);
    return dartrtc.MediaStreamWeb(jsStream, "local");
  }

  @override
  Future<void> cache(Object sdkContext, { required bool clear }) {
    return jsutil.promiseToFuture(_callJSMethod(sdkContext, "cache", [clear]));
  }

  @override
  void clear(Object sdkContext) {
    _callJSMethod(sdkContext, "clear", []);
  }

  @override
  Future<void> preload(Object sdkContext) {
    return jsutil.promiseToFuture(
      _callJSMethod(sdkContext, "preload", [])
    );
  }

  @override
  bool run(Object sdkContext) {
    return _callJSMethod(sdkContext, "run", []);
  }

  @override
  void setOnChangeInputResolutionCallback(Object sdkContext, Function? callback) {
    _callJSMethod(sdkContext, "onChangeInputResolution", [_wrapFunction(callback)]);
  }

  @override
  void setOnColorFilterSuccessCallback(Object sdkContext, Function(String id)? callback) {
    _callJSMethod(sdkContext, "onColorFilterSuccess", [_wrapFunction(callback)]);
  }

  @override
  void setOnErrorCallback(Object sdkContext, Function(dynamic)? callback) {
    _callJSMethod(sdkContext, "onError", [_wrapFunction(callback)]);
  }

  @override
  void setOnLowLightSuccessCallback(Object sdkContext, Function? callback) {
    _callJSMethod(sdkContext, "onLowLightSuccess", [_wrapFunction(callback)]);
  }

  @override
  void clearBackground(Object sdkContext) {
    _callJSMethod(sdkContext, "clearBackground", []);
  }

  @override
  void setBackgroundColor(Object sdkContext, int color) {
    _callJSMethod(
        sdkContext, "setBackgroundColor", [_removeAlphaChannel(color)]);
    _callJSMethod(sdkContext, "setBackground", ["color"]);
  }

  @override
  void setBackgroundImage(Object sdkContext, String url) {
    _callJSMethod(sdkContext, "setBackground", [url]);
  }

  @override
  void setBackgroundStream(Object sdkContext, webrtc.MediaStream stream) {
    final streamWeb = stream as dartrtc.MediaStreamWeb;
    final jsStream = streamWeb.jsStream;
    _callJSMethod(sdkContext, "setBackground", [jsStream]);
  }

  @override
  void setBoundaryLevel(Object sdkContext, double level) {
    _callJSMethod(sdkContext, "setBoundaryLevel", [level]);
  }

  @override
  void setBoundaryMode(Object sdkContext, BoundaryMode mode) {
    _callJSMethod(sdkContext, "setBoundaryMode", [mode.name]);
  }

  @override
  void setBackgroundFitMode(Object sdkContext, FitMode mode) {
    _callJSMethod(sdkContext, "setBackgroundFitMode", [mode.name]);
  }

  @override
  void clearBeautification(Object sdkContext) {
    _callJSMethod(sdkContext, "disableBeautification", []);
  }

  @override
  void setBeautificationLevel(Object sdkContext, double level) {
    _callJSMethod(sdkContext, "setBeautificationLevel", [level]);
  }

  @override
  void clearBlur(Object sdkContext) {
    _callJSMethod(sdkContext, "clearBlur", []);
  }

  @override
  void setBlur(Object sdkContext, double power) {
    _callJSMethod(sdkContext, "setBlur", [power]);
  }

  @override
  void setSegmentationPreset(Object sdkContext, String preset) {
    _callJSMethod(sdkContext, "setSegmentationPreset", [preset]);
  }

  @override
  void enableSmartZoom(Object sdkContext) {
    _callJSMethod(sdkContext, "enableSmartZoom", []);
  }

  @override
  void disableSmartZoom(Object sdkContext) {
    _callJSMethod(sdkContext, "disableSmartZoom", []);
  }

  @override
  void setFaceArea(Object sdkContext, double area) {
    _callJSMethod(sdkContext, "setFaceArea", [area]);
  }

  @override
  void setSmartZoomPeriod(Object sdkContext, double periodMs) {
    _callJSMethod(sdkContext, "setSmartZoomPerod", [periodMs]);
  }

  @override
  void setSmartZoomSensitivity(Object sdkContext, double value) {
    _callJSMethod(sdkContext, "setSmartZoomSensitivity", [value]);
  }

  @override
  void setSmartZoomSmoothing(Object sdkContext, double steps) {
    _callJSMethod(sdkContext, "setSmartZoomSmoothing", [steps]);
  }

  @override
  void setFaceDetectorAccuracy(Object sdkContext, double value) {
    _callJSMethod(sdkContext, "setFaceDetectorAccuracy", [value]);
  }

  @override
  void enableColorCorrector(Object sdkContext) {
    _callJSMethod(sdkContext, "enableColorCorrector", []);
  }

  @override
  void disableColorCorrector(Object sdkContext) {
    _callJSMethod(sdkContext, "disableColorCorrector", []);
  }

  @override
  bool enableColorFilter(Object sdkContext) {
    return _callJSMethod(sdkContext, "enableColorFilter", []);
  }

  @override
  bool disableColorFilter(Object sdkContext) {
    return _callJSMethod(sdkContext, "disableColorFilter", []);
  }

  @override
  Future<void> setColorFilterConfig(Object sdkContext, ColorFilterConfig config) {
    final jsConfig = jsutil.newObject();
    _setPropertyIfNotNull(jsConfig, "lut", config.lut);
    _setPropertyIfNotNull(jsConfig, "power", config.power);
    _setPropertyIfNotNull(jsConfig, "capacity", config.capacity);

    final completer = Completer();
    if (null != config.lut) {
      jsutil.setProperty(jsConfig, "promise", _jsifyCompleter(completer));
    }
    bool ok = _callJSMethod(sdkContext, "setColorFilterConfig", [jsConfig]);
    if (!ok) {
      completer.completeError(StateError("ColorFilter is not initialized"));
    }
    else if(null == config.lut) {
      completer.complete();
    }

    return completer.future;
  }

  @override
  void setColorCorrectorPower(Object sdkContext, double power) {
    _callJSMethod(sdkContext, "setColorCorrectorPower", [power]);
  }

  @override
  void setColorCorrectorPeriod(Object sdkContext, int periodMs) {
    _callJSMethod(sdkContext, "setColorCorrectorPeriod", [periodMs]);
  }

  @override
  void enableLowLightEffect(Object sdkContext) {
    _callJSMethod(sdkContext, "enableLowLightEffect", []);
  }

  @override
  void disableLowLightEffect(Object sdkContext) {
    _callJSMethod(sdkContext, "disableLowLightEffect", []);
  }

  @override
  void setLowLightEffectConfig(Object sdkContext, LowLightConfig config) {
    final jsConfig = jsutil.newObject();
    _setPropertyIfNotNull(jsConfig, "modelWidth", config.modelWidth);
    _setPropertyIfNotNull(jsConfig, "modelHeight", config.modelHeight);
    _setPropertyIfNotNull(jsConfig, "power", config.power);
    bool ok = _callJSMethod(sdkContext, "setLowLightEffectConfig", [jsConfig]); 
    if (!ok) {
      throw StateError("LowLightEffect is not initialized");
    } 
  }

  @override
  void setLowLightEffectPower(Object sdkContext, double value) {
    _callJSMethod(sdkContext, "setLowLightEffectPower", [value]);
  }

  @override
  void setLayout(Object sdkContext, Layout layout) {
    String layoutName = webNameOfLayout(layout);
    _callJSMethod(sdkContext, "setLayout", [layoutName]);
  }

  @override
  void setCustomLayout(
      Object sdkContext, double? size, double? xOffset, double? yOffset) {
    var persent = jsutil.newObject();
    if (size != null) {
      jsutil.setProperty(persent, "size", size * 100);
    }
    if (xOffset != null) {
      jsutil.setProperty(persent, "xOffset", xOffset * 100);
    }
    if (yOffset != null) {
      jsutil.setProperty(persent, "yOffset", yOffset * 100);
    }

    _callJSMethod(sdkContext, "setCustomLayout", [persent]);
  }

  @override
  void showFps(Object sdkContext) {
    _callJSMethod(sdkContext, "showFps", []);
  }

  @override
  void hideFps(Object sdkContext) {
    _callJSMethod(sdkContext, "hideFps", []);
  }

  @override
  void setFpsLimit(Object sdkContext, int limit) {
    _callJSMethod(sdkContext, "setFpsLimit", [limit]);
  }

  @override
  void setOutputFrameFormat(Object sdkContext, FrameFormat format) {
    final formatName = webNameOfFrameFormat(format);
    _callJSMethod(sdkContext, "setOutputFrameFormat", [formatName]);
  }

  @override
  void setOutputResolution(Object sdkContext, int? width, int? height) {
    var resolution = jsutil.newObject();
    if (width != null) {
      jsutil.setProperty(resolution, "width", width * 100);
    }
    if (height != null) {
      jsutil.setProperty(resolution, "height", height * 100);
    }
    _callJSMethod(sdkContext, "setOutputResolution", [resolution]);
  }

  @override
  void clearOutputResolution(Object sdkContext) {
    _callJSMethod(sdkContext, "clearOutputResolution", []);
  }

  @override
  void enableFrameSkipping(Object sdkContext) {
    _callJSMethod(sdkContext, "enableFrameSkipping", []);
  }

  @override
  void disableFrameSkipping(Object sdkContext) {
    _callJSMethod(sdkContext, "disableFrameSkipping", []);
  }

  @override
  void enablePipelineSkipping(Object sdkContext) {
    _callJSMethod(sdkContext, "enablePipelineSkipping", []);
  }

  @override
  void disablePipelineSkipping(Object sdkContext) {
    _callJSMethod(sdkContext, "disablePipelineSkipping", []);
  }

  @override
  Object createLowerThirdComponent(
      Object sdkContext, LowerThirdOptions options) {
    final jsParams = jsutil.newObject();
    final lowerThirdType = (null != options.type)? options.type! : LowerThirdType.lowerthird_1;
    jsutil.setProperty(jsParams, "component", webNameOfLowerThirdType(lowerThirdType));
    jsutil.setProperty(jsParams, "options", _jsifyLowerThirdOptions(options));

    return _callJSMethod(sdkContext, "createComponent", [jsParams]);
  }

  @override
  Object createStickersComponent(Object sdkContext, StickerOptions options) {
    final jsOptions = _jsifyStickersOptions(options);

    final params = jsutil.newObject();
    jsutil.setProperty(params, "component", "stickers");
    jsutil.setProperty(params, "options", jsOptions);

    final result = _callJSMethod(sdkContext, "createComponent", [params]);
    // To work around ignoring position options
    componentSetStickerOptions(result, options);

    final stickerContext = StickerContext();
    jsutil.setProperty(result, _stickerContextSymbol, stickerContext);

    onLoadSucccess(String url, String? removedUrl) {
      stickerContext.urls.remove(removedUrl);
      stickerContext.onLoadSuccess?.call(url, removedUrl);
    }

    _callJSMethod(result, "onLoadSucccess", [_wrapFunction(onLoadSucccess)]);

    onLoadError(String url) {
      stickerContext.onLoadError?.call(url, null);
    }

    _callJSMethod(result, "onLoadError", [_wrapFunction(onLoadError)]);

    return result;
  }

  @override
  Object createOverlayScreenComponent(
      Object sdkContext, OverlayScreenOptions options) {
    final jsOptions = _jsifyOverlayScreenOptions(options);

    final params = jsutil.newObject();
    jsutil.setProperty(params, "component", "overlay_screen");
    jsutil.setProperty(params, "options", jsOptions);

    final result = _callJSMethod(sdkContext, "createComponent", [params]);
    return result;
  }

  @override
  Object createWatermarkComponent(Object sdkContext, WatermarkOptions options) {
    final jsOptions = _jsifyWatermarkOptions(options);

    final params = jsutil.newObject();
    jsutil.setProperty(params, "component", "watermark");
    jsutil.setProperty(params, "options", jsOptions);

    final result = _callJSMethod(sdkContext, "createComponent", [params]);
    return result;
  }

  @override
  void addComponent(Object sdkContext, Object component, String id) {
    _callJSMethod(sdkContext, "addComponent", [component, id]);
  }

  @override
  void removeComponent(Object sdkContext, String id) {
    if (!jsutil.hasProperty(sdkContext, "components")) {
      return;
    }
    final components = jsutil.getProperty<Object>(sdkContext, "components");
    jsutil.delete(components, id);
  }

  @override
  void componentDestroy(Object component) {
    _callJSMethod(component, "destroy", []);
  }

  @override
  void componentSetOnBeforeShow(Object component, Function? func) {
    _callJSMethod(component, "onBeforeShow", [_wrapFunction(func)]);
  }

  @override
  void componentSetOnAfterShow(Object component, Function? func) {
    _callJSMethod(component, "onAfterShow", [_wrapFunction(func)]);
  }

  @override
  void componentSetOnBeforeHide(Object component, Function? func) {
    _callJSMethod(component, "onBeforeHide", [_wrapFunction(func)]);
  }

  @override
  void componentSetOnAfterHide(Object component, Function? func) {
    _callJSMethod(component, "onAfterHide", [_wrapFunction(func)]);
  }

  @override
  void componentShow(Object component) {
    _callJSMethod(component, "show", []);
  }

  @override
  void componentHide(Object component) {
    _callJSMethod(component, "hide", []);
  }

  @override
  void componentShowLowerThird(Object component) {
    _callJSMethod(component, "showLowerThird", []);
  }

  @override
  void componentHideLowerThird(Object component) {
    _callJSMethod(component, "hideLowerThird", []);
  }

  @override
  void componentSetOnStickerLoadSucces(
      Object component, Function(String, String?)? func) {
    final stickerContext = _getStickerContext(component);
    stickerContext.onLoadSuccess = func;
  }

  @override
  void componentSetOnStickerLoadError(
      Object component, Function(String, dynamic)? func) {
    final stickerContext = _getStickerContext(component);
    stickerContext.onLoadError = func;
  }

  @override
  void componentPlaySticker(Object component, String url) {
    final stickerContext = _getStickerContext(component);

    if (stickerContext.urls.contains(url)) {
      final options = jsutil.newObject();
      jsutil.setProperty(options, "id", url);
      _callJSMethod(component, "setOptions", [options]);
    } else {
      final options = _jsifyAddSticker(url, false);
      _callJSMethod(component, "setOptions", [options]);
      stickerContext.urls.add(url);
    }
  }

  @override
  void componentPreloadSticker(Object component, String url) {
    final stickerContext = _getStickerContext(component);

    final options = _jsifyAddSticker(url, true);
    _callJSMethod(component, "setOptions", [options]);
    stickerContext.urls.add(url);
  }

  @override
  void componentSetLowerThirdOptions(
      Object component, LowerThirdOptions options) {
    final jsOptions = _jsifyLowerThirdOptions(options);

    _callJSMethod(component, "setOptions", [jsOptions]);
  }

  @override
  void componentSetStickerOptions(Object component, StickerOptions options) {
    final jsOptions = _jsifyStickersOptions(options);

    _callJSMethod(component, "setOptions", [jsOptions]);
  }

  @override
  void componentSetOverlayScreenOptions(
      Object component, OverlayScreenOptions options) {
    final jsOptions = _jsifyOverlayScreenOptions(options);

    _callJSMethod(component, "setOptions", [jsOptions]);
  }

  @override
  void componentSetWatermarkOptions(Object component, WatermarkOptions options) {
    final jsOptions = _jsifyWatermarkOptions(options);

    _callJSMethod(component, "setOptions", [jsOptions]);
  }

  @override
  bool freeze(Object sdkContext) {
    return _callJSMethod(sdkContext, "freeze", []);
  }

  @override
  bool unfreeze(Object sdkContext) {
    return _callJSMethod(sdkContext, "unfreeze", []);
  }

  Object _jsifyLowerThirdOptions(LowerThirdOptions options) {
    final jsOptions = jsutil.newObject();
    final jsTextOptions = jsutil.newObject();
    _setPropertyIfNotNull(jsTextOptions, "title", options.title);
    _setPropertyIfNotNull(jsTextOptions, "subtitle", options.subtitle);
    _setPropertyIfNotNull(jsOptions, "text", jsTextOptions);

    final jsColorOptions = jsutil.newObject();
    _setPropertyIfNotNull(
      jsColorOptions, "primary", _removeAlphaChannel(options.primaryColor)
    );
    _setPropertyIfNotNull(
      jsColorOptions, "secondary", _removeAlphaChannel(options.secondaryColor)
    );
    _setPropertyIfNotNull(jsOptions, "color", jsColorOptions);

    if (null != options.left || null != options.bottom) {
      final jsOffsetOption = jsutil.newObject();
      _setPropertyIfNotNull(jsOffsetOption, "x",
          options.left != null ? options.left! * 100 : null);
      _setPropertyIfNotNull(jsOffsetOption, "y",
          options.bottom != null ? options.bottom! * 100 : null);
      _setPropertyIfNotNull(jsOptions, "offset", jsOffsetOption);
    }

    return jsOptions;
  }

  Object _jsifyAddSticker(String url, bool loadOnly) {
      final sticker = jsutil.newObject();
      jsutil.setProperty(sticker, "url", url);
      if (loadOnly) {
        jsutil.setProperty(sticker, "silenceMode", true);
      }

      final options = jsutil.newObject();
      jsutil.setProperty(options, "sticker", sticker);

      return options;
  }

  Object _jsifyStickersOptions(StickerOptions options) {
    final jsOptions = jsutil.newObject();
    _setPropertyIfNotNull(
        jsOptions, "duration", options.duration.inMilliseconds);
    _setPropertyIfNotNull(jsOptions, "capacity", options.capacity);
    _setPropertyIfNotNull(jsOptions, "size", options.size);
    _setPropertyIfNotNull(jsOptions, "ratio", options.ratio);
    _setPropertyIfNotNull(jsOptions, "animationSpeed", options.animationSpeed);
    if (null != options.position) {
      final pos = jsutil.newObject();
      _setPropertyIfNotNull(pos, "x", options.position?.x);
      _setPropertyIfNotNull(pos, "y", options.position?.y);
      _setPropertyIfNotNull(pos, "placement", 
        webNameOfPlacement(options.position?.placement));

      _setPropertyIfNotNull(jsOptions, "position", pos);
    }

    return jsOptions;
  }

  Object _jsifyOverlayScreenOptions(OverlayScreenOptions options) {
    final jsOptions = jsutil.newObject();
    jsutil.setProperty(jsOptions, "url", options.url);

    return jsOptions;
  }

  Object _jsifyWatermarkOptions(WatermarkOptions options) {
    final jsOptions = jsutil.newObject();
    _setPropertyIfNotNull(jsOptions, "url", options.url);
    _setPropertyIfNotNull(jsOptions, "size", options.size);
    if (null != options.position) {
      _setPropertyIfNotNull(jsOptions, "position", _jsifyComponentPosition(options.position!));
    }

    return jsOptions;
  }

  Object _jsifyComponentPosition(ComponentPosition pos) {
    final jsOptions = jsutil.newObject();
    _setPropertyIfNotNull(jsOptions, "x", pos.x);
    _setPropertyIfNotNull(jsOptions, "y", pos.y);
    _setPropertyIfNotNull(jsOptions, "placement", webNameOfPlacement(pos.placement));

    return jsOptions;
  }

  T _callJSMethod<T>(Object object, String name, List<Object?> args) {
    return jsutil.callMethod(object, name, args);
  }

  void _setPropertyIfNotNull(Object object, String name, dynamic value) {
    if (null == value) {
      return;
    }

    jsutil.setProperty(object, name, value);
  }

  Object _jsifyCompleter(Completer completer) {
    final jsPromiseContainer = jsutil.newObject();
    resolve() { completer.complete(); }
    jsutil.setProperty(jsPromiseContainer, "resolve", _wrapFunction(resolve));
    reject(e) { completer.completeError(e); };
    jsutil.setProperty(jsPromiseContainer, "reject", _wrapFunction(reject));

    return jsPromiseContainer;
  }

  dynamic _wrapFunction<T extends Function>(T? func) {
    return (null != func)? js.allowInterop(func) : null;
  }

  int? _removeAlphaChannel(int? color) {
    return (null != color)? (0x00ffffff & color) : null;
  }

  StickerContext _getStickerContext(Object stickerComponent) {
    return jsutil.getProperty<StickerContext>(
        stickerComponent, _stickerContextSymbol);
  }
}
