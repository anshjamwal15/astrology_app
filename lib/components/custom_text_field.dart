import 'package:astrology_app/constants/app_constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextInputType keyboardType;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final String? value;
  final bool? disabled;

  const CustomTextField({
    super.key,
    required this.keyboardType,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.value = '',
    this.disabled = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscure;
  late String? _value;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
    _value = widget.value ?? '';
    widget.controller.text = _value!;
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
        readOnly: widget.disabled!,
        onChanged: (val) {
          setState(() {
            _value = val;
          });

          final isPhone = RegExp(r'^\+?\d+$').hasMatch(val);

          if (isPhone) {
            String numericValue = val.replaceAll(RegExp(r'[^\d]'), '');

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
          filled: widget.disabled,
          fillColor: widget.disabled! ? Colors.grey : Colors.white,
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
