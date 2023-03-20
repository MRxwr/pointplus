import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:point/domain/home_model.dart';
import 'package:point/domain/league_details_model.dart';
import 'package:point/domain/leagues_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/point_services.dart';
import '../../app/constant.dart';
import '../../domain/leagues_details_model.dart';
import '../../domain/profile_model.dart';
import '../photo/photo_screen.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import '../web/webview_screen.dart';
class LeaguesDetailsScreen extends StatefulWidget {
  GlobalKey<NavigatorState> page;

  Leagues leagues;


  LeaguesDetailsScreen({Key? key,required this.page,required this.leagues}) : super(key: key);

  @override
  State<LeaguesDetailsScreen> createState() => _LeaguesDetailsScreen();
}


class _LeaguesDetailsScreen extends State<LeaguesDetailsScreen> {
  bool isCopied = false;
  List<Users> usersList =[];
  final CarouselController _controller = CarouselController();
  int _current =0;
  String mLanguage = "";
  ProfileModel? profileModel;
  Future<LeaguesDetailsModel?> leagues() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("id")??"";

    mLanguage = sharedPreferences.getString(LANG_CODE)??"";
    PointServices pointServices = PointServices();

    LeaguesDetailsModel? leaguesModel = await pointServices.leaguesDetailsModel(widget.leagues.id);
    Map<String,dynamic> map = {};
    map['id']= id;

    profileModel = await pointServices.profile(map);
    usersList =leaguesModel!.data!.users!;
    // usersList.sort((a, b) {
    //   return Comparable.compare(int.parse(a.points!), int.parse(b.points!));
    // });

