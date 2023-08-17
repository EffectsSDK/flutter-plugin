

# Video Effects SDK: Flutter plugin and samples

Video Effects SDK plugin for Flutter Web

Add real-time AI video enhancements that make the video meeting experience more effective and comfortable to your application.
This repository contains the Flutter plugin that integrates Video Effects SDK Web into your project/product that uses **Flutter WebRTC** plugin.
The plugin can work with **Flutter WebRTC**, just put a **MediaStream** into the SDK and use the returned **MediaStream**.
Also, there is the example Flutter project, which, if you have a license, you can build and run to see the plugin in action.

## Obtaining an Effects SDK License

To receive an **Effects SDK** license, please fill out the contact form on [effectssdk.com](https://effectssdk.com/contacts) website.

## Features

- Virtual backgrounds (put an image, color, or WebRTC MediaStream as a background)
- Background blur
- Beautification/Touch up my appearance
- Auto framing
- Automatic Color Correction
- Layouts
- Lower-Third
- Overlays

### How to add

Add `<script src="https://effectssdk.com/sdk/dev/2.3.5/tsvb-web.js"></script>` to your index.html.

Add next code as dependency in your pubspec.yaml file.
```yaml
  effects_sdk:
    git:
      url: https://github.com/EffectsSDK/flutter-plugin.git
```

### Usage

- Create an instance of **EffectsSDK** and pass your Customer ID to the constructor.
- Use `EffectsSDK.useStream(mediaStream)` to put a stream to be processed.
- Use `EffectsSDK.getStream()` to get a stream with applied effects.
- Set `EffectsSDK.onReady` callback.
- When ready use `EffectsSDK.run()` to start video processing.
- Enable features you wish. For example, use `EffectsSDK.setBlur(power)` to enable Background blur.

```dart
const String customerID = String.fromEnvironment("CUSTOMER_ID");
final effectsSDK = EffectsSDK(customerID);
effectsSDK.useStream(inputStream);
final outputStream = effectsSDK.getStream();
effectsSDK.onReady = () {
    effectsSDK.run();
    effectsSDK.setBlur(60);
};
```

More usage details can be found in: **Example/lib/main.dart**.

## How to run example

To run example provide environment variable `CUSTOMER_ID` with your customer id.
```sh
flutter run --dart-define=CUSTOMER_ID=$CUSTOMER_ID
```

## Class Reference

### EffectsSDK

**EffectsSDK**(**String** *customerID*)  
Constructs an instance of EffectsSDK  
Arguments:
- **String** *customerID* - ID gotten from [effectssdk.com](https://effectssdk.com/contacts)

onReady -\> Function?  
The property holds a function that is called on SDK readiness.  
Note: An instance can not get ready before `useStream` is called with the correct argument.

useStream(**MediaStream** *stream*) -\> **void**  
Puts the stream into SDK to process.  
Arguments:
- **MediaStream** *stream* - a WebRTC stream to be processed.

getStream() -\> **MediaStream**  
Returns a stream with applied effects.

isReady -\> **bool**  
The property is true when SDK is ready to process video, method `run` can be called, and features can be activated.

clear() -\> **void**  
Disables enabled features and stops processing.

**NOTE**: Don't use next methods until this instance is ready.

run()-\> **void**  
Starts processing.  
Note: The stream that was returned by `getStream()` started providing media.  
If no features are enabled, then the stream provides original media.

clearBackground() -\> **void**  
Disables the background feature.

setBackgroundImage(**String** *url*) -\> **void**  
Sets an image as a background. If Background Replacement is not enabled, then this method enables it.  
Replaces another background.  
Arguments:
- **String** *url* - an URL to an image.

setBackgroundStream(**MediaStream** *stream*) -\> **void**  
Sets a stream as a background. If Background Replacement is not enabled, then this method enables it.  
Replaces another background.  
Arguments:
- **MediaStream** *stream* - a WebRTC stream with video.

setBackgroundColor(**int** *color*) -\> **void**  
Sets a color as the background. If Background Replacement is not enabled, then this method enables it.  
Replaces another background.  
Arguments:
- **int** *color* - A 32 bit color value in ARGB format. (See [dart:ui Color](https://api.flutter.dev/flutter/dart-ui/Color/value.html))

setBackgroundFitMode(**FitMode** mode) -\> **void**
Control background fit/fill mode. 
Arguments:
- **FitMode** mode - the background fit mode, can be fit of fill (Default is fill mode).

clearBeautification() -\> **void**  
Disables beautification feature.

setBeautificationLevel(**double** *level*) -\> **void**  
Enables beautification.  
Arguments:
- **double** *level* - a value from 0 to 1. A higher value has a more visible effect on beautification.

clearBlur() -\> **void**  
Disables background blur feature.

setBlur(**double** *power*) -\> **void**  
Enables Background blur feature. Sets blur power.  
Arguments:
- **double** *power* - A number greater than 0. A higher number means a blurrier background.

setBoundaryLevel(**double** level) -\> **void**
Sets segmentations boundaries area.
Arguments:
- **double** level - a value from -5 to 5. Higher number -\> bigger area outside the segmentation object.

setBoundaryMode(**BoundaryMode** mode) -/> **void**
Controls boundary mode smooth or strong. Default value is strong mode.
Arguments:
- **BoundaryMode** mode - the boundary mode, can be smooth or strong.

setSegmentationPreset(**SegmentationPreset** *preset*) -\> **void**  
Selects algorithms to use for Virtual background features.  
Note: The preset affects performance and quality.  
Arguments:
- **SegmentationPreset** *preset* - a value of **SegmentationPreset** enumeration.

enableSmartZoom() -\> **void**
Enable smart zoom effect. 

disableSmartZoom() -\> **void**
Disable smart zoom effect. 

setFaceArea(**double** area) -\> **void**
Set the face-area proportion. Used by the smart-zoom effect to calculate frame scale value
Arguments:
- **double** area - a value from 0.01 to 1 (default 0.1).

setFaceDetectorAccuracy(**double** accuracy) -\> **void**
Set the face detector accuracy.
Arguments:
- **double** accuracy - a value from 0.2 to 1 (default 0.75).

setSmartZoomPeriod(**int** periodMS) -\> **void**
Set period in milliseconds for face detector reaction.
Arguments:
- **int** periodMS - Period duration in milliseconds. Can be from 0 to 1000 (default 100)

setSmartZoomSensitivity(**double** value) -\> **void**
Set sensitivity for the smart-zoom rection. 
The set value means the difference between the new and old face-params for the smart-zoom reaction.
Arguments:
- **double** value - a value from 0 to 1 (default 0.05).

setSmartZoomSmoothing(**double** steps) -\> **void**
Set count of the smart-zoom smoothing. The more steps, the higher the smoothing
Arguments:
- **double** steps - a value from 0.01 to 1 (default 0.2).

enableColorCorrector() -\> **void**
Enable color correction effect.

disableColorCorrector() -\> **void**
Disable color correction effect.

setColorCorrectorPower(**double** power) -\> **void**
Control how strong the effect aplied.
Arguments:
- **double** power - a value from 0 to 1. Higher number -\> more visible effect.

setColorCorrectorPeriod(**int** periodMs) -\> **void** 
Set period in milliseconds for color correction model working.
Arguments:
- **int** periodMs - Period duration in milliseconds. Can be from 0 to 5000 (default 1000)

setLayout(**Layout** layout) -\> **void**
Set the layout mode. Useful for presentations.

setCustomLayout({**double**? size, **double**? xOffset, **double**? yOffset}) -\> **void**
Set a custom layout mode.
Arguments:
- **double?** size - size of window, a value from 0 to 1.
- **double?** xOffset - padding from the left edge, a value from 0 to 1.
- **double?** yOffset -  padding from the top edge, a value from 0 to 1.

showFps() -\> **void**
Show FPS statistic on the stream. (By default hidden).

hideFps() -\> **void**
Hide FPS statistic on the stream.

setFpsLimit(**int** limit) -\> **void**
Arguments:
- **int** limit

enableFrameSkipping() -\> **void**
Enable Frame Skipping - segmentation will be running on every second frame, this will increase FPS but brings some motion trail.

disableFrameSkipping() -\> **void**
Disable Frame Skipping - segmentation will be running on every video frame. FrameSkipping disabled by default.

enablePipelineSkipping() -\> **void**

disablePipelineSkipping() -\> **void**

createLowerThirdComponent({**String**? title, **String**? subtitle, **int**? primaryColor}) -\> **LowerThirdComponent**
Create and return a new instance of **LowerThirdComponent**. For more information see **LowerThirdComponent**.
Note: Returned **Component** should to be passed into addComponent to be shown.
Arguments:
- **String**? title - field of **LowerThirdOptions**
- **String**? subtitle  - field of **LowerThirdOptions**
- **int**? primaryColor - field of **LowerThirdOptions**

Example
```dart
final lowerThird = _effectsSDK.createLowerThirdComponent(
    title: "Jonh Doe",
    subtitle: "Some description"
);
_effectsSDK.addComponent(lowerThird, "lower_third");
lowerThird.showLowerThird();
```

createLowerThirdComponentWithOptions(**LowerThirdOptions** options)-\> **LowerThirdComponent**
Create and return a new instance of **LowerThirdComponent**. For more information see **LowerThirdComponent**.
Note: Returned **Component** should to be passed into addComponent to be shown.
Arguments:
- **LowerThirdOptions** options - see **LowerThirdOptions**

createStickersComponent({required **int** capacity, required **Duration** duration, **StickerPosition**? pos}) -\> **StickersComponent**
Create and return a new instance of **StickersComponent**. For more information see **StickersComponent**.
Note: Returned **Component** should to be passed into addComponent to be shown.
Arguments:
- **int** capacity - field of **StickerOptions**
- **Duration** duration - field of **StickerOptions**
- **StickerPosition**? pos - field of **StickerOptions**

Example
```dart
final stickers = _effectsSDK.createStickersComponent(
    capacity: 8, 
    duration: const Duration(seconds: 16)
);
_effectsSDK.addComponent(stickers, "stickers");

stickers.playSticker(url: urlToMedia);
```

createStickersComponentWithOptions(**StickerOptions** options) -\> **StickersComponent** 
Create and return a new instance of **StickersComponent**. For more information see **StickersComponent**.
Note: Returned **Component** should to be passed into addComponent to be shown.
Arguments:
- **StickerOptions** options - see **StickerOptions**.

createOverlayScreenComponent({required **String** url}) -\> **OverlayScreenComponent** 
Create and return a new instance of **OverlayScreenComponent**. For more information see **OverlayScreenComponent**.
Note: Returned **Component** should to be passed into addComponent to be shown.
Arguments:
- **String** url - url to a media file

Example
```dart
final overlay = _effectsSDK.createOverlayScreenComponent(
    url: urlToMedia
);
_effectsSDK.addComponent(overlay, "overlay");
overlay.show();
```

addComponent(**Component** component, **String** id) -\> **void**
Add the component to pipeline. 
Arguments:
- **Component** component - component to be added into the pipeline.
- **String** id - an unique identificator of component within the pipeline.

components -\> **UnmodifiableMapView**<**String**, **Component**>
Read-only property that returns a copy of component map. Key is id.

### enum SegmentationPreset

Enumeration with available presets

Available values:
* quality;
* balanced;
* speed;

### enum BoundaryMode 

Available values:
* smooth;
* strong;

### class Component

Components system allows add Overlays, Lower Thirds, videos and images to the pipeline.
**Component** is base class of all components. Instance of **Component** does not creates directly, to create **Component** use EffectsSDK methods.

type -\> **ComponentType**

Read-only return type of **Component**.

show() -\> **void**

Make this component visible.

hide() -\> **void**

Make this component invisible.

setOnBeforeShow(**Function**? handler) -\> **void**
Set function that will be called when this component is about to show.
Arguments:
- **Function**? handler

setOnAfterShow(**Function**? handler) -\> **void**
Set function that will be called after this component get shown.
Arguments:
- **Function**? handler

setOnBeforeHide(**Function**? handler) -\> **void**
Set function that will be called when this component is about to hide.
Arguments:
- **Function**? handler 

setOnAfterHide(**Function**? handler) -\> **void**
Set function that will be called when this component get hidden.
Arguments:
- **Function**? handler 

### enum ComponentType

Available values:
* stickers
* lowerThird
* overlayScreen

### class LowerThirdOptions

LowerThirdOptions contains settings of Lower Third functional.

title -\> **String**?

subtitle -\> **String**?

primaryColor -\> **int**?

A 32 bit color value in ARGB format. (See [dart:ui Color](https://api.flutter.dev/flutter/dart-ui/Color/value.html))
Note: Alpha channel is ignored.

left -\> **double**?

Horizontal position of lower third. 0 at left border, 1 at right border

bottom -\> **double**?

Vertical position of lower third. 0 at bottom border, 1 at top border

### class LowerThirdComponent extends Component

Controls Lower Third component inside of pipeline.

setOptions(**LowerThirdOptions** options) -\> **void**
Reconfigure this Lower Third.
Arguments:
- **LowerThirdOptions** options 

showLowerThird() -\> **void**
Make this visible and begin expanding animation.

hideLowerThird() -\> **void**
Begin collapsing animation and make this invisible in the end.

### enum StickerPlacement 

Available values:
* topLeft,
* bottomLeft,
* center,
* topRight,
* bottomRight,
* custom

### class StickerPosition 

x -\> **double**?

Horizontal position on screen. Ignored if placement is not **StickerPlacement**.custom.
0 at left border, 1 at right border

y -\> **double**?

Vertical position on screen. Ignored if placement is not **StickerPlacement**.custom.
0 at top border, 1 at bottom border

placement -\> **StickerPlacement**?

Determinates position of sticker on screen. 
If placement is **StickerPlacement**.custom then position is determinated by x and y coordinates.

StickerPosition({**double**? x, **double**? y, **StickerPlacement**? placement}) 
Constructor

### class StickerOptions
  
capacity -\> **int**

Max number of loaded media files in cache.

duration -\> **Duration**

Duration of sticker on screen.

position -\> **StickerPosition**?

Position of sticker on screen.

size -\> **double**?

Relative size of sticker. From 0 to 1.

### class StickersComponent extends Component 

Renders a media file on screen

playSticker({required String url}) -\> **void**
Load and render media. If media is already loaded then render immediatelly.
Component keeps last **StickerOptions**.capacity files.
Old media files will be unloaded.
Arguments:
- **String** url - url to a media file.

setOnLoadSuccess(**Function**(**String** url, **String**? removedUrl)? handler) -\> **void**
Set handler on successfully loaded media file. 
handler gets url of the loaded media file and optionally gets url of a media file that was removed from the cache.
Arguments:
- **Function** handler

handler's argument:
- **String** url - url of loaded media file.
- **String**? removedUrl - url of removed media file if has removed one otherwise null.

setOnLoadError(**Function**(**String** url, **dynamic**)? handler) -\> **void**
Set handler on error during file loading. 
Arguments:
- **Function**(**String** url, **dynamic**)? handler

handler's argument:
- **String** url - url of the media file.

setOptions(**StickersOptions** options) -\> **void**
Reconfigure this component.
Arguments:
- **StickersOptions** options 

### class OverlayScreenOptions 

url -\> **String**

Url to a media file.

OverlayScreenOptions({required **String** url});
Constructor

### class OverlayScreenComponent extends Component 
  
OverlayScreen replaces entire screen by image or video.
OverlayScreen by default hidden, to render overlay on screen, use show().
  
setOptions(**OverlayScreenOptions** options) -\> **void**
Reconfigure this **Component**. Can be used to choose another media file.
Arguments:
- **OverlayScreenOptions** options 

### enum FitMode 

Available values:
* fill,
* fit

### enum Layout 

Available values:
* center;
* leftBottom;
* rightBottom;