


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

### How to add

Add `<script src="https://effectssdk.com/sdk/web/tsvb-web.js"></script>` to your index.html.

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
final effectsSDK = EffectsSDK("$CUSTOMER_ID");
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

setSegmentationPreset(**SegmentationPreset** *preset*) -\> **void**  
Selects algorithms to use for Virtual background features.  
Note: The preset affects performance and quality.  
Arguments:
- **SegmentationPreset** *preset* - a value of **SegmentationPreset** enumeration.

### SegmentationPreset

Enumeration with available presets

Available values:
* quality;
* balanced;
* speed;
