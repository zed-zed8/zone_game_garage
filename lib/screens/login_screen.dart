import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zone_game_garage/cubits/auth/auth_cubit.dart';
import 'package:zone_game_garage/cubits/auth/auth_state.dart';

import 'package:zone_game_garage/repositories/auth_repository.dart';
import 'package:zone_game_garage/services/databases/app_database.dart';
import 'package:zone_game_garage/services/databases/user_database.dart';

import 'package:zone_game_garage/screens/dashboard_screen.dart';
import 'package:zone_game_garage/screens/register_screen.dart';

import 'package:zone_game_garage/widgets/link_text.dart';
import 'package:zone_game_garage/widgets/form_input.dart';
import 'package:zone_game_garage/widgets/form_input_password.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formGlobalKey = GlobalKey<FormState>();

  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AuthCubit(AuthRepository(UserDatabase(AppDatabase.instance))),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (newcontext, state) {
          return Center(
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.all(Radius.circular(2.0)),
              ),
              child: Form(
                key: _formGlobalKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // heading
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Login',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),

                    // username
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormInput(
                        label: 'Username',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username can\'t be empty';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _username = value!;
                        },
                      ),
                    ),

                    // password
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormInputPassword(
                        label: 'password',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password can\'t be empty';
                          }
                          if (value.length < 8) {
                            return 'Password must be atleast 8 characters long';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value!;
                        },
                      ),
                    ),

                    // submit button
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilledButton(
                        onPressed: () async {
                          if (_formGlobalKey.currentState!.validate()) {
                            _formGlobalKey.currentState!.save();

                            log('login!!');
                            log(_username);
                            log(_password);

                            // TODO: add login logic

                            // register using cubit
                            newcontext.read<AuthCubit>().login(
                              _username,
                              _password,
                            );

                            // navigate to dashboard
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) => DashboardScreen(),
                              ),
                              (Route<dynamic> route) => false,
                            );

                            _formGlobalKey.currentState!.reset();
                          }
                        },
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19),
                          ),
                        ),
                        child: const Text('Login'),
                      ),
                    ),

                    // register link
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.topRight,
                        child: LinkText(
                          text: 'No account? ',
                          linkText: 'Register Now!',
                          linkWidget: DashboardScreen(screen: RegisterScreen()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
