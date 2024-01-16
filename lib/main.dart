import 'package:bloc_auth_flow/injection.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

import 'routes/router.dart';

final _lightTheme = ThemeData.light();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setup();
  runApp(const BlocAuthFlow());
}

class BlocAuthFlow extends StatelessWidget {
  const BlocAuthFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: StarlightUtils.navigatorKey,
      theme: _lightTheme.copyWith(
        colorScheme: _lightTheme.colorScheme.copyWith(primary: Colors.blue),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          floatingLabelStyle: TextStyle(
            color: Colors.blueAccent.shade100,
          ),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blueAccent.shade100,
            ),
          ),
        ),
        drawerTheme: DrawerThemeData(
            backgroundColor: Colors.white, width: context.width * .7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 1,
        ),
        textButtonTheme: const TextButtonThemeData(
            style: ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(Colors.blue))),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll(Colors.blue),
            foregroundColor: const MaterialStatePropertyAll(Colors.white),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router,
    );
  }
}
