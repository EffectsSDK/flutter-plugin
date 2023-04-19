import 'package:flutter/material.dart';
import 'dart:async';

import 'package:effects_sdk/effects_sdk.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_webrtc/flutter_webrtc.dart';

void main() {
  runApp(const EffectsSDKSampleApp());
}

void stopTracks(MediaStream? stream) {
  if (stream == null) {
    return;
  }
  
  for (final track in stream.getTracks()) {
    track.stop();
  }
}

String getCustomerID() {
  const String result = String.fromEnvironment("CUSTOMER_ID");
  if (result.isEmpty) {
    throw Exception(
      "CUSTOMER_ID is not provided!\n"
      "Please, provide CUSTOMER_ID as an environment variable by using --dart-define=CUSTOMER_ID={Your_customer_id}.\n"
      "Example 'flutter run --dart-define=CUSTOMER_ID=\$CUSTOMER_ID'\n"
      "To receive a license, visit https://effectssdk.com/contacts/"
    );
  }

  return result;
}

class EffectsSDKSampleApp extends StatefulWidget {
  const EffectsSDKSampleApp({super.key});

  @override
  State<EffectsSDKSampleApp> createState() => _EffectsSDKSampleAppState();
}

class _EffectsSDKSampleAppState extends State<EffectsSDKSampleApp> {
  final RTCVideoRenderer _rtcVideoRenderer = RTCVideoRenderer();
  final _effectsSDK = EffectsSDK(getCustomerID());

  String? _currentCameraID;
  MediaStream? _currentCameraStream;
  MediaStream? _currentSdkOutput;

  bool _cameraSelectionEnabled = false;
  List<MediaDeviceInfo> _cameraInfoList = [];


  @override
  void initState() {
    super.initState();
    _rtcVideoRenderer.initialize();
    initEffectsSDK();
  }

  Future<void> initEffectsSDK() async {
    final cameraInfos = await enumerateVideoInputs();
    if (cameraInfos.isEmpty) {
      return;
    }

    switchCamera(cameraInfos.first.deviceId);
  }

  Future<void> switchCamera(String deviceID) async {
    if (_currentCameraID?.compareTo(deviceID) == 0) {
      return;
    }

    MediaStream inputStream = await getVideoStream(deviceID);
    _effectsSDK.clear();
    _effectsSDK.useStream(inputStream);
    MediaStream outputStream = _effectsSDK.getStream();
    _rtcVideoRenderer.srcObject = outputStream;
    _effectsSDK.onReady = () {
      _effectsSDK.run();
      _effectsSDK.setBackgroundColor(Colors.greenAccent.value);
    };

    _currentCameraID = deviceID;
    stopTracks(_currentCameraStream);
    _currentCameraStream = inputStream;
    stopTracks(_currentSdkOutput);
    _currentSdkOutput = outputStream;
  }

  Future<List<MediaDeviceInfo>> enumerateVideoInputs() async {
    final List<MediaDeviceInfo> devices = await navigator.mediaDevices.enumerateDevices();
    List<MediaDeviceInfo> result = [];
    for (final device in devices) {
      if ("videoinput" == device.kind) {
        result.add(device);
      }
    }
    
    return result;
  }

  Future<MediaStream> getVideoStream(String deviceID) async {
    Map<String, dynamic> constraints = {"video": {"optional": [{"sourceId": deviceID}]} };
    if (kIsWeb) {
      constraints = {"video": {"deviceId": deviceID} };
    }
    return navigator.mediaDevices.getUserMedia(constraints);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('EffectsSDK Example App'),
        ),
        body: _cameraSelectionEnabled? buildCameraSelector() : buildVideoPreview(),
      ),
    );
  }

  Widget buildVideoPreview() {
    onSwitchCameraPressed() async {
      final infos = await enumerateVideoInputs();
      setState(() {
        _cameraInfoList = infos;
        _cameraSelectionEnabled = true;
      });
    }

    return Column(children: [
      Expanded(child: 
        RTCVideoView(_rtcVideoRenderer)
      ),
      TextButton(
        onPressed: onSwitchCameraPressed, 
        child: Container(
          padding: const EdgeInsets.all(6.0),
          margin: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(border: Border.all(width: 1)),
          child: const Text("Switch Camera")
        )
      )
    ]);
  }

  Widget buildCameraSelector() {
    return Column(
      children: [
        Expanded(child: buildCameraList()),
        TextButton(onPressed: () { setState(() {
            _cameraInfoList = [];
            _cameraSelectionEnabled = false;
            }); 
          }, 
          child: Container(
            padding: const EdgeInsets.all(24),
            child: const Text("Cancel")
          )
        )
      ]
    );
  }

  Widget buildCameraList() {
    final cameraInfos = _cameraInfoList;
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemBuilder: (BuildContext context, int index) {
        return buildCameraItem(cameraInfos[index]);
      },
      itemCount: cameraInfos.length,
    );
  }

  Widget buildCameraItem(MediaDeviceInfo deviceInfo) {
    onPressed() {
      switchCamera(deviceInfo.deviceId);
      setState(() {
        _cameraInfoList = [];
        _cameraSelectionEnabled = false;
      });
    }

    return TextButton(
      onPressed: onPressed, 
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Text(deviceInfo.label)
      )
    );
  }
}
