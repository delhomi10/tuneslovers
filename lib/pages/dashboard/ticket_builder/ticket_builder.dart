import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tunes_lovers/models/event.dart';
import 'package:tunes_lovers/models/payment.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/models/stripe_models/session.dart';
import 'package:tunes_lovers/services/navigation_service/navigation_service.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:tunes_lovers/uis/event_detail_ui/event_detail_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class TicketBuilder extends StatelessWidget {
  final Person person;
  const TicketBuilder({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Session")
            .doc(person.customerId)
            .collection("Session")
            .where("paymentStatus", isEqualTo: "paid")
            .where("expiresAt",
                isGreaterThan: Timestamp.now().millisecondsSinceEpoch / 1000)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              key: key,
              child: CircularProgressIndicator(
                key: key,
                color: Theme.of(context).primaryColor,
              ),
            );
          } else {
            List<Session> sessions = snapshot.data!.docs
                .map((e) => Session.fronJSON(e.data()))
                .toList();
            return sessions.isEmpty
                ? Center(
                    key: key,
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: SizeService.outerHorizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Tickets for Upcoming Events",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: SizeService.separatorHeight,
                        ),
                        SizedBox(
                          height: SizeService(context).height * 0.2,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: sessions.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, i) {
                                Session session = sessions[i];
                                return StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("Event")
                                        .doc(session.eventId)
                                        .snapshots(),
                                    builder: (context, eSnapshot) {
                                      if (eSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          key: key,
                                          child: CircularProgressIndicator(
                                            key: key,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        );
                                      }

                                      Event event = Event.fromJson(
                                          eSnapshot.data!.data());
                                      return GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (ctx) {
                                                return Container(
                                                  padding: const EdgeInsets.all(
                                                      SizeService.innerPadding),
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    boxShadow: [
                                                      ThemeService.boxShadow(
                                                          context),
                                                    ],
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        event.title,
                                                        style: GoogleFonts.lato(
                                                          fontSize: 20.0,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: SizeService
                                                              .separatorHeight),
                                                      Text(
                                                        "Date: ${Intl().date("MM/dd/yyyy").format(event.startDate.toDate())}",
                                                        style: GoogleFonts.lato(
                                                          letterSpacing: 0.2,
                                                          fontSize: 18.0,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: SizeService
                                                              .separatorHeight),
                                                      Text(
                                                        event.address!
                                                            .formattedAddress,
                                                        style: GoogleFonts.lato(
                                                          letterSpacing: 0.2,
                                                          fontSize: 18.0,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: StreamBuilder<
                                                                DocumentSnapshot>(
                                                            stream: FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "Session")
                                                                .doc(person
                                                                    .customerId)
                                                                .collection(
                                                                    "Session")
                                                                .doc(event
                                                                    .price!
                                                                    .priceId)
                                                                .snapshots(),
                                                            builder: (context,
                                                                pSnapshot) {
                                                              if (!pSnapshot
                                                                  .hasData) {
                                                                return Center(
                                                                  key: key,
                                                                  child: Text(
                                                                    "Generating QR code...",
                                                                    key: key,
                                                                  ),
                                                                );
                                                              }
                                                              return SfBarcodeGenerator(
                                                                value: session
                                                                    .priceId!
                                                                    .split(
                                                                        "price_")[1],
                                                                backgroundColor:
                                                                    Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                barColor: Colors
                                                                    .white,
                                                                textStyle: GoogleFonts.lato(
                                                                    color: Colors
                                                                        .white),
                                                                showValue: true,
                                                                symbology:
                                                                    QRCode(),
                                                              );
                                                            }),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                        child: AspectRatio(
                                          aspectRatio: 20 / 9,
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      SizeService.borderRadius),
                                              boxShadow: [
                                                ThemeService.boxShadow(context),
                                              ],
                                            ),
                                            alignment: Alignment.center,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 12.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          event.title,
                                                          style:
                                                              GoogleFonts.lato(
                                                            fontSize: 20.0,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: SizeService
                                                                .separatorHeight),
                                                        Text(
                                                          "Date: ${Intl().date("MM/dd/yyyy").format(event.startDate.toDate())}",
                                                          style:
                                                              GoogleFonts.lato(
                                                            letterSpacing: 0.2,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: SizeService
                                                                .separatorHeight),
                                                        Text(
                                                          event.address!
                                                              .formattedAddress,
                                                          style:
                                                              GoogleFonts.lato(
                                                            letterSpacing: 0.2,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: StreamBuilder<
                                                          DocumentSnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection("Session")
                                                          .doc(
                                                              person.customerId)
                                                          .collection("Session")
                                                          .doc(event
                                                              .price!.priceId)
                                                          .snapshots(),
                                                      builder:
                                                          (context, pSnapshot) {
                                                        if (!pSnapshot
                                                            .hasData) {
                                                          return Center(
                                                            key: key,
                                                            child: Text(
                                                              "Generating QR code...",
                                                              key: key,
                                                            ),
                                                          );
                                                        } else if (!pSnapshot
                                                            .data!.exists) {
                                                          return Center();
                                                        }
                                                        return ClipRRect(
                                                          borderRadius: BorderRadius
                                                              .circular(SizeService
                                                                  .borderRadius),
                                                          child:
                                                              SfBarcodeGenerator(
                                                            // value: {
                                                            //   "firebaseUserId":
                                                            //       session
                                                            //           .firebaseUserId,
                                                            //   "customerId":
                                                            //       session
                                                            //           .customerId,
                                                            //   "customerEmail":
                                                            //       session
                                                            //           .customerEmail,
                                                            //   "amount": session
                                                            //       .amount,
                                                            //   "eventId": session
                                                            //       .eventId,
                                                            //   "priceId": session
                                                            //       .priceId,
                                                            //   "paymentIntentId":
                                                            //       session
                                                            //           .paymentIntentId,
                                                            //   "paymentStatus":
                                                            //       session
                                                            //           .paymentStatus,
                                                            // }.toString(),
                                                            value: session
                                                                .priceId!
                                                                .split(
                                                                    "price_")[1],

                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                            barColor:
                                                                Colors.white,
                                                            showValue: false,
                                                            symbology: QRCode(),
                                                          ),
                                                        );
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              }),
                        ),
                      ],
                    ),
                  );
          }
        });
  }
}
