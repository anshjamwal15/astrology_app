import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  const CustomAppBar({super.key, this.actions});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AppBar(
      backgroundColor: Colors.white,
      actions: [
        SizedBox(
          height: size.height * 0.4,
          child: Image.asset(
            color: Colors.black87,
            "assets/images/wallet.png",
            scale: 20,
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
