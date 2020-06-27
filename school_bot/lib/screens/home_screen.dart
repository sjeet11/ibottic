import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_bot/widgets/app_bar.dart';
import 'package:school_bot/widgets/child_widget.dart';
import 'package:school_bot/providers/auth.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final List<ChildData> _studentList =
        Provider.of<Auth>(context).childrenData;

    return Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          elevation: 0,
          // backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Container(
            padding: EdgeInsets.all(8),
            height: deviceSize.height * 0.1,
            child: Image.asset(
              'assets/images/sb_logo.png',
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        drawer: AppDrawer(),
        backgroundColor: Colors.white,
        drawerScrimColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: deviceSize.height * 0.03,
                    horizontal: deviceSize.width * 0.05),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Student Details",
                  style: Theme.of(context).textTheme.subhead.copyWith(
                      height: 1,
                      fontSize: 24,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700),
                ),
              ),
              ..._studentList.map((item) {
                return ChildCard(item);
              }),
            ],
          ),
        ));
  }
}
