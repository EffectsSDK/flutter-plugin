
import 'dart:html' as html show window;
import 'dart:js' as js;
import 'dart:js_util' as jsutil;

import 'package:dart_webrtc/src/media_stream_impl.dart' as dartrtc;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

import 'effects_sdk_platform_interface.dart';

class EffectsSDKWeb extends EffectsSDKPlatform {
  EffectsSDKWeb();

  static void registerWith(Registrar registrar) {
    EffectsSDKPlatform.instance = EffectsSDKWeb();
  }
  
  @override
  Object createContext(String customerID) {
    if (!jsutil.hasProperty(html.window, "tsvb")) {
      throw StateError(
        'tsvb has not been loaded.' 
        ' Please, add <script src="https://effectssdk.com/sdk/web/tsvb-web.js"></script> to your index.html'
      );
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
  void useStream(Object sdkContext, webrtc.MediaStream stream) {
    final streamWeb = stream as dartrtc.MediaStreamWeb;
    final jsStream = streamWeb.jsStream;
    jsutil.callMethod(sdkContext, "useStream", [jsStream]);
  }

  @override
  webrtc.MediaStream getStream(Object sdkContext) {
    final jsStream = jsutil.callMethod(sdkContext, "getStream", []);
    return dartrtc.MediaStreamWeb(jsStream, "local");
  }

  @override
  void clear(Object sdkContext) {
    jsutil.callMethod(sdkContext, "clear", []);
  }

  @override
  bool run(Object sdkContext) {
    return jsutil.callMethod(sdkContext, "run", []);
  }

  @override
  void clearBackground(Object sdkContext) {
    jsutil.callMethod(sdkContext, "clearBackground", []);
  }

  @override
  void setBackgroundColor(Object sdkContext, int color) {
    jsutil.callMethod(sdkContext, "setBackgroundColor", [color]);
    jsutil.callMethod(sdkContext, "setBackground", ["color"]);
  }

  @override
  void setBackgroundImage(Object sdkContext, String url) {
    jsutil.callMethod(sdkContext, "setBackground", [url]);
  }

  @override
  void setBackgroundStream(Object sdkContext, webrtc.MediaStream stream) {
    final streamWeb = stream as dartrtc.MediaStreamWeb;
    final jsStream = streamWeb.jsStream;
    jsutil.callMethod(sdkContext, "setBackground", [jsStream]);
  }

  @override
  void clearBeautification(Object sdkContext) {
    jsutil.callMethod(sdkContext, "disableBeautification", []);
  }

  @override
  void setBeautificationLevel(Object sdkContext, double level) {
    jsutil.callMethod(sdkContext, "setBeautificationLevel", [level]);
  }

  @override
  void clearBlur(Object sdkContext) {
    jsutil.callMethod(sdkContext, "clearBlur", []);
  } 

  @override
  void setBlur(Object sdkContext, double power) {
    jsutil.callMethod(sdkContext, "setBlur", [power]);
  } 

  @override
  void setSegmentationPreset(Object sdkContext, String preset) {
    jsutil.callMethod(sdkContext, "setSegmentationPreset", [preset]);
  }
}
