import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loginapp/Pages/welcome.dart';
import 'package:loginapp/ui/add_transaction_screen/add_transaction_screen.dart';
import 'package:loginapp/ui/budget_screen/budget_screen.dart';
import 'package:loginapp/ui/custom/Constants.dart';
import 'package:loginapp/ui/dept_screen/dept_screen.dart';
import 'package:loginapp/ui/statistics_screen/statistics_screen.dart';
import 'package:loginapp/ui/transaction_screen/transaction_screen.dart';

class NoteScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NoteScreenState();
}

class NoteScreenState extends State<NoteScreen> {
  int screenIndex = 0;
  final googleSignIn = new GoogleSignIn();
  final auth = FirebaseAuth.instance;

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
            Text("Money Grower"),
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context){
              return Constants.choices.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: screenList[screenIndex],
      floatingActionButton: FloatingActionButton(
        heroTag: "addTransaction",
        elevation: 4.0,
        child: new Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTransactionPage(), fullscreenDialog: true));
        },
        tooltip: 'Increment',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
  void choiceAction(String choice){
    if(choice == Constants.Settings){
      print('Settings');
    }else if(choice == Constants.Subscribe){
      print('Subscribe');
    }else if(choice == Constants.SignOut){
      signOut();
    }
  }
  void signOut()async{
    var gg = auth.currentUser;

    if (gg != null) {
      await googleSignIn.signOut();
      print("User Sign Out");
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage(), fullscreenDialog: true));
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) => new AlertDialog(
          title: new Text("Chào mừng"),
          content: new Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Nhập vào tên người dùng"
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Nhập vào só tiền hiện có"
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        FlatButton(
                          child: Text("Xác nhận"),
                          onPressed: (){},
                        ),
                        FlatButton(
                          child: Text("Hủy bỏ"),
                          onPressed: () {},
                        ),
                      ],
                    )
                  )
                ],
              )
          )
        ),
      );
    });
  }
}
