import 'package:flutter/material.dart';
import './home_screen.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';
import '../providers/auth.dart';

class InitialScreen extends StatefulWidget {
  static const routeName = '/initialscreen';

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool _isInit = true;
  bool _isloading = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await _fetchCard();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Retry'),
            onPressed: () {
              _fetchCard();
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _fetchCard() async {
    setState(() {
      _isloading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).fetchChildrenData();
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      const errorMessage = 'Sorry something went wrong';
      _showErrorDialog(errorMessage);
    } finally {
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withOpacity(1),
                  Theme.of(context).primaryColor.withOpacity(0.5),
                  Theme.of(context).primaryColor.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 0.8, 1],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              (deviceSize.height < deviceSize.width)
                  ? Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      width: deviceSize.width * 0.3,
                      child: Image.asset(
                        'assets/images/sb_logo.png',
                        fit: BoxFit.cover,
                      ),
                    )
                  : Flexible(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        child: Image.asset(
                          'assets/images/sb_logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
