import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machinetest/application/features/productMangement/Product_bloc/add_product_bloc.dart';
import 'package:machinetest/application/features/productMangement/views/HomePage/addProduct.dart';
import 'package:machinetest/application/features/productMangement/views/HomePage/home_view.dart';
import 'package:machinetest/application/features/productMangement/views/Login/login_view.dart';
import 'package:machinetest/application/features/productMangement/views/Register/user_register.dart';
import 'package:machinetest/application/features/productMangement/views/SplashScreen/splashscreen.dart';
import 'package:machinetest/application/features/productMangement/views/mpinScreen/mpinScreen.dart';

import 'package:machinetest/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddProductBloc>(
        create: (context) => AddProductBloc(), // Instantiate ProductBloc here
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            textTheme: const TextTheme(
                displayLarge: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26),
                bodySmall: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => SplashPageWrapper(),
            '/mpin': (context) => mPinScreen(),
            '/login': (context) => LoginViewWrapper(),
            '/register': (context) => RegisterPageWrapper(),
            '/home': (context) => HomeNavigationPage(),
            '/homepage': (context) => AddProductViewWrapper(),
          },
        ));
  }
}
