import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomOtpInput extends StatefulWidget {
  const CustomOtpInput({super.key});

  @override
  State<CustomOtpInput> createState() => _CustomOtpInputState();
}

class _CustomOtpInputState extends State<CustomOtpInput> {
  final int otpLength = 4;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(otpLength, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < otpLength - 1) {
      FocusScope.of(context).nextFocus();
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).previousFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    InputDecoration otpDecoration = const InputDecoration(
      hintText: "0",
      counterText: "",
      contentPadding: EdgeInsets.symmetric(vertical: 12),
      border: InputBorder.none,
    );

    return Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(otpLength, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              height: size.height * 0.07,
              width: size.height * 0.07,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.black),
              ),
              child: TextFormField(
                key: const Key("loginForm_otpInput_textField"),
                controller: _controllers[index],
                onChanged: (val) => _onChanged(val, index),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: otpDecoration,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
