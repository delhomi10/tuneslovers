import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:tunes_lovers/admin_panel/manage_performers_ui/edit_performer_ui/components/avatar_ui.dart';
import 'package:tunes_lovers/apis/lcoation_api.dart';
import 'package:tunes_lovers/app_drawer/app_drawer.dart';
import 'package:tunes_lovers/models/address.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';

class EditProfileUI extends StatefulWidget {
  final Person person;
  const EditProfileUI({Key? key, required this.person}) : super(key: key);

  @override
  State<EditProfileUI> createState() => _EditProfileUIState();
}

class _EditProfileUIState extends State<EditProfileUI> {
  initializeData() {
    avatarURLController.text = widget.person.avatarURL ?? "";
    firstNameController.text = widget.person.firstName;
    middleNameController.text = widget.person.middleName ?? "";
    lastNameController.text = widget.person.lastName;
    phoneController.text = widget.person.phone;
    addressController.text = widget.person.address!.formattedAddress;
    cityController.text = widget.person.address!.city;
    countyController.text = widget.person.address!.county ?? "";
    stateController.text = widget.person.address!.state;
    countryController.text = widget.person.address!.country;
    postalCodeController.text = widget.person.address!.postalCode;
    dateTime = widget.person.dateOfBirth!.toDate();
  }

  TextEditingController avatarURLController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countyController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();

  DateTime dateTime = DateTime.now();

  onSubmit() async {
    Map<String, dynamic> candidate = await LocationApi().getFormattedAddress(
      "${addressController.text.trim()}, ${cityController.text.trim()}, ${stateController.text.trim()} ${postalCodeController.text.trim()}, ${countryController.text.trim()}",
    );

    FirebaseFirestore.instance
        .collection("Customer")
        .doc(widget.person.userId)
        .update(
          Person(
            address: Address(
              latLng: LatLng(
                candidate["latlng"]["lat"],
                candidate["latlng"]["lng"],
              ),
              formattedAddress: candidate["formatted_address"],
              placeId: candidate["place_id"],
              streetNumber: addressController.text.split(" ")[0].trim(),
              streetName: addressController.text.replaceFirst(
                  addressController.text.split(" ")[0].trim(), ""),
              city: cityController.text.trim(),
              state: stateController.text.trim(),
              country: countryController.text.trim(),
              county: countyController.text.trim(),
              postalCode: postalCodeController.text.trim(),
            ),
            socials: [],
            firstName: firstNameController.text.trim(),
            lastName: lastNameController.text.trim(),
            isVerified: widget.person.isVerified,
            userId: widget.person.userId,
            email: widget.person.email,
            phone: phoneController.text.trim(),
            accessLevel: 1,
            avatarURL: avatarURLController.text.trim(),
            dateOfBirth: Timestamp.fromDate(dateTime),
            middleName: middleNameController.text.trim(),
          ).toJson(),
        )
        .then((value) {
      Navigator.pop(context);
    });
  }

  Address? address;

