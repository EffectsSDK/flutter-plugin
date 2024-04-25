
enum ErrorType {
  info,
  warning,
  error
}

enum ErrorEmitter {
  tsvb,
  componentSystem,
  streamProcessor,
  mlInference,
  presetInit,
  renderer,
  recorder,

  effectVirtualBackground,
  effectColorCorrection,
  effectColorFilter,
  effectSmartZoom,
  effectLowLight
}

class ErrorObject {
  final String message;
  final ErrorType type;
  final ErrorEmitter? emitter;
  final Object? cause;

  ErrorObject({
    required this.message,
    required this.type,
    this.emitter,
    this.cause
  });
}