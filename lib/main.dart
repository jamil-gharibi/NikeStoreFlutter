import 'package:flutter/material.dart';
import 'package:nike_flutter_application/data/repo/auth_repository.dart';
import 'package:nike_flutter_application/theme.dart';
import 'package:nike_flutter_application/ui/root.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  authRepository.loadAutInfo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const defaultTextStyle = TextStyle(fontFamily: 'Iranian Sans');
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
            textStyle: WidgetStateProperty.all(defaultTextStyle),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
          )),
          inputDecorationTheme: InputDecorationTheme(
              labelStyle: defaultTextStyle,
              floatingLabelStyle: defaultTextStyle.copyWith(
                  color: LightThemeColor.secondaryColor),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.2))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: LightThemeColor.secondaryColor, width: 2))),
          snackBarTheme: const SnackBarThemeData(
              backgroundColor: LightThemeColor.secondaryColor),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  textStyle: WidgetStateProperty.all(defaultTextStyle),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
                  backgroundColor: WidgetStateProperty.all(Colors.blue))),
          buttonTheme: const ButtonThemeData(
            buttonColor: LightThemeColor.secondaryColor,
          ),
          colorScheme: const ColorScheme.light(
              primary: LightThemeColor.primaryColor,
              secondary: LightThemeColor.secondaryColor,
              onSecondary: Colors.white,
              surfaceContainerHighest: Color(0xffF5F5F5)),
          useMaterial3: true,
          textTheme: TextTheme(
            titleMedium: defaultTextStyle,
            bodyMedium: defaultTextStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: LightThemeColor.secondaryTextColor),
            headlineMedium: defaultTextStyle.copyWith(
                fontWeight: FontWeight.w700, fontSize: 18),
            headlineLarge: defaultTextStyle.copyWith(
                fontWeight: FontWeight.w700, fontSize: 20),
          )),
      home: const Directionality(
          textDirection: TextDirection.rtl, child: RootScreen()),
    );
  }
}
