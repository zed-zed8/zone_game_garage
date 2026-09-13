import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zone_game_garage/cubits/auth/auth_cubit.dart';
import 'package:zone_game_garage/cubits/auth/auth_state.dart';
import 'package:zone_game_garage/helpers/datetime_helpers.dart';
import 'package:zone_game_garage/models/user.dart';
import 'package:zone_game_garage/screens/auth/login_screen.dart';

import 'package:zone_game_garage/screens/dashboard_screen.dart';
import 'package:zone_game_garage/services/shared_preferences/auth_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final Future<bool> isLogin;

  @override
  void initState() {
    super.initState();
    isLogin = AuthStorage.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (newcontext, state) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
              ),
              width: 500,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: isLogin,
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (asyncSnapshot.hasError) {
                      return Center(
                        child: Text('ERROR: ${asyncSnapshot.error}'),
                      );
                    }
                    if (!asyncSnapshot.hasData) {
                      return const Center(child: Text('No profile found'));
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (asyncSnapshot.data!) ...[
                          Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .fontSize,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          ProfileBody(authCubit: newcontext.read<AuthCubit>()),
                          SizedBox(height: 10.0),
                          LogoutButton(authCubit: newcontext.read<AuthCubit>()),
                        ] else ...[
                          Text(
                            'You are not logged in',
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .fontSize,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          LoginButton(),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProfileBody extends StatefulWidget {
  ProfileBody({super.key, required this.authCubit});
  final AuthCubit authCubit;

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  late Future<Map<String, Object?>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _fetchUserData();
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    User? user = await widget.authCubit.getUser();
    if (user == null) {
      return {};
    }
    return user.map();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, Object?>>(
      future: _userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('ERROR: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No profile found'));
        }

        final Map<String, Object?> user = snapshot.data!;

        return ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('Username: ${user['username']}'),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('Email: ${user['email']}'),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'Created At: ${DateTime.parse(user['created_at'].toString()).readableFormat()}',
              ),
            ),
          ],
        );
      },
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key, required this.authCubit});
  final AuthCubit authCubit;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () async {
        await authCubit.logout();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const DashboardScreen(),
            ),
            (Route<dynamic> route) =>
                false, // This condition removes all previous routes
          );
        }
      },
      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red)),
      child: Text('Logout', style: TextStyle(color: Colors.white)),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(screen: LoginScreen()),
          ),
          (Route<dynamic> route) => false,
        );
      },
      child: Text('Login'),
    );
  }
}
