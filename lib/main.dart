import 'package:flutter/material.dart';
import 'screens/loading.dart';
import 'screens/auth_screen.dart';
import 'package:provider/provider.dart';
import 'screens/form_screen.dart';
import 'providers/user_provider.dart';
import 'screens/result_screen.dart';
import 'screens/Ideas.dart';
import 'providers/auth.dart';
import 'screens/forget_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
          ChangeNotifierProxyProvider<Auth, UserProvider>(
              update: (context, auth, previousProvider) => UserProvider(
                  auth.token,
                  auth.userId,
                  previousProvider == null ? [] : previousProvider.issueList)),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            title: 'Health',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: auth.isAuth
                ? FormScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? Loading()
                            : AuthScreen(),
                  ),
            routes: {
              ResultPage.routeName: (_) => ResultPage(),
              Ideas.routeName: (_) => Ideas(),
              ForgetScreen.routeName: (_) => ForgetScreen(),
            },
          ),
        ));
  }
}
