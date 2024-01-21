import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps/business_logic/phone_auth/phone_auth_cubit.dart';
import 'package:maps/presintation/Screens/Login.dart';
import 'package:maps/presintation/Screens/MapSceen.dart';
import 'package:maps/presintation/Screens/Otp_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Constant/Strings.dart';

class AppRouter {
  PhoneAuthCubit? phoneAuthCubit;

  AppRouter() {
    phoneAuthCubit = PhoneAuthCubit();
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mapScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
            child: MapScreen(),
          ),
        );

      case loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
            child: Login(),
          ),
        );
      case otpScreen:
        final phoneNumber = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => BlocProvider<PhoneAuthCubit>.value(
                  value: phoneAuthCubit!,
                  child: Otp_screen(phoneNumber: phoneNumber),
                ));
    }
  }
}
