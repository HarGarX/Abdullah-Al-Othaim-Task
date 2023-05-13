import 'package:abdullah_al_othaim_task/src/core/routes/route_consts.dart';
import 'package:abdullah_al_othaim_task/src/core/routes/route_generator.dart';
import 'package:abdullah_al_othaim_task/src/core/service_locater.dart';
import 'package:abdullah_al_othaim_task/src/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider>[
        BlocProvider<HomeBloc>(
          create: (context) => locator<HomeBloc>(),
        ),
      ],
      child: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return MaterialApp(
            builder: (context, child) => ResponsiveWrapper.builder(
              child!,
              maxWidth: MediaQuery.of(context).size.width,
              minWidth: 480,
              defaultScale: true,
              breakpoints: [
                const ResponsiveBreakpoint.resize(480, name: MOBILE),
                const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
              ],
            ),
            useInheritedMediaQuery: true,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: RouteGenerator.onGenerateRoute,
            initialRoute: RouteConsts.homeRoute,
            theme: ThemeData(
              // fontFamily: null ,
              // scaffoldBackgroundColor: null,
              // accentColor: null,
              // primaryColor: null
              textSelectionTheme: const TextSelectionThemeData(
                  // cursorColor: null,
                  ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    // primary: null,
                    ),
              ),
            ),
          );
        },
        maxTabletWidth: 900, // Optional
      ),
    );
  }
}
