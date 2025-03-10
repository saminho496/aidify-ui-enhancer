
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aidify/routes.dart';
import 'package:aidify/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const AidifyApp());
}

class AidifyApp extends StatelessWidget {
  const AidifyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aidify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routes: appRoutes,
      initialRoute: '/',
    );
  }
}
