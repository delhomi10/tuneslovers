import 'package:flutter/material.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/pages/profile_page/edit_profile_ui/edit_profile_ui.dart';
import 'package:tunes_lovers/services/navigation_service/navigation_service.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:tunes_lovers/uis/membership_ui/membership_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileButtonRow extends StatelessWidget {
  final Person person;
  const ProfileButtonRow({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(SizeService.innerPadding),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Theme.of(context).cardTheme.color!,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeService.borderRadius),
                  side: BorderSide(
                    width: 0.5,
                    color: ThemeService.isDark(context)
                        ? DarkTheme.secondaryIconColor
                        : LightTheme.secondaryIconColor,
                  ),
                ),
              ),
              onPressed: () {
                NavigationService(context).push(
                  EditProfileUI(person: person),
                );
              },
              child: Text(
                "Edit Profile",
                style: GoogleFonts.lato(
                    color: ThemeService.isDark(context)
                        ? DarkTheme.mainTextColor
                        : LightTheme.primaryColor),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeService.borderRadius),
                ),
              ),
              onPressed: () {
                NavigationService(context).push(MembershipUI(person: person));
              },
              child: const Text("Membership"),
            ),
          ),
        ],
      ),
    );
  }
}
