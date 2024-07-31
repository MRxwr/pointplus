import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/point_services.dart';
import '../../app/constant.dart';
import '../../domain/top_model.dart';
import '../photo/photo_screen.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/values_manager.dart';
import '../web/webview_screen.dart';
import 'compare_screen.dart';
class TopScreen extends StatefulWidget {
  GlobalKey<NavigatorState> page;
   TopScreen({super.key,required this.page});

  @override
  State<TopScreen> createState() => _TopScreenState();
}

class _TopScreenState extends State<TopScreen> {
  List<Banners> banners =[];
  List<Month> months =[];
  List<User> ?users =[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    top(topId).then((value){
      setState(() {
        topModel = value;
      });


    });
  }
  final CarouselController _controller = CarouselController();
  TopModel? topModel;
  int _current =0;
  String topId = "";
  List<bool> round=[];
  String  mLanguage="";
  String id ="";
  Future<TopModel> top(String topId) async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     id = sharedPreferences.getString("id")??"";
      mLanguage = sharedPreferences.getString(LANG_CODE)??"";
    PointServices pointServices = PointServices();
    TopModel? topModel = await pointServices.top(topId);
    banners = topModel!.data!.banners!;
    months = topModel!.data!.list!;
    if(topModel.data!.top != null){
      users = topModel!.data!.top!.list!;
    }

    for(int i =0;i<months.length;i++){
      if(i ==0){
        round.add(true);
      }else{
        round.add(false);
      }
    }
    return topModel!;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: Container(
        child: topModel == null?
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
              height: 280.h,
              margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
              child: Column(
                children: [
                  Container(
                    child: banners.isEmpty
                        ?Container():
                    SizedBox(
                      height: 250.h,

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
                        items: banners!.map((item) =>
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
                                            title:item.enTitle.toString() ,);

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
                    children: banners!.map((item) {
                      int? index =banners!.indexOf(item);
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
              margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("top".tr(),
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
              child: users!.isEmpty?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text('no_data_available'.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                  SizedBox(height: 50.h,)
                ],
              ):Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: AppSize.s30,
                    margin: EdgeInsetsDirectional.only(start: AppSize.s20),
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,

                        itemBuilder: (context,index){
                          return GestureDetector(
                            onTap: () async{
                              for(int i =0;i<months.length;i++){
                                if(i == index){
                                  round[i] = true;
                                }else{
                                  round[i] = false;
                                }
                              }
                              users = null;
                              setState(() {

                              });

                              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

                              String id = sharedPreferences.getString("id")??"";
                              print('id  ---> ${id}');
                              PointServices pointServices = PointServices();
                              TopModel? topModel = await pointServices.top(months[index].id);

                              users = topModel!.data!.top!.list;
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
                              child: Text(mLanguage == "en"?
                                months![index].enTitle!:months![index].arTitle!,
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
                    }, itemCount: months.length),

                  ),
                  SizedBox(height: AppSize.s20,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
                      child:users == null?
                      Container(
                        child: const CircularProgressIndicator(


                        ),
                        alignment: AlignmentDirectional.center,
                      ):users!.isEmpty?
                      Container(
                        alignment: AlignmentDirectional.center,
                        child: Text("empty_data".tr(),style: TextStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s18,
                            fontWeight: FontWeight.normal
                        ),),
                      ):ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context,index){
                              return GestureDetector(
                              onTap: (){
                                String currentUserId = id;
                                String selecetedUserId= users![index].userId.toString();
                                if(currentUserId!= selecetedUserId) {
                                  Navigator.of(context, rootNavigator: true).push(
                                      MaterialPageRoute(builder: (BuildContext context) {
                                        return CompareScreen(
                                          userId: id,
                                          comparedUserId: users![index].userId.toString(),
                                        );
                                      }));
                                }
                              },
                              child: users![index].userId == id?Container(
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
                                        Text(users![index].username.toString(),
                                          style: TextStyle(
                                              color: ColorManager.black,
                                              fontSize: FontSize.s12,
                                              fontWeight: FontWeight.normal
                                          ),),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(users![index].totalPoints.toString(),
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
                                        Text(users![index].username.toString(),
                                          style: TextStyle(
                                              color: ColorManager.white,
                                              fontSize: FontSize.s12,
                                              fontWeight: FontWeight.normal
                                          ),),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(users![index].totalPoints.toString(),
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



                              ),
                            );
                          }, separatorBuilder: (context,index){
                        return Container(height: AppSize.s10,);
                      }, itemCount: users!.length)
                  ),
                ],
              ),
            )
          ],
        )
      ),


    );
  }
}
