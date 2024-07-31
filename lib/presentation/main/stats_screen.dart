import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point/domain/error_status_model.dart';
import 'package:point/domain/leagues_model.dart';
import 'package:point/presentation/main/create_invitation_league_screen.dart';
import 'package:point/presentation/main/join_league_screen.dart';
import 'package:point/presentation/main/league_details_screen.dart';
import 'package:point/presentation/main/leagues_details_screen.dart';
import 'package:point/presentation/main/my_league_details_screen.dart';
import 'package:point/presentation/resources/font_manager.dart';
import 'package:point/presentation/resources/strings_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/point_services.dart';
import '../../app/constant.dart';
import '../photo/photo_screen.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/values_manager.dart';
import '../web/webview_screen.dart';
class StatsScreen extends StatefulWidget {
  GlobalKey<NavigatorState> page;
   StatsScreen({Key? key, required this.page}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  LeaguesModel? leaguesModel;
  int overAllPoints =0;
  String rank = "";
  bool? isOk;
  String? text;
  int _current =0;
  final CarouselController _controller = CarouselController();
  String mLanguage = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    leagues().then((value) {


      setState(() {
        leaguesModel = value;
      });

    });
  }


  String mOverAllPoints ="";

  Future<LeaguesModel?> leagues() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("id")??"";
    print('userId  ---> ${id}');

    mLanguage = sharedPreferences.getString(LANG_CODE)??"";
    PointServices pointServices = PointServices();
    dynamic response = await pointServices.leagues(id);
    isOk  = response['ok'];
    LeaguesModel? leaguesModel;

    if(isOk!){
    leaguesModel =  LeaguesModel.fromJson(response);

    // int size =0;
    // int mRank = 0;
    //
    // for(int i =0;i<leaguesModel.data!.leagues!.length;i++){
    //   overAllPoints += int.parse(leaguesModel.data!.leagues![i].points!);
    //    mRank += int.parse(leaguesModel.data!.leagues![i].rank!);
    //   size++;
    //
    // }
    mOverAllPoints = leaguesModel.data!.user![0].points.toString();
    // double dRank =mRank.toDouble()/size.toDouble();
    rank = leaguesModel.data!.user![0].rank.toString();
    }else{
      // message = "noData".tr();
      // errorStatusModel = ErrorStatusModel.fromJson(response);
      leaguesModel = null;

    }

    return leaguesModel;
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
          child: isOk == null?
          Container(
            child: const CircularProgressIndicator(


            ),
            alignment: AlignmentDirectional.center,
          ):


