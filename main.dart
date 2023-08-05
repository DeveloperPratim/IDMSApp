import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'AppLogin/splash_screen.dart';
import 'AppSettings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              textTheme: GoogleFonts.robotoTextTheme().copyWith(
                headline1: TextStyle(fontSize: 24),
                headline2: TextStyle(fontSize: 20),
                headline3: TextStyle(fontSize: 16),
                headline4: TextStyle(fontSize: 14),
                headline5: TextStyle(fontSize: 12),
                headline6: TextStyle(fontSize: 10),
                subtitle1: TextStyle(fontSize: 8),
                subtitle2: TextStyle(fontSize: 8),
                bodyText1: TextStyle(fontSize: 8),
                bodyText2: TextStyle(fontSize: 8),
                button: TextStyle(fontSize: 10),
                caption: TextStyle(fontSize: 8),
                overline: TextStyle(fontSize: 8),
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              textTheme: GoogleFonts.robotoTextTheme().copyWith(
                headline1: TextStyle(fontSize: 24),
                headline2: TextStyle(fontSize: 20),
                headline3: TextStyle(fontSize: 16),
                headline4: TextStyle(fontSize: 14),
                headline5: TextStyle(fontSize: 12),
                headline6: TextStyle(fontSize: 10),
                subtitle1: TextStyle(fontSize: 8),
                subtitle2: TextStyle(fontSize: 8),
                bodyText1: TextStyle(fontSize: 8 ),
               
                bodyText2: TextStyle(fontSize: 8),
                button: TextStyle(fontSize: 10),
                caption: TextStyle(fontSize: 8),
                overline: TextStyle(fontSize: 8),
              ),
            ),
            themeMode: settingsProvider.isDarkModeEnabled
                ? ThemeMode.dark
                : ThemeMode.light,
            home: Splash(),
            routes: {
              '/settings': (_) => SettingsPage(),
            },
          );
        },
      ),
    );
  }
}

class SettingsProvider with ChangeNotifier {
  bool _isDarkModeEnabled = false;

  bool get isDarkModeEnabled => _isDarkModeEnabled;

  void toggleDarkMode() {
    _isDarkModeEnabled = !_isDarkModeEnabled;
    notifyListeners();
  }
}
