import 'package:bloc_auth_flow/controllers/forgetPassword/forget_password_cubit.dart';
import 'package:bloc_auth_flow/controllers/home/home_bloc.dart';
import 'package:bloc_auth_flow/controllers/home/home_state.dart';
import 'package:bloc_auth_flow/controllers/login/login_bloc.dart';
import 'package:bloc_auth_flow/controllers/note_create/note_create_cubit.dart';
import 'package:bloc_auth_flow/controllers/register/register_bloc.dart';
import 'package:bloc_auth_flow/controllers/update_user_info/update_user_info_cubit.dart';
import 'package:bloc_auth_flow/injection.dart';
import 'package:bloc_auth_flow/repositories/auth_service.dart';
import 'package:bloc_auth_flow/screens/views/create_post_screen.dart';
import 'package:bloc_auth_flow/screens/views/forget_password_screen.dart';
import 'package:bloc_auth_flow/screens/views/home_screen.dart';
import 'package:bloc_auth_flow/screens/views/login_screen.dart';
import 'package:bloc_auth_flow/screens/views/register_screen.dart';
import 'package:bloc_auth_flow/screens/views/update_user_info_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

abstract class RouteNames {
  static const String home = "/",
      login = "/login",
      register = "/register",
      forgetPassword = "/forgetPassword",
      updateUsername = "/update-username",
      updateEmail = "/update-email",
      updatePassword = "/update-password",
      createNote = "/create-notes";
}

Route? router(RouteSettings settings) {
  String incommingRoute = settings.name ?? "/";

  // bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
  // if (incommingRoute == "/" && !isLoggedIn) {
  //   incommingRoute = "/login";
  // }

  switch (incommingRoute) {
    case RouteNames.home:
      // if (FirebaseAuth.instance.currentUser == null) {
      //   return _loadRoute(
      //       Scaffold(
      //         body: Center(child: Text("Login")),
      //       ),
      //       settings);
      // }

      return _protecctedRoute(
        incommingRoute,
        BlocProvider(
          create: (_) =>
              HomeBloc(HomeInitialState(Injection<AuthService>().currentUser)),
          lazy: false,
          child: const HomeScreen(),
        ),
        settings,
      );
    case RouteNames.createNote:
      return _protecctedRoute(
        RouteNames.createNote,
        BlocProvider(
          create: (_) => NoteCreateCubit(),
          child: const CreatePostScreen(),
        ),
        settings,
      );
    case RouteNames.updateUsername:
      return _protecctedRoute(
        RouteNames.updateUsername,
        BlocProvider(
          create: (_) => UpdateUserInfoCubit(
              Injection<AuthService>().currentUser!, (user, value, _) {
            return user.updateDisplayName(value);
          }, (user, controller) {
            controller.text = user.displayName ?? "";
          }),
          child: UpdateUserInfoScreen(
            title: "Update Username",
            labelText: "Username",
            validator: (v) => v?.isNotEmpty == true
                ? null
                : "Username is "
                    "required",
          ),
        ),
        settings,
      );
    case RouteNames.updateEmail:
      return _protecctedRoute(
        RouteNames.updateEmail,
        BlocProvider(
          create: (_) =>
              UpdateUserInfoCubit(Injection<AuthService>().currentUser!,
                  (user, value, password) async {
            final current = await user.reauthenticateWithCredential(
                EmailAuthProvider.credential(
                    email: user.email!, password: password));
            return current.user!.updateEmail(value);
          }, (user, controller) {
            controller.text = user.email ?? "";
          }),
          child: UpdateUserInfoScreen(
            requiredAuth: true,
            title: "Update Email",
            labelText: "Email",
            validator: (v) => v?.isNotEmpty == true
                ? v!.isEmail == true
                    ? null
                    : "Invalid email"
                : "Email is "
                    "required",
          ),
        ),
        settings,
      );
    case RouteNames.updatePassword:
      return _protecctedRoute(
        RouteNames.updatePassword,
        BlocProvider(
          create: (_) => UpdateUserInfoCubit(
            Injection<AuthService>().currentUser!,
            (user, value, password) async {
              final current = await user.reauthenticateWithCredential(
                  EmailAuthProvider.credential(
                      email: user.email!, password: password));
              return current.user!.updatePassword(value);
            },
            (user, controller) {},
          ),
          child: UpdateUserInfoScreen(
            requiredAuth: true,
            title: "Update Password",
            labelText: "New Password",
            validator: (v) => v?.isNotEmpty == true
                ? v!.isStrongPassword(
                    minLength: 6,
                    checkUpperCase: false,
                    checkSpecailChar: false,
                  )
                : "New Password is "
                    "required",
          ),
        ),
        settings,
      );
    case RouteNames.login:
      return _protecctedRoute(
        incommingRoute,
        BlocProvider(
          create: (_) => LoginBloc(),
          child: const LoginScreen(),
        ),
        settings,
      );
    case RouteNames.register:
      return _protecctedRoute(
        incommingRoute,
        BlocProvider(
          create: (_) => RegisterBloc(),
          child: const RegisterScreen(),
        ),
        settings,
      );
    case RouteNames.forgetPassword:
      return _protecctedRoute(
        incommingRoute,
        BlocProvider(
          create: (_) => ForgetPasswordCubit(),
          child: const ForgetPasswordScreen(),
        ),
        settings,
      );

    default:
      return _loadRoute(
        const Scaffold(
          body: Center(child: Text("NotFound")),
        ),
        settings,
      );
  }
}

List<String> _protecctedRoutes = ["/"];

Route _loadRoute(Widget child, RouteSettings settings) {
  return MaterialPageRoute(builder: (_) => child, settings: settings);
}

Route? _protecctedRoute(String path, Widget child, RouteSettings settings) {
  return _loadRoute(
      //FirebaseAuth.instance.
      Injection<AuthService>()
                      . //injection tone tr direct ma do chin lot
                      currentUser ==
                  null &&
              _protecctedRoutes.contains(path)
          ? BlocProvider(
              create: (_) => LoginBloc(),
              child: const LoginScreen(),
            )
          : child,
      settings);
}
