import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withOpacity(1),
                  Theme.of(context).primaryColor.withOpacity(0.8),
                  Theme.of(context).primaryColor.withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 0.3, 1],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Container(
                  width: deviceSize.width * 0.7,
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: Image.asset(
                    'assets/images/sb_logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              CircularProgressIndicator(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Powered By  "),
                  Image.asset(
                    "assets/images/ibottic_logo.png",
                    width: deviceSize.width * 0.25,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
