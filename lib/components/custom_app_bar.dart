import 'package:astrology_app/screens/wallet/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      systemOverlayStyle:
          SystemUiOverlayStyle(statusBarColor: Colors.blue.shade900),
      actions: [
        GestureDetector(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WalletScreen()),
            ),
          },
          child: SizedBox(
            height: size.height * 0.4,
            child: Image.asset(
              color: Colors.black87,
              "assets/images/wallet.png",
              scale: 20,
            ),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
