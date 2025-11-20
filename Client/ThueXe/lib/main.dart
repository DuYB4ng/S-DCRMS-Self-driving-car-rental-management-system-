import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thuexe/viewmodels/car_list_viewmodel.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/register_viewmodel.dart';
import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/orders_viewmodel.dart';
import 'viewmodels/order_detail_viewmodel.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/home/home_navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => OrdersViewModel()),
        ChangeNotifierProvider(create: (_) => OrderDetailViewModel()),
        ChangeNotifierProvider(create: (_) => CarListViewModel()),

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: "/login",

      routes: {
        "/login": (_) => LoginView(),
        "/register": (_) => RegisterView(),
        "/home": (_) => HomeNavigation(),
      },
    );
  }
}
