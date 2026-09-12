import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zone_game_garage/cubits/auth/auth_state.dart';
import 'package:zone_game_garage/models/user.dart';
import 'package:zone_game_garage/repositories/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;

  AuthCubit(this.repository) : super(AuthInitial());

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
}
