import 'dart:async';

import 'package:tunes_lovers/apis/lcoation_api.dart';
import 'package:tunes_lovers/models/address.dart';

class AddressesBloc {
  StreamController<List<Address>> controller =
      StreamController<List<Address>>.broadcast();
  Stream<List<Address>> get stream => controller.stream.asBroadcastStream();

  Future<void> update(String text) async {
    LocationApi locationApi = LocationApi();
    locationApi.getAddresesFromText(text).then((value) {
      controller.sink.add(value);
    });
  }

  Future<void> clear() async {
    controller.sink.add([]);
  }
}
