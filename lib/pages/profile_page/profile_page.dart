import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tunes_lovers/admin_panel/admin_panel.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/pages/profile_page/components/profile_button_row.dart';
import 'package:tunes_lovers/pages/profile_page/components/profile_image.dart';
import 'package:tunes_lovers/services/navigation_service/navigation_service.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:tunes_lovers/uis/ticket_purchases_ui/ticket_purchases_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  final Person person;
  final List<String> followedPerformers;

  const ProfilePage(
      {Key? key, required this.person, required this.followedPerformers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(
                  height: SizeService.separatorHeight * 2,
                ),
                ProfileImage(person: person),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "${person.firstName} ${person.lastName}",
                    style: GoogleFonts.lato(
                      fontSize: 20.0,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Text(
                  person.email,
                  style: GoogleFonts.lato(
                    letterSpacing: 1.2,
                    color: ThemeService.isDark(context)
                        ? DarkTheme.secondaryTextColor
                        : LightTheme.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: SizeService.separatorHeight),
                ProfileButtonRow(person: person),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SizeService.innerHorizontalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Settings",
                          style: GoogleFonts.lato(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (person.accessLevel > 2)
                        ListTile(
                          contentPadding: const EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(SizeService.borderRadius),
                          ),
                          onTap: () {
                            NavigationService(context)
                                .push(AdminPanel(person: person));
                          },
                          leading: Card(
                            color: ThemeService.isDark(context)
                                ? Colors.black
                                : Colors.blue,
                            shape: const CircleBorder(),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.admin_panel_settings,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          title: const Text("Admin Panel"),
                          subtitle: Text(
                            "Manage events, performers and many more",
                            style: GoogleFonts.lato(
                              fontSize: 12.0,
                              color: ThemeService.isDark(context)
                                  ? DarkTheme.secondaryTextColor
                                  : LightTheme.secondaryTextColor,
                            ),
                          ),
                        ),
                      if (person.accessLevel > 2)
                        const SizedBox(height: SizeService.separatorHeight),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(SizeService.borderRadius),
                            color: Theme.of(context).cardTheme.color,
                            boxShadow: [
                              ThemeService.boxShadow(context),
                            ]),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(SizeService.borderRadius),
                          ),
                          onTap: () {
                            NavigationService(context).push(
                              TicketPurchasesUI(person: person),
                            );
                          },
                          leading: Card(
                            color: ThemeService.isDark(context)
                                ? Colors.black
                                : Colors.blue,
                            shape: const CircleBorder(),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.subscriptions,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          title: const Text("Ticket Purchases"),
                          subtitle: Text(
                            "Check event tickets purchased history",
                            style: GoogleFonts.lato(
                              fontSize: 12.0,
                              color: ThemeService.isDark(context)
                                  ? DarkTheme.secondaryTextColor
                                  : LightTheme.secondaryTextColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: SizeService.separatorHeight),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(SizeService.borderRadius),
                            color: Theme.of(context).cardTheme.color,
                            boxShadow: [
                              ThemeService.boxShadow(context),
                            ]),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(SizeService.borderRadius),
                          ),
                          onTap: () {},
                          leading: Card(
                            color: ThemeService.isDark(context)
                                ? Colors.black
                                : Colors.blue,
                            shape: const CircleBorder(),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.feedback,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          title: const Text("Feedback"),
                          subtitle: Text(
                            "Suggest us to improve 🙂",
                            style: GoogleFonts.lato(
                              fontSize: 12.0,
                              color: ThemeService.isDark(context)
                                  ? DarkTheme.secondaryTextColor
                                  : LightTheme.secondaryTextColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: SizeService.separatorHeight),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(SizeService.borderRadius),
                            color: Theme.of(context).cardTheme.color,
                            boxShadow: [
                              ThemeService.boxShadow(context),
                            ]),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(SizeService.borderRadius),
                          ),
                          onTap: () {},
                          leading: Card(
                            color: ThemeService.isDark(context)
                                ? Colors.black
                                : Colors.blue,
                            shape: const CircleBorder(),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.privacy_tip,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          title: const Text("Privacy Policy"),
                          subtitle: Text(
                            "Check our terms and privacy policy",
                            style: GoogleFonts.lato(
                              fontSize: 12.0,
                              color: ThemeService.isDark(context)
                                  ? DarkTheme.secondaryTextColor
                                  : LightTheme.secondaryTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
