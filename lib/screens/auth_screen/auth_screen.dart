import 'package:flutter/material.dart';
import 'package:tunes_lovers/screens/auth_screen/forget_password_screen/forget_password_screen.dart';
import 'package:tunes_lovers/screens/auth_screen/form_type_bloc.dart';
import 'package:tunes_lovers/screens/auth_screen/login_screen/login_screen.dart';
import 'package:tunes_lovers/screens/auth_screen/register_screen/register_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static final FormTypeBloc formTypeBloc = FormTypeBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FormType>(
        stream: formTypeBloc.stream,
        initialData: FormType.login,
        builder: (context, snapshot) {
          FormType formType = snapshot.data!;
          if (formType == FormType.login) {
            return LoginScreen(
              formTypeBloc: formTypeBloc,
              key: key,
            );
          } else if (formType == FormType.register) {
            return RegisterScreen(
              formTypeBloc: formTypeBloc,
              key: key,
            );
          } else {
            return ForgetPasswordScreen(
              formTypeBloc: formTypeBloc,
              key: key,
            );
          }
        });
  }
}
