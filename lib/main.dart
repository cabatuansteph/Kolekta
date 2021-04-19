import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kolekta/models/userModel.dart';
import 'package:kolekta/pages/collector.dart';
import 'package:kolekta/pages/home.dart';
import 'package:kolekta/pages/schedule.dart';
import 'package:kolekta/pages/userType.dart';
import 'package:kolekta/services/authentication.dart';
import 'package:kolekta/user/login.dart';
import 'package:kolekta/user/signup.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ListenableProvider<UserData>(create: (_) => UserData()),
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/login",
        routes: {
          "/login": (_) => LoginUser(),
          "/register": (_) => RegisterUser(),
          "/home": (_) => Home(),
          "/userType": (_) => UserType(),
          "/collector": (_) => Collector(),
          "/schedule": (_) => Schedule(date: "", garbageType: ""),
        },
      ),
    ),
  );
}
