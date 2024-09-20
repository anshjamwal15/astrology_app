import 'package:astrology_app/constants/index.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int availableBalance = 100;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConstants.bgColor,
      appBar: AppBar(
        backgroundColor: AppConstants.bgColor,
        centerTitle: true,
        title: const Text("My Wallet"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: size.width * 0.9,
              height: size.height * 0.12,
              decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Available Balance",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.height * 0.018,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "$availableBalance.00 INR",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.height * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          availableBalance > 0
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Recent Transactions",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: size.height * 0.024,
                          letterSpacing: 0,
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      _paymentContainer(size, false),
                      _paymentContainer(size, true),
                      _paymentContainer(size, false),
                      _paymentContainer(size, true),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: Column(
                    children: [
                      Image.asset("assets/images/money.png", scale: 5),
                      Text(
                        "No balance available",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.height * 0.028,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "All transactions will be shown here",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: size.height * 0.02,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          height: size.height * 0.06,
          width: size.width * 0.02,
          decoration: BoxDecoration(
            color: Colors.black87,
            border: Border.all(),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              "Top up",
              style: TextStyle(
                color: Colors.white,
                fontSize: size.height * 0.025,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _paymentContainer(Size size, bool add) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Colors.black12)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            Image.asset(
              "assets/images/${add ? "add-wallet" : "wallet"}.png",
              scale: 20,
              color: add ? Colors.green : Colors.red,
            ),
            SizedBox(width: size.width * 0.04),
             Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(add ? "Added" : "Paid", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: size.height * 0.018)),
                      Text("March 18, 2023", style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w400, fontSize: size.height * 0.018))
                    ],
                  ),
                  Text("${add ? "+" : "-"} 25.00 INR", style: TextStyle(color: add ? Colors.green.shade400 : Colors.red.shade400, fontWeight: FontWeight.w500, fontSize: size.height * 0.018)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
