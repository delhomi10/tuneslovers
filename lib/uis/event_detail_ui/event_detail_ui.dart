import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tunes_lovers/apis/payment_api/payment_api.dart';
import 'package:tunes_lovers/models/event.dart';
import 'package:tunes_lovers/models/performer.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/models/purchase.dart';
import 'package:tunes_lovers/models/stripe_models/price.dart';
import 'package:tunes_lovers/models/stripe_models/session.dart';
import 'package:tunes_lovers/models/stripe_models/subscription.dart';
import 'package:tunes_lovers/services/navigation_service/navigation_service.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:tunes_lovers/uis/event_detail_ui/payment_ui/payment_ui.dart';
import 'package:tunes_lovers/uis/performer_detail_ui/performer_detail_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class EventDetailUI extends StatelessWidget {
  final Person person;
  final String eventId;
  const EventDetailUI({Key? key, required this.person, required this.eventId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Event")
              .doc(eventId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  key: key,
                ),
              );
            }
            Event event = Event.fromJson(snapshot.data!);
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              key: key,
              slivers: [
                SliverAppBar(
                  key: key,
                  pinned: true,
                  title: Text(
                    event.title,
                    key: key,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(SizeService.innerPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              event.title,
                              style: GoogleFonts.lato(
                                letterSpacing: 0.6,
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0,
                              ),
                            ),
                            const SizedBox(height: SizeService.separatorHeight),
                            Text(
                              event.detail,
                              style: GoogleFonts.lato(
                                fontStyle: FontStyle.italic,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeService.separatorHeight,
                          child: Divider(
                            thickness: 1,
                            color: Theme.of(context).primaryIconTheme.color,
                          ),
                        ),

                        // Event Info
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Capacity: ',
                                style: GoogleFonts.lato(
                                  fontSize: 14.0,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${event.capacity}',
                                    style: GoogleFonts.lato(
                                      fontSize: 14.0,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: SizeService.separatorHeight),
                            RichText(
                              text: TextSpan(
                                text: 'Space Left: ',
                                style: GoogleFonts.lato(
                                  fontSize: 14.0,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${event.space}',
                                    style: GoogleFonts.lato(
                                      fontSize: 14.0,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: SizeService.separatorHeight),
                            RichText(
                              text: TextSpan(
                                text: 'Start Date and Time: ',
                                style: GoogleFonts.lato(
                                  fontSize: 14.0,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: Intl()
                                        .date("MM/dd/yyyy HH:mm a (EEEE)")
                                        .format(event.startDate.toDate()),
                                    style: GoogleFonts.lato(
                                      fontSize: 14.0,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: SizeService.separatorHeight),
                            RichText(
                              text: TextSpan(
                                text: 'End Date and Time: ',
                                style: GoogleFonts.lato(
                                  fontSize: 14.0,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: Intl()
                                        .date("MM/dd/yyyy HH:mm a (EEEE)")
                                        .format(event.endDate.toDate()),
                                    style: GoogleFonts.lato(
                                      fontSize: 14.0,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: SizeService.separatorHeight),
                            RichText(
                              text: TextSpan(
                                text: 'Address: ',
                                style: GoogleFonts.lato(
                                  fontSize: 14.0,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: event.address!.formattedAddress,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        List<Location> locations =
                                            await locationFromAddress(event
                                                .address!.formattedAddress);
                                        bool? isAvailable =
                                            await MapLauncher.isMapAvailable(
                                                MapType.google);

                                        if (isAvailable!) {
                                          await MapLauncher.showMarker(
                                            mapType: MapType.google,
                                            extraParams: {},
                                            description:
                                                event.address!.formattedAddress,
                                            coords: Coords(
                                                locations.first.latitude,
                                                locations.first.longitude),
                                            title: event.address!.streetName,
                                          );
                                        }
                                      },
                                    style: GoogleFonts.lato(
                                      fontSize: 16.0,
                                      color: ThemeService.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: SizeService.separatorHeight),
                          ],
                        ),

                        //Performers
                        SizedBox(
                          height: SizeService.separatorHeight,
                          child: Divider(
                            thickness: 1,
                            color: Theme.of(context).primaryIconTheme.color,
                          ),
                        ),
                        const SizedBox(height: SizeService.separatorHeight),

                        Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.artstation,
                              size: 16.0,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Performers",
                              style: GoogleFonts.lato(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: SizeService.separatorHeight),
                        SizedBox(
                          height: SizeService(context).height * 0.28,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: event.performers
                                .map((String performerId) => StreamBuilder<
                                        DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("Performer")
                                        .doc(performerId)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                          key: key,
                                        );
                                      }

                                      Performer performer = Performer.fromJson(
                                          snapshot.data!.data());
                                      return GestureDetector(
                                        onTap: () {
                                          NavigationService(context).push(
                                            PerformerDetailUI(
                                                person: person,
                                                performerId: performer.id),
                                          );
                                        },
                                        child: AspectRatio(
                                          aspectRatio: 14 / 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: SizeService
                                                  .innerVerticalPadding,
                                            ),
                                            margin: const EdgeInsets.only(
                                                right: 8.0),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .cardTheme
                                                  .color,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      SizeService.borderRadius),
                                              boxShadow: [
                                                ThemeService.boxShadow(context),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: performer.avatarURL ==
                                                          ""
                                                      ? CircleAvatar(
                                                          radius: 50.0,
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        )
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    SizeService
                                                                        .borderRadius),
                                                            child:
                                                                Image.network(
                                                              performer
                                                                  .avatarURL,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          performer.name,
                                                          style:
                                                              GoogleFonts.lato(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Text(
                                                          performer.bio
                                                              .substring(0, 20),
                                                          style: GoogleFonts.lato(
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic),
                                                        ),
                                                        const SizedBox(
                                                            height: SizeService
                                                                .separatorHeight),
                                                        Text(
                                                          performer.country,
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                        const SizedBox(
                                                            height: SizeService
                                                                .separatorHeight),
                                                        Text(
                                                          performer.email,
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                        const SizedBox(
                                                            height: SizeService
                                                                .separatorHeight),
                                                        Text(
                                                          "Genres",
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                        const SizedBox(
                                                            height: SizeService
                                                                .separatorHeight),
                                                        Wrap(
                                                          spacing: 6.0,
                                                          runSpacing: 6.0,
                                                          children:
                                                              performer.genre
                                                                  .map(
                                                                    (e) => Container(
                                                                        padding: const EdgeInsets.all(6.0),
                                                                        decoration: BoxDecoration(
                                                                          color: ThemeService.isDark(context)
                                                                              ? DarkTheme.chipBackgroundColor
                                                                              : LightTheme.chipBackgroundColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10.0),
                                                                          boxShadow: [
                                                                            ThemeService.boxShadow(context),
                                                                          ],
                                                                        ),
                                                                        child: Text(e)),
                                                                  )
                                                                  .toList(),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }))
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: SizeService.separatorHeight),
                        SizedBox(
                          height: SizeService.separatorHeight,
                          child: Divider(
                            thickness: 1,
                            color: Theme.of(context).primaryIconTheme.color,
                          ),
                        ),
                        const SizedBox(height: SizeService.separatorHeight),

                        //Tickets
                        Text(
                          "Ticket",
                          style: GoogleFonts.lato(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: SizeService.separatorHeight),
                        StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("Session")
                                .doc(person.customerId)
                                .collection("Session")
                                .doc(event.price!.priceId)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  key: key,
                                  child: CircularProgressIndicator(key: key),
                                );
                              } else if (snapshot.data!.exists &&
                                  snapshot.data!["paymentStatus"] == "paid") {
                                Session session =
                                    Session.fronJSON(snapshot.data);

                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      "Please, scan your QR code at the door",
                                      style: GoogleFonts.lato(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w700,
                                        color: ThemeService.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              SizeService.borderRadius),
                                          color: ThemeService.isDark(context)
                                              ? Colors.black
                                              : Colors.white,
                                          boxShadow: [
                                            ThemeService.boxShadow(context),
                                          ]),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: SfBarcodeGenerator(
                                          value: session.priceId!
                                              .split("price_")[1],
                                          textStyle: GoogleFonts.lato(
                                            color: ThemeService.isDark(context)
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          backgroundColor:
                                              ThemeService.isDark(context)
                                                  ? Colors.black
                                                  : Colors.white,
                                          barColor: ThemeService.isDark(context)
                                              ? Colors.white
                                              : Colors.black,
                                          showValue: true,
                                          symbology: QRCode(),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              SizeService.borderRadius),
                                        ),
                                        primary: ThemeService.dangerColor,
                                        onPrimary: Colors.white,
                                      ),
                                      onPressed: () async {
                                        Price.refund(
                                          priceId: event.price!.priceId,
                                          customerId: person.customerId!,
                                          eventId: event.id,
                                          firebaseUserId: person.userId,
                                          paymentIntentId:
                                              session.paymentIntentId!,
                                        );
                                      },
                                      child: const Text("Cancel Ticket"),
                                    ),
                                  ],
                                );
                              } else {
                                return ElevatedButton(
                                  onPressed: () async {
                                    await Price.createPaymentSession(
                                      customerId: person.customerId!,
                                      eventId: event.id,
                                      firebaseUserId: person.userId,
                                      priceId: event.price!.priceId,
                                    ).then((url) async {
                                      await launchUrl(Uri.parse(url!),
                                              mode: LaunchMode
                                                  .externalApplication)
                                          .then((value) {
                                        Navigator.pop(context);
                                      });
                                    });
                                  },
                                  child: Text(
                                      "Buy Tickets \$ ${(event.price!.amount / 100).toStringAsFixed(2)}"),
                                );
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
