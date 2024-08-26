import 'package:astrology_app/blocs/auth/auth_event.dart';
import 'package:astrology_app/blocs/auth/auth_state.dart';
import 'package:astrology_app/blocs/index.dart';
import 'package:astrology_app/components/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login Successful')),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Image.asset("assets/images/logo.png", scale: 6),
                ),
                Container(
                  color: Colors.blue.shade900,
                  height: size.height / 2,
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 40, left: 40),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              border: Border.all(color: Colors.black),
                            ),
                            child: _CustomTextField(
                              key: const Key(
                                  'loginForm_passwordInput_textField',),
                              controller: _emailController,
                              keyboardType: TextInputType.text,
                              hintText: "Email",
                              obscureText: false,
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Padding(
                          padding: const EdgeInsets.only(right: 40, left: 40),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              border: Border.all(color: Colors.black),
                            ),
                            child: _CustomTextField(
                              key: const Key(
                                  'loginForm_passwordInput_textField',),
                              keyboardType: TextInputType.text,
                              controller: _passwordController,
                              hintText: "Password",
                              obscureText: true,
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "By signing up, you agree to our ",
                                  style: TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                                TextSpan(
                                  text: "Terms of Use",
                                  style: GoogleFonts.acme(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const TextSpan(
                                  text: " and",
                                  style: TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          "Privacy Policy",
                          style: GoogleFonts.acme(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        CustomButton(onPressed: () {
                          context.read<AuthBloc>().add(
                                SignInRequested(
                                  _emailController.text,
                                  _passwordController.text,
                                ),
                              );
                        }),
                        SizedBox(height: size.height * 0.01),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 60,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: size.width * 0.3,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.white70,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: size.width * 0.015),
                              const Text(
                                "Or",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 20,),
                              ),
                              SizedBox(width: size.width * 0.015),
                              Container(
                                width: size.width * 0.3,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.white70,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                              elevation: 10,
                              shadowColor: Colors.white.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 0.2,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 90,
                                vertical: 10,
                              ),
                            ),
                            onPressed: () => context
                                .read<AuthBloc>()
                                .add(GoogleSignInRequested()),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/google.png",
                                  scale: 20,
                                ),
                                SizedBox(width: size.width * 0.02),
                                Text(
                                  'SIGN UP',
                                  style: GoogleFonts.acme(
                                    fontSize: 20,
                                    color: Colors.black.withOpacity(0.8),
                                    shadows: [
                                      Shadow(
                                        offset: const Offset(0, 1),
                                        blurRadius: 6,
                                        color: Colors.black.withOpacity(0.4),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              top: size.height * 0.38,
              left: size.width * 0.1,
              right: size.width * 0.1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: Colors.black),
                  color: Colors.white,
                ),
                height: 40,
                width: 100,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Center(
                    child: Text(
                      "First chat with Astrologer is FREE!",
                      style: GoogleFonts.acme(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final Key key;
  final TextInputType keyboardType;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  const _CustomTextField({
    required this.key,
    required this.keyboardType,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: key,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      cursorColor: Colors.blue.shade900,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        hintText: hintText,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
    );
  }
}
