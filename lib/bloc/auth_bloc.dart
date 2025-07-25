import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtxt_blog/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthCheckStatus>(_onCheckStatus);
  }

  AuthService get authService => _authService;

  Future<void> _onLogin(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authService.login(event.email, event.password);
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onRegister(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authService.register(event.username, event.email, event.password);
      emit(AuthUnauthenticated()); // Show login screen
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authService.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    final token = await _authService.getAccessToken();
    final refresh = await _authService.getRefreshToken();

    if (token != null && !Jwt.isExpired(token)) {
      emit(AuthAuthenticated());
    } else if (refresh != null) {
      try {
        await _authService.refreshAccessToken();
        emit(AuthAuthenticated());
      } catch (e) {
        await _authService.logout();
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }
}
