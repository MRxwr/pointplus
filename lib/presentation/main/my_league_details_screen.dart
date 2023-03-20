import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:point/domain/view_my_league_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/point_services.dart';
import '../../app/constant.dart';
import '../../domain/league_details_model.dart';
import '../../domain/leagues_model.dart';
import '../photo/photo_screen.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/values_manager.dart';
import '../web/webview_screen.dart';
class MyLeagueDetailsScreen extends StatefulWidget {
  GlobalKey<NavigatorState> page;
  String leagueId;
  MyLeagueDetailsScreen({Key? key,required this.page, required this.leagueId }) : super(key: key);



  @override
  State<MyLeagueDetailsScreen> createState() => _MyLeagueDetailsScreenState();
}

class _MyLeagueDetailsScreenState extends State<MyLeagueDetailsScreen> {
  bool isCopied = false;
  ViewMyLeagueModel? leaguesModel;

  final TextEditingController _codeController =  TextEditingController();
  final CarouselController _controller = CarouselController();
  int _current =0;
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

  Future<ViewMyLeagueModel?> leagues() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    mLanguage = sharedPreferences.getString(LANG_CODE)??"";
    String id = sharedPreferences.getString("id")??"";
    PointServices pointServices = PointServices();
    ViewMyLeagueModel? leaguesModel = await pointServices.viewMyLeague(widget.leagueId);

    return leaguesModel;
  }
  String mLanguage = "";
  Future<String>init() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("id")??"";


    return mLanguage;
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
          child:leaguesModel == null?
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
                child: leaguesModel!.data!.banners!.isEmpty?
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
                        items: leaguesModel!.data!.banners!.map((item) =>
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
                  child: Text(leaguesModel!.data!.league![0].title.toString(),
                    style: TextStyle(
                      color: ColorManager.white,
                      fontWeight: FontWeight.w500,
                      fontSize: FontSize.s17,
                    ),)),
              Container(height: AppSize.s5,),
              Container(
                  alignment: AlignmentDirectional.center,
                  child: Text("Joined".tr()+"(${leaguesModel!.data!.league![0].title.toString()})",
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
                              "leagueCode".tr()+" : "+leaguesModel!.data!.league![0].code.toString(),
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
                            Clipboard.setData( ClipboardData(text:leaguesModel!.data!.league![0].code.toString() ));
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
                  child: Text("invite".tr() +leaguesModel!.data!.league![0].title.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(

                      color: ColorManager.white,
                      fontWeight: FontWeight.w500,
                      fontSize: FontSize.s17,
                    ),)),

              Container(height: AppSize.s50,),
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
