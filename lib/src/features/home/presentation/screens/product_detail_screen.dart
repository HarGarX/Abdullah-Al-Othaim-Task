import 'package:abdullah_al_othaim_task/src/core/constants/app_color.dart';
import 'package:abdullah_al_othaim_task/src/core/routes/route_consts.dart';
import 'package:abdullah_al_othaim_task/src/features/home/domain/entites/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProductsDetailScreen extends StatefulWidget {
  final ProductEntity productEntity;

  const ProductsDetailScreen({Key? key, required this.productEntity}) : super(key: key);

  @override
  State<ProductsDetailScreen> createState() => _ProductsDetailScreenState();
}

class _ProductsDetailScreenState extends State<ProductsDetailScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mainAppColorWhite,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FittedBox(
                    fit: BoxFit.fill,
                    child: Image.asset(
                      widget.productEntity.imageUrl!,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.productEntity.desc!,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Metropolis',
                              height: 1.2,
                              fontWeight: FontWeight.w600,
                              fontSize: 23.sp,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: widget.productEntity.salePrice! > 0.0
                              ? MainAxisAlignment.spaceEvenly
                              : MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.productEntity.regularPrice!.toStringAsFixed(2),
                              style: TextStyle(
                                color: widget.productEntity.salePrice! > 0.0 ? AppColor.mainAppColorRed : Colors.black,
                                fontFamily: 'Metropolis',
                                fontWeight: FontWeight.w500,
                                decoration: widget.productEntity.salePrice! > 0.0 ? TextDecoration.lineThrough : null,
                                fontSize: widget.productEntity.salePrice! > 0.0 ? 14.sp : 22.sp,
                              ),
                            ),
                            widget.productEntity.salePrice! > 0.0
                                ? Text(
                                    widget.productEntity.salePrice!.toStringAsFixed(2),
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
                                color: AppColor.mainAppColorLimeGreen,
                                fontFamily: 'Metropolis',
                                fontWeight: FontWeight.w500,
                                fontSize: 18.sp,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '''Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.''',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Metropolis',
                          height: 1.2,
                          fontWeight: FontWeight.w400,
                          fontSize: 23.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 3.w,
              top: 4.h,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(55.0),
                ),
                padding: const EdgeInsets.all(12.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(RouteConsts.homeRoute, (Route<dynamic> route) => false);
                    // Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_sharp,
                    size: 30,
                    color: AppColor.mainAppColorGreen,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
