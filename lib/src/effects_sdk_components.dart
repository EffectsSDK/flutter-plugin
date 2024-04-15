import 'effects_sdk_platform_interface.dart';
import 'effects_sdk_enums.dart';

enum ComponentType { stickers, lowerThird, overlayScreen, watermark }
enum LowerThirdType { lowerthird_1, lowerthird_2, lowerthird_3, lowerthird_4, lowerthird_5 }

class ComponentPosition {
  double? x;
  double? y;
  Placement? placement;

  ComponentPosition({this.x, this.y, this.placement});
}

abstract class Component {
  final Object _componentContext;
  final ComponentType type;
  Component(Object componentContext, this.type)
      : _componentContext = componentContext;

  void show() {
    EffectsSDKPlatform.instance.componentShow(_componentContext);
  }

  void hide() {
    EffectsSDKPlatform.instance.componentHide(_componentContext);
  }

  void destroy() {
    EffectsSDKPlatform.instance.componentDestroy(_componentContext);
  }

  set onBeforeShow(Function? handler) {
    EffectsSDKPlatform.instance
        .componentSetOnBeforeShow(_componentContext, handler);
  }

  set onAfterShow(Function? handler) {
    EffectsSDKPlatform.instance
        .componentSetOnAfterShow(_componentContext, handler);
  }

  set onBeforeHide(Function? handler) {
    EffectsSDKPlatform.instance
        .componentSetOnBeforeHide(_componentContext, handler);
  }

  set onAfterHide(Function? handler) {
    EffectsSDKPlatform.instance
        .componentSetOnAfterHide(_componentContext, handler);
  }

  Object internalContext() {
    return _componentContext;
  }
}

class LowerThirdOptions {
  LowerThirdType? type;
  String? title;
  String? subtitle;
  int? primaryColor;
  int? secondaryColor;

  double? left;
  double? bottom;
}

class LowerThirdComponent extends Component {
  LowerThirdComponent(Object componenContext)
      : super(componenContext, ComponentType.lowerThird);

  void showLowerThird() {
    EffectsSDKPlatform.instance.componentShowLowerThird(_componentContext);
  }

  void hideLowerThird() {
    EffectsSDKPlatform.instance.componentHideLowerThird(_componentContext);
  }

  void setOptions(LowerThirdOptions options) {
    EffectsSDKPlatform.instance
        .componentSetLowerThirdOptions(_componentContext, options);
  }
}

typedef StickerPlacement = Placement;
typedef StickerPosition = ComponentPosition;

class StickerOptions {
  int capacity;
  Duration duration;
  double? animationSpeed;
  StickerPosition? position;
  double? size;
  double? ratio;

  StickerOptions(
      {required this.capacity, required this.duration, this.position});
}

class StickersComponent extends Component {
  StickersComponent(Object componenContext)
      : super(componenContext, ComponentType.stickers);

  void playSticker({required String url}) {
    EffectsSDKPlatform.instance.componentPlaySticker(_componentContext, url);
  }

  void preloadSticker({required String url}) {
    EffectsSDKPlatform.instance.componentPreloadSticker(_componentContext, url);
  }

  void setOnLoadSuccess(Function(String url, String? removedUrl)? handler) {
    EffectsSDKPlatform.instance
        .componentSetOnStickerLoadSucces(_componentContext, handler);
  }

  void setOnLoadError(Function(String url, dynamic e)? handler) {
    EffectsSDKPlatform.instance
        .componentSetOnStickerLoadError(_componentContext, handler);
  }

  void setOptions(StickerOptions options) {
    EffectsSDKPlatform.instance
        .componentSetStickerOptions(_componentContext, options);
  }
}

class OverlayScreenOptions {
  String url;

  OverlayScreenOptions({required this.url});
}

class OverlayScreenComponent extends Component {
  OverlayScreenComponent(Object componenContext)
      : super(componenContext, ComponentType.overlayScreen);

  void setOptions(OverlayScreenOptions options) {
    EffectsSDKPlatform.instance
        .componentSetOverlayScreenOptions(_componentContext, options);
  }
}

class WatermarkOptions {
  String? url;
  ComponentPosition? position;
  double? size;

  WatermarkOptions({this.url, this.position, this.size});
}
class WatermarkComponent extends Component {
  WatermarkComponent(Object componenContext)
    : super(componenContext, ComponentType.watermark);
  void setOptions(WatermarkOptions options) {
    EffectsSDKPlatform.instance
        .componentSetWatermarkOptions(_componentContext, options);
  }
}