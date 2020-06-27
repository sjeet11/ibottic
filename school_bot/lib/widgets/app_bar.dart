import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:school_bot/providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    void _showErrorDialog(String message) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error!'),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }

    Widget divder = Divider(
      indent: 15,
      endIndent: 15,
      height: 1,
      thickness: 0.5,
      // color: Colors.white,
    );
    Widget text(String data) => Text(
          data,
          style: Theme.of(context).textTheme.title.copyWith(
              fontSize: 18,
              // fontWeight: FontWeight.w400,
              color: Colors.grey[700]),
        );
    Widget icon(IconData data) => Icon(
          data,
          size: 28,
          color: Theme.of(context).primaryColor,
        );
    _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        _showErrorDialog('Could not launch webpage $url');
      }
    }

    return Drawer(
      elevation: 0,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
        child: Container(
          color: Colors.white70,
          child: Column(
            children: <Widget>[
              AppBar(
                  elevation: 0,
                  // title: Container(
                  //     height: deviceSize.height * 0.1,
                  //     child: Image.asset("assets/images/elogo_trans.png")),
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  backgroundColor: Colors.transparent),
              GestureDetector(
                onTap: () {
                  // Navigator.of(context).pushNamed(AccountScreen.routeName);
                },
                child: Card(
                  elevation: 5,
                  color: Colors.white.withOpacity(0.95),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 50,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 1.5,
                              color: Theme.of(context).primaryColor),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset("assets/images/profileO.png"),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${Provider.of<Auth>(context).userName}",
                            style: Theme.of(context).textTheme.subhead.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontSize: 22),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${Provider.of<Auth>(context).loginType}",
                            style: Theme.of(context).textTheme.title.copyWith(
                                  color: Colors.grey[700],
                                ),
                          ),
                        ],
                      ),
                      Spacer(),
                      // Icon(
                      //   Icons.arrow_forward_ios,
                      //   color: Colors.grey,
                      //   size: 20,
                      // ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                color: Colors.white.withOpacity(0.85),
                elevation: 0,
                margin: EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: icon(Icons.info_outline),
                      title: text("About"),
                      onTap: () {
                        _launchURL("http://ibottic.com/abouts.html");
                      },
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                      ),
                    ),
                    divder,
                    ListTile(
                      leading: icon(Icons.help_outline),
                      title: text('Support'),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                      ),
                      onTap: () {
                        _launchURL("http://ibottic.com/contacts.html");
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                color: Colors.white.withOpacity(0.85),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: EdgeInsets.symmetric(horizontal: 10),
                elevation: 0,
                child: ListTile(
                  leading: Icon(
                    Icons.power_settings_new,
                    size: 28,
                    color: Colors.red,
                  ),
                  title: text('Logout'),
                  onTap: () {
                    // Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/');
                    Provider.of<Auth>(context, listen: false).logout();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
