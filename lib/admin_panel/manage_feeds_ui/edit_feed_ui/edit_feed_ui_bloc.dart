import 'dart:async';

class EditFeedUIBloc {
  StreamController<bool> controller = StreamController<bool>.broadcast();
  Stream<bool> get stream => controller.stream.asBroadcastStream();

  void update({required bool isUploading}) {
    controller.sink.add(isUploading);
  }
}
