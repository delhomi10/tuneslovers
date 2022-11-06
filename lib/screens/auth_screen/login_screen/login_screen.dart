import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:tunes_lovers/apis/auth_api.dart';
import 'package:tunes_lovers/app_drawer/app_drawer.dart';
import 'package:tunes_lovers/custom_widgets/error_dialog/error_dialog.dart';
import 'package:tunes_lovers/screens/auth_screen/forget_password_screen/forget_password_screen.dart';
import 'package:tunes_lovers/screens/auth_screen/form_type_bloc.dart';
import 'package:tunes_lovers/services/navigation_service/navigation_service.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';

class LoginScreen extends StatefulWidget {
  final FormTypeBloc formTypeBloc;
  const LoginScreen({Key? key, required this.formTypeBloc}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AuthApi authApi = AuthApi();

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      key: widget.key,
      child: Scaffold(
        drawer: AppDrawer(
          key: widget.key,
        ),
        key: widget.key,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeService.outerHorizontalPadding,
                    vertical: SizeService(context).height * 0.075,
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/logo_h.png",
                        height: 50,
                      ),
                      const SizedBox(height: SizeService.separatorHeight),
                      Text(
                        "Real Tunes with real People",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lobster(
                          fontSize: 18.0,
                          color: ThemeService.isDark(context)
                              ? DarkTheme.secondaryTextColor
                              : const Color(0xffC00938).withOpacity(0.75),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SizeService.innerHorizontalPadding,
                  ),
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(SizeService.innerPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Sign In",
                            key: widget.key,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 24.0,
                              color: ThemeService.isDark(context)
                                  ? DarkTheme.secondaryTextColor
                                  : const Color(0xff2F1A54),
                            ),
                          ),
                          const SizedBox(
                              height: SizeService.separatorHeight * 4),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardTheme.color,
                              borderRadius: BorderRadius.circular(
                                  SizeService.borderRadius),
                              boxShadow: [
                                ThemeService.boxShadow(context),
                              ],
                            ),
                            child: TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: GoogleFonts.lato(
                                color: ThemeService.isDark(context)
                                    ? DarkTheme.mainTextColor
                                    : LightTheme.mainTextColor,
                                fontSize: 14.0,
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(12.0),
                                border: InputBorder.none,
                                hintText: "Email Address",
                                hintStyle: GoogleFonts.lato(
                                  fontSize: 14.0,
                                  color: ThemeService.isDark(context)
                                      ? DarkTheme.secondaryTextColor
                                      : LightTheme.secondaryTextColor,
                                ),
                              ),
                              validator: ValidationBuilder(
                                      requiredMessage: "Invalid Email Address")
                                  .email()
                                  .build(),
                            ),
                          ),
                          const SizedBox(height: SizeService.separatorHeight),
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardTheme.color,
                              borderRadius: BorderRadius.circular(
                                  SizeService.borderRadius),
                              boxShadow: [
                                ThemeService.boxShadow(context),
                              ],
                            ),
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              style: GoogleFonts.lato(
                                color: ThemeService.isDark(context)
                                    ? DarkTheme.mainTextColor
                                    : LightTheme.mainTextColor,
                                fontSize: 14.0,
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(12.0),
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: GoogleFonts.lato(
                                  fontSize: 14.0,
                                  color: ThemeService.isDark(context)
                                      ? DarkTheme.secondaryTextColor
                                      : LightTheme.secondaryTextColor,
                                ),
                              ),
                              validator: ValidationBuilder()
                                  .maxLength(20)
                                  .minLength(6)
                                  .build(),
                            ),
                          ),
                          const SizedBox(
                            height: SizeService.separatorHeight * 2,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                await authApi
                                    .login(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                )
                                    .catchError((error) {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return ErrorDialog(
                                        message: error,
                                      );
                                    },
                                  );
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  SizeService.borderRadius,
                                ),
                              ),
                            ),
                            child: Text(
                              "Login",
                              key: widget.key,
                              style: GoogleFonts.lato(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: SizeService.separatorHeight),
                          TextButton(
                            onPressed: () {
                              NavigationService(context).push(
                                ForgetPasswordScreen(
                                    formTypeBloc: widget.formTypeBloc),
                              );
                            },
                            child: const Text("Forget Password?",
                                style: TextStyle(
                                  color: Color(0xff2F1A54),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Need an account?",
                      key: widget.key,
                      style: GoogleFonts.lato(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: ThemeService.isDark(context)
                            ? DarkTheme.secondaryTextColor
                            : LightTheme.secondaryTextColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.formTypeBloc.update(FormType.register);
                      },
                      child: Text(
                        "Sign Up",
                        key: widget.key,
                        style: GoogleFonts.lato(
                          fontSize: 16.0,
                          color: ThemeService.isDark(context)
                              ? DarkTheme.secondaryTextColor
                              : const Color(0xffC00938),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
