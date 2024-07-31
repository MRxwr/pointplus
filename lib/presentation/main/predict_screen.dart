import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:point/domain/prediction_model.dart';
import 'package:point/domain/sumbit_predict_model.dart';
import 'package:point/presentation/resources/font_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/point_services.dart';
import '../../app/constant.dart';
import '../../providers/model_hud.dart';
import '../photo/photo_screen.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import '../web/webview_screen.dart';
class PredictScreen extends StatefulWidget {
  const PredictScreen({Key? key}) : super(key: key);

  @override
  State<PredictScreen> createState() => _PredictScreenState();
}

class _PredictScreenState extends State<PredictScreen> with WidgetsBindingObserver{
  PredictionModel? predictionModel;
  List<Teams> teams =[];
  String mLanguage ="";
  String x2 = "0";
  String x3 = "0";
  String gw = "";
  bool enableButton  = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _current =0;

  final CarouselController _controller = CarouselController();
  int remaningTime = 0;
  AppLifecycleState? _notification;
  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        predictionModel = null;
        setState(() {

        });
        predictions().then((value){
          predictionModel = value;
          teams = predictionModel!.data!.teams!;
          x2 = predictionModel!.data!.user!.x2.toString();
          x3 = predictionModel!.data!.user!.x3.toString();
          if(predictionModel!.data!.countdown.toString()!= "") {
            remaningTime = getRemainingTime(
                predictionModel!.data!.countdown.toString(),
                predictionModel!.data!.startTime.toString());
          }
          setState(() {

          });

        });
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    predictions().then((value){
      predictionModel = value;
      teams = predictionModel!.data!.teams!;
      x2 = predictionModel!.data!.user!.x2.toString();
      x3 = predictionModel!.data!.user!.x3.toString();
      if(predictionModel!.data!.countdown.toString()!= "") {
        remaningTime = getRemainingTime(
            predictionModel!.data!.countdown.toString(),
            predictionModel!.data!.startTime.toString());
      }
      setState(() {

      });

    });
  }
  Future<PredictionModel?> predictions() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    gw = sharedPreferences.getString("gw")??"";
    String id = sharedPreferences.getString("id")??"";
    Map<String,dynamic> map = {};
    map['userId']= id;
    print('userId ---> ${id}');
    PointServices pointServices = PointServices();


    mLanguage = sharedPreferences.getString(LANG_CODE)??"";
    PredictionModel? predictionModel = await pointServices.predictions(map);
    return predictionModel;
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
      child: ModalProgressHUD(
        inAsyncCall: Provider.of<ModelHud>(context).isLoading,
        child: Scaffold(
            key: _scaffoldKey,
          backgroundColor: ColorManager.backGroundColor,
          body: predictionModel == null?
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
                child: predictionModel!.data!.banners!.isEmpty?
                Container():Column(
                  children: [
                    Container(height: 250.h,
                      margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
                      child:  CarouselSlider(

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
                        items: predictionModel?.data!.banners!.map((item) =>
                            Stack(

                              children: [
                                GestureDetector(
                                  onTap: (){
                                    String? url = item.url;
                                    if(Uri.parse(url!).isAbsolute){
                                      if(url.contains("instagram")) {
                                        launchUrl(Uri.parse(url),
                                          mode: LaunchMode.externalApplication,);
                                      }else {
                                        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (BuildContext context){
                                          return  WebViewScreen(url:url,
                                            title:mLanguage == "en"?item.enTitle.toString():item.arTitle.toString() ,);
                                        }));
                                      }
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

                      )),
                    Container(height: AppSize.s20,),
                  ],
                ),
              ),
              Container(
                child:predictionModel!.data!.countdown.toString() == ""?
                Container():Container(
                  height: AppSize.s70,
                  margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorManager.blueBlack,
                      borderRadius: BorderRadius.all(Radius.circular(AppSize.s5))
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: AppSize.s20,vertical: AppSize.s5),
                      child: Row(
                        children: [
                          Expanded(flex:4,child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                             Expanded(
                               flex: 1,
                                 child:
                                 Text(
                                     gw+" "+ "gwString".tr() ,
                                   style: TextStyle(
                                     color: ColorManager.white,
                                     fontSize: FontSize.s10,
                                     fontWeight: FontWeight.normal
                                   ),

                                 )),
                                Expanded(flex:2,child:predictionModel!.data!.countdown.toString().isEmpty?
                                    Container():



                                Countdown(
                                    seconds: getRemainingTime(predictionModel!.data!.countdown.toString(),predictionModel!.data!.startTime.toString()),
                                  build: (BuildContext context, double time) {
                                      print("time ---> ${time}");

                                   return   Row(
                                        children: [
                                          Expanded(flex:1,child: Container(
                                            alignment: AlignmentDirectional.center,
                                            child: Text(time.toInt() <= 0 ?"00":
                                              formatDuration(time.toInt())[0],
                                              style: TextStyle(
                                                  color: ColorManager.secondary,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: FontSize.s16
                                              ),
                                            ),
                                          )),
                                          Text(':',
                                            style: TextStyle(
                                                color: ColorManager.secondary,
                                                fontSize: FontSize.s16,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          Expanded(flex:1,child: Container(
                                            alignment: AlignmentDirectional.center,
                                            child: Text(remaningTime  <=0 ?"00":
                                              formatDuration(time.toInt())[1],
                                              style: TextStyle(
                                                  color: ColorManager.secondary,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: FontSize.s16
                                              ),
                                            ),
                                          )),
                                          Text(':',
                                            style: TextStyle(
                                                color: ColorManager.secondary,
                                                fontSize: FontSize.s16,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          Expanded(flex:1,child: Container(
                                            alignment: AlignmentDirectional.center,
                                            child: Text(time.toInt()  <= 0 ?"00":
                                              formatDuration(time.toInt())[2],
                                              style: TextStyle(
                                                  color: ColorManager.secondary,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: FontSize.s16
                                              ),
                                            ),
                                          )),
                                          Text(':',
                                            style: TextStyle(
                                                color: ColorManager.secondary,
                                                fontSize: FontSize.s16,
                                                fontWeight: FontWeight.w500

                                            ),),
                                          Expanded(flex:1,child: Container(
                                            alignment: AlignmentDirectional.center,
                                            child: Text(time.toInt() <= 0 ?"00":
                                              formatDuration(time.toInt())[3],
                                              style: TextStyle(
                                                  color: ColorManager.secondary,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: FontSize.s16
                                              ),
                                            ),
                                          )),

                                        ],

                                      );},
                                  interval: const Duration(seconds: 1),
                                  onFinished: () {
                                      remaningTime = 0;
                                      setState(() {

                                      });
                                    print('Timer is done!');
                                  },
                                )),
                                Expanded(flex:1,child:  Container(
                                  child: Row(
                                    children: [
                                      Expanded(flex:1,child: Container(
                                        alignment: AlignmentDirectional.center,
                                        child: Text(
                                          "daysString".tr(),
                                          style: TextStyle(
                                              color: ColorManager.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: FontSize.s8
                                          ),
                                        ),
                                      )),

                                      Expanded(flex:1,child: Container(
                                        alignment: AlignmentDirectional.center,
                                        child: Text(
                                          "hoursString".tr(),
                                          style: TextStyle(
                                              color: ColorManager.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: FontSize.s8
                                          ),
                                        ),
                                      )),

                                      Expanded(flex:1,child: Container(
                                        alignment: AlignmentDirectional.center,
                                        child: Text(
                                          "minutesString".tr(),
                                          style: TextStyle(
                                              color: ColorManager.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: FontSize.s8
                                          ),
                                        ),
                                      )),

                                      Expanded(flex:1,child: Container(
                                        alignment: AlignmentDirectional.center,
                                        child: Text(
                                          "secondsString".tr(),
                                          style: TextStyle(
                                              color: ColorManager.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: FontSize.s8
                                          ),
                                        ),
                                      )),

                                    ],

                                  ),
                                ))

                              ],
                            ),
                          )),

                          Expanded(flex:1,child: Container(
                            child: Image.asset(ImageAssets.clockLogo),
                          )),
                        ],
                      ),

                    ),
                  ),
                ),
              ),

              Container(
                child:remaningTime>0? Column(
                  children: [
                    Container(height: AppSize.s20,),
                    Container(
                      height: AppSize.s40,
                      margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child:  predictionModel!.data!.user!.x2.toString() == "0"?
                                x2=="0"?


                            GestureDetector(
                              onTap: (){

                                x2 = "1";
                                setState(() {

                                });
                              },
                              child: Container(
                                alignment: AlignmentDirectional.center,
                                width: AppSize.s100,
                                height: AppSize.s40,
                                decoration: BoxDecoration(
                                  color: ColorManager.secondary,
                                  borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
                                ),
                                child: Text(
                                  "pointTwo".tr(),
                                  style: TextStyle(
                                    color: ColorManager.white,
                                    fontSize: FontSize.s10,
                                    fontWeight: FontWeight.normal

                                  ),

                                ),
                              ),
                            ):
                                GestureDetector(
                                  onTap: (){

                                    x2 = "0";
                                    setState(() {

                                    });
                                  },
                                  child: Container(
                                    alignment: AlignmentDirectional.center,
                                    width: AppSize.s100,
                                    height: AppSize.s40,
                                    decoration: BoxDecoration(
                                        color: Color(0xFF07778E),
                                        borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
                                    ),
                                    child: Text(
                                      "pointTwo".tr(),
                                      style: TextStyle(
                                          color: ColorManager.white,
                                          fontSize: FontSize.s10,
                                          fontWeight: FontWeight.normal

                                      ),

                                    ),
                                  ),
                                ):
                            GestureDetector(

                              child: Container(
                                alignment: AlignmentDirectional.center,
                                width: AppSize.s100,
                                height: AppSize.s40,
                                decoration: BoxDecoration(
                                    color: Color(0xFF07778E),
                                    borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
                                ),
                                child: Text(
                                  "pointTwo".tr(),
                                  style: TextStyle(
                                      color: ColorManager.white,
                                      fontSize: FontSize.s10,
                                      fontWeight: FontWeight.normal

                                  ),

                                ),
                              ),
                            )
                          ),
                          Container(
                            child: predictionModel!.data!.user!.x3.toString() == "0"?
                                x3 == "0"?

                            GestureDetector(
                              onTap: (){
                                x3 = "1";
                                setState(() {

                                });
                              },
                              child: Container(
                                alignment: AlignmentDirectional.center,
                                width: AppSize.s100,
                                height: AppSize.s40,
                                decoration: BoxDecoration(
                                    color: ColorManager.secondary,
                                    borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
                                ),
                                child: Text(
                                  "pointThree".tr(),
                                  style: TextStyle(
                                      color: ColorManager.white,
                                      fontSize: FontSize.s10,
                                      fontWeight: FontWeight.normal

                                  ),

                                ),
                              ),
                            ):
                            GestureDetector(
                              onTap: (){
                                x3 = "0";
                                setState(() {

                                });
                              },
                              child: Container(
                                alignment: AlignmentDirectional.center,
                                width: AppSize.s100,
                                height: AppSize.s40,
                                decoration: BoxDecoration(
                                    color: Color(0xFF07778E),
                                    borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
                                ),
                                child: Text(
                                  "pointThree".tr(),
                                  style: TextStyle(
                                      color: ColorManager.white,
                                      fontSize: FontSize.s10,
                                      fontWeight: FontWeight.normal

                                  ),

                                ),
                              ),
                            ):
                            GestureDetector(

                              child: Container(
                                alignment: AlignmentDirectional.center,
                                width: AppSize.s100,
                                height: AppSize.s40,
                                decoration: BoxDecoration(
                                    color: Color(0xFF07778E),
                                    borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
                                ),
                                child: Text(
                                  "pointThree".tr(),
                                  style: TextStyle(
                                      color: ColorManager.white,
                                      fontSize: FontSize.s10,
                                      fontWeight: FontWeight.normal

                                  ),

                                ),
                              ),
                            ),
                          )

                        ],
                      )
                    ),
                    Container(height: AppSize.s20,),
                    Container(
                      height: AppSize.s40,
                      margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
                      child:
                      Container(

                        decoration: BoxDecoration(
                            color: ColorManager.blueBlack,
                            borderRadius: BorderRadius.all(Radius.circular(AppSize.s5))
                        ),
                        child: Container(
                          margin: EdgeInsets.all(AppSize.s5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Expanded(flex:1,child: Text(
                                "pointTwoDescription".tr(),
                                style: TextStyle(
                                  color: ColorManager.white,
                                  fontSize: FontSize.s9,
                                  fontWeight: FontWeight.normal
                                ),

                              )),
                              Expanded(flex:1,child: Text(
                                "pointThreeDescription".tr(),
                                style: TextStyle(
                                    color: ColorManager.white,
                                    fontSize: FontSize.s9,
                                    fontWeight: FontWeight.normal
                                ),

                              ))
                            ],
                          ),
                        ),

                      )
                    ),
                    Container(height: AppSize.s20,),
                  ],
                ):Container(
                  height: AppSize.s90,
                  margin: EdgeInsets.symmetric(horizontal: AppSize.s20,vertical: AppSize.s20),
                  decoration: BoxDecoration(
                      color: ColorManager.blueBlack,
                      borderRadius: BorderRadius.all(Radius.circular(AppSize.s5)),
                    border: Border.all(color: ColorManager.secondary,width: AppSize.s1)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:  EdgeInsets.all(AppSize.s8),
                        child: SvgPicture.asset('assets/images/no_predict.svg',width: AppSize.s30,height: AppSize.s30,),
                      ),
                      Text(

                        gw+" "+ "gwEnd".tr() ,
                        style: TextStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s12,
                            fontWeight: FontWeight.normal
                        ),
                        textAlign: TextAlign.center,

                      ),
                      SizedBox(height: AppSize.s4,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                           "stayTuned".tr() ,
                            style: TextStyle(
                                color: ColorManager.white,
                                fontSize: FontSize.s12,
                                fontWeight: FontWeight.normal
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            " ... ! " ,
                            style: TextStyle(
                                color: ColorManager.secondary,
                                fontSize: FontSize.s12,
                                fontWeight: FontWeight.normal
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                      
                    ],
                  ),

                )
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index){
                  return Container(
                    height: 220.h,
                    decoration: BoxDecoration(
                      color: ColorManager.blueBlack,
                      borderRadius: BorderRadius.all(Radius.circular(AppSize.s5)),


                    ),
                    child: Stack(
                      children: [
                        Positioned.directional(
                          textDirection: Directionality.of(context),
                          top: 0,
                          end: 0,
                          start: 0,
                          bottom: 0,
                          child: Container(
                            margin: EdgeInsets.all(AppSize.s20),
                            child: Column(
                              children: [
                                Expanded(flex:2,child: Stack(
                                  children: [
                                    Positioned.directional(
                                      textDirection: Directionality.of(context),
                                      child: Container(

                                        child: Row(

                                          children: [
                                            Expanded(flex:1,child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  children: [
                                                    Expanded(flex:1,child: GestureDetector(
                                                      onTap: (){
                                                        int goalOne =  int.parse(teams[index].goals1.toString());
                                                        goalOne++;
                                                        Teams team = teams[index];
                                                        team.goals1 = goalOne.toString();
                                                        teams[index]= team;
                                                        setState(() {

                                                        });
                                                      },
                                                      child: Container(
                                                        child: Container(
                                                          alignment: AlignmentDirectional.center,
                                                          margin: EdgeInsets.symmetric(vertical: AppSize.s2),
                                                          width: AppSize.s45,
                                                          decoration: BoxDecoration(
                                                              color: ColorManager.secondary,
                                                              borderRadius: BorderRadius.all(Radius.circular(AppSize.s2))
                                                          ),
                                                          child:
                                                          Icon(
                                                            Icons.add,
                                                            color: ColorManager.white,
                                                            size: AppSize.s15,
                                                          ),
                                                        ),
                                                      ),
                                                    )),

                                                    Expanded(flex:1,child: GestureDetector(
                                                      onTap: (){
                                                        int goalOne =  int.parse(teams[index].goals1.toString());
                                                        if(goalOne> 0) {
                                                          goalOne--;
                                                          Teams team = teams[index];
                                                          team.goals1 = goalOne.toString();
                                                          teams[index] = team;
                                                          setState(() {

                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        child: Container(
                                                          alignment: AlignmentDirectional.center,
                                                          margin: EdgeInsets.symmetric(vertical: AppSize.s2),
                                                          width: AppSize.s45,
                                                          decoration: BoxDecoration(
                                                              color: ColorManager.secondary,
                                                              borderRadius: BorderRadius.all(Radius.circular(AppSize.s2))
                                                          ),
                                                          child: Icon(
                                                            Icons.remove,
                                                            color: ColorManager.white,
                                                            size: AppSize.s15,
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                                  ],
                                                ),
                                                SizedBox(width: AppSize.s14,),
                                                Container(
                                                  height: AppSize.s30,
                                                  width: AppSize.s30,
                                                  alignment: AlignmentDirectional.center,
                                                  decoration: BoxDecoration(
                                                      color: ColorManager.primary,
                                                      shape: BoxShape.circle
                                                  ),
                                                  child: Text(
                                                    teams[index].goals1.toString(),style: TextStyle(
                                                    color: ColorManager.white,
                                                    fontSize: FontSize.s16
                                                  ),
                                                  ),
                                                ),


                                              ],
                                            )),
                                            Expanded(flex:1,child: Container(
                                              alignment: AlignmentDirectional.center,
                                              child: Container(
                                                width: MediaQuery.of(context).size.width,

                                                height:35.h,
                                                margin: EdgeInsets.symmetric(horizontal: 10.w),
                                                color: ColorManager.primary,
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      flex:1,

                                                      child: Center(
                                                        child: Text(teams![index].matchDate.toString(),
                                                          style: TextStyle(
                                                              color:ColorManager.white,
                                                              fontSize: FontSize.s8,
                                                              fontWeight: FontWeight.normal


                                                          ),),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Center(
                                                        child: Text(teams![index].matchTime.toString(),
                                                          style: TextStyle(
                                                              color:ColorManager.rectangle,
                                                              fontSize: FontSize.s8,
                                                              fontWeight: FontWeight.normal


                                                          ),),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                              ),
                                            )),
                                            Expanded(flex:1,child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: AppSize.s30,
                                                  width: AppSize.s30,
                                                  alignment: AlignmentDirectional.center,
                                                  decoration: BoxDecoration(
                                                      color: ColorManager.primary,
                                                      shape: BoxShape.circle
                                                  ),
                                                  child: Text(
                                                    teams[index].goals2.toString(),style: TextStyle(
                                                      color: ColorManager.white,
                                                      fontSize: FontSize.s16
                                                  ),
                                                  ),
                                                ),
                                                SizedBox(width: AppSize.s14,),
                                                Column(
                                                  children: [
                                                    Expanded(flex:1,child: GestureDetector(
                                                      onTap: (){
                                                        int goalOne =  int.parse(teams[index].goals2.toString());
                                                        goalOne++;
                                                        Teams team = teams[index];
                                                        team.goals2 = goalOne.toString();
                                                        teams[index]= team;
                                                        setState(() {

                                                        });

                                                      },
                                                      child: Container(
                                                        child: Container(
                                                          alignment: AlignmentDirectional.center,
                                                          margin: EdgeInsets.symmetric(vertical: AppSize.s2),
                                                          width: AppSize.s45,
                                                          decoration: BoxDecoration(
                                                              color: ColorManager.secondary,
                                                              borderRadius: BorderRadius.all(Radius.circular(AppSize.s2))
                                                          ),
                                                          child: Icon(
                                                            Icons.add,
                                                            color: ColorManager.white,
                                                            size: AppSize.s15,
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                                    Expanded(flex:1,child: GestureDetector(
                                                      onTap: (){
                                                        int goalOne =  int.parse(teams[index].goals2.toString());
                                                        if(goalOne> 0) {
                                                          goalOne--;
                                                          Teams team = teams[index];
                                                          team.goals2 = goalOne.toString();
                                                          teams[index] = team;
                                                          setState(() {

                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        child: Container(
                                                          alignment: AlignmentDirectional.center,
                                                          margin: EdgeInsets.symmetric(vertical: AppSize.s2),
                                                          width: AppSize.s45,
                                                          decoration: BoxDecoration(
                                                              color: ColorManager.secondary,
                                                              borderRadius: BorderRadius.all(Radius.circular(AppSize.s2))
                                                          ),
                                                          child: Icon(
                                                            Icons.remove,
                                                            color: ColorManager.white,
                                                            size: AppSize.s15,
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                                  ],
                                                )

                                              ],
                                            ))
                                          ],
                                        ),
                                      ),
                                    ),

                                  ],
                                )),
                                Container(height: AppSize.s10,),
                                Expanded(flex:4,child: Stack(
                                  children: [
                                    Positioned.directional(
                                      textDirection: Directionality.of(context),
                                      start: 0,
                                      end: 0,
                                      top: 0,
                                      bottom: 0,

                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(AppSize.s5)),
                                          color: ColorManager.white,
                                            border: teams[index].type == "1"?
                                            Border.all(color: const Color(0xFFC4BE6B),width: 4.w):null
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.all(AppSize.s20),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                flex:4,
                                                child: Row(
                                                  children: [
                                                    Expanded(flex:1,child: Column(
                                                      children: [
                                                        Expanded(flex:4,child: Container(
                                                          child:
                                                          CachedNetworkImage(
                                                            height: AppSize.s60,
                                                            width: AppSize.s60,
                                                            imageUrl:'$TAG_LOGO_URL${teams[index].logoTeam1.toString()}',
                                                            imageBuilder: (context, imageProvider) => Stack(
                                                              children: [
                                                                ClipRRect(

                                                                  child: Container(
                                                                      height: AppSize.s60,
                                                                      width: AppSize.s60,


                                                                      decoration: BoxDecoration(

                                                                        shape: BoxShape.rectangle,

                                                                        image: DecorationImage(
                                                                            fit: BoxFit.fill,
                                                                            image: imageProvider),
                                                                      )
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            placeholder: (context, url) =>
                                                                Center(
                                                                  child: SizedBox(
                                                                      height: AppSize.s50,
                                                                      width: AppSize.s50,
                                                                      child: const CircularProgressIndicator()),
                                                                ),


                                                            errorWidget: (context, url, error) => ClipRRect(
                                                              child: Icon(Icons.image_not_supported_outlined,color: ColorManager.navColor,
                                                                size: AppSize.s60,),

                                                            ),
                                                          ),

                                                        )),
                                                        Expanded(flex:1,child: Container(
                                                          alignment: AlignmentDirectional.center,
                                                          child: Text(
                                                            mLanguage == "en"?
                                                              teams[index].enTitleTeam1.toString():
                                                            teams[index].arTitleTeam1.toString(),
                                                            style: TextStyle(
                                                              color: ColorManager.black,
                                                              fontSize: FontSize.s11,
                                                              fontWeight: FontWeight.w500
                                                            ),
                                                          ),

                                                        ))
                                                      ],
                                                    )),
                                                    Container(
                                                      alignment: AlignmentDirectional.topCenter,
                                                      child: Text(
                                                        mLanguage == "en"?
                                                        teams[index].leagueEn.toString():
                                                        teams[index].leagueAr.toString(),
                                                        style: TextStyle(
                                                            color: ColorManager.black,
                                                            fontSize: FontSize.s11,
                                                            fontWeight: FontWeight.w500
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(flex:1,child: Column(
                                                      children: [
                                                        Expanded(flex:4,child: Container(
                                                          child:
                                                          CachedNetworkImage(
                                                            height: AppSize.s60,
                                                            width: AppSize.s60,

                                                            imageUrl:'$TAG_LOGO_URL${teams[index].logoTeam2.toString()}',
                                                            imageBuilder: (context, imageProvider) => Stack(
                                                              children: [
                                                                ClipRRect(

                                                                  child: Container(
                                                                      height: AppSize.s60,
                                                                      width: AppSize.s60,


                                                                      decoration: BoxDecoration(

                                                                        shape: BoxShape.rectangle,

                                                                        image: DecorationImage(
                                                                            fit: BoxFit.fill,
                                                                            image: imageProvider),
                                                                      )
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            placeholder: (context, url) =>
                                                                Center(
                                                                  child: SizedBox(
                                                                      height: AppSize.s50,
                                                                      width: AppSize.s50,
                                                                      child: const CircularProgressIndicator()),
                                                                ),


                                                            errorWidget: (context, url, error) => ClipRRect(
                                                              child: Icon(Icons.image_not_supported_outlined,color: ColorManager.navColor,
                                                                size: AppSize.s60,),

                                                            ),
                                                          ),

                                                        )),

                                                        Expanded(flex:1,child: Container(
                                                          alignment: AlignmentDirectional.center,
                                                          child: Text(
                                                            mLanguage == "en"?
                                                            teams[index].enTitleTeam2.toString():
                                                            teams[index].arTitleTeam2.toString(),
                                                            style: TextStyle(
                                                                color: ColorManager.black,
                                                                fontSize: FontSize.s11,
                                                                fontWeight: FontWeight.w500
                                                            ),
                                                          ),

                                                        ))
                                                      ],
                                                    ))

                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 10.h,),
                                              Expanded(flex:1,
                                                  child: Center(
                                                    child: Container(
                                                      height: 20.h,
                                                      width: 100.w,
                                                      alignment: AlignmentDirectional.center,
                                                      decoration: BoxDecoration(
                                                          color: ColorManager.primary,
                                                          borderRadius: BorderRadius.all(Radius.circular(10.h))
                                                      ),
                                                      child: Text(
                                                        teams![index].stadium.toString(),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.normal,
                                                          fontSize: FontSize.s8,



                                                        ),
                                                      ),
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned.directional(

                                        textDirection: Directionality.of(context),
                                        top: AppSize.s10,
                                        start: AppSize.s10,

                                        child: Container(
                                          child: teams[index].type == "1"? Image.asset(
                                            ImageAssets.fav,
                                            height: AppSize.s14,
                                            width: AppSize.s14,

                                          ):Container(),
                                        )),

                                  ],
                                )),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  );
                }, separatorBuilder: (context,index){
                  return Container(
                    height: AppSize.s20,
                  );
                }, itemCount: predictionModel!.data!.teams!.length),

              ),
              Container(height: AppSize.s30,),
              Container(
                  alignment: AlignmentDirectional.center,
                  margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
                  child: remaningTime > 0?


                  loginButton("sumbitPrediction".tr(),context):Container()



              ),

            ],
          )
        ),
      ),
    );
  }
  TextButton loginButton(String text,BuildContext context){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(

      minimumSize: Size(width, AppSize.s55 ),

      shape:  RoundedRectangleBorder(

        borderRadius: BorderRadius.all(Radius.circular(AppSize.s27)),
      ),
      backgroundColor: ColorManager.secondary,
    );

    return TextButton(
      style: flatButtonStyle,
      onPressed: () {
        validate(context);




      },
      child:
      Center(
        child: Text(text,style: TextStyle(
            color: ColorManager.black,
            fontSize: FontSize.s16,
            fontWeight: FontWeight.bold
        ),),
      ),
    );
  }
  int  getRemainingTime(String date ,String startTime){
    print('startTime ${startTime}');
    // if(startTime == ' :00'){
    //   startTime= '2023-02-20 15:20:55';
    // }

    DateTime now =  DateTime.parse(startTime);
    print(now);
    DateTime tempDate =  DateTime.parse(date);
    print(date);
    Duration difference = tempDate.difference(now);
    return difference.inSeconds;
  }
 List<String>  formatDuration(int d) {
    var seconds = d;
    final days = seconds~/Duration.secondsPerDay;
    seconds -= days*Duration.secondsPerDay;
    final hours = seconds~/Duration.secondsPerHour;
    seconds -= hours*Duration.secondsPerHour;
    final minutes = seconds~/Duration.secondsPerMinute;
    seconds -= minutes*Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('${days}');
    }else{
      tokens.add('00');
    }
    if (tokens.isNotEmpty || hours != 0){
      tokens.add('${hours}');
    }else{
      tokens.add('00');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('${minutes}');
    }else{
      tokens.add('00');
    }
    if (tokens.isNotEmpty || seconds != 0){
      tokens.add('${seconds}');
    }else{
      tokens.add('00');
    }

    print(tokens);

    return tokens;
  }

  void validate(BuildContext context) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("id")??"";
    final modelHud = Provider.of<ModelHud>(context,listen: false);
    modelHud.changeIsLoading(true);
    PointServices pointServices = PointServices();

    if(predictionModel!.data!.user!.x2.toString()!= "0"){
      x2 = "0";
    }
    if(predictionModel!.data!.user!.x3.toString()!="0"){
      x3 = "0";
    }

    Map<String, dynamic>   response = await pointServices.sumbitPrediction(teams, id,x2,x3);
    print('response ---> ${response}');
    modelHud.changeIsLoading(false);
    bool  isOk  = response['ok'];
    if(isOk){
      SumbitPredictModel sumbitPredictModel = SumbitPredictModel.fromJson(response);
      predictionModel!.data!.user!.x3 = sumbitPredictModel.data!.user!.x3;
      predictionModel!.data!.user!.x2 = sumbitPredictModel.data!.user!.x2;
      setState(() {

      });
      successDialog(context: context);
    }

  }
  void successDialog({required BuildContext context}) {

    showDialog(context: _scaffoldKey.currentState!.context, builder: (context){
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppSize.s10)),


        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
          width: AppSize.width,
          height: AppSize.s180,
          color: ColorManager.white,
          child: Container(
            margin: EdgeInsets.all(AppSize.s10),
            child: Column(
              children: [
                Expanded(flex:1,child: Container(
                  alignment: AlignmentDirectional.center,
                  child: Text("predict".tr(),
                    style: TextStyle(
                        color: ColorManager.black,
                        fontSize: FontSize.s15,
                        fontWeight: FontWeight.w500
                    ),),
                )),
                Expanded(flex:1,child: Container(
                  alignment: AlignmentDirectional.center,
                  child: Text("sumbittedPrediction".tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorManager.rectangle,
                        fontSize: FontSize.s15,
                        fontWeight: FontWeight.w500
                    ),),
                )),Expanded(flex:1,child: Container(
                  alignment: AlignmentDirectional.center,
                  child: Image.asset(ImageAssets.happyIcon,width: AppSize.s30,
                    height: AppSize.s30,fit: BoxFit.fill,),
                )),
                Expanded(flex:1,child: Container(
                    margin: EdgeInsets.symmetric(vertical: AppSize.s5,horizontal: AppSize.s20),
                    alignment: AlignmentDirectional.center,
                    child: addressButton("done".tr(),context)
                ))

              ],
            ),
          ),
        ),
      );
    });
  }
  TextButton addressButton(String text,BuildContext context){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(



      shape:  RoundedRectangleBorder(

        borderRadius: BorderRadius.all(Radius.circular(AppSize.s5)),
      ),
      backgroundColor: ColorManager.secondary,
    );

    return TextButton(
      style: flatButtonStyle,
      onPressed: () {
        Navigator.pop(context);
        // validate(context);



      },
      child:
      Center(
        child: Text(text,style: TextStyle(
            color: ColorManager.white,
            fontSize: FontSize.s10,
            fontWeight: FontWeight.bold
        ),),
      ),
    );
  }



}
