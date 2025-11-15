import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thuexe/viewmodels/login_viewmodel.dart';
import 'package:thuexe/viewmodels/home_viewmodel.dart';
import 'package:thuexe/viewmodels/register_viewmodel.dart';
import 'package:thuexe/views/register_view.dart';
import 'package:thuexe/views/login_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
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

      // Khai báo route nếu cần
      routes: {
        "/register": (_) => RegisterView(),
        "/login": (_) => LoginView(),
        "/register": (_) => RegisterView(),
      },

      home: RegisterView(), // Màn hình chạy đầu tiên
    );
  }
}
