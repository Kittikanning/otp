import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:otp/language_select.dart';

import 'package:otp/provider/auth_provider.dart';
import 'package:otp/screen/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:
            LanguageSelectionScreen(), // แก้ไขตรงนี้เป็น LanguageSelectionScreen
        title: "FlutterPhoneAuth",
      ),
    );
  }
}
