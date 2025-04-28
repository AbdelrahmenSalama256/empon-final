import 'package:embone/features/client/menu/view/inner_screens/widgets/accounts_bottom_sheet.dart';
import 'package:flutter/material.dart';

class BottomSheetScreen extends StatelessWidget {
  const BottomSheetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showAccountsBottomSheet(context);
          },
          child: null,
        ),
      ),
    );
  }
}