                ListView(
                  padding: EdgeInsets.zero,
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Container(height: AppSize.s10,),
                    Container(
                      child: leaguesModel!.data!.banners!.isEmpty?
                      Container():Column(
                        children: [
                          Container(height: 250.h,
                          margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
                          child:
                          CarouselSlider(

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
                            items: leaguesModel?.data!.banners!.map((item) =>
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

                          ),),
                          Container(height: AppSize.s20,),
                        ],
                      ),
                    ),
                    Container(margin: EdgeInsets.symmetric(horizontal: AppSize.s45),
                      child:isOk!?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text( "overAllPoints".tr() + mOverAllPoints.toString(),
                          style: TextStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s12,
                            fontWeight: FontWeight.w500,
                          ),),
                          Text( "overAllRank".tr() + rank.toString(),
                            style: TextStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s12,
                              fontWeight: FontWeight.w500,
                            ),)
                        ],
                      ):Container(),


                    ),
                    Container(height: AppSize.s20,),

                    Container(
                      alignment: AlignmentDirectional.center,
                        child: Text("leagues".tr(),
                        style: TextStyle(
                          color: ColorManager.white,
                          fontWeight: FontWeight.w500,
                          fontSize: FontSize.s12,
                        ),)),
                    Container(height: AppSize.s10,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: AppSize.s45),
                      height: AppSize.s42,
                      child: Row(
                        children: [
                          Expanded(flex:1,
                              child: GestureDetector(
                                onTap: (){
                                  widget.page.currentState!.push(MaterialPageRoute(builder: (context) =>  JoinLeagueScreen(page: widget.page,leaguesModel: leaguesModel!,)));
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => const JoinLeagueScreen()),
                                  // );
                                },
                                child: Container(
                                  alignment: AlignmentDirectional.center,
                                  decoration: BoxDecoration(
                                      color: ColorManager.rectangle,

                                      borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
                                  ),
                                  child: Text(
                                    "joinLeagues".tr(),
                                    style: TextStyle(
                                      color: ColorManager.black,
                                      fontSize: FontSize.s12,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),


                                ),
                              )),
                          SizedBox(width: AppSize.s10,),
                          Expanded(flex:1,
                              child: GestureDetector(
                                onTap: (){
                                  widget.page.currentState!.push(MaterialPageRoute(builder: (context) =>  CreateInvitationLeagueScreen(page: widget.page,leaguesModel: leaguesModel!,)));

                                },
                                child: Container(
                                  alignment: AlignmentDirectional.center,
                                  decoration: BoxDecoration(
                                      color: ColorManager.rectangle,

                                      borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
                                  ),
                                  child: Text(
                                    "createLeagues".tr(),
                                    style: TextStyle(
                                        color: ColorManager.black,
                                        fontSize: FontSize.s12,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),


                                ),
                              )),
                        ],
                      ),

                    ),
                    Container(height: AppSize.s20,),
                    Container(
                      child: leaguesModel!.data!.leagues!.isNotEmpty?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(margin: EdgeInsets.symmetric(horizontal: AppSize.s45),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text( "league".tr(),
                                  style: TextStyle(
                                    color: ColorManager.white,
                                    fontSize: FontSize.s12,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                Text( "currentRank".tr(),
                                  style: TextStyle(
                                    color: ColorManager.white,
                                    fontSize: FontSize.s12,
                                    fontWeight: FontWeight.w500,
                                  ),)
                              ],
                            ),


                          ),
                          Container(height: AppSize.s10,),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: AppSize.s40),
                            child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context,index){
                              return GestureDetector(
                                onTap: (){
                                  widget.page.currentState!.push(MaterialPageRoute(builder: (context) =>  LeaguesDetailsScreen(page: widget.page, leagues: leaguesModel!.data!.leagues![index],)));

                                },
                                child: Container(
                                  height: AppSize.s33,
                                  decoration: BoxDecoration(
                                    color: ColorManager.white,
                                    borderRadius: BorderRadius.all(Radius.circular(AppSize.s8)),
                                    border: Border.all(color: ColorManager.rectangle,width: AppSize.s2)



                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(AppSize.s4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex:1,
                                          child: Container(
                                            alignment: AlignmentDirectional.centerStart,
                                            child: Container(
                                              alignment: AlignmentDirectional.center,
                                              height:AppSize.s24,
                                              width: AppSize.s24,

                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: ColorManager.primary
                                              ),
                                              child: Text(
                                                '${index+1}',
                                                style: TextStyle(
                                                  color: ColorManager.white,
                                                  fontSize: FontSize.s11,
                                                  fontWeight: FontWeight.w500

                                                ),
                                              ),

                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(leaguesModel!.data!.leagues![index].title.toString(),
                                          style: TextStyle(
                                            color: ColorManager.selectedRectangle,
                                            fontSize: FontSize.s11
                                          ),),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [

                                              Container(
                                                alignment: AlignmentDirectional.center,
                                                child: getRank(leaguesModel!.data!.leagues![index].subLeagPRank.toString(), leaguesModel!.data!.leagues![index].subLeagRank.toString()) == 0?
                                              Image.asset(ImageAssets.equalArrow,
                                              height: AppSize.s7,width: AppSize.s7,
                                              fit: BoxFit.fill,):getRank(leaguesModel!.data!.leagues![index].subLeagPRank.toString(), leaguesModel!.data!.leagues![index].subLeagRank.toString()) == 1?
                                                Image.asset(ImageAssets.downArrow,
                                                  height: AppSize.s5,width: AppSize.s9,
                                                  fit: BoxFit.fill,):Image.asset(ImageAssets.upArrow,
                                                  height: AppSize.s5,width: AppSize.s9,
                                                  fit: BoxFit.fill,),

                                              ),
                                              Text(leaguesModel!.data!.leagues![index].subLeagRank.toString(),
                                                style: TextStyle(
                                                    color: ColorManager.selectedRectangle,
                                                    fontSize: FontSize.s11
                                                ),),
                                            ],
                                          ),
                                        )

                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }, separatorBuilder: (context,index){
                              return Container(height: AppSize.s20);
                            }, itemCount: leaguesModel!.data!.leagues!.length),
                          ),

                        ],
                      ):Container(
                        height: AppSize.s200,
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          'You have not joined any league yet.',
                          style: TextStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s14,
                            fontWeight: FontWeight.normal
                          ),

                        ),
                      ),
                    ),
                    Container(height: AppSize.s20,),
                    Container(
                      child: leaguesModel!.data!.create!.isNotEmpty?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(margin: EdgeInsets.symmetric(horizontal: AppSize.s45),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text( "myLeagues".tr(),
                                  style: TextStyle(
                                    color: ColorManager.white,
                                    fontSize: FontSize.s12,
                                    fontWeight: FontWeight.w500,
                                  ),),

                              ],
                            ),


                          ),
                          Container(height: AppSize.s10,),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: AppSize.s40),
                            child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context,index){
                                  return GestureDetector(
                                    onTap: (){
                                      widget.page.currentState!.push(MaterialPageRoute(builder: (context) =>  MyLeagueDetailsScreen(page: widget.page, leagueId: leaguesModel!.data!.create![index].id.toString(),)));

                                    },
                                    child: Container(
                                      height: AppSize.s33,
                                      decoration: BoxDecoration(
                                          color: ColorManager.white,
                                          borderRadius: BorderRadius.all(Radius.circular(AppSize.s8)),
                                          border: Border.all(color: ColorManager.rectangle,width: AppSize.s2)



                                      ),
                                      child: Container(
                                        margin: EdgeInsets.all(AppSize.s4),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex:1,
                                              child: Container(
                                                alignment: AlignmentDirectional.centerStart,
                                                child: Container(
                                                  alignment: AlignmentDirectional.center,
                                                  height:AppSize.s24,
                                                  width: AppSize.s24,

                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: ColorManager.primary
                                                  ),
                                                  child: Text(
                                                    '${index+1}',
                                                    style: TextStyle(
                                                        color: ColorManager.white,
                                                        fontSize: FontSize.s11,
                                                        fontWeight: FontWeight.w500

                                                    ),
                                                  ),

                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text(leaguesModel!.data!.create![index].title.toString(),
                                                style: TextStyle(
                                                    color: ColorManager.selectedRectangle,
                                                    fontSize: FontSize.s11
                                                ),),
                                            ),


                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }, separatorBuilder: (context,index){
                              return Container(height: AppSize.s20);
                            }, itemCount: leaguesModel!.data!.create!.length),
                          ),
                          SizedBox(height: AppSize.s100,),
                        ],
                      ):Container(
                        height: AppSize.s200,
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          'You have not created any league yet.',
                          style: TextStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s14,
                              fontWeight: FontWeight.normal
                          ),

                        ),
                      ),
                    )

                  ],

                )




        ),


      ),
    );
  }

  int getRank(String pRank,String rank){
    int result =0;
    if(int.parse(pRank)>int.parse(rank)){
      result = -1;


    }else if(int.parse(pRank)<int.parse(rank)){
      result = 1;
    }else{
      result = 0;
    }
    return result;

  }
}
