import 'package:abdullah_al_othaim_task/src/core/routes/route_consts.dart';
import 'package:abdullah_al_othaim_task/src/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class RouteGenerator {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case RouteConsts.homeRoute:
        return PageTransition(child: const HomeScreen(), type: PageTransitionType.fade);

      default:
        return errorRoute();
    }
  }

  static Route<dynamic> errorRoute() {
    return MaterialPageRoute(
      builder: (BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Material(
                      child: InkWell(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Error Route',
                      style: TextStyle(color: Colors.black),
                    ),
                    const Spacer(),
                    Container(),
                  ],
                ),
              ),
              const Center(
                child: Text(
                  'ERROR: UNKNOWN ROUTE',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
