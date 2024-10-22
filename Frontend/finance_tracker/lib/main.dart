import 'package:finance_tracker/view/pages/login_page.dart';
import 'package:finance_tracker/view/pages/transactions_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 68, 159, 243)),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(),
      home: const LoginPage(),
    );
  }
}
