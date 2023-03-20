
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_switch/flutter_switch.dart';
import 'package:point/app/constant.dart';
import 'package:point/domain/settings_model.dart';
import 'package:point/presentation/main/main.dart';
import 'package:point/presentation/main/privacy_screen.dart';
import 'package:point/presentation/main/shop_screen.dart';
import 'package:point/presentation/main/webview_screen.dart';
import 'package:point/presentation/resources/font_manager.dart';
import 'package:point/presentation/resources/strings_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../api/point_services.dart';
import '../photo/photo_screen.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/values_manager.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationStatus = true;
  bool isEnglish = true;
  SettingsModel? settingsModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settings().then((value) {
      setState(() {
        settingsModel = value;
      });

    });

  }
  int _current =0;
  final CarouselController _controller = CarouselController();
  String mLanguage = "";

  String lang ="";
  Future<SettingsModel?> settings()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    notificationStatus = sharedPreferences.getBool(NotificationStatus)??true;
     lang =sharedPreferences.getString(LANG_CODE)??"en";
   if(lang == "en"){
     isEnglish = true;
   }else{
     isEnglish = false;
   }
    PointServices pointServices = PointServices();
    SettingsModel? settingsModel = await pointServices.settings();
    return settingsModel;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: ColorManager.primary,
        body: Container(

          child:settingsModel == null?
          Container(
            child: const CircularProgressIndicator(


            ),
            alignment: AlignmentDirectional.center,
          ):ListView(
            padding: EdgeInsets.zero,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              Container(height: AppSize.s10,),
              Container(
                child: settingsModel!.data!.banners!.isEmpty?
                Container():Column(
                  children: [
                    Container(height: AppSize.s80,
                      margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
                      child: CarouselSlider(

                        carouselController: _controller,
                        options: CarouselOptions(
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 10),



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
                        items: settingsModel?.data!.banners!.map((item) =>
                            Stack(

                              children: [
                                GestureDetector(
                                  onTap: (){
                                    String? url = item.url;
                                    if(Uri.parse(url!).isAbsolute){
                                      Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (BuildContext context){
                                        return  WebViewScreen(url:url,
                                          title:mLanguage == "en"?item.enTitle.toString():item.arTitle.toString() ,);
                                      }));
                                    }else{
                                      Navigator.of(context,rootNavigator: true).push( MaterialPageRoute(builder: (BuildContext context){
                                        return  PhotoScreen(imageProvider: NetworkImage(
                                          TAG_IMAGE_URL+url,
                                        ),);
                                      }));

                                    }

                                  },


                                  child:
                                  Column(
                                    children: [

                                      Expanded(
                                        flex:4,
                                        child:
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(AppSize.s8),

                                          child:
                                          CachedNetworkImage(
                                            width: AppSize.width,

                                            fit: BoxFit.fill,
                                            imageUrl:'$TAG_IMAGE_URL${item.image}',
                                            imageBuilder: (context, imageProvider) => Container(
                                                width: AppSize.width,


                                                decoration: BoxDecoration(



                                                  image: DecorationImage(


                                                      fit: BoxFit.fill,
                                                      image: imageProvider),
                                                )
                                            ),
                                            placeholder: (context, url) =>
                                                Column(
                                                  children: [
                                                    Expanded(
                                                      flex: 9,
                                                      child: Container(
                                                        height: AppSize.height,
                                                        width:  AppSize.width,


                                                        alignment: FractionalOffset.center,
                                                        child: SizedBox(
                                                            height: AppSize.s50,
                                                            width: AppSize.s50,
                                                            child:  const CircularProgressIndicator()),
                                                      ),
                                                    ),
                                                  ],
                                                ),


                                            errorWidget: (context, url, error) => Container(
                                                height: AppSize.height,
                                                width:  AppSize.width,

                                                alignment: FractionalOffset.center,
                                                child: const Icon(Icons.image_not_supported_outlined)),

                                          ),
                                          // Image.network(
                                          //
                                          //
                                          // '${kBaseUrl}${mAdsPhoto}${item.photo}'  , fit: BoxFit.fitWidth,
                                          //   height: 600.h,),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ] ,
                            )).toList(),

                      ),),
                    Container(height: AppSize.s50,),
                  ],
                ),
              )
              ,
              Container(
                margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSize.s10),
                    ),
                    child: Container(
                      height: AppSize.s100,
                      color: ColorManager.expandedColor,
                      child: Column(
                        children: [

                          Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ColorManager.navColor,
                                  borderRadius: BorderRadiusDirectional.only(bottomStart: Radius.circular(AppSize.s10),
                                  bottomEnd: Radius.circular(AppSize.s10))

                                ),
                                child: Container(
                                  margin: EdgeInsets.all(AppSize.s5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex:1,
                                        child: Container(
                                          child: Image.asset(ImageAssets.bill,height: AppSize.s21,width: AppSize.s18,
                                         ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text("notifications".tr(),
                                        style: TextStyle(
                                          color: ColorManager.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: FontSize.s12
                                        ),),
                                      ),

                                      Expanded(
                                        flex: 1,
                                        child: Image.asset(ImageAssets.arrowDown,height: AppSize.s9,width: AppSize.s15,
                                          ),
                                      ),

                                    ],
                                  ),
                                ),

                              )),
                          Expanded(flex:1,child: Container(

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("generalNotifications".tr(),
                                  style: TextStyle(
                                      color: ColorManager.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: FontSize.s12
                                  ),),
                                FlutterSwitch(
                                  activeColor: ColorManager.secondary,
                                  inactiveColor: ColorManager.grey,
                                  width: AppSize.s50,
                                  height: AppSize.s24,
                                  activeText: "",
                                  inactiveText: "",

                                  value: notificationStatus,
                                  borderRadius: AppSize.s12,
                                  padding: AppSize.s2,
                                  showOnOff: true,
                                  onToggle: (val) async{
                                    SharedPreferences sharedPrefrences = await SharedPreferences.getInstance();
                                    sharedPrefrences.setBool(NotificationStatus, val);
                                    setState(() {
                                      notificationStatus = val;
                                    });
                                  },
                                )
                              ],
                            ),

                          ))

                        ],
                      ),

                    ),
                  ),
                    SizedBox(height: AppSize.s20,),
                    Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSize.s10),
                      ),
                      child: Container(
                        height: AppSize.s100,
                        color: ColorManager.expandedColor,
                        child: Column(
                          children: [

                            Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: ColorManager.navColor,
                                      borderRadius: BorderRadiusDirectional.only(bottomStart: Radius.circular(AppSize.s10),
                                          bottomEnd: Radius.circular(AppSize.s10))

                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(AppSize.s5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex:1,
                                          child: Container(
                                            child: Image.asset(ImageAssets.generalImage,height: AppSize.s20,width: AppSize.s20,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text("general".tr(),
                                            style: TextStyle(
                                                color: ColorManager.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: FontSize.s12
                                            ),),
                                        ),

                                        Expanded(
                                          flex: 1,
                                          child: Image.asset(ImageAssets.arrowDown,height: AppSize.s9,width: AppSize.s15,
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),

                                )),
                            Expanded(flex:1,child: Container(

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text("language".tr(),
                                    style: TextStyle(
                                        color: ColorManager.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: FontSize.s12
                                    ),),
                                  Row(
                                    children: [
                                      Text("arabic".tr(),
                                        style: TextStyle(
                                            color: isEnglish?ColorManager.white:ColorManager.secondary,
                                            fontWeight: FontWeight.w500,
                                            fontSize: FontSize.s12
                                        ),),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: AppSize.s4),
                                        child: FlutterSwitch(
                                          activeColor: ColorManager.secondary,
                                          inactiveColor: ColorManager.secondary,
                                          width: AppSize.s50,
                                          height: AppSize.s24,
                                          activeText: "",
                                          inactiveText: "",

                                         value: true,
                                          borderRadius: AppSize.s12,
                                          padding: AppSize.s2,
                                          showOnOff: true,
                                          onToggle: (val) async{
                                            SharedPreferences sharedPrefrences = await SharedPreferences.getInstance();
                                            if(!isEnglish){

                                              sharedPrefrences.setString(LANG_CODE, "en");
                                             Locale loc =context.supportedLocales[0];
                                             print('local ---> ${loc.countryCode}');
                                              await context.setLocale(context.supportedLocales[0]);


                                              Navigator.of(context,rootNavigator: true).pushReplacement(

                                                MaterialPageRoute(builder: (context) => const MainView()),);

                                            }else{
                                              sharedPrefrences.setString(LANG_CODE, "ar");

                                              Locale loc =context.supportedLocales[1];
                                              print('local ---> ${loc.countryCode}');

                                               await context.setLocale(context.supportedLocales[1]);

                                              Navigator.of(context,rootNavigator: true).pushReplacement(

                                                MaterialPageRoute(builder: (context) => const MainView()),);

                                            }


                                            // setState(() {
                                            //   isEnglish = val;
                                            // });
                                          },
                                        ),
                                      ),
                                      Text("english".tr(),
                                        style: TextStyle(
                                            color: isEnglish?ColorManager.secondary:ColorManager.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: FontSize.s12
                                        ),),
                                    ],
                                  )
                                ],
                              ),

                            ))

                          ],
                        ),

                      ),
                    ),
                    SizedBox(height: AppSize.s20,),
                    GestureDetector(
                      onTap: (){
                        String? privacy = lang== "en"?settingsModel!.data!.enPolicy:settingsModel!.data!.arPolicy;
      Navigator.of(context,rootNavigator: true).push( MaterialPageRoute(builder: (BuildContext context){
          return  PrivacyPolicyScreen(privacy: privacy!,title: "privacy".tr());
        }));
                      },
                      child: Container(
                        height: AppSize.s50,
                        decoration: BoxDecoration(
                       color: ColorManager.navColor,
                          borderRadius: BorderRadius.circular(AppSize.s10)
                        ),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: AppSize.s5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex:1,
                                child: Container(
                                  child: Image.asset(ImageAssets.privacyPolicy,height: AppSize.s19,width: AppSize.s12,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text("privacy".tr(),
                                  style: TextStyle(
                                      color: ColorManager.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: FontSize.s12
                                  ),),
                              ),



                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSize.s20,),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context,rootNavigator: true).push( MaterialPageRoute(builder: (BuildContext context){
                          return  ShopScreen();
                        }));
                      },
                      child: Container(
                        height: AppSize.s50,
                        decoration: BoxDecoration(
                            color: ColorManager.navColor,
                            borderRadius: BorderRadius.circular(AppSize.s10)
                        ),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: AppSize.s5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex:1,
                                child: Container(
                                  child: Image.asset(ImageAssets.prizes,height: AppSize.s20,width: AppSize.s20,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text("prizes".tr(),
                                  style: TextStyle(
                                      color: ColorManager.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: FontSize.s12
                                  ),),
                              ),



                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSize.s20,),
                    GestureDetector(
                      onTap: (){
                        String? privacy = lang == "en"?settingsModel!.data!.enAbout:settingsModel!.data!.arAbout;
                        Navigator.of(context,rootNavigator: true).push( MaterialPageRoute(builder: (BuildContext context){
                          return  PrivacyPolicyScreen(privacy: privacy!,title: "help".tr());
                        }));
                      },
                      child: Container(
                        height: AppSize.s50,
                        decoration: BoxDecoration(
                            color: ColorManager.navColor,
                            borderRadius: BorderRadius.circular(AppSize.s10)
                        ),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: AppSize.s5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex:1,
                                child: Container(
                                  child: Image.asset(ImageAssets.help,height: AppSize.s20,width: AppSize.s20,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text("help".tr(),
                                  style: TextStyle(
                                      color: ColorManager.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: FontSize.s12
                                  ),),
                              ),



                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSize.s50,),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: (){
                              _openUrl(url("+${settingsModel!.data!.whatsapp}", "hi")) ;

                            },

                              child: Image.asset(ImageAssets.whatsapp,height: AppSize.s32,width: AppSize.s32,)),
                          GestureDetector(
                            onTap: (){
                             String url =settingsModel!.data!.insta.toString();
                              Navigator.of(context,rootNavigator: true).push( MaterialPageRoute(builder: (BuildContext context){
                                return  WebViewScreen(url: url,title: "instagram".tr());
                              }));
                            },
                              child: Image.asset(ImageAssets.instagram,height: AppSize.s32,width: AppSize.s32,)),
                          GestureDetector(
                              onTap:(){
                                String url =settingsModel!.data!.twitter.toString();
                                Navigator.of(context,rootNavigator: true).push( MaterialPageRoute(builder: (BuildContext context){
                                  return  WebViewScreen(url: url,title: "twitter".tr());
                                }));
                              },child: Image.asset(ImageAssets.twitter,height: AppSize.s27,width: AppSize.s33,)),



                        ],
                      ),
                    ),
                    SizedBox(height: AppSize.s50,),
                        ],
                      ),
                    )




            ],
          ),
        ),
      ),
    );
  }
  String url(String phone,String message) {
    if (Platform.isAndroid) {
      // add the [https]
      return "https://wa.me/$phone/?text=${Uri.parse(message)}"; // new line
    } else {
      // add the [https]
      return "https://api.whatsapp.com/send?phone=$phone&text=${Uri.parse(message)}"; // new line
    }
  }
  Future<void> _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
