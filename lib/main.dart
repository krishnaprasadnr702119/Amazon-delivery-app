// main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/forgetpassword/screen/bloc/forgetpassword_bloc.dart';
import 'package:task/login/bloc/login_bloc.dart';
import 'package:task/signup/bloc/registration_bloc.dart';
import 'package:task/screens/splashscreen.dart';
import 'package:task/task/task.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<RegistrationBloc>(
            create: (BuildContext context) => RegistrationBloc(),
          ),
          BlocProvider<LoginBloc>(
            create: (BuildContext context) => LoginBloc(),
          ),
          BlocProvider<ForgetPasswordBloc>(
            create: (BuildContext context) => ForgetPasswordBloc(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
          routes: {
            '/TaskPage': (context) => TaskPage(),
          },
        ));
  }
}