    return leaguesModel;
  }
  LeaguesDetailsModel? leaguesDetailsModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    leagues().then((value){
      setState(() {
        leaguesDetailsModel = value;
      });

    });
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

          child: leaguesDetailsModel == null?
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
                child: leaguesDetailsModel!.data!.banners!.isEmpty?
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
                        items: leaguesDetailsModel!.data!.banners!.map((item) =>
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
              ),
              Container(
                  alignment: AlignmentDirectional.center,
                  child: Text(leaguesDetailsModel!.data!.league![0].title.toString(),
                    style: TextStyle(
                      color: ColorManager.white,
                      fontWeight: FontWeight.w500,
                      fontSize: FontSize.s17,
                    ),)),
              Container(height: AppSize.s5,),
              Container(
                  alignment: AlignmentDirectional.center,
                  child: Text("Joined".tr()+"(${leaguesDetailsModel!.data!.users!.length})",
                    style: TextStyle(
                      color: ColorManager.white,
                      fontWeight: FontWeight.w500,
                      fontSize: FontSize.s12,
                    ),)),
              Container(height: AppSize.s10,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: AppSize.s30),
                height: AppSize.s34,
                child: Row(
                  children: [
                    Expanded(flex:1,
                        child: GestureDetector(
                          onTap: (){
                            // widget.page.currentState!.push(MaterialPageRoute(builder: (context) =>  JoinLeagueScreen(page: widget.page,)));
                            // // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => const JoinLeagueScreen()),
                            // );
                          },
                          child: Container(
                            alignment: AlignmentDirectional.center,
                            decoration: BoxDecoration(
                                color: ColorManager.white,

                                borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
                            ),
                            child: Text(
                              "leagueCode".tr()+" : "+leaguesDetailsModel!.data!.league![0].code.toString(),
                              style: TextStyle(
                                  color: ColorManager.background,
                                  fontSize: FontSize.s10,
                                  fontWeight: FontWeight.w500
                              ),
                            ),


                          ),
                        )),
                    SizedBox(width: AppSize.s20,),
                    Expanded(flex:1,
                        child: GestureDetector(
                          onTap: (){
                            Clipboard.setData( ClipboardData(text:leaguesDetailsModel!.data!.league![0].code.toString()));
                            isCopied = true;
                            setState(() {

                            });

                            // widget.page.currentState!.push(MaterialPageRoute(builder: (context) =>  CreateInvitationLeagueScreen(page: widget.page,)));

                          },
                          child: Container(
                            alignment: AlignmentDirectional.center,
                            decoration: BoxDecoration(
                                color: ColorManager.rectangle,

                                borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
                            ),
                            child: Text(
                              isCopied?"copied".tr(): "copyCode".tr(),
                              style: TextStyle(
                                  color: ColorManager.backGroundColor,
                                  fontSize: FontSize.s10,
                                  fontWeight: FontWeight.w500
                              ),
                            ),


                          ),
                        )),
                  ],
                ),

              ),
              Container(height: AppSize.s50,),
              Container(
                  alignment: AlignmentDirectional.center,
                  child: Text("invite".tr() +leaguesDetailsModel!.data!.league![0].title.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(

                      color: ColorManager.white,
                      fontWeight: FontWeight.w500,
                      fontSize: FontSize.s17,
                    ),)),
              Container(height: AppSize.s10,),

              Container(
                margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
                child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return profileModel!.data!.user![0].username == usersList[index].username?Container(
                        height: AppSize.s40,
                        margin: EdgeInsets.all(AppSize.s4),
                        decoration: BoxDecoration(
                            color: ColorManager.rectangle,

                            borderRadius: BorderRadius.all(Radius.circular(AppSize.s25))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: AppSize.s40,
                                  width: AppSize.s40,
                                  alignment: AlignmentDirectional.center,
                                  margin: EdgeInsets.all(AppSize.s4),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ColorManager.white
                                  ),
                                  child: Text('${index+1}',
                                    style: TextStyle(
                                        color: ColorManager.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: FontSize.s14
                                    ),


                                  ),
                                ),
                                Container(width: AppSize.s14,),
                                Text(usersList[index].username.toString(),
                                  style: TextStyle(
                                      color: ColorManager.black,
                                      fontSize: FontSize.s12,
                                      fontWeight: FontWeight.normal
                                  ),),
                              ],
                            ),
                            Row(
                              children: [
                                Text(usersList[index].points.toString(),
                                  style: TextStyle(
                                      color: ColorManager.black,
                                      fontSize: FontSize.s12,
                                      fontWeight: FontWeight.normal
                                  ),),
                                Container(width: AppSize.s8,),
                                Text("pts".tr(),
                                  style: TextStyle(
                                      color: ColorManager.white,
                                      fontSize: FontSize.s12,
                                      fontWeight: FontWeight.normal
                                  ),),
                                Container(width: AppSize.s16,),
                              ],
                            )
                          ],
                        ),



                      ):
                      Container(
                        height: AppSize.s40,
                        margin: EdgeInsets.all(AppSize.s4),
                        decoration: BoxDecoration(
                            color: ColorManager.selectedRectangle,

                            borderRadius: BorderRadius.all(Radius.circular(AppSize.s25))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: AppSize.s40,
                                  width: AppSize.s40,
                                  alignment: AlignmentDirectional.center,
                                  margin: EdgeInsets.all(AppSize.s4),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ColorManager.selectedCircle
                                  ),
                                  child: Text('${index+1}',
                                    style: TextStyle(
                                        color: ColorManager.rectangle,
                                        fontWeight: FontWeight.normal,
                                        fontSize: FontSize.s14
                                    ),


                                  ),
                                ),
                                Container(width: AppSize.s14,),
                                Text(usersList[index].username.toString(),
                                  style: TextStyle(
                                      color: ColorManager.white,
                                      fontSize: FontSize.s12,
                                      fontWeight: FontWeight.normal
                                  ),),
                              ],
                            ),
                            Row(
                              children: [
                                Text(usersList[index].points.toString(),
                                  style: TextStyle(
                                      color: ColorManager.rectangle,
                                      fontSize: FontSize.s12,
                                      fontWeight: FontWeight.normal
                                  ),),
                                Container(width: AppSize.s8,),
                                Text("pts".tr(),
                                  style: TextStyle(
                                      color: ColorManager.white,
                                      fontSize: FontSize.s12,
                                      fontWeight: FontWeight.normal
                                  ),),
                                Container(width: AppSize.s16,),
                              ],
                            )
                          ],
                        ),



                      );
                    }, separatorBuilder: (context,index){
                  return Container(height: AppSize.s10,);
                }, itemCount: usersList.length),
              ),
              Container(height: AppSize.s20,),
              GestureDetector(
                onTap: (){
                  widget.page.currentState!.pop();
                },
                child: Container(height: AppSize.s70,
                  alignment: AlignmentDirectional.center,
                  margin: EdgeInsets.symmetric(horizontal: AppSize.s30),
                  decoration: BoxDecoration(
                      color: ColorManager.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(AppSize.s35))
                  ),
                  child: Text("back".tr(),
                    style: TextStyle(
                      color: ColorManager.black,
                      fontSize: FontSize.s16,
                      fontWeight: FontWeight.w500,

                    ),),
                ),
              ),
              Container(height: AppSize.s50,),
            ],
          ),
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
