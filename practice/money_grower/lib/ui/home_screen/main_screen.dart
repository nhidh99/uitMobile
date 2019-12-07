import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/blocs/user_bloc.dart';
import 'package:loginapp/helper/format_helper.dart';
import 'package:loginapp/models/user_model.dart';
import 'package:loginapp/ui/budget_screen/budget_screen.dart';
import 'package:loginapp/ui/dept_screen/dept_screen.dart';
import 'package:loginapp/ui/statistics_screen/statistics_screen.dart';
import 'package:loginapp/ui/transaction_screen/transaction_screen.dart';
import 'package:async_loader/async_loader.dart';

class SimpleNoteApp extends StatelessWidget {
  final GlobalKey<AsyncLoaderState> asyncLoaderState =
  new GlobalKey<AsyncLoaderState>();

  init() async {
    final userBloc = UserBloc();
    final FirebaseUser curUser = await FirebaseAuth.instance.currentUser();
    await userBloc.getUserByUsername(curUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    final asyncLoader = new AsyncLoader(
      key: asyncLoaderState,
      initState: () async => await init(),
      renderLoad: () => LoadingScreen(),
      renderError: ([error]) => ErrorScreen(),
      renderSuccess: ({data}) => MainScreen(),
    );

    return new MaterialApp(
      title: "Simple Note",
      home: asyncLoader,
      theme: ThemeData(
        // Define the default brightness and colors.
          primaryColor: Colors.green,
          accentColor: Colors.green),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image.asset('images/coins.png', width: 64, height: 64),
            Text("Money Grower"),
          ],
        ),
      ),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image.asset('images/coins.png', width: 64, height: 64),
            Text("Money Grower"),
          ],
        ),
      ),
      body: Center(child: Text("Lỗi kết nối!", style: TextStyle(fontSize: 18))),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int screenIndex = 0;
  final user = UserModel();
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
            Image.asset('images/coins.png', width: 64, height: 64),
            SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 5),
                Text("Tổng cộng:",
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
                SizedBox(height: 2),
                Text(FormatHelper().formatMoney(user.income - user.outgoings, "đ")),
              ],
            )
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
