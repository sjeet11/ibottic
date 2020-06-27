import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_bot/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:school_bot/screens/auth_screen.dart';
import 'package:school_bot/screens/home_screen.dart';
import 'package:school_bot/screens/initial_fetch.dart';
import 'package:school_bot/screens/loading_screen.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          // ChangeNotifierProxyProvider<Auth, EmergencyContacts>(
          //   builder: (ctx, auth, _) => EmergencyContacts(auth.token),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'SchoolBot',
            theme: ThemeData(
              primaryColor: Color.fromRGBO(102, 191, 215, 1),
              accentColor: Colors.white,
              canvasColor: Colors.transparent,
              fontFamily: 'BalooPaaji2',
              iconTheme: IconThemeData(
                color: Theme.of(context).primaryColor,
              ),
              textTheme: TextTheme(
                button: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                subtitle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                title: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                caption: TextStyle(fontWeight: FontWeight.w400),
                display1: TextStyle(fontWeight: FontWeight.w600, fontSize: 21),
                body1: TextStyle(fontWeight: FontWeight.w500),
                subhead: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              appBarTheme: AppBarTheme(
                color: Color.fromRGBO(39, 169, 225, 1).withOpacity(1),
                elevation: 0,
              ),
            ),
            home: auth.isAuth
                ? InitialScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? LoadingScreen()
                            : AuthScreen(),
                  ),
            routes: {
              HomeScreen.routeName: (ctx) => HomeScreen(),
            },
          ),
        ));
  }
}
