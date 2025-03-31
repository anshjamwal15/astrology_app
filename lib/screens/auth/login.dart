import 'dart:developer';

import 'package:astrology_app/blocs/auth/auth_event.dart';
import 'package:astrology_app/blocs/auth/auth_state.dart';
import 'package:astrology_app/blocs/index.dart';
import 'package:astrology_app/components/index.dart';
import 'package:astrology_app/constants/index.dart';
import 'package:astrology_app/screens/auth/email_verification.dart';
import 'package:astrology_app/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailOrPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailOrPhoneController.dispose();
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
        } else if (state is CheckEmailVerification) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EmailVerification(),
            ),
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
                    padding: const EdgeInsets.symmetric(
                      vertical: 40,
                    ),
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
                                'loginForm_emailInput_textField',
                              ),
                              controller: _emailOrPhoneController,
                              keyboardType: TextInputType.text,
                              hintText: "Email or Phone",
                              obscureText: false,
                            ),
                          ),
                        ),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              transitionBuilder: (widget, animation) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, -0.5),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOut,
                                    ),
                                  ),
                                  child: widget,
                                );
                              },
                              child: state is ShowOtpField
                                  ? passwordOrOtpField(
                                      size,
                                      _passwordController,
                                      false,
                                    )
                                  : state is ShowPasswordField
                                      ? passwordOrOtpField(
                                          size,
                                          _passwordController,
                                          true,
                                        )
                                      : const SizedBox(),
                            );
                          },
                        ),
                        SizedBox(height: size.height * 0.02),
                        Padding(
                          padding: const EdgeInsets.only(right: 50, left: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .end, // change to spaceBetween for forgot pass
                            children: [
                              Text(
                                "Sign in using OTP",
                                style: GoogleFonts.acme(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: size.height * 0.018,
                                ),
                              ),
                              // Text(
                              //   "Forgot Password ?",
                              //   style: GoogleFonts.acme(
                              //     color: Colors.black,
                              //     decoration: TextDecoration.underline,
                              //     fontWeight: FontWeight.w500,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is OtpSent &&
                                state is CheckEmailVerification) {
                              return CustomButton(
                                onPressed: () {
                                  if (!isDialogOpen()) {
                                    showLoader(context);
                                    // context
                                    //     .read<AuthBloc>()
                                    //     .add(SignUpRequested(
                                    //       _emailOrPhoneController.text,
                                    //       _passwordController.text,
                                    //     )); TODO: This function won't work
                                  }
                                },
                                buttonName: "LOGIN",
                              );
                            } else {
                              return CustomButton(
                                onPressed: () {
                                  if (!isDialogOpen()) {
                                    // showLoader(context);
                                    try {
                                      if (isEmailOrPhone(
                                          _emailOrPhoneController.text)) {
                                        // email
                                        context
                                            .read<AuthBloc>()
                                            .add(PasswordFieldRequested());
                                      } else {
                                        // phone
                                        context
                                            .read<AuthBloc>()
                                            .add(OtpFieldRequested());
                                      }
                                    } catch (e) {
                                      showAuthErrorDialog(
                                        context,
                                        "Please enter a valid email or phone number",
                                      );
                                    }
                                  }
                                },
                                buttonName: "NEXT",
                              );
                            }
                          },
                        ),
                        SizedBox(height: size.height * 0.01),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 50,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                  color: Colors.white70,
                                  fontSize: 20,
                                ),
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
                        SizedBox(height: size.height * 0.01),
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
                            onPressed: () async {
                              if (!isDialogOpen()) {
                                showLoader(context);
                                context
                                    .read<AuthBloc>()
                                    .add(GoogleSignInRequested());
                              }
                            },
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

  showAuthErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(
            message,
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: AppConstants.bgColor,
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('CLOSE', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextInputType keyboardType;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  const _CustomTextField({
    super.key,
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
        hintStyle: const TextStyle(color: Colors.grey),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
    );
  }
}

Widget passwordOrOtpField(
    Size size, TextEditingController controller, bool isPass) {
  return Column(
    key: const Key('loginForm_passwordInput_textField'),
    children: [
      SizedBox(height: size.height * 0.02),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.black),
          ),
          child: isPass
              ? _CustomTextField(
                  key: const Key('loginForm_passwordInput_textField'),
                  keyboardType: TextInputType.text,
                  controller: controller,
                  hintText: "Password",
                  obscureText: true,
                )
              : _CustomTextField(
                  key: const Key('loginForm_otpInput_textField'),
                  keyboardType: TextInputType.number,
                  controller: controller,
                  hintText: "One Time Password",
                  obscureText: false,
                ),
        ),
      ),
    ],
  );
}
