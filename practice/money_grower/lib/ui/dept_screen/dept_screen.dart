import 'package:flutter/material.dart';

class DeptScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DeptScreenState();
}

class DeptScreenState extends State<DeptScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(child: Text("a Screen"));
  }

  @override
  bool get wantKeepAlive => true;
}
