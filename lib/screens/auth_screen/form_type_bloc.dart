import 'dart:async';

enum FormType { login, register, forgetPassword }

class FormTypeBloc {
  StreamController<FormType> controller =
      StreamController<FormType>.broadcast();
  Stream<FormType> get stream => controller.stream.asBroadcastStream();

  get dispose => controller.close();

  update(FormType formType) {
    controller.sink.add(formType);
  }
}
