import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_flutter_application/data/repo/auth_repository.dart';
import 'package:nike_flutter_application/ui/auth/bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController userNameControler =
      TextEditingController(text: 'test@gmail.com');
  final TextEditingController passwordNameControler =
      TextEditingController(text: '123456');
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    const onBackground = Colors.white;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Theme(
        data: themeData.copyWith(
          textSelectionTheme: const TextSelectionThemeData(
              cursorColor: onBackground, selectionHandleColor: onBackground),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
                  minimumSize:
                      WidgetStateProperty.all(const Size.fromHeight(56)))),
          colorScheme: themeData.colorScheme.copyWith(onSurface: onBackground),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: const TextStyle(color: onBackground),
            fillColor: onBackground,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: onBackground.withOpacity(0.7), width: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue, width: 2)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: onBackground, width: 1),
            ),
          ),
        ),
        child: Scaffold(
          backgroundColor: themeData.colorScheme.primary,
          body: BlocProvider<AuthBloc>(
            create: (context) {
              final bloc = AuthBloc(authRepository);
              bloc.stream.forEach((state) {
                if (state is AuthSuccess) {
                  Navigator.of(context).pop();
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.exception.message)));
                }
              });
              bloc.add(AuthStarted());

              return bloc;
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (previous, current) {
                    return current is AuthError ||
                        current is AuthInitial ||
                        current is AuthLoading;
                  },
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/img/nike_logo.png',
                          color: onBackground,
                          width: 120,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(state.isLoginMode ? 'خوش آمدید' : 'ثبت نام'),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(state.isLoginMode
                            ? 'لطفا وارد حساب کاربری خود شوید'
                            : 'ایمیل و رمز عبور را وارد نمایید'),
                        const SizedBox(
                          height: 8,
                        ),
                        TextField(
                          style: const TextStyle(color: onBackground),
                          controller: userNameControler,
                          keyboardType: TextInputType.emailAddress,
                          decoration:
                              const InputDecoration(label: Text('آدرس ایمیل')),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        _PasswordTextField(
                          onBackground: onBackground,
                          passwordControler: passwordNameControler,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              BlocProvider.of<AuthBloc>(context).add(
                                  AuthButtonIsClicked(
                                      userName: userNameControler.text,
                                      password: passwordNameControler.text));
                            },
                            child: state is AuthLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                    state.isLoginMode ? 'ورورد' : 'ثبت نام')),
                        const SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<AuthBloc>(context)
                                .add(AuthModeChangeIsClicked());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.isLoginMode
                                    ? 'حساب کاربری ندارید؟'
                                    : 'حساب کاربری دارید؟',
                                style: TextStyle(
                                    color: onBackground.withOpacity(0.7)),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                state.isLoginMode ? 'ثبت نام' : 'ورود',
                                style: TextStyle(
                                    color: themeData.colorScheme.secondary,
                                    decoration: TextDecoration.underline),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  const _PasswordTextField({
    required this.onBackground,
    required this.passwordControler,
  });

  final Color onBackground;
  final TextEditingController passwordControler;
  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool obsecurText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: widget.onBackground),
      controller: widget.passwordControler,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obsecurText,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                obsecurText = !obsecurText;
              });
            },
            icon: Icon(obsecurText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined),
            color: widget.onBackground.withOpacity(0.7),
          ),
          label: const Text('رمز عبور')),
    );
  }
}
