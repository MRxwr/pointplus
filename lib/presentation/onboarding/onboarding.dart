import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:point/presentation/login/login.dart';
import 'package:point/presentation/register/register.dart';



import '../../domain/model.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  List<SliderObject> sliderObjectList =[];
  final CarouselController _controller = CarouselController();
  int _current =0;
  ScreenUtil screenUtil = ScreenUtil();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sliderObjectList.add(SliderObject(AppStrings.onBoardingTitle1, AppStrings.onBoardingSubTitle1, ImageAssets.onboardingLogo1));
    sliderObjectList.add(SliderObject(AppStrings.onBoardingTitle2, AppStrings.onBoardingSubTitle2, ImageAssets.onboardingLogo2));
    sliderObjectList.add(SliderObject(AppStrings.onBoardingTitle3, AppStrings.onBoardingSubTitle3, ImageAssets.onboardingLogo3));
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

   return Scaffold(
     body: Container(
         decoration: const BoxDecoration(
             image:  DecorationImage(
               image: AssetImage(ImageAssets.background),
               fit: BoxFit.cover,
             )),
     child: Column(
       children: [
         Expanded(flex:6,

             child: Container(
           child: CarouselSlider(

             carouselController: _controller,
             options: CarouselOptions(
                 autoPlay: true,
                 autoPlayInterval: Duration(seconds: 10),



                 height: double.infinity,
                 viewportFraction: 1.0,
                 enlargeCenterPage: false,
                 disableCenter: true,
                 pauseAutoPlayOnTouch: true
                 ,




                 onPageChanged: (index, reason) {
                   setState(() {
                     _current = index;
                   });
                 }
             ),
             items: sliderObjectList.map((item) =>
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.center,

                   children: [
                     SizedBox(height: 100.w,),
                     Image.asset(item.image,height: 180.w,width: 180.w,fit: BoxFit.fill,),
                     SizedBox(height: 60.w,),
                     Text(item.title,style: TextStyle(
                       color: const Color(0xFF00CAD6),
                       fontSize: screenUtil.setSp(20),
                       fontWeight: FontWeight.bold
                     ),),
                     SizedBox(height: 20.w,),
                     Text(item.subTitle,style: TextStyle(
                         color: const Color(0xFFFFFFFF),
                         fontSize: screenUtil.setSp(14),
                         fontWeight: FontWeight.normal
                     ),)
                   ],
                 )).toList(),

           ),

         )),
         Expanded(flex:3,child: Container(
           child: Stack(
             children: [
           Container(
             child:_current== 2?
             Positioned.directional(
               textDirection:  Directionality.of(context),
               bottom: 40.w,
               start: 30.w,
               end: 30.w,
               child:
               Container(
                 height: 55.w,

                   child: playButton(AppStrings.letsPlay, context)),

             ):Container(),
           )
             ],
           ),

         )),
         Expanded(flex:1,child: Container(
           child: Stack(
             children: [
               Positioned.directional(  textDirection:  Directionality.of(context),
                   start: 0,
                   end: 0,
                   top: 0,
                   bottom: 0,
                   child:  Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: sliderObjectList.map((item) {
                       int index =sliderObjectList.indexOf(item);
                       return Container(
                         width:_current == index? 12.0.w:8.w,
                         height: 8.0.h,
                         margin: EdgeInsets.symmetric(vertical: 10.0.w, horizontal: 2.0.h),
                         decoration: BoxDecoration(
                           shape:  _current == index?BoxShape.rectangle:BoxShape.circle,
                           color: _current == index
                               ? const Color(0xFF00CAD6)
                               : const Color(0xFFFFFFFF),
                         ),
                       );
                     }).toList(),
                   )),
               Container(
                 child: _current !=2 ?Positioned.directional(textDirection: Directionality.of(context),
                     start: 10.w,
                     top: 0,
                     bottom: 0,

                     child: Center(
                       child: GestureDetector(
                         onTap: (){
                           Navigator.of(context,rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (BuildContext context){
                             return  RegisterView();
                           }));
                         },
                         child: Text(
                           AppStrings.skip,
                           style: TextStyle(
                             color: const Color(0xFFFFFFFF),
                             fontSize: screenUtil.setSp(16),
                             fontWeight: FontWeight.normal
                           ),
                         ),
                       ),
                     )):Container(),
               ),
               Container(
                 child:_current !=2 ?
                 Positioned.directional(textDirection: Directionality.of(context),
                     end: 10.w,
                     top: 0,
                     bottom: 0,

                     child: Center(
                       child: GestureDetector(
                         onTap: (){
                           _current++;
                           setState(() {

                           });
                         },

                         child: Text(
                           AppStrings.next,
                           style: TextStyle(
                               color: const Color(0xFF00CAD6),
                               fontSize: screenUtil.setSp(16),
                               fontWeight: FontWeight.normal
                           ),
                         ),
                       ),
                     )):Container(),
               )
             ],
           ),

         )),

       ],
     ),),
   );
  }
  TextButton playButton(String text,BuildContext context){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      primary: const Color(0xFF000000),
      minimumSize: Size(width, 30.h),
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      shape:  RoundedRectangleBorder(

        borderRadius: BorderRadius.all(Radius.circular(30.w)),
      ),
      backgroundColor: const Color(0xFF00CAD6),
    );

    return TextButton(
      style: flatButtonStyle,
      onPressed: () {
        Navigator.of(context,rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (BuildContext context){
          return  const LoginView();
        }));

      },
      child: Text(text,style: TextStyle(
          color: const Color(0xFF000000),
          fontSize: screenUtil.setSp(16),
          fontWeight: FontWeight.normal
      ),),
    );
  }
}


