import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_grower/ui/budget_screen/budget_screen.dart';
import 'package:money_grower/ui/dept_screen/dept_screen.dart';
import 'package:money_grower/ui/statistics_screen/statistics_screen.dart';
import 'package:money_grower/ui/transaction_screen/transaction_screen.dart';

void main() => runApp(SimpleNoteApp());

class SimpleNoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Simple Note",
      home: new NoteScreen(),
      theme: ThemeData(
          // Define the default brightness and colors.
          primaryColor: Colors.green,
          accentColor: Colors.green),
    );
  }
}

class NoteScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NoteScreenState();
}

class NoteScreenState extends State<NoteScreen> {
  int screenIndex = 0;
  final List<Widget> screenList = [
    TransactionScreen(),
    DeptScreen(),
    StatisticsScreen(),
    BudgetScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image.asset('assets/coins.png', width: 64, height: 64),
            Text("Money Grower"),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {},
            child: Icon(Icons.settings),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: screenList[screenIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: screenIndex,
        onTap: (newIndex) => setState(() => screenIndex = newIndex),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet, color: Colors.green),
            title: Text('Giao dịch', style: TextStyle(color: Colors.green)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on, color: Colors.green),
            title: Text('Vay mượn', style: TextStyle(color: Colors.green)),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart, color: Colors.green),
              title: Text('Thống kê', style: TextStyle(color: Colors.green))),
          BottomNavigationBarItem(
              icon: Icon(Icons.collections_bookmark, color: Colors.green),
              title: Text('Ngân sách', style: TextStyle(color: Colors.green)))
        ],
      ),
    );
  }
}
