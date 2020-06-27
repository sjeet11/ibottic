import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:school_bot/models/http_exception.dart';
import 'package:school_bot/providers/auth.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // PushNotification(),
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
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
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
                  AuthCard(),
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
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, Object> _authData = {
    'username': '',
    'password': '',
  };
  var _isLoading = false;
  var _passwordVisible = false;
  final _passwordController = TextEditingController();

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

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .login(_authData["username"], _authData["password"]);

      // Log user in

    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      const errorMessage = 'Sorry something went wrong';
      _showErrorDialog(errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      // color: Colors.white70,
      child: Column(
        children: <Widget>[
          Container(
            width: deviceSize.width * 0.80,
            padding: EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      key: ValueKey(1),
                      initialValue: _authData['username'],
                      decoration: InputDecoration(
                        labelText: 'Username / Phone number',
                        labelStyle: TextStyle(fontSize: 16),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter your username / Phone number';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _authData['username'] = value;
                      },
                    ),
                    (TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(fontSize: 16),
                          suffixIcon: IconButton(
                            icon: Icon(_passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            disabledColor: Colors.grey,
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            color: Theme.of(context).primaryColor,
                          )),
                      obscureText: !_passwordVisible,
                      controller: _passwordController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide Password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['password'] = value;
                      },
                    )),
                    SizedBox(
                      height: 20,
                    ),
                    (_isLoading)
                        ? CircularProgressIndicator(
                            backgroundColor: Theme.of(context).primaryColor,
                          )
                        : RaisedButton(
                            child: Text('LOGIN'),
                            onPressed: () {
                              _submit();
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 8.0),
                            color: Theme.of(context).primaryColor,
                            textColor:
                                Theme.of(context).primaryTextTheme.button.color,
                          ),
                    SizedBox(
                      height: 5,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
