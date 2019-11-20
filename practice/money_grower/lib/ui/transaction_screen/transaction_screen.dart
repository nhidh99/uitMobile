import 'package:flutter/material.dart';
import 'package:money_grower/ui/transaction_screen/transacton_board.dart';

class TransactionScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: TransactionBoard(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
