import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart'; 
import 'screens/ana_sayfa.dart';
import './themes/theme_1.dart';
import 'providers/tarih_provider.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBxsrIbP7KrU7MNc2sFHE6UE6vwdfzR9F4",
      authDomain: "samx-e034f.firebaseapp.com",
      databaseURL: "https://samx-e034f-default-rtdb.europe-west1.firebasedatabase.app",
      projectId: "samx-e034f",  
      storageBucket: "samx-e034f.appspot.com",
      messagingSenderId: "609822869170",
      appId: "1:609822869170:web:538bd24ca61f880fe9abab",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TarihProvider()), 
      ],
      child: MaterialApp(
        title: 'Hava İstasyonu',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        supportedLocales: const [Locale('tr')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const AnaSayfa(),
      ),
    );
  }
}
