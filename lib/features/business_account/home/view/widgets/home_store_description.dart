import 'package:flutter/material.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/store_desc.dart';

class HomeStoreDescription extends StatelessWidget {
  final String description ;
  final String name;
  const HomeStoreDescription({super.key, required this.description, required this.name});

  @override
  Widget build(BuildContext context) {
    return StoreDescription(description:description ,name: name);
  }
}
