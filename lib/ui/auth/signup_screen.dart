import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_management/ui/auth/login_screen.dart';
import 'package:home_management/utils/utility.dart';
import 'package:home_management/widgets/round_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            hintText: 'Enter Your Email',
                            prefixIcon: Icon(Icons.email_outlined)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        controller: passwordController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            hintText: 'Enter Your Password',
                            prefixIcon: Icon(Icons.lock_outline)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Password';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                )),
            RoundButton(
                title: "Sign Up",
                loading: isLoading,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    signUp();
                  }
                }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 18),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void signUp() {
    setState(() {
      isLoading = true;
    });
    _firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString()).then((value) {
      setState(() {
        isLoading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      Utility().toastMessage(error.toString());
    });
  }
}
