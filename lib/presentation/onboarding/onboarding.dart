import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
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
    sliderObjectList.add(SliderObject("onBoardingTitle1".tr(), "onBoardingSubTitle1".tr(), 'assets/images/onboardingOne.svg'));
    sliderObjectList.add(SliderObject("onBoardingTitle2".tr(), "onBoardingSubTitle2".tr(), 'assets/images/onboardingTwo.svg'));
    sliderObjectList.add(SliderObject("onBoardingTitle3".tr(), "onBoardingSubTitle3".tr(), 'assets/images/onboardingThree.svg'));
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

   return WillPopScope(
     onWillPop: () async {
       if (Navigator.of(context).userGestureInProgress) {
         return false;
       } else {
         return true;
       }
     },
     child: Scaffold(
       body: Container(
           decoration: const BoxDecoration(
               image:  DecorationImage(
                 image: AssetImage(ImageAssets.background),
                 fit: BoxFit.cover,
               )),
       child: Column(
         children: [
           Expanded(flex:7,

               child: Container(
             child: CarouselSlider.builder(
               itemCount: sliderObjectList.length,
               itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex){
                  return Column(
                   crossAxisAlignment: CrossAxisAlignment.center,

                   children: [
                     SizedBox(height: 100.w,),
                     SvgPicture.asset(sliderObjectList[_current].image,height: 180.w,width: 180.w,fit: BoxFit.fill,),
                     SizedBox(height: 60.w,),
                     Text(sliderObjectList[_current].title,style: TextStyle(
                         color: const Color(0xFF00CAD6),
                         fontSize: screenUtil.setSp(20),
                         fontWeight: FontWeight.bold
                     ),),
                     SizedBox(height: 20.w,),
                     Text(sliderObjectList[_current].subTitle,style: TextStyle(
                         color: const Color(0xFFFFFFFF),
                         fontSize: screenUtil.setSp(14),
                         fontWeight: FontWeight.normal
                     ),)
                   ],
                 );
               },

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

                     child: playButton("letsPlay".tr(), context)),

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
                       children: sliderObjectList.map((item)
                       {
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
                             "skip".tr(),
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
                             "next".tr(),
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
     ),
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


