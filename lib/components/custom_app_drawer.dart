import 'package:astrology_app/models/user.dart';
import 'package:astrology_app/services/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;


class CustomAppDrawer extends StatefulWidget {
  const CustomAppDrawer({super.key});

  @override
  State<CustomAppDrawer> createState() => _CustomAppDrawerState();
}

class _CustomAppDrawerState extends State<CustomAppDrawer> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    User? user = UserManager.instance.user;
    return SafeArea(
      child: Drawer(
        clipBehavior: Clip.hardEdge,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset("assets/images/logo.png", scale: 28),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            user?.name.isNotEmpty == true
                                ? user!.name
                                : "New User",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: size.width * 0.01),
                          const Icon(Icons.edit, size: 20)
                        ],
                      ),
                      Text(
                        user?.email.isNotEmpty == true
                            ? user!.email
                            : "Not found",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    _drawerOptions(size, "Home", Icons.home),
                    SizedBox(height: size.height * 0.03),
                    _drawerOptions(
                      size,
                      "Wallet Transactions",
                      Icons.account_balance_wallet,
                    ),
                    SizedBox(height: size.height * 0.03),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const badges.Badge(
                          badgeContent: Text('3', style: TextStyle(color: Colors.white)),
                          showBadge: false,
                          child: Icon(Icons.email, color: Colors.black54, size: 25)
                        ),
                        SizedBox(width: size.width * 0.03),
                        const Text(
                          "Inbox",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.03),
                    _drawerOptions(size, "Order History", Icons.history),
                    SizedBox(height: size.height * 0.03),
                    _drawerOptions(size, "Settings", Icons.settings),
                    SizedBox(height: size.height * 0.03),
                    _drawerOptions(size, "Logout", Icons.logout),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _drawerOptions(Size size, String name, IconData icon) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(icon, color: Colors.black54, size: 25),
      SizedBox(width: size.width * 0.03),
      Text(
        name,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    ],
  );
}
