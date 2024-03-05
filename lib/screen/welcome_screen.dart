import 'package:flutter/material.dart';
import 'package:otp/provider/auth_provider.dart';
import 'package:otp/screen/condition_screen.dart';
import 'package:otp/screen/home_screen.dart';
import 'package:otp/screen/register_screen.dart';

import 'package:otp/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              "assets/alert.png",
              height: 300,
            ),
            const SizedBox(height: 20),
            const Text(
              "Let's get stared",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Never a better time than now to start.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black38,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // customer buttom
            SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomButton(
                onPressed: () async {
                  if (ap.isSignedIn == true) {
                    await ap.getDataFromSP().whenComplete(
                          () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          ),
                        );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  }
                },
                text: "Get started",
              ),
            )
          ]),
        ),
      )),
    );
  }
}
