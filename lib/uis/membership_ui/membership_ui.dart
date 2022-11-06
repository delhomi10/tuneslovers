import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/models/stripe_models/subscription.dart';
import 'package:tunes_lovers/services/navigation_service/navigation_service.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:tunes_lovers/uis/membership_ui/launch_portal.dart';
import 'package:tunes_lovers/uis/membership_ui/subscription_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MembershipUI extends StatefulWidget {
  final Person person;
  const MembershipUI({
    Key? key,
    required this.person,
  }) : super(key: key);

  @override
  State<MembershipUI> createState() => _MembershipUIState();
}

class _MembershipUIState extends State<MembershipUI> {
  Future<String?> createPortal() async {
    try {
      Response response = await Client().post(
          (Uri.parse("http://10.0.2.2:8080/customer/portal")),
          body: {"customerId": widget.person.customerId!});
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      return jsonResponse["data"]["url"];
    } catch (e) {
      log("error: $e");
    }
    return null;
  }

  SubscriptionBloc subscriptionBloc = SubscriptionBloc();

  Widget tile(String title, String content) {
    return SizedBox(
      height: SizeService(context).height * 0.07,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: GoogleFonts.lato(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
              color: ThemeService.isDark(context)
                  ? DarkTheme.secondaryTextColor
                  : LightTheme.secondaryTextColor,
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            content,
            style: GoogleFonts.lato(
              fontSize: 18.0,
              fontWeight: FontWeight.w900,
            ),
          )
        ],
      ),
    );
  }

  Widget get verticalSeparator => Container(
        color: LightTheme.secondaryTextColor,
        width: 1.0,
        height: SizeService(context).height * 0.07,
      );

  @override
  Widget build(BuildContext context) {
    subscriptionBloc.update(customerId: widget.person.customerId!);
    return ThemeConsumer(
      key: widget.key,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Membership"),
        ),
        key: widget.key,
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Subscription")
                .doc(widget.person.customerId!)
                .snapshots(),
            initialData: null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    key: widget.key,
                  ),
                );
              }
              if (!snapshot.data!.exists) {
                return Padding(
                  padding: const EdgeInsets.all(SizeService.outerPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await Subscription.createMonthlySubscriptionSession(
                                  customerId: widget.person.customerId!,
                                  firebaseUserId: widget.person.userId)
                              .then((sessionURL) async {
                            await launchUrl(
                              Uri.parse(sessionURL!),
                              mode: LaunchMode.externalApplication,
                              webOnlyWindowName: "Buy Plans",
                              webViewConfiguration: const WebViewConfiguration(
                                enableDomStorage: true,
                                enableJavaScript: true,
                              ),
                            );
                            // NavigationService(context).push(
                            //   LaunchPortal(
                            //       appBarTitle: "Buy Subscription",
                            //       subscriptionBloc: subscriptionBloc,
                            //       person: widget.person,
                            //       sessionURL: sessionURL!),
                            // );
                          });
                        },
                        child: const Text("Get Monthly Subscription"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await Subscription.createYearlySubscriptionSession(
                                  customerId: widget.person.customerId!,
                                  firebaseUserId: widget.person.userId)
                              .then((sessionURL) async {
                            await launchUrl(
                              Uri.parse(sessionURL!),
                              mode: LaunchMode.externalApplication,
                              webOnlyWindowName: "Buy Plans",
                              webViewConfiguration: const WebViewConfiguration(
                                enableDomStorage: true,
                                enableJavaScript: true,
                              ),
                            );
                            // NavigationService(context).push(
                            //   LaunchPortal(
                            //       appBarTitle: "Buy Subscription",
                            //       subscriptionBloc: subscriptionBloc,
                            //       person: widget.person,
                            //       sessionURL: sessionURL!),
                            // );
                          });
                        },
                        child: const Text("Get Yearly Subscription"),
                      ),
                    ],
                  ),
                );
              } else {
                Subscription subscription =
                    Subscription.fromJSON(snapshot.data!);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SizeService.outerHorizontalPadding,
                    vertical: SizeService.outerVerticalPadding,
                  ),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: SizeService(context).height * 0.03,
                      ),
                      Text(
                        "You have bought subscription on ${Intl().date("MMMM dd, yyyy").format(subscription.startAt.toDate())}.\n",
                        style: GoogleFonts.lato(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                          color: ThemeService.primaryColor,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          tile("PRICE", "\$ ${subscription.amount / 100}"),
                          verticalSeparator,
                          tile(
                            "SUBSCRIPTION",
                            subscription.interval.toUpperCase(),
                          ),
                          verticalSeparator,
                          tile(
                            "DAYS LEFT",
                            subscription.endAt
                                .toDate()
                                .difference(subscription.startAt.toDate())
                                .inDays
                                .toString(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: SizeService.separatorHeight * 2,
                      ),
                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     primary: ThemeService.dangerColor,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(15.0),
                      //     ),
                      //   ),
                      //   onPressed: () async {
                      //     showModalBottomSheet(
                      //         isDismissible: false,
                      //         context: context,
                      //         builder: (ctx) {
                      //           return ThemeConsumer(
                      //             child: Column(
                      //               mainAxisSize: MainAxisSize.min,
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 const SizedBox(
                      //                   height: SizeService.separatorHeight * 3,
                      //                 ),
                      //                 Text(
                      //                   "Do you want to cancel your membership?",
                      //                   style: GoogleFonts.lato(
                      //                     fontSize: 16.0,
                      //                   ),
                      //                 ),
                      //                 const SizedBox(
                      //                   height: SizeService.separatorHeight * 2,
                      //                 ),
                      //                 Row(
                      //                   children: [
                      //                     const SizedBox(
                      //                       width: 20,
                      //                     ),
                      //                     Expanded(
                      //                       child: OutlinedButton(
                      //                         onPressed: () {
                      //                           Navigator.of(ctx).pop(false);
                      //                         },
                      //                         child: const Text("No"),
                      //                       ),
                      //                     ),
                      //                     const SizedBox(
                      //                       width: 20,
                      //                     ),
                      //                     Expanded(
                      //                       child: ElevatedButton(
                      //                         style: ElevatedButton.styleFrom(
                      //                           primary:
                      //                               ThemeService.dangerColor,
                      //                         ),
                      //                         onPressed: () async {
                      //                           await Subscription
                      //                                   .cancelSubscription(
                      //                                       subscription.id)
                      //                               .then((val) async {
                      //                             await subscriptionBloc
                      //                                 .update(
                      //                                     widget.person.email)
                      //                                 .then((value) {
                      //                               Navigator.of(ctx).pop(true);
                      //                             });
                      //                           });
                      //                         },
                      //                         child: const Text("Yes"),
                      //                       ),
                      //                     ),
                      //                     const SizedBox(
                      //                       width: 20,
                      //                     ),
                      //                   ],
                      //                 ),
                      //                 const SizedBox(
                      //                   height: SizeService.separatorHeight,
                      //                 ),
                      //               ],
                      //             ),
                      //           );
                      //         });
                      //   },
                      //   child: Text(
                      //     "Manage Subscriptions",
                      //     style: GoogleFonts.lato(
                      //       fontSize: 16.0,
                      //       fontWeight: FontWeight.w700,
                      //     ),
                      //   ),
                      // ),

                      const Divider(
                        thickness: 1,
                      ),
                      ListTile(
                        onTap: () async {
                          await createPortal().then((sessionURL) async {
                            await launchUrl(
                              Uri.parse(sessionURL!),
                              mode: LaunchMode.externalApplication,
                              webOnlyWindowName: "Manage Portal",
                              webViewConfiguration: const WebViewConfiguration(
                                enableDomStorage: true,
                                enableJavaScript: true,
                              ),
                            );
                            // NavigationService(context).push(
                            //   LaunchPortal(
                            //       appBarTitle: "Manage Payments",
                            //       subscriptionBloc: subscriptionBloc,
                            //       person: widget.person,
                            //       sessionURL: sessionURL!),
                            // ),
                          });
                        },
                        leading: const Icon(Icons.payment),
                        title: const Text("Manage Payments and Subscriptions"),
                        trailing: const Icon(Icons.forward),
                      ),
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }
}
