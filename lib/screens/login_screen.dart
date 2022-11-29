import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '';
  String _password = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void trySubmit() async {
    FocusScope.of(context).unfocus();
    _formKey.currentState!.save();
    UserCredential userCredential;
    try {
      if (_isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  key: const ValueKey('Email'),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Email'),
                  onSaved: (newValue) => _email = newValue!,
                  validator: (value) {
                    if (!EmailValidator.validate(value!) || value.isEmpty) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  key: const ValueKey('Password'),
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  onSaved: (newValue) => _password = newValue!,
                  validator: (value) {
                    if (value!.length <= 4 || value.isEmpty) {
                      return 'Please enter minimum 4 character';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                    onPressed: trySubmit,
                    child:
                        _isLogin ? const Text('Login') : const Text('SignUp')),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child:
                        _isLogin ? const Text('SignUp') : const Text('Login'))
              ],
            ),
          )),
    );
  }
}
