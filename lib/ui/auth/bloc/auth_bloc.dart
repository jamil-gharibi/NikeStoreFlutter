import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_flutter_application/common/exception.dart';
import 'package:nike_flutter_application/data/repo/auth_repository.dart';
import 'package:nike_flutter_application/data/repo/cart_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  bool isLoginMode;
  final IAuthRepository authRepository;
  AuthBloc(this.authRepository, {this.isLoginMode = true})
      : super(AuthInitial(isLoginMode)) {
    on<AuthEvent>((event, emit) async {
      try {
        if (event is AuthButtonIsClicked) {
          emit(AuthLoading(isLoginMode));
          if (isLoginMode) {
            await authRepository.login(event.userName, event.password);
            cartRepository.count();
            emit(AuthSuccess(isLoginMode));
          } else {
            await authRepository.sigUp(event.userName, event.password);
            CartRepository.cartItemCountNotifire.value = 0;
            emit(AuthSuccess(isLoginMode));
          }
        } else if (event is AuthModeChangeIsClicked) {
          isLoginMode = !isLoginMode;
          emit(AuthInitial(isLoginMode));
        }
      } catch (e) {
        emit(AuthError(isLoginMode, AppException()));
      }
    });
  }
}
