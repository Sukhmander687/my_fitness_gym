import 'package:flutter/material.dart';
import 'package:fluttergym/screens/splash_screen.dart';
import 'package:fluttergym/tabs/main_screen.dart';
import 'package:fluttergym/utils/const.dart';
import 'package:fluttergym/utils/size_config.dart';
import 'package:provider/provider.dart';

import 'models/user_modal.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  UserModal modal  = UserModal() ;
  @override
  Widget build(BuildContext context) {
    return
      MultiProvider(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return OrientationBuilder(
              builder: (context, orientation) {
                SizeConfig().init(constraints, orientation);
                return MaterialApp(
//             locale: DevicePreview.of(context).locale,
//             builder: DevicePreview.appBuilder,
                  debugShowCheckedModeBanner: false,
                  title: 'Flutter Gym',
                  theme: ThemeData(
                    primaryColor: primaryColor,
                    accentColor: primaryColor,

                  ),
                  home: SplashScreen(),
                );
              },
            );
          },
        ),
        providers: [
          ChangeNotifierProvider<UserModal>.value(value: modal),
        ],
      );
  }
}
