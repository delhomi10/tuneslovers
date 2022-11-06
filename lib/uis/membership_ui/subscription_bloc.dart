import 'dart:async';

import 'package:tunes_lovers/models/stripe_models/subscription.dart';

class SubscriptionBloc {
  StreamController<Subscription?> controller =
      StreamController<Subscription?>.broadcast();
  Stream<Subscription?> get stream => controller.stream.asBroadcastStream();

  get dispose => controller.close();

  Future<void> update({required String customerId}) async {
    Subscription.fetchSubscription(customerId: customerId).then((value) {
      print(value);
      controller.sink.add(value);
    });
  }
}
