import 'package:astrology_app/blocs/auth/auth_event.dart';
import 'package:astrology_app/blocs/auth/auth_state.dart';
import 'package:astrology_app/blocs/index.dart';
import 'package:astrology_app/components/index.dart';
import 'package:astrology_app/constants/app_constants.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            showFloatingSnackBar(context, 'Login Successful');
          } else if (state is AuthError) {
            showFloatingSnackBar(context, state.error);
          } else if (state is CheckEmailVerification) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EmailVerification(),
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Image.asset("assets/images/logo.png", scale: 6),
                  ),
                  Container(
                    color: Colors.blue.shade900,
                    height: size.height / 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Colors.black),
                              ),
                              child: _CustomTextField(
                                key:
                                    const Key('loginForm_emailInput_textField'),
                                controller: _emailOrPhoneController,
                                keyboardType: TextInputType.text,
                                hintText: "Email or Phone",
                                obscureText: false,
                              ),
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder: (widget, animation) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, -0.5),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOut,
                                )),
                                child: widget,
                              );
                            },
                            child: (state is ShowPasswordField ||
                                    state is ShowOtpField)
                                ? passwordOrOtpField(
                                    size,
                                    _passwordController,
                                    state is ShowPasswordField,
                                  )
                                : const SizedBox(),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (_emailOrPhoneController
                                        .text.isNotEmpty) {
                                      context
                                          .read<AuthBloc>()
                                          .add(OtpFieldRequested());
                                    } else {
                                      showAuthErrorDialog(context,
                                          "Please enter a valid email or phone number");
                                    }
                                  },
                                  child: Text(
                                    "Sign in using OTP",
                                    style: GoogleFonts.acme(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: size.height * 0.018,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          CustomButton(
                            onPressed: () {
                              if (!isDialogOpen()) {
                                if (state is ShowPasswordField ||
                                    state is ShowOtpField ||
                                    state is CheckEmailVerification) {
                                  showLoader(context);
                                  context.read<AuthBloc>().add(SignUpRequested(
                                        _emailOrPhoneController.text,
                                        _passwordController.text,
                                      ));
                                } else {
                                  if (isEmailOrPhone(
                                      _emailOrPhoneController.text)) {
                                    context
                                        .read<AuthBloc>()
                                        .add(PasswordFieldRequested());
                                  } else {
                                    context
                                        .read<AuthBloc>()
                                        .add(OtpFieldRequested());
                                  }
                                }
                              }
                            },
                            buttonName: (state is ShowPasswordField ||
                                    state is ShowOtpField ||
                                    state is CheckEmailVerification)
                                ? "LOGIN"
                                : "NEXT",
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
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
                              onPressed: () {
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
                  ),
                ],
              ),
              Positioned(
                top: size.height * 0.38,
                left: size.width * 0.1,
                right: size.width * 0.1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black),
                    color: Colors.white,
                  ),
                  height: 40,
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
            ],
          );
        },
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
                context.read<AuthBloc>().add(HideFieldRequested());
              },
              child: const Text('CLOSE', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}

class _CustomTextField extends StatefulWidget {
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
  State<_CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<_CustomTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppConstants.primaryColor,
          selectionColor: AppConstants.primaryColorTwo,
          selectionHandleColor: AppConstants.primaryColorThree,
        ),
      ),
      child: TextFormField(
        key: widget.key,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: _obscure,
        onChanged: (value) {
          final isPhone = RegExp(r'^\+?\d+$').hasMatch(value);

          if (isPhone) {
            String numericValue = value.replaceAll(RegExp(r'[^\d]'), '');

            if (numericValue.startsWith('91') && numericValue.length > 10) {
              numericValue = numericValue.substring(2);
            }

            if (widget.controller.text != numericValue) {
              widget.controller.text = numericValue;
              widget.controller.selection = TextSelection.fromPosition(
                TextPosition(offset: numericValue.length),
              );
            }
          }
        },
        onEditingComplete: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTapOutside: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        enableInteractiveSelection: true,
        autofillHints: const [
          AutofillHints.email,
          AutofillHints.telephoneNumberDevice,
        ],
        decoration: InputDecoration(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                    color: AppConstants.primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}

Widget passwordOrOtpField(
    Size size, TextEditingController controller, bool isPass) {
  return Column(
    children: [
      SizedBox(height: size.height * 0.02),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: isPass
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black),
                ),
                child: _CustomTextField(
                  key: const Key('loginForm_passwordInput_textField'),
                  keyboardType: TextInputType.text,
                  controller: controller,
                  hintText: "Password",
                  obscureText: true,
                ),
              )
            : const CustomOtpInput(),
      ),
    ],
  );
}