  Future<void> getCurrentAddress() async {
    LatLng latLng = await LocationApi().getCurrentLocation();
    Address currentAddress = await LocationApi().getAddressFromLatLng(latLng);
    address = currentAddress;
    addressController.text =
        "${currentAddress.streetNumber} ${currentAddress.streetName}";
    cityController.text = currentAddress.city;
    countyController.text = currentAddress.county ?? "";
    stateController.text = currentAddress.state;
    countryController.text = currentAddress.country;
    postalCodeController.text = currentAddress.postalCode;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      key: widget.key,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          endDrawer: AppDrawer(
            key: widget.key,
            person: widget.person,
          ),
          key: widget.key,
          body: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  key: widget.key,
                  slivers: [
                    SliverAppBar(
                      key: widget.key,
                      pinned: true,
                      title: Text(
                        "Edit Profile",
                        key: widget.key,
                      ),
                      leading: BackButton(key: widget.key),
                    ),
                    SliverToBoxAdapter(
                      child: Form(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(SizeService.innerPadding),
                          child: Column(
                            children: [
                              const SizedBox(
                                  height: SizeService.separatorHeight * 2),
                              AvatarUI(
                                userId: widget.person.userId,
                                avatarURLController: avatarURLController,
                              ),
                              const SizedBox(
                                  height: SizeService.separatorHeight * 4),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    key: widget.key,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardTheme.color,
                                      borderRadius: BorderRadius.circular(
                                          SizeService.borderRadius),
                                      boxShadow: [
                                        ThemeService.boxShadow(context),
                                      ],
                                    ),
                                    child: TextFormField(
                                      key: widget.key,
                                      controller: firstNameController,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(8.0),
                                        border: InputBorder.none,
                                        labelText: "First Name",
                                        labelStyle: GoogleFonts.lato(
                                          color: ThemeService.isDark(context)
                                              ? DarkTheme.secondaryTextColor
                                              : LightTheme.secondaryTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                      height: SizeService.separatorHeight),
                                  Container(
                                    key: widget.key,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardTheme.color,
                                      borderRadius: BorderRadius.circular(
                                          SizeService.borderRadius),
                                      boxShadow: [
                                        ThemeService.boxShadow(context),
                                      ],
                                    ),
                                    child: TextFormField(
                                      key: widget.key,
                                      controller: middleNameController,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(8.0),
                                        border: InputBorder.none,
                                        labelText: "Middle Name",
                                        labelStyle: GoogleFonts.lato(
                                          color: ThemeService.isDark(context)
                                              ? DarkTheme.secondaryTextColor
                                              : LightTheme.secondaryTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                      height: SizeService.separatorHeight),
                                  Container(
                                    key: widget.key,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardTheme.color,
                                      borderRadius: BorderRadius.circular(
                                          SizeService.borderRadius),
                                      boxShadow: [
                                        ThemeService.boxShadow(context),
                                      ],
                                    ),
                                    child: TextFormField(
                                      key: widget.key,
                                      controller: lastNameController,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(8.0),
                                        border: InputBorder.none,
                                        labelText: "Last Name",
                                        labelStyle: GoogleFonts.lato(
                                          color: ThemeService.isDark(context)
                                              ? DarkTheme.secondaryTextColor
                                              : LightTheme.secondaryTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                      height: SizeService.separatorHeight),
                                  Container(
                                    key: widget.key,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardTheme.color,
                                      borderRadius: BorderRadius.circular(
                                          SizeService.borderRadius),
                                      boxShadow: [
                                        ThemeService.boxShadow(context),
                                      ],
                                    ),
                                    child: TextFormField(
                                      key: widget.key,
                                      controller: phoneController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(8.0),
                                        border: InputBorder.none,
                                        labelText: "Phone",
                                        labelStyle: GoogleFonts.lato(
                                          color: ThemeService.isDark(context)
                                              ? DarkTheme.secondaryTextColor
                                              : LightTheme.secondaryTextColor,
                                        ),
                                      ),
                                      inputFormatters: [
                                        PhoneInputFormatter(),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                      height: SizeService.separatorHeight),

                                  //Address
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Address",
                                      key: widget.key,
                                      style: GoogleFonts.lato(
                                        color: Theme.of(context)
                                            .primaryIconTheme
                                            .color,
                                      ),
                                    ),
                                  ),

                                  Container(
                                    key: widget.key,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardTheme.color,
                                      borderRadius: BorderRadius.circular(
                                          SizeService.borderRadius),
                                      boxShadow: [
                                        ThemeService.boxShadow(context),
                                      ],
                                    ),
                                    child: TextFormField(
                                      key: widget.key,
                                      controller: addressController,
                                      keyboardType: TextInputType.streetAddress,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(8.0),
                                        border: InputBorder.none,
                                        labelText: "Street",
                                        labelStyle: GoogleFonts.lato(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        hintText: "Address",
                                        hintStyle: GoogleFonts.lato(
                                          color: ThemeService.isDark(context)
                                              ? DarkTheme.secondaryTextColor
                                              : LightTheme.secondaryTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                      height: SizeService.separatorHeight),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 8.0),
                                          key: widget.key,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .cardTheme
                                                .color,
                                            borderRadius: BorderRadius.circular(
                                                SizeService.borderRadius),
                                            boxShadow: [
                                              ThemeService.boxShadow(context),
                                            ],
                                          ),
                                          child: TextFormField(
                                            key: widget.key,
                                            controller: cityController,
                                            keyboardType:
                                                TextInputType.streetAddress,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.all(8.0),
                                              border: InputBorder.none,
                                              labelText: "City",
                                              labelStyle: GoogleFonts.lato(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              hintText: "City",
                                              hintStyle: GoogleFonts.lato(
                                                color:
                                                    ThemeService.isDark(context)
                                                        ? DarkTheme
                                                            .secondaryTextColor
                                                        : LightTheme
                                                            .secondaryTextColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 8.0),
                                          key: widget.key,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .cardTheme
                                                .color,
                                            borderRadius: BorderRadius.circular(
                                                SizeService.borderRadius),
                                            boxShadow: [
                                              ThemeService.boxShadow(context),
                                            ],
                                          ),
                                          child: TextFormField(
                                            key: widget.key,
                                            controller: stateController,
                                            keyboardType:
                                                TextInputType.streetAddress,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.all(8.0),
                                              border: InputBorder.none,
                                              labelText: "State",
                                              labelStyle: GoogleFonts.lato(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              hintText: "State",
                                              hintStyle: GoogleFonts.lato(
                                                color:
                                                    ThemeService.isDark(context)
                                                        ? DarkTheme
                                                            .secondaryTextColor
                                                        : LightTheme
                                                            .secondaryTextColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                      height: SizeService.separatorHeight),
                                  Container(
                                    margin: const EdgeInsets.only(right: 8.0),
                                    key: widget.key,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardTheme.color,
                                      borderRadius: BorderRadius.circular(
                                          SizeService.borderRadius),
                                      boxShadow: [
                                        ThemeService.boxShadow(context),
                                      ],
                                    ),
                                    child: TextFormField(
                                      key: widget.key,
                                      controller: countyController,
                                      keyboardType: TextInputType.streetAddress,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(8.0),
                                        border: InputBorder.none,
                                        labelText: "County (Optional)",
                                        labelStyle: GoogleFonts.lato(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        hintText: "County (Optional)",
                                        hintStyle: GoogleFonts.lato(
                                          color: ThemeService.isDark(context)
                                              ? DarkTheme.secondaryTextColor
                                              : LightTheme.secondaryTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                      height: SizeService.separatorHeight),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 8.0),
                                          key: widget.key,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .cardTheme
                                                .color,
                                            borderRadius: BorderRadius.circular(
                                                SizeService.borderRadius),
                                            boxShadow: [
                                              ThemeService.boxShadow(context),
                                            ],
                                          ),
                                          child: TextFormField(
                                            key: widget.key,
                                            controller: countryController,
                                            keyboardType:
                                                TextInputType.streetAddress,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.all(8.0),
                                              border: InputBorder.none,
                                              labelText: "Country",
                                              labelStyle: GoogleFonts.lato(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              hintText: "Country",
                                              hintStyle: GoogleFonts.lato(
                                                color:
                                                    ThemeService.isDark(context)
                                                        ? DarkTheme
                                                            .secondaryTextColor
                                                        : LightTheme
                                                            .secondaryTextColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 8.0),
                                          key: widget.key,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .cardTheme
                                                .color,
                                            borderRadius: BorderRadius.circular(
                                                SizeService.borderRadius),
                                            boxShadow: [
                                              ThemeService.boxShadow(context),
                                            ],
                                          ),
                                          child: TextFormField(
                                            key: widget.key,
                                            controller: postalCodeController,
                                            keyboardType:
                                                TextInputType.streetAddress,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.all(8.0),
                                              border: InputBorder.none,
                                              labelText: "Postal Code",
                                              labelStyle: GoogleFonts.lato(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              hintText: "Postal Code",
                                              hintStyle: GoogleFonts.lato(
                                                color:
                                                    ThemeService.isDark(context)
                                                        ? DarkTheme
                                                            .secondaryTextColor
                                                        : LightTheme
                                                            .secondaryTextColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                      height: SizeService.separatorHeight),
                                  //Address
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Date of Birth",
                                      key: widget.key,
                                      style: GoogleFonts.lato(
                                        color: Theme.of(context)
                                            .primaryIconTheme
                                            .color,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    key: widget.key,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardTheme.color,
                                      borderRadius: BorderRadius.circular(
                                          SizeService.borderRadius),
                                      boxShadow: [
                                        ThemeService.boxShadow(context),
                                      ],
                                    ),
                                    child: TextFormField(
                                      key: widget.key,
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: Intl()
                                            .date("   MM/dd/yyyy")
                                            .format(dateTime),
                                        hintStyle: GoogleFonts.lato(
                                          color: ThemeService.isDark(context)
                                              ? DarkTheme.secondaryTextColor
                                              : LightTheme.secondaryTextColor,
                                        ),
                                        suffixIcon: Icon(
                                          Icons.calendar_month,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        ),
                                      ),
                                      onTap: () {
                                        showDatePicker(
                                          builder: ((context, child) {
                                            return Theme(
                                              data: ThemeData(
                                                colorScheme: ColorScheme.dark(
                                                  primary: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .color!,
                                                  onPrimary: Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                  surface: Theme.of(context)
                                                      .cardTheme
                                                      .color!,
                                                  onSurface: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .color!,
                                                  onTertiary: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .color!,
                                                  onSecondary: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .color!,
                                                  onPrimaryContainer:
                                                      Theme.of(context)
                                                          .textTheme
                                                          .bodyText1!
                                                          .color!,
                                                ),
                                                textButtonTheme:
                                                    TextButtonThemeData(
                                                  style: TextButton.styleFrom(
                                                    textStyle: GoogleFonts.lato(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1!
                                                          .color!,
                                                    ),
                                                  ),
                                                ),
                                                dialogBackgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                              ),
                                              child: child!,
                                            );
                                          }),
                                          context: context,
                                          initialDate: dateTime,
                                          firstDate: DateTime(1920),
                                          lastDate: DateTime.now(),
                                        ).then((value) {
                                          setState(() {
                                            dateTime = value!;
                                          });
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(SizeService.innerPadding),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              SizeService.borderRadius,
                            ),
                          ),
                          backgroundColor: Theme.of(context).cardTheme.color,
                        ),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.lato(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(SizeService.innerPadding),
                      child: ElevatedButton(
                        onPressed: onSubmit,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              SizeService.borderRadius,
                            ),
                          ),
                        ),
                        child: Text(
                          "Update",
                          style: GoogleFonts.lato(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
