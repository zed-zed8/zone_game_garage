import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zone_game_garage/cubits/auth/auth_state.dart';
import 'package:zone_game_garage/models/user.dart';
import 'package:zone_game_garage/repositories/auth_repository.dart';
import 'package:zone_game_garage/services/databases/app_database.dart';
import 'package:zone_game_garage/services/databases/user_database.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository = AuthRepository(
    UserDatabase(AppDatabase.instance),
  );

  AuthCubit() : super(AuthInitial());

  Future<void> register(String username, String email, String password) async {
    emit(AuthLoading());

    try {
      final User user = await repository.register(username, email, password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> login(String username, String password) async {
    emit(AuthLoading());

    try {
      final User? user = await repository.login(username, password);
      if (user != null) {
        emit(AuthAuthenticated(user));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> checkAuth() async {
    emit(AuthLoading());

    final User? user = await repository.getCurrentUser();

    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    emit(AuthLogout());

    try {
      await repository.logout();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<User?> getUser() async {
    emit(AuthLoading());

    try {
      return await repository.getCurrentUser();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
    return null;
  }

  Future<String?> getUsername() async {
    emit(AuthLoading());

    try {
      return await repository.getUsername();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
    return null;
  }
}
