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

Map<StickerPlacement, String> webNamesOfStickerPlacement() {
  return {
    StickerPlacement.topLeft: "top-left",
    StickerPlacement.bottomLeft: "bottom-left",
    StickerPlacement.center: "center",
    StickerPlacement.topRight: "top-right",
    StickerPlacement.bottomRight: "bottom-right",
    StickerPlacement.custom: "custom"
  };
}

String? webNameOfStickerPlacement(StickerPlacement? placement) {
  return (null != placement) ? webNamesOfStickerPlacement()[placement] : null;
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
          ' Please, add <script src="https://effectssdk.ai/sdk/web/2.6.8/tsvb-web.js"></script> to your index.html');
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
  void clear(Object sdkContext) {
    _callJSMethod(sdkContext, "clear", []);
  }

  @override
  bool run(Object sdkContext) {
    return _callJSMethod(sdkContext, "run", []);
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
    final jsOptions = _jsifyLowerThirdOptions(options);

    final params = jsutil.newObject();
    jsutil.setProperty(params, "component", "lower_third_1");
    jsutil.setProperty(params, "options", jsOptions);

    return _callJSMethod(sdkContext, "createComponent", [params]);
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
  void addComponent(Object sdkContext, Object component, String id) {
    _callJSMethod(sdkContext, "addComponent", [component, id]);
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
      final sticker = jsutil.newObject();
      jsutil.setProperty(sticker, "url", url);

      final options = jsutil.newObject();
      jsutil.setProperty(options, "sticker", sticker);

      _callJSMethod(component, "setOptions", [options]);
      stickerContext.urls.add(url);
    }
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

  Object _jsifyLowerThirdOptions(LowerThirdOptions options) {
    final jsOptions = jsutil.newObject();
    _setPropertyIfNotNull(jsOptions, "title", options.title);
    _setPropertyIfNotNull(jsOptions, "subtitle", options.subtitle);
    _setPropertyIfNotNull(
        jsOptions, "primaryColor", _removeAlphaChannel(options.primaryColor));
    _setPropertyIfNotNull(
        jsOptions, "left", options.left != null ? options.left! * 100 : null);
    _setPropertyIfNotNull(jsOptions, "bottom",
        options.bottom != null ? options.bottom! * 100 : null);

    return jsOptions;
  }

  Object _jsifyStickersOptions(StickerOptions options) {
    final jsOptions = jsutil.newObject();
    _setPropertyIfNotNull(
        jsOptions, "duration", options.duration.inMilliseconds);
    _setPropertyIfNotNull(jsOptions, "capacity", options.capacity);
    _setPropertyIfNotNull(jsOptions, "size", options.size);
    if (null != options.position) {
      final pos = jsutil.newObject();
      _setPropertyIfNotNull(pos, "x", options.position?.x);
      _setPropertyIfNotNull(pos, "y", options.position?.y);
      _setPropertyIfNotNull(pos, "placement",
          webNameOfStickerPlacement(options.position?.placement));

      _setPropertyIfNotNull(jsOptions, "position", pos);
    }

    return jsOptions;
  }

  Object _jsifyOverlayScreenOptions(OverlayScreenOptions options) {
    final jsOptions = jsutil.newObject();
    jsutil.setProperty(jsOptions, "url", options.url);

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

  dynamic _wrapFunction(Function? func) {
    if (null != func) {
      return js.allowInterop(func);
    } else {
      return null;
    }
  }

  int? _removeAlphaChannel(int? color) {
    if (null != color) {
      return 0x00ffffff & color;
    } else {
      return null;
    }
  }

  StickerContext _getStickerContext(Object stickerComponent) {
    return jsutil.getProperty<StickerContext>(
        stickerComponent, _stickerContextSymbol);
  }
}
