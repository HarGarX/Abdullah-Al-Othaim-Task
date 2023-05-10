import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/app_color.dart';

class DefaultLoader extends StatelessWidget {
  const DefaultLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          alignment: Alignment.center,
          height: 10.h,
          width: 10.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: AppColor.mainAppColorGreenShade.withOpacity(0.3),
          ),
          child: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: const Center(
                child: CircularProgressIndicator(
              color: AppColor.mainAppColorLimeGreen,
              backgroundColor: AppColor.mainAppColorWhite,
            )),
          ),
        ),
      ),
    );
  }
}
