import 'package:flutter/material.dart';
import 'package:tunes_lovers/apis/auth_api.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';

class AppDrawer extends StatelessWidget {
  final Person? person;
  const AppDrawer({Key? key, this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      key: key,
      child: Scaffold(
        key: key,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                key: key,
                child: CustomScrollView(
                  key: key,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.dark_mode),
                            title: const Text("Dark Mode"),
                            subtitle: Text(ThemeService.isDark(context)
                                ? "Active"
                                : "Inactive"),
                            trailing: Switch(
                              value: ThemeService.isDark(context),
                              onChanged: (val) {
                                ThemeService.switchTheme(context);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                key: key,
                onTap: () {
                  AuthApi().logout();
                },
                leading: Icon(
                  Icons.logout,
                  key: key,
                ),
                title: Text(
                  "Logout",
                  key: key,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
