import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAuthInput extends StatefulWidget {
  final bool isPassword;
  final TextEditingController? passwordController;

  const CustomAuthInput({
    super.key,
    required this.isPassword,
    this.passwordController,
  });

  @override
  State<CustomAuthInput> createState() => _CustomAuthInputState();
}

class _CustomAuthInputState extends State<CustomAuthInput> {
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());

  @override
  void dispose() {
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (widget, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.5), // Start slightly above
            end: Offset.zero, // End at normal position
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          )),
          child: widget,
        );
      },
      child: widget.isPassword ? _buildPasswordField() : _buildOtpFields(),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.black),
        ),
        child: TextField(
          key: const Key('loginForm_passwordInput_textField'),
          keyboardType: TextInputType.text,
          controller: widget.passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: "Password",
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (index) => _buildOtpDigitField(index)),
      ),
    );
  }

  Widget _buildOtpDigitField(int index) {
    return Container(
      width: 60, // 25% of password field width (adjustable if needed)
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black),
      ),
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _otpFocusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1, // Only one digit per field
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          counterText: "", // Hide character count
          border: InputBorder.none,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly
        ], // Only digits allowed
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            _otpFocusNodes[index + 1].requestFocus(); // Move to next field
          }
        },
        // onKey: (event) { // TODO: Fix it
        //   if (event.logicalKey == LogicalKeyboardKey.backspace &&
        //       index > 0 &&
        //       _otpControllers[index].text.isEmpty) {
        //     _otpFocusNodes[index - 1].requestFocus(); // Move back on backspace
        // }
        // },
      ),
    );
  }
}
