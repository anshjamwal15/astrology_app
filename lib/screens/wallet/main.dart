import 'package:astrology_app/blocs/index.dart';
import 'package:astrology_app/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:astrology_app/models/transaction.dart' as model;

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
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
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserWalletResponse) {
                return Column(
                  children: [
                    _balanceContainer(size, state.wallet.balance),
                    SizedBox(height: size.height * 0.02),
                    _transactionSection(size, state.wallet.balance, state.transactions)
                  ],
                );
              } else {
                return Column(
                  children: [
                    _balanceContainer(size, 0),
                    SizedBox(height: size.height * 0.02),
                    _transactionSection(size, 0, [])
                  ],
                );
              }
            },
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: GestureDetector(
          onTap: () => showUpcomingSnackBar("Coming Soon"),
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
      ),
    );
  }

  void showUpcomingSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(value), behavior: SnackBarBehavior.floating));
  }
}

Widget _balanceContainer(Size size, int balance) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      width: size.width * 0.9,
      height: size.height * 0.12,
      decoration: BoxDecoration(
          color: Colors.blue.shade900,
          border: Border.all(),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
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
              "$balance.00 INR",
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
  );
}

Widget _paymentContainer(Size size, bool add, int balance) {
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
                    Text(add ? "Added" : "Paid",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: size.height * 0.018)),
                    Text("March 18, 2023",
                        style: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.w400,
                            fontSize: size.height * 0.018))
                  ],
                ),
                Text(
                  "${add ? "+" : "-"} $balance.00 INR",
                  style: TextStyle(
                    color: add ? Colors.green.shade400 : Colors.red.shade400,
                    fontWeight: FontWeight.w500,
                    fontSize: size.height * 0.018,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _transactionSection(Size size, int availableBalance, List<model.Transaction> transactions) {
  return (availableBalance > 0 || transactions.isNotEmpty)
      ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
              SizedBox(
                height: size.width * 0.4,
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final data = transactions[index];
                    return _paymentContainer(size, false, data.amount);
                  },
                ),
              )
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
        );
}
