import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/models/stripe_models/charge.dart';
import 'package:tunes_lovers/services/navigation_service/navigation_service.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:tunes_lovers/uis/event_detail_ui/event_detail_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TicketPurchasesUI extends StatelessWidget {
  final Person person;
  const TicketPurchasesUI({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: Scaffold(
        key: key,
        body: CustomScrollView(
          key: key,
          slivers: [
            SliverAppBar(
              key: key,
              pinned: true,
              title: Text(
                "Ticket Purchases",
                key: key,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Charge")
                    .doc(person.customerId)
                    .collection("Charge")
                    .orderBy("createdAt", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(
                          key: key,
                        ),
                      ),
                    );
                  } else {
                    List<Charge> charges = snapshot.data!.docs
                        .map((e) => Charge.fromJSON(e))
                        .toList();
                    return SliverPadding(
                      padding: const EdgeInsets.all(8.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            Charge charge = charges[i];
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      SizeService.borderRadius),
                                  color: Theme.of(context).cardTheme.color,
                                  boxShadow: [
                                    ThemeService.boxShadow(context),
                                  ]),
                              margin: const EdgeInsets.symmetric(
                                vertical: SizeService.innerVerticalPadding,
                              ),
                              child: ListTile(
                                onTap: () async {
                                  await FirebaseFirestore.instance
                                      .collection("Session")
                                      .doc(person.customerId)
                                      .collection("Session")
                                      .where("paymentIntentId",
                                          isEqualTo: charge.paymentIntentId)
                                      .get()
                                      .then((queryDoc) async {
                                    if (queryDoc.docs.isNotEmpty) {
                                      NavigationService(context).push(
                                          EventDetailUI(
                                              person: person,
                                              eventId: queryDoc.docs[0]
                                                  ["eventId"]));
                                    }
                                  });
                                },
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical:
                                        SizeService.innerVerticalPadding * 2,
                                    horizontal:
                                        SizeService.innerHorizontalPadding),
                                isThreeLine: true,
                                leading: CircleAvatar(
                                  backgroundColor: charge.refunded!
                                      ? ThemeService.successColor
                                      : ThemeService.dangerColor,
                                  child: Text(
                                    charge.refunded! ? "R" : "P",
                                    style: GoogleFonts.lato(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  "${charge.currency!.toUpperCase()} ${(charge.amount! / 100).toStringAsFixed(2)}",
                                  style: GoogleFonts.lato(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),
                                    Text(
                                      charge.refunded! ? "Refunded" : "Charged",
                                      style: GoogleFonts.lato(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: charge.refunded!
                                            ? ThemeService.successColor
                                            : ThemeService.dangerColor,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      Intl()
                                          .date("MM/dd/yyyy, HH:mm a")
                                          .format(charge.createdAt!.toDate()),
                                      style: GoogleFonts.lato(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .primaryIconTheme
                                            .color,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Status: ${charge.chargeStatus!}",
                                      style: GoogleFonts.lato(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .primaryIconTheme
                                            .color,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  onPressed: () async {
                                    await launchUrlString(
                                      charge.receiptUrl!,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                                  icon: const Icon(Icons.receipt),
                                ),
                              ),
                            );
                          },
                          childCount: charges.length,
                        ),
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
