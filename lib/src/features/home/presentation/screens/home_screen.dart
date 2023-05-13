import 'dart:async';
import 'dart:developer';

import 'package:abdullah_al_othaim_task/src/core/constants/app_color.dart';
import 'package:abdullah_al_othaim_task/src/core/constants/asset_consts.dart';
import 'package:abdullah_al_othaim_task/src/core/constants/secure_storage_consts.dart';
import 'package:abdullah_al_othaim_task/src/core/platform/network_info.dart';
import 'package:abdullah_al_othaim_task/src/core/service_locater.dart';
import 'package:abdullah_al_othaim_task/src/core/widgets/default_loader.dart';
import 'package:abdullah_al_othaim_task/src/features/home/presentation/bloc/home_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeBloc _homeBloc;
  late Timer timer;
  final CarouselController carouselController = CarouselController();
  int currentActivePage = 0;
  List<int> favProductsList = [];

  @override
  void initState() {
    super.initState();
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _homeBloc.add(const FetchHomeDataEvent());
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) => updateLocalData());
  }

  Future<void> updateLocalData() async {
    _homeBloc.add(const UpdateLocalDataEvent());
    log("updating data fired");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Container(
        // padding: EdgeInsets.all(30.0),
        child: Text(
          'Update : updating local data on the background ...',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Metropolis',
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
      ),

      backgroundColor: AppColor.mainAppColorGreenShade.withOpacity(0.7),
      padding: EdgeInsets.all(15.0),
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      behavior: SnackBarBehavior.floating,
      // width: 20.w,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      duration: const Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
          ),
          automaticallyImplyLeading: false,
          toolbarHeight: Device.orientation == Orientation.portrait ? 17.h : 17.w,
          backgroundColor: AppColor.mainAppColorWhite,
          titleSpacing: 0.0,
          title: GestureDetector(
            onTap: () {
              _homeBloc.add(const FetchHomeDataEvent());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  AssetConst.logo,
                  alignment: Alignment.topCenter,
                  height: Device.orientation == Orientation.portrait ? 16.h : 16.w,
                  width: Device.orientation == Orientation.portrait ? 20.w : 20.h,
                  fit: BoxFit.cover,
                ),
                // Your widgets here
              ],
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: AppColor.mainAppColorWhite.withOpacity(0.95),
        body: SafeArea(
          child: BlocConsumer<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is HomeFailureState) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Container(
                    // padding: EdgeInsets.all(30.0),
                    child: Text(
                      'Error : ${state.errorMessage}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),

                  backgroundColor: AppColor.mainAppColorRed,
                  padding: EdgeInsets.all(15.0),
                  margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                  behavior: SnackBarBehavior.floating,
                  // width: 20.w,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  duration: const Duration(seconds: 4),
                ));
              } else if (state is HomeSuccessState) {
                final NetworkInfo networkInfo = locator<NetworkInfo>();
                networkInfo.isConnected.then((isConnected) async {
                  final secureStorage = locator<FlutterSecureStorage>();
                  final String? notFirstFetch = await secureStorage.read(key: SecureStorageConstants.NOT_FIRST_FETCH);
                  final bool isItNotFirstFetch = notFirstFetch == 'true' ? true : false;
                  if (isItNotFirstFetch == true) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Container(
                        // padding: EdgeInsets.all(30.0),
                        child: Text(
                          'Info : getting data from local cache',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Metropolis',
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),

                      backgroundColor: AppColor.secondaryAppColorYellow,
                      padding: const EdgeInsets.all(15.0),
                      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                      behavior: SnackBarBehavior.floating,
                      // width: 20.w,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      duration: const Duration(seconds: 4),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Container(
                        // padding: EdgeInsets.all(30.0),
                        child: Text(
                          'Info : getting data from sever',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Metropolis',
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),

                      backgroundColor: AppColor.mainAppColorLimeGreen,
                      padding: EdgeInsets.all(15.0),
                      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                      behavior: SnackBarBehavior.floating,
                      // width: 20.w,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      duration: const Duration(seconds: 4),
                    ));
                  }
                });
              }
            },
            builder: (context, state) {
              if (state is HomeSuccessState) {
                return Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 3.w),
                      child: CarouselSlider(
                        carouselController: carouselController,
                        options: CarouselOptions(
                          height: Device.orientation == Orientation.portrait ? 35.h : 35.w,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.39,
                          initialPage: 0,
                          enableInfiniteScroll: false,
                          padEnds: false,
                          reverse: false,
                          autoPlay: false,
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration: const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: false,
                          // enlargeFactor: 0.3,
                          onPageChanged: (currentPage, carouselPageChangedReason) {
                            setState(() {
                              currentActivePage = currentPage;
                            });
                          },
                          scrollDirection: Axis.horizontal,
                        ),
                        items: state.productsList.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                clipBehavior: Clip.hardEdge,
                                child: Container(
                                  width: 100.w,
                                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                                  decoration: BoxDecoration(
                                    color: AppColor.mainAppColorGreenShade.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Stack(
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            i.imageUrl!,
                                            height: 20.h,
                                            width: 50.w,
                                            fit: BoxFit.fill,
                                          ),
                                          const SizedBox(
                                            height: 2.0,
                                          ),
                                          Text(
                                            i.desc!,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Metropolis',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 21.sp,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Column(
                                            mainAxisAlignment: i.salePrice! > 0.0
                                                ? MainAxisAlignment.spaceEvenly
                                                : MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                i.regularPrice!.toStringAsFixed(2),
                                                style: TextStyle(
                                                  color: i.salePrice! > 0.0 ? AppColor.mainAppColorRed : Colors.black,
                                                  fontFamily: 'Metropolis',
                                                  fontWeight: FontWeight.w500,
                                                  decoration: i.salePrice! > 0.0 ? TextDecoration.lineThrough : null,
                                                  fontSize: 22.sp,
                                                ),
                                              ),
                                              i.salePrice! > 0.0
                                                  ? Text(
                                                      i.salePrice!.toStringAsFixed(2),
                                                      style: TextStyle(
                                                        color: AppColor.mainAppColorLimeGreen,
                                                        fontFamily: 'Metropolis',
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 22.sp,
                                                      ),
                                                    )
                                                  : Text(
                                                      "",
                                                      style: TextStyle(
                                                        color: AppColor.mainAppColorLimeGreen,
                                                        fontFamily: 'Metropolis',
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 22.sp,
                                                      ),
                                                    ),
                                              Text(
                                                "SAR",
                                                style: TextStyle(
                                                  color: AppColor.mainAppColorRed,
                                                  fontFamily: 'Metropolis',
                                                  // fontWeight: FontWeight.w500,
                                                  decoration: TextDecoration.lineThrough,

                                                  fontSize: 22.sp,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Positioned(
                                        right: 1.h,
                                        top: 1.h,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (favProductsList.contains(i.sku!)) {
                                                favProductsList.remove(i.sku);
                                              } else {
                                                favProductsList.add(i.sku!);
                                              }
                                            });
                                          },
                                          child: Icon(
                                            favProductsList.contains(i.sku!) ? Icons.favorite : Icons.favorite_border,
                                            color: AppColor.mainAppColorRed,
                                            size: 35.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    if (currentActivePage > 0) ...[
                      Positioned(
                        right: 3.w,
                        top: 13.h,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(45.0),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              carouselController.nextPage();
                            },
                            child: const Icon(
                              Icons.arrow_forward_ios_sharp,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (currentActivePage > 0) ...[
                      Positioned(
                        left: 3.w,
                        top: 13.h,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(45.0),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              carouselController.previousPage();
                            },
                            child: const Icon(
                              Icons.arrow_back_ios_new_sharp,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              } else if (state is HomeLoadingState) {
                return const Align(
                  alignment: Alignment.center,
                  child: Center(
                    child: DefaultLoader(),
                  ),
                );
              } else {
                return Container(
                  height: 100.w,
                  width: 100.w,
                  color: Colors.white,
                );
              }
            },
          ),
        ));
  }
}
