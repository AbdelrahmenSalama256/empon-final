import 'package:embone/features/client/wallet/view/add_funds_screen.dart';
import 'package:embone/features/client/wallet/view/wallet_details_screen.dart';
import 'package:embone/features/client/wallet/view/wallet_summary_screen.dart';
import 'package:flutter/material.dart';

class WalletScreens extends StatelessWidget {
  const WalletScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wallet Options")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WalletDetailsScreen()),
                );
              },
              child: const Text("Go to Wallet Details"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WalletSummaryScreen()),
                );
              },
              child: const Text("Go to Wallet Summary"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddFundsScreen()),
                );
              },
              child: const Text("Go to Add Funds"),
            ),
          ],
        ),
      ),
    );
  }
}
