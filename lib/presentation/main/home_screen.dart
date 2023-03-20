

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point/api/point_services.dart';
import 'package:point/domain/home_model.dart';
import 'package:point/domain/profile_model.dart';
import 'package:point/presentation/resources/color_manager.dart';
import 'package:point/presentation/resources/font_manager.dart';
import 'package:point/presentation/resources/strings_manager.dart';
import 'package:point/presentation/resources/values_manager.dart';
import 'package:point/providers/notification_provider.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../app/constant.dart';
import '../photo/photo_screen.dart';
import '../resources/assets_manager.dart';
import '../web/webview_screen.dart';
import 'leadership_screen.dart';

class HomeScreen extends StatefulWidget {
  GlobalKey<NavigatorState> page;
    HomeScreen({Key? key,required this.page}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeModel? homeModel;
  final CarouselController _controller = CarouselController();
  int _current =0;
  List<bool> round=[];
  List<Matches>? matches;
  List<Leaderboard> leaderBordList =[];
  String mLanguage = "";
  ProfileModel? profileModel;
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    home().then((value) {
      setState(() {
        homeModel = value;
      });

    });
  }
  String? points;
  String? rank;

  Future<HomeModel?> home()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    mLanguage = sharedPreferences.getString(LANG_CODE)??"";
    String id = sharedPreferences.getString("id")??"";
    // id = "5";
    print('id  ---> ${id}');
    PointServices pointServices = PointServices();
    HomeModel? homeModel = await pointServices.home(id);
    Map<String,dynamic> map = {};
    map['id']= id;

  profileModel = await pointServices.profile(map);
    sharedPreferences.setString('gw',"GW "+ homeModel!.data!.rounds![0].round.toString());
    Provider.of<NotificationProvider>(context,listen: false).changeNotification(homeModel!.data!.user!.notifications.toString());
    points = homeModel?.data!.user!.points ;
    rank = homeModel?.data!.user!.rank ;
    matches = homeModel!.data!.matches!;
  leaderBordList = homeModel.data!.leaderboard!;
    leaderBordList.sort((a, b) {
      return Comparable.compare(int.parse(a.points!), int.parse(b.points!));
    });
    leaderBordList = leaderBordList.reversed.toList();

