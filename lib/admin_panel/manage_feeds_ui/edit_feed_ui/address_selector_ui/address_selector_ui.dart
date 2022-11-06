import 'package:flutter/material.dart';
import 'package:tunes_lovers/admin_panel/manage_events_ui/edit_event_ui/addresses_builder/addresses_bloc.dart';
import 'package:tunes_lovers/admin_panel/manage_events_ui/edit_event_ui/addresses_builder/addresses_builder.dart';
import 'package:tunes_lovers/models/address.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressSelectorUI extends StatelessWidget {
  final Person person;
  final TextEditingController addressController;
  final AddressesBloc addressesBloc;
  final Function(Address?) onTap;
  const AddressSelectorUI({
    Key? key,
    required this.addressesBloc,
    required this.addressController,
    required this.person,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          key: key,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(SizeService.borderRadius),
                topRight: Radius.circular(SizeService.borderRadius)),
            boxShadow: [
              ThemeService.boxShadow(context),
            ],
          ),
          child: TextFormField(
            key: key,
            controller: addressController,
            keyboardType: TextInputType.streetAddress,
            style: GoogleFonts.lato(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8.0),
              border: InputBorder.none,
              labelText: "Address",
              labelStyle: GoogleFonts.lato(
                color: ThemeService.isDark(context)
                    ? DarkTheme.secondaryTextColor
                    : LightTheme.secondaryTextColor,
              ),
              hintText: "Address",
              hintStyle: GoogleFonts.lato(
                color: ThemeService.isDark(context)
                    ? DarkTheme.secondaryTextColor
                    : LightTheme.secondaryTextColor,
              ),
              prefixIcon: Icon(
                Icons.navigation,
                size: 18.0,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              suffixIcon: IconButton(
                iconSize: 18.0,
                color: Theme.of(context).primaryIconTheme.color,
                onPressed: () {
                  addressController.clear();
                  addressesBloc.update("");
                  addressesBloc.clear();
                },
                icon: const Icon(Icons.cancel),
              ),
            ),
            maxLines: 2,
            onChanged: (val) {
              addressesBloc.update(val.trim());
            },
          ),
        ),
        AddressesBuilder(
          onTap: (Address? val) {
            onTap(val!);
            addressController.text = val.formattedAddress;
            addressesBloc.clear();
          },
          addressController: addressController,
          person: person,
          addressesBloc: addressesBloc,
        ),
      ],
    );
  }
}
