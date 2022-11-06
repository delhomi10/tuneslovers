import 'package:flutter/material.dart';
import 'package:tunes_lovers/admin_panel/manage_events_ui/edit_event_ui/addresses_builder/addresses_bloc.dart';
import 'package:tunes_lovers/models/address.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressesBuilder extends StatelessWidget {
  final Person person;
  final TextEditingController addressController;
  final AddressesBloc addressesBloc;
  final Function(Address?) onTap;
  const AddressesBuilder({
    Key? key,
    required this.person,
    required this.addressController,
    required this.addressesBloc,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Address>>(
      stream: addressesBloc.stream,
      initialData: const <Address>[],
      builder: (context, snapshot) {
        List<Address> list = snapshot.data!;
        return Container(
          constraints: BoxConstraints(
            maxHeight: SizeService(context).height * 0.25,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(SizeService.borderRadius),
                bottomRight: Radius.circular(SizeService.borderRadius)),
          ),
          child: ListView.builder(
              padding: const EdgeInsets.all(0.0),
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, i) {
                Address address = list[i];
                return ListTile(
                  onTap: () => onTap(address),
                  leading: const Icon(Icons.navigation),
                  title: Text(
                    address.formattedAddress,
                    style: GoogleFonts.lato(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              }),
        );
      },
    );
  }
}
