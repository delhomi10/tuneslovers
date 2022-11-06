import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:tunes_lovers/models/event.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:theme_provider/theme_provider.dart';

class PaymentUI extends StatefulWidget {
  final Person person;
  final Event event;
  const PaymentUI({Key? key, required this.person, required this.event})
      : super(key: key);

  @override
  State<PaymentUI> createState() => _PaymentUIState();
}

class _PaymentUIState extends State<PaymentUI> {
  CardEditController cardEditController = CardEditController();
  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      key: widget.key,
      child: Scaffold(
        key: widget.key,
        body: CustomScrollView(
          key: widget.key,
          slivers: [
            SliverAppBar(
              title: Text("Purchase Ticket"),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  CardField(
                    enablePostalCode: true,
                    controller: cardEditController,
                    onCardChanged: (card) {
                      setState(() {
                        print(card?.number);
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
