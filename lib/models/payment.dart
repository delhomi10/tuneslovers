class Payment {
  final String eventId;
  final String mode;
  final String paymentIntentId;
  final String priceId;
  final String paymentStatus;
  final String status;
  final String sessionId;

  Payment({
    required this.eventId,
    required this.mode,
    required this.paymentIntentId,
    required this.priceId,
    required this.paymentStatus,
    required this.status,
    required this.sessionId,
  });

  factory Payment.fromJSON(dynamic jsonData) {
    return Payment(
      eventId: jsonData["eventId"] ?? "",
      mode: jsonData["mode"] ?? "",
      paymentIntentId: jsonData["paymentIntentId"] ?? "",
      priceId: jsonData["priceId"] ?? "",
      paymentStatus: jsonData["paymentStatus"] ?? "",
      status: jsonData["status"] ?? "",
      sessionId: jsonData["sessionId"] ?? "",
    );
  }
}
