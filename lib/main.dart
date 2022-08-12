import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:my_shop_app/pages/add_product_page.dart';
import 'package:my_shop_app/pages/home_page.dart';
import 'package:my_shop_app/pages/sign_in_page.dart';
import 'package:my_shop_app/pages/sign_up_page.dart';
import 'package:my_shop_app/services/auth_service.dart';
import 'package:my_shop_app/services/db_service.dart';

import 'firebase_options.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await runZonedGuarded(() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(const MyApp());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  Widget _startPage() {
    return StreamBuilder<User?>(
      stream: AuthService.auth.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          DBService.saveUserId(snapshot.data!.uid);
          return const HomePage();
        } else {
          DBService.removeUserId();
          return const SignInPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _startPage(),
      routes: {
        HomePage.id : (context) => const HomePage(),
        AddProductPage.id : (context) => const AddProductPage(),
        SignInPage.id : (context) => const SignInPage(),
        SignUpPage.id : (context) => const SignUpPage(),
      },
    );
  }
}
