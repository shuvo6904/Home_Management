import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_management/ui/auth/signup_screen.dart';
import 'package:home_management/ui/home/home_screen.dart';
import 'package:home_management/utils/utility.dart';
import 'package:home_management/widgets/round_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false, title: const Text('Login')),
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
                  title: "Login",
                  loading: isLoading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      loginUser();
                    }
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 18),
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void loginUser() {
    setState(() {
      isLoading = true;
    });
    _firebaseAuth
        .signInWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
          setState(() {
            isLoading = false;
          });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      Utility().toastMessage(error.toString());
    });
  }
}
