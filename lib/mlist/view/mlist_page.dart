import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_repository/shop_repository.dart';
import '../mlist.dart';

class MlistPage extends StatelessWidget {
  const MlistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocProvider(
        lazy: false,
        create: (_) => MlistBloc(repo: ShopRepository()),
        child: const MlistGrid(),
      ),
    );
  }
}