    for(int i =0;i<homeModel.data!.rounds!.length;i++){
      if(i ==0){
        round.add(true);
      }else{
        round.add(false);
      }
    }
    return homeModel;
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

child: homeModel == null?
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
        height: AppSize.s150,
  margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
        child: Column(
          children: [
            Container(
              child: homeModel!.data!.banners!.isEmpty
                  ?Container():SizedBox(
                height: AppSize.s126,

                width: AppSize.width,
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
                  items: homeModel?.data!.banners!.map((item) =>
                      Stack(

                        children: [
                          GestureDetector(
                            onTap: (){
                              String? url = item.url;
                              if(Uri.parse(url!).isAbsolute){
                                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (BuildContext context){
                                  return  WebViewScreen(url:url,
                                    title:item.enTitle.toString() ,);
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
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: AppSize.s10),
                                    child: ClipRRect(
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
                                ),
                              ],
                            ),
                          ),

                        ] ,
                      )).toList(),

                ),
              ),
            ),
            SizedBox(height: AppSize.s10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: homeModel!.data!.banners!.map((item) {
                int? index =homeModel?.data!.banners!.indexOf(item);
                return Container(
                  width: AppSize.s8,
                  height:AppSize.s8,
                  margin: EdgeInsets.symmetric(vertical: AppSize.s2, horizontal: AppSize.s2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? ColorManager.rectangle
                        : ColorManager.white,
                  ),
                );
              }).toList(),
            ),



          ],
        ),
      ),
      SizedBox(height: AppSize.s4,),
      Container(
        height: AppSize.s50,
        width: AppSize.width,
        margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
        child: Row(
          children: [
            Expanded(flex:10,child:
            Container(
              height: AppSize.s50,
              decoration: BoxDecoration(
                color: ColorManager.rectangle,

                  borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
              ),
              child: Container(
               margin: EdgeInsets.all(AppSize.s8),

                child: Row(

                  children:  [

                    Expanded(
                      flex:3,
                      child:
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: AppSize.s4),
                        child: Column(

                          children: [
                            Expanded(
                              flex: 1,

                              child: Container(
                                alignment: AlignmentDirectional.center,
                                color: ColorManager.primary,


                                child: Text("last_week".tr(),

                                  style: TextStyle(
                                  color: ColorManager.white,
                                  fontSize: FontSize.s10,
                                  fontWeight: FontWeight.normal,

                                ),),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: AppSize.height,
                                width: AppSize.width,
                                alignment: AlignmentDirectional.center,
                                child: Text(

                                  "GW ${homeModel!.data!.user!.stats![1].round}",
                                  style: TextStyle(
                                    color: ColorManager.primary,
                                    fontSize: ScreenUtil().setSp(12)
                                  ),
                                ),

                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                    Expanded(flex:1,child: Container(
                      alignment: AlignmentDirectional.center,
                      decoration: BoxDecoration(
                        color: ColorManager.primary,
                        borderRadius: BorderRadius.circular(AppSize.s5)
                      ),
                      child: Text(
                        homeModel!.data!.user!.stats![1].totalPoints.toString(),
                        style: TextStyle(
                          color: ColorManager.white,
                          fontSize: ScreenUtil().setSp(14)
                        ),
                      ),
                    ))


                  ],
                ),
              ),
            )),
            Expanded(flex:1,child: Container(
              height: AppSize.s50,


            )),
            Expanded(flex:10,child:
            Container(
              height: AppSize.s50,
              decoration: BoxDecoration(
                  color: ColorManager.rectangle,

                  borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
              ),
              child: Container(
                margin: EdgeInsets.all(AppSize.s8),

                child: Row(

                  children:  [

                    Expanded(
                      flex:3,
                      child:
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: AppSize.s4),
                        child: Column(

                          children: [
                            Expanded(
                              flex: 1,

                              child: Container(
                                alignment: AlignmentDirectional.center,
                                color: ColorManager.primary,


                                child: Text("current_week".tr(),

                                  style: TextStyle(
                                    color: ColorManager.white,
                                    fontSize: FontSize.s10,
                                    fontWeight: FontWeight.normal,

                                  ),),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: AppSize.height,
                                width: AppSize.width,
                                alignment: AlignmentDirectional.center,
                                child: Text(

                                  "GW ${homeModel!.data!.user!.stats![0].round}",
                                  style: TextStyle(
                                      color: ColorManager.primary,
                                      fontSize: ScreenUtil().setSp(12)
                                  ),
                                ),

                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                    Expanded(flex:1,child: Container(
                      alignment: AlignmentDirectional.center,
                      decoration: BoxDecoration(
                          color: ColorManager.primary,
                          borderRadius: BorderRadius.circular(AppSize.s5)
                      ),
                      child: Text(
                        homeModel!.data!.user!.stats![0].totalPoints.toString(),
                        style: TextStyle(
                            color: ColorManager.white,
                            fontSize: ScreenUtil().setSp(14)
                        ),
                      ),
                    ))


                  ],
                ),
              ),
            )),


          ],
        ),
      ),
      SizedBox(height: AppSize.s10,),
      Container(
        height: AppSize.s50,
        width: AppSize.width,
        decoration: BoxDecoration(
            color: ColorManager.rectangle,

            borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
        ),
        margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("totalPoints".tr(),
                style: TextStyle(
                  color: ColorManager.white,
                  fontSize: FontSize.s10,
                  fontWeight: FontWeight.normal

                ),),
                Text(points!,
                  style: TextStyle(
                      color: ColorManager.black,
                      fontSize: FontSize.s22,
                      fontWeight: FontWeight.normal

                  ),)
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("rank".tr(),
                  style: TextStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s10,
                      fontWeight: FontWeight.normal

                  ),),
                Text(rank!,
                  style: TextStyle(
                      color: ColorManager.black,
                      fontSize: FontSize.s22,
                      fontWeight: FontWeight.normal

                  ),)
              ],
            ),
            Container(
              alignment: AlignmentDirectional.center,
              child: getRank(homeModel!.data!.user!.pRank.toString(), homeModel!.data!.user!.rank.toString()) == 0?
              Image.asset(ImageAssets.equalArrow,
                height: AppSize.s7,width: AppSize.s7,
                fit: BoxFit.fill,):getRank(homeModel!.data!.user!.pRank.toString(), homeModel!.data!.user!.rank.toString()) == 1?
              Image.asset(ImageAssets.downArrow,
                height: AppSize.s5,width: AppSize.s9,
                fit: BoxFit.fill,):Image.asset(ImageAssets.upArrow,
                height: AppSize.s5,width: AppSize.s9,
                fit: BoxFit.fill,),

            ),
          ],
        ),
      ),
      SizedBox(height: AppSize.s20,),
      Container(
        margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("leaderShip".tr(),
            style: TextStyle(
              color: ColorManager.white,
              fontSize: FontSize.s12,
              fontWeight: FontWeight.normal

            ),)
            ,    GestureDetector(
              onTap: (){
                widget.page.currentState!.push(MaterialPageRoute(builder: (context) =>   LeaderShipScreen(page: widget.page,)));

              },
              child: Text("viewall".tr(),
                style: TextStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s12,
                    fontWeight: FontWeight.normal

                ),),
            )

          ],
        ),

      ),
      SizedBox(height: AppSize.s20,),
      Container(
        margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
        child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
          return leaderBordList[index].username == profileModel!.data!.user![0].username?Container(
            height: AppSize.s50,
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
          height: AppSize.s50,
          width: AppSize.s50,
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
        Text(leaderBordList[index].username.toString(),
        style: TextStyle(
          color: ColorManager.black,
          fontSize: FontSize.s12,
          fontWeight: FontWeight.normal
        ),),
      ],
  ),
  Row(
      children: [
        Text(leaderBordList[index].points.toString(),
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
            height: AppSize.s50,
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
                      height: AppSize.s50,
                      width: AppSize.s50,
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
                    Text(leaderBordList[index].username.toString(),
                      style: TextStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s12,
                          fontWeight: FontWeight.normal
                      ),),
                  ],
                ),
                Row(
                  children: [
                    Text(leaderBordList[index].points.toString(),
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
        }, itemCount: leaderBordList.length),
      ),
      SizedBox(height: AppSize.s20,),
      Container(
        margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("gameHistory".tr(),
              style: TextStyle(
                  color: ColorManager.white,
                  fontSize: FontSize.s12,
                  fontWeight: FontWeight.normal

              ),)


          ],
        ),

      ),
      SizedBox(height: AppSize.s20,),
      Container(
        height: AppSize.s30,
        margin: EdgeInsetsDirectional.only(start: AppSize.s20),
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,

            itemBuilder: (context,index){
              return GestureDetector(
                onTap: () async{
                  for(int i =0;i<round.length;i++){
                    if(i == index){
                      round[i] = true;
                    }else{
                      round[i] = false;
                    }
                  }
                  matches = null;
                  setState(() {

                  });

                  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                  mLanguage = sharedPreferences.getString(LANG_CODE)??"";
                  String id = sharedPreferences.getString("id")??"";
                  print('id  ---> ${id}');
                  PointServices pointServices = PointServices();
                  HomeModel? homeRoundModel = await pointServices.roundHome(id,homeModel!.data!.rounds![index].round.toString());
                  matches = homeRoundModel!.data!.matches!;
                  setState(() {

                  });

                },
                child: Container(
                  width: AppSize.s66,
                    alignment: AlignmentDirectional.center,
                    decoration: BoxDecoration(
                        color:round[index]? ColorManager.rectangle:ColorManager.white,

                        borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
                    ),
                  child: Text(
                     "gw".tr()+ homeModel!.data!.rounds![index].round.toString(),
                    style: TextStyle(
                      color: ColorManager.black,
                      fontSize: FontSize.s12,
                      fontWeight: FontWeight.normal
                    ),

                  ),

                ),
              );
            }, separatorBuilder: (context,index){
              return Container(width: AppSize.s20,);
        }, itemCount: homeModel!.data!.rounds!.length),

      ),
      SizedBox(height: AppSize.s20,),
      Container(
        margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
        child:matches == null?
        Container(
          child: const CircularProgressIndicator(


          ),
          alignment: AlignmentDirectional.center,
        ):
            matches!.isEmpty?
            Container(
              alignment: AlignmentDirectional.center,
              child: Text("noData".tr(),style: TextStyle(
                  color: ColorManager.white,
                  fontSize: FontSize.s18,
                  fontWeight: FontWeight.normal
              ),),
            ):


        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,

            itemBuilder: (context, index){
          return SizedBox(
            height: AppSize.s120,
            child: Card(
              elevation: AppSize.s4,
              color: ColorManager.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s10),
              ),
              child: Container(
                width: AppSize.width,
                height: AppSize.height,
                margin: EdgeInsets.symmetric(vertical: AppSize.s10,horizontal: AppSize.s30),
                child:
                Column(
             crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Expanded(
                      flex:1,
                      child: Container(
                        alignment: AlignmentDirectional.topCenter,
                        child: Text(matches![index].status=="0"?"inActive".tr():"active".tr(),
                        style: TextStyle(
                          color: matches![index].status=="0"?ColorManager.expire:ColorManager.active,
                          fontSize: FontSize.s9,
                          fontWeight: FontWeight.normal


                        ),),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Row(

                        children: [
                          Expanded(
                            flex:1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: AppSize.s32,
                                  width: AppSize.s32,
                                  child:   CachedNetworkImage(
                                    width: AppSize.width,

                                    fit: BoxFit.fill,
                                    imageUrl:'$TAG_LOGO_URL${matches![index].team1![0].logo.toString()}',
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
                                ),
                                SizedBox(height: AppSize.s4,),
                                Text(mLanguage == "en"?matches![index].team1![0].enTitle.toString():
                                matches![index].team1![0].arTitle.toString(),
                                  style:TextStyle(
                                      color: ColorManager.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize:FontSize.s6

                                  ) ,)

                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(matches![index].result!.goals1.toString(),
                                  style: TextStyle(
                                      color:ColorManager.black,
                                      fontSize: FontSize.s21,
                                      fontWeight: FontWeight.normal


                                  ),),
                                SizedBox(width: AppSize.s10,),
                                Image.asset(ImageAssets.doubleDot,width: AppSize.s6,height: AppSize.s11,),
                                SizedBox(width: AppSize.s10,),
                                Text(matches![index].result!.goals2.toString(),
                                  style: TextStyle(
                                      color:ColorManager.black,
                                      fontSize: FontSize.s21,
                                      fontWeight: FontWeight.normal


                                  ),),
                              ],

                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: AppSize.s32,
                                  width: AppSize.s32,
                                  child:   CachedNetworkImage(
                                    width: AppSize.width,

                                    fit: BoxFit.fill,
                                    imageUrl:'$TAG_LOGO_URL${matches![index].team2![0].logo.toString()}',
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
                                ),
                                SizedBox(height: AppSize.s4,),
                                Text(mLanguage == "en"?
                                matches![index].team2![0].enTitle.toString():
                                matches![index].team2![0].arTitle.toString(),
                                  style:TextStyle(
                                      color: ColorManager.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize:FontSize.s6

                                  ) ,)

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex:3,
                      child: Container(
                        height: AppSize.s30,
                        width: AppSize.width,




                        decoration: BoxDecoration(
                            color: ColorManager.backGroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(AppSize.s15))

                        ),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: AppSize.s15),


                          child: Row(

                            children: [
                              Expanded(
                                flex:1,
                                child: Container(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    "prediction".tr(),
                                    style: TextStyle(
                                        color: ColorManager.white,
                                        fontSize: FontSize.s9,
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: AlignmentDirectional.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(matches![index].predictions!.goals1.toString(),
                                        style: TextStyle(
                                            color:ColorManager.rectangle,
                                            fontSize: FontSize.s14,
                                            fontWeight: FontWeight.normal


                                        ),),
                                      SizedBox(width: AppSize.s10,),
                                      Image.asset(ImageAssets.doubleDot,width: AppSize.s4,height: AppSize.s14,color: ColorManager.rectangle,),
                                      SizedBox(width: AppSize.s10,),
                                      Text(matches![index].predictions!.goals2.toString().toString(),
                                        style: TextStyle(
                                            color:ColorManager.rectangle,
                                            fontSize: FontSize.s14,
                                            fontWeight: FontWeight.normal


                                        ),),
                                    ],

                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(matches![index].predictions!.points.toString(),
                                        style: TextStyle(
                                            color: ColorManager.rectangle,
                                            fontSize: FontSize.s14,
                                            fontWeight: FontWeight.normal
                                        ),),
                                      Container(width: AppSize.s8,),
                                      Text("pts".tr(),
                                        style: TextStyle(
                                            color: ColorManager.white,
                                            fontSize: FontSize.s9,
                                            fontWeight: FontWeight.normal
                                        ),),

                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

                      ),
                    )




                  ],
                ),
              ),

            ),

          );
        }, separatorBuilder: (context,index){
          return Container(
            height: AppSize.s10,
          );
        }, itemCount: matches!.length),
      )


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
