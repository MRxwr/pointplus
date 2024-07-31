import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point/presentation/resources/color_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/point_services.dart';
import '../../app/constant.dart';
import '../../domain/compare_model.dart';
import '../photo/photo_screen.dart';
import '../resources/assets_manager.dart';
import '../resources/font_manager.dart';
import '../resources/values_manager.dart';
import '../web/webview_screen.dart';
class CompareScreen extends StatefulWidget {
  String userId;
  String comparedUserId;
   CompareScreen({super.key,required this.userId,required this.comparedUserId});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  String roundCount ="0";
  List<bool> round=[];
  List<Matches>? matches;
  CompareModel? compareModel;
  String mLanguage = "";
  final CarouselController _controller = CarouselController();
  int _current =0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    compareUsers().then((value){
      compareModel = value;
      setState(() {

      });

    });

  }
  Future<CompareModel> compareUsers()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("id")??"";

    mLanguage = sharedPreferences.getString(LANG_CODE)??"";
    PointServices pointServices = PointServices();
    CompareModel? compareModel = await pointServices.compareDetails(widget.userId, widget.comparedUserId, roundCount);
    matches = compareModel!.data!.matches!;
    for(int i =0;i<compareModel.data!.rounds!.length;i++){
      if(i ==0){
        round.add(true);
      }else{
        round.add(false);
      }
    }
    return compareModel;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: AppBar(
        elevation: 0,

        backgroundColor: ColorManager.primary,
        title: Center(
          child: Center(
            child: Image.asset(ImageAssets.titleBarImage,height: AppSize.s32, width: AppSize.s110,fit: BoxFit.fill,),
          ),
        ),
        actions: [
          SizedBox(width: AppSize.s30,)
        ],
        leading:
        GestureDetector(
          onTap: (){
            Navigator.pop(context);

          },
          child: Icon(Icons.arrow_back_ios_outlined,color: Colors.white,size: AppSize.s20,),
        ),


      ),
      body: Container(

        child: compareModel == null?
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
              height: 280.h,
              margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
              child: Column(
                children: [
                  Container(
                    child: compareModel!.data!.banners!.isEmpty
                        ?Container():SizedBox(
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
                        items: compareModel?.data!.banners!.map((item) =>
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
                    children: compareModel!.data!.banners!.map((item) {
                      int? index =compareModel?.data!.banners!.indexOf(item);
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
              height: AppSize.s150,
              margin: EdgeInsets.symmetric(horizontal: AppSize.s20,vertical: AppSize.s10),
              child: Container(

                decoration: BoxDecoration(
                    color: ColorManager.white,
                    borderRadius: BorderRadius.all(Radius.circular(AppSize.s20))
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: AppSize.s20,vertical: AppSize.s10),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("user_details".tr(),style: TextStyle(
                                  color: ColorManager.black,
                                  fontSize: FontSize.s15,
                                  fontWeight: FontWeight.w500
                              ),),


                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(flex: 2,
                                  child:Container(
                                    child: Text(
                                      "userName".tr(),
                                      style: TextStyle(
                                          color: const Color(0xAA707070),
                                          fontSize: FontSize.s12,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),

                                  )),
                              Expanded(flex: 3,
                                  child:Container(
                                    child: Text(
                                      compareModel!.data!.compare!.username.toString(),
                                      style: TextStyle(
                                          color: ColorManager.black,
                                          fontSize: FontSize.s12,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),

                                  ))
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: const Color(0x44707070),
                        height: AppSize.s1,
                      ),

                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(flex: 2,
                                  child:Container(
                                    child: Text(
                                      "nationality".tr(),
                                      style: TextStyle(
                                          color: const Color(0xAA707070),
                                          fontSize: FontSize.s12,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),

                                  )),
                              Expanded(flex: 3,
                                  child:Container(
                                    child: Text(
                                      compareModel!.data!.compare!.country.toString(),
                                      style: TextStyle(
                                          color: ColorManager.black,
                                          fontSize: FontSize.s12,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),

                                  ))
                            ],
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
              ),
            ),
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: AppSize.s20,vertical: AppSize.s10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text("profileDetails".tr(),style: TextStyle(
            //           color: ColorManager.white,
            //           fontSize: FontSize.s15,
            //           fontWeight: FontWeight.w500
            //       ),),
            //
            //
            //     ],
            //   ),
            // ),
            // Container(
            //   height: AppSize.s50,
            //   width: AppSize.width,
            //   margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
            //   child: Row(
            //     children: [
            //       Expanded(flex:10,child:
            //       Container(
            //         height: AppSize.s50,
            //         decoration: BoxDecoration(
            //             color: ColorManager.rectangle,
            //
            //             borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
            //         ),
            //         child: Container(
            //           margin: EdgeInsets.all(AppSize.s8),
            //
            //           child: Row(
            //
            //             children:  [
            //
            //               Expanded(
            //                 flex:3,
            //                 child:
            //                 Container(
            //                   margin: EdgeInsets.symmetric(horizontal: AppSize.s4),
            //                   child: Column(
            //
            //                     children: [
            //                       Expanded(
            //                         flex: 1,
            //
            //                         child: Container(
            //                           alignment: AlignmentDirectional.center,
            //                           color: ColorManager.primary,
            //
            //
            //                           child: Text("last_week".tr(),
            //
            //                             style: TextStyle(
            //                               color: ColorManager.white,
            //                               fontSize: FontSize.s10,
            //                               fontWeight: FontWeight.normal,
            //
            //                             ),),
            //                         ),
            //                       ),
            //                       Expanded(
            //                         flex: 1,
            //                         child: Container(
            //                           height: AppSize.height,
            //                           width: AppSize.width,
            //                           alignment: AlignmentDirectional.center,
            //                           child: Text(
            //
            //                             "GW ${compareModel!.data!.user!.stats![1].round}",
            //                             style: TextStyle(
            //                                 color: ColorManager.primary,
            //                                 fontSize: ScreenUtil().setSp(12)
            //                             ),
            //                           ),
            //
            //                         ),
            //                       )
            //
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //               Expanded(flex:1,child: Container(
            //                 alignment: AlignmentDirectional.center,
            //                 decoration: BoxDecoration(
            //                     color: ColorManager.primary,
            //                     borderRadius: BorderRadius.circular(AppSize.s5)
            //                 ),
            //                 child: Text(
            //                   compareModel!.data!.user!.stats![1].totalPoints.toString(),
            //                   style: TextStyle(
            //                       color: ColorManager.white,
            //                       fontSize: ScreenUtil().setSp(14)
            //                   ),
            //                 ),
            //               ))
            //
            //
            //             ],
            //           ),
            //         ),
            //       )),
            //       Expanded(flex:1,child: Container(
            //         height: AppSize.s50,
            //
            //
            //       )),
            //       Expanded(flex:10,child:
            //       Container(
            //         height: AppSize.s50,
            //         decoration: BoxDecoration(
            //             color: ColorManager.rectangle,
            //
            //             borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
            //         ),
            //         child: Container(
            //           margin: EdgeInsets.all(AppSize.s8),
            //
            //           child: Row(
            //
            //             children:  [
            //
            //               Expanded(
            //                 flex:3,
            //                 child:
            //                 Container(
            //                   margin: EdgeInsets.symmetric(horizontal: AppSize.s4),
            //                   child: Column(
            //
            //                     children: [
            //                       Expanded(
            //                         flex: 1,
            //
            //                         child: Container(
            //                           alignment: AlignmentDirectional.center,
            //                           color: ColorManager.primary,
            //
            //
            //                           child: Text("current_week".tr(),
            //
            //                             style: TextStyle(
            //                               color: ColorManager.white,
            //                               fontSize: FontSize.s10,
            //                               fontWeight: FontWeight.normal,
            //
            //                             ),),
            //                         ),
            //                       ),
            //                       Expanded(
            //                         flex: 1,
            //                         child: Container(
            //                           height: AppSize.height,
            //                           width: AppSize.width,
            //                           alignment: AlignmentDirectional.center,
            //                           child: Text(
            //
            //                             "GW ${compareModel!.data!.user!.stats![0].round}",
            //                             style: TextStyle(
            //                                 color: ColorManager.primary,
            //                                 fontSize: ScreenUtil().setSp(12)
            //                             ),
            //                           ),
            //
            //                         ),
            //                       )
            //
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //               Expanded(flex:1,child: Container(
            //                 alignment: AlignmentDirectional.center,
            //                 decoration: BoxDecoration(
            //                     color: ColorManager.primary,
            //                     borderRadius: BorderRadius.circular(AppSize.s5)
            //                 ),
            //                 child: Text(
            //                   compareModel!.data!.user!.stats![0].totalPoints.toString(),
            //                   style: TextStyle(
            //                       color: ColorManager.white,
            //                       fontSize: ScreenUtil().setSp(14)
            //                   ),
            //                 ),
            //               ))
            //
            //
            //             ],
            //           ),
            //         ),
            //       )),
            //
            //
            //     ],
            //   ),
            // ),
            // SizedBox(height: AppSize.s10,),
            // Container(
            //   height: AppSize.s50,
            //   width: AppSize.width,
            //   decoration: BoxDecoration(
            //       color: ColorManager.rectangle,
            //
            //       borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
            //   ),
            //   margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //
            //     children: [
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //         children: [
            //           Text("totalPoints".tr(),
            //             style: TextStyle(
            //                 color: ColorManager.white,
            //                 fontSize: FontSize.s10,
            //                 fontWeight: FontWeight.normal
            //
            //             ),),
            //           Text(compareModel!.data!.user!.points.toString(),
            //             style: TextStyle(
            //                 color: ColorManager.black,
            //                 fontSize: FontSize.s22,
            //                 fontWeight: FontWeight.normal
            //
            //             ),)
            //         ],
            //       ),
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //         children: [
            //           Text("rank".tr(),
            //             style: TextStyle(
            //                 color: ColorManager.white,
            //                 fontSize: FontSize.s10,
            //                 fontWeight: FontWeight.normal
            //
            //             ),),
            //           Text(compareModel!.data!.user!.rank.toString()!,
            //             style: TextStyle(
            //                 color: ColorManager.black,
            //                 fontSize: FontSize.s22,
            //                 fontWeight: FontWeight.normal
            //
            //             ),)
            //         ],
            //       ),
            //       Container(
            //         alignment: AlignmentDirectional.center,
            //         child: getRank(compareModel!.data!.user!.pRank.toString(), compareModel!.data!.user!.rank.toString()) == 0?
            //         Image.asset(ImageAssets.equalArrow,
            //           height: AppSize.s7,width: AppSize.s7,
            //           fit: BoxFit.fill,):getRank(compareModel!.data!.user!.pRank.toString(), compareModel!.data!.user!.rank.toString()) == 1?
            //         Image.asset(ImageAssets.downArrow,
            //           height: AppSize.s5,width: AppSize.s9,
            //           fit: BoxFit.fill,):Image.asset(ImageAssets.upArrow,
            //           height: AppSize.s5,width: AppSize.s9,
            //           fit: BoxFit.fill,),
            //
            //       ),
            //     ],
            //   ),
            // ),
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: AppSize.s20,vertical: AppSize.s10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text("user_details".tr(),style: TextStyle(
            //           color: ColorManager.white,
            //           fontSize: FontSize.s15,
            //           fontWeight: FontWeight.w500
            //       ),),
            //
            //
            //     ],
            //   ),
            // ),
            // Container(
            //   height: AppSize.s50,
            //   width: AppSize.width,
            //   margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
            //   child: Row(
            //     children: [
            //       Expanded(flex:10,child:
            //       Container(
            //         height: AppSize.s50,
            //         decoration: BoxDecoration(
            //             color: ColorManager.rectangle,
            //
            //             borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
            //         ),
            //         child: Container(
            //           margin: EdgeInsets.all(AppSize.s8),
            //
            //           child: Row(
            //
            //             children:  [
            //
            //               Expanded(
            //                 flex:3,
            //                 child:
            //                 Container(
            //                   margin: EdgeInsets.symmetric(horizontal: AppSize.s4),
            //                   child: Column(
            //
            //                     children: [
            //                       Expanded(
            //                         flex: 1,
            //
            //                         child: Container(
            //                           alignment: AlignmentDirectional.center,
            //                           color: ColorManager.primary,
            //
            //
            //                           child: Text("last_week".tr(),
            //
            //                             style: TextStyle(
            //                               color: ColorManager.white,
            //                               fontSize: FontSize.s10,
            //                               fontWeight: FontWeight.normal,
            //
            //                             ),),
            //                         ),
            //                       ),
            //                       Expanded(
            //                         flex: 1,
            //                         child: Container(
            //                           height: AppSize.height,
            //                           width: AppSize.width,
            //                           alignment: AlignmentDirectional.center,
            //                           child: Text(
            //
            //                             "GW ${compareModel!.data!.compare!.stats![1].round}",
            //                             style: TextStyle(
            //                                 color: ColorManager.primary,
            //                                 fontSize: ScreenUtil().setSp(12)
            //                             ),
            //                           ),
            //
            //                         ),
            //                       )
            //
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //               Expanded(flex:1,child: Container(
            //                 alignment: AlignmentDirectional.center,
            //                 decoration: BoxDecoration(
            //                     color: ColorManager.primary,
            //                     borderRadius: BorderRadius.circular(AppSize.s5)
            //                 ),
            //                 child: Text(
            //                   compareModel!.data!.compare!.stats![1].totalPoints.toString(),
            //                   style: TextStyle(
            //                       color: ColorManager.white,
            //                       fontSize: ScreenUtil().setSp(14)
            //                   ),
            //                 ),
            //               ))
            //
            //
            //             ],
            //           ),
            //         ),
            //       )),
            //       Expanded(flex:1,child: Container(
            //         height: AppSize.s50,
            //
            //
            //       )),
            //       Expanded(flex:10,child:
            //       Container(
            //         height: AppSize.s50,
            //         decoration: BoxDecoration(
            //             color: ColorManager.rectangle,
            //
            //             borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
            //         ),
            //         child: Container(
            //           margin: EdgeInsets.all(AppSize.s8),
            //
            //           child: Row(
            //
            //             children:  [
            //
            //               Expanded(
            //                 flex:3,
            //                 child:
            //                 Container(
            //                   margin: EdgeInsets.symmetric(horizontal: AppSize.s4),
            //                   child: Column(
            //
            //                     children: [
            //                       Expanded(
            //                         flex: 1,
            //
            //                         child: Container(
            //                           alignment: AlignmentDirectional.center,
            //                           color: ColorManager.primary,
            //
            //
            //                           child: Text("current_week".tr(),
            //
            //                             style: TextStyle(
            //                               color: ColorManager.white,
            //                               fontSize: FontSize.s10,
            //                               fontWeight: FontWeight.normal,
            //
            //                             ),),
            //                         ),
            //                       ),
            //                       Expanded(
            //                         flex: 1,
            //                         child: Container(
            //                           height: AppSize.height,
            //                           width: AppSize.width,
            //                           alignment: AlignmentDirectional.center,
            //                           child: Text(
            //
            //                             "GW ${compareModel!.data!.compare!.stats![0].round}",
            //                             style: TextStyle(
            //                                 color: ColorManager.primary,
            //                                 fontSize: ScreenUtil().setSp(12)
            //                             ),
            //                           ),
            //
            //                         ),
            //                       )
            //
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //               Expanded(flex:1,child: Container(
            //                 alignment: AlignmentDirectional.center,
            //                 decoration: BoxDecoration(
            //                     color: ColorManager.primary,
            //                     borderRadius: BorderRadius.circular(AppSize.s5)
            //                 ),
            //                 child: Text(
            //                   compareModel!.data!.compare!.stats![0].totalPoints.toString(),
            //                   style: TextStyle(
            //                       color: ColorManager.white,
            //                       fontSize: ScreenUtil().setSp(14)
            //                   ),
            //                 ),
            //               ))
            //
            //
            //             ],
            //           ),
            //         ),
            //       )),
            //
            //
            //     ],
            //   ),
            // ),
            // SizedBox(height: AppSize.s10,),
            // Container(
            //   height: AppSize.s50,
            //   width: AppSize.width,
            //   decoration: BoxDecoration(
            //       color: ColorManager.rectangle,
            //
            //       borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
            //   ),
            //   margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //
            //     children: [
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //         children: [
            //           Text("totalPoints".tr(),
            //             style: TextStyle(
            //                 color: ColorManager.white,
            //                 fontSize: FontSize.s10,
            //                 fontWeight: FontWeight.normal
            //
            //             ),),
            //           Text(compareModel!.data!.compare!.points.toString(),
            //             style: TextStyle(
            //                 color: ColorManager.black,
            //                 fontSize: FontSize.s22,
            //                 fontWeight: FontWeight.normal
            //
            //             ),)
            //         ],
            //       ),
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //         children: [
            //           Text("rank".tr(),
            //             style: TextStyle(
            //                 color: ColorManager.white,
            //                 fontSize: FontSize.s10,
            //                 fontWeight: FontWeight.normal
            //
            //             ),),
            //           Text(compareModel!.data!.compare!.rank.toString()!,
            //             style: TextStyle(
            //                 color: ColorManager.black,
            //                 fontSize: FontSize.s22,
            //                 fontWeight: FontWeight.normal
            //
            //             ),)
            //         ],
            //       ),
            //       Container(
            //         alignment: AlignmentDirectional.center,
            //         child: getRank(compareModel!.data!.compare!.pRank.toString(), compareModel!.data!.compare!.rank.toString()) == 0?
            //         Image.asset(ImageAssets.equalArrow,
            //           height: AppSize.s7,width: AppSize.s7,
            //           fit: BoxFit.fill,):getRank(compareModel!.data!.compare!.pRank.toString(), compareModel!.data!.compare!.rank.toString()) == 1?
            //         Image.asset(ImageAssets.downArrow,
            //           height: AppSize.s5,width: AppSize.s9,
            //           fit: BoxFit.fill,):Image.asset(ImageAssets.upArrow,
            //           height: AppSize.s5,width: AppSize.s9,
            //           fit: BoxFit.fill,),
            //
            //       ),
            //     ],
            //   ),
            // ),
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
              height: AppSize.s40,
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
                        CompareModel? homeRoundModel = await pointServices.compareDetails(widget.userId,widget.comparedUserId,compareModel!.data!.rounds![index].round.toString());

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
                          textAlign: TextAlign.center,
                          "gw".tr()+ compareModel!.data!.rounds![index].round.toString(),
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
              }, itemCount: compareModel!.data!.rounds!.length),

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
                child: Text("loading_next_round".tr(),style: TextStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s18,
                    fontWeight: FontWeight.normal
                ),),
              ):


              ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,

                  itemBuilder: (context, index){
                    return Container(
                      height: 190.h,
                      width: MediaQuery.of(context).size.width,

                      child: Container(

                        decoration: const BoxDecoration(
                           color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),



                        child: Container(
                          width: MediaQuery.of(context).size.width,
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
                                  child: Text(matches![index].isActive=="0"?"inActive".tr():"active".tr(),
                                    style: TextStyle(
                                        color: matches![index].isActive=="0"?ColorManager.expire:ColorManager.active,
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
                                          SizedBox(height: AppSize.s2,),
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
                                          SizedBox(height: AppSize.s2,),
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
                              Container(
                                height: 20.h,

                                alignment: AlignmentDirectional.center,
                                child: Container(
                                  width: 130.w,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFd59f0b),
                                    borderRadius: BorderRadius.all(Radius.circular(10.h)),

                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(matches![index].matchDate.toString(),
                                        style: TextStyle(
                                            color:const Color(0xFF0e3151),
                                            fontSize: FontSize.s8,
                                            fontWeight: FontWeight.normal


                                        ),),
                                      Text(matches![index].matchTime.toString(),
                                        style: TextStyle(
                                            color:const Color(0xFF000000),
                                            fontSize: FontSize.s8,
                                            fontWeight: FontWeight.normal


                                        ),),
                                    ],
                                  ),

                                ),
                              ),
                              SizedBox(height: 10.h,),
                              Center(
                                child: Container(
                                  height: 60.h,
                                  child: Stack(
                                    children: [





                                      Positioned.directional(
                                        top: 10.h,
                                        bottom: 0,
                                        start: 0,
                                        end: 0,
                                        textDirection: Directionality.of(context),
                                        child: Container(
                                          height: AppSize.s60,
                                          width: AppSize.width,
                                          alignment: AlignmentDirectional.bottomCenter,




                                          decoration: BoxDecoration(
                                              color: const Color(0xFFd59f0b),
                                              borderRadius: BorderRadius.all(Radius.circular(AppSize.s15))

                                          ),
                                          child: Container(
                                            margin: EdgeInsets.symmetric(horizontal: AppSize.s10,vertical: 10.h),


                                            child: Column(


                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Row(


                                                    children: [
                                                      Expanded(
                                                        flex:1,
                                                        child: Container(
                                                          alignment: AlignmentDirectional.centerStart,
                                                          child: Text(
                                                            "prediction".tr(),
                                                            style: TextStyle(
                                                                color: const Color(0xFF0e3151),
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
                                                              Text(matches![index].predictions!.user!.goals1.toString(),
                                                                style: TextStyle(
                                                                    color:const Color(0xFF000000),
                                                                    fontSize: FontSize.s14,
                                                                    fontWeight: FontWeight.normal


                                                                ),),
                                                              SizedBox(width: AppSize.s10,),
                                                              Image.asset(ImageAssets.doubleDot,width: AppSize.s4,height: AppSize.s14,color: const Color(0xFF000000),),
                                                              SizedBox(width: AppSize.s10,),
                                                              Text(matches![index].predictions!.user!.goals2.toString().toString(),
                                                                style: TextStyle(
                                                                    color:const Color(0xFF000000),
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
                                                              Text(matches![index].predictions!.user!.points.toString(),
                                                                style: TextStyle(
                                                                    color: const Color(0xFF000000),
                                                                    fontSize: FontSize.s14,
                                                                    fontWeight: FontWeight.normal
                                                                ),),
                                                              Container(width: AppSize.s8,),
                                                              Text("pts".tr(),
                                                                style: TextStyle(
                                                                    color: const Color(0xFF0e3151),
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
                                                Expanded(
                                                  flex: 1,
                                                  child: Row(

                                                    children: [
                                                      Expanded(
                                                        flex:1,
                                                        child: Container(
                                                          alignment: AlignmentDirectional.centerStart,
                                                          child: Text(
                                                            "player_prediction".tr(),
                                                            style: TextStyle(
                                                                color: const Color(0xFF0e3151),
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
                                                              Text(matches![index].predictions!.comapre!.goals1.toString(),
                                                                style: TextStyle(
                                                                    color:const Color(0xFF000000),
                                                                    fontSize: FontSize.s14,
                                                                    fontWeight: FontWeight.normal


                                                                ),),
                                                              SizedBox(width: AppSize.s10,),
                                                              Image.asset(ImageAssets.doubleDot,width: AppSize.s4,height: AppSize.s14,color: const Color(0xFF000000),),
                                                              SizedBox(width: AppSize.s10,),
                                                              Text(matches![index].predictions!.comapre!.goals2.toString().toString(),
                                                                style: TextStyle(
                                                                    color:const Color(0xFF000000),
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
                                                              Text(matches![index].predictions!.comapre!.points.toString(),
                                                                style: TextStyle(
                                                                    color: const Color(0xFF000000),
                                                                    fontSize: FontSize.s14,
                                                                    fontWeight: FontWeight.normal
                                                                ),),
                                                              Container(width: AppSize.s8,),
                                                              Text("pts".tr(),
                                                                style: TextStyle(
                                                                    color: const Color(0xFF0e3151),
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
                                              ],
                                            ),
                                          ),

                                        ),
                                      ),
                                      Positioned.directional(textDirection: Directionality.of(context),
                                          top: 0,
                                          start: 0,
                                          end: 0,


                                          child: Center(
                                            child: Container(
                                              height: 20.h,
                                              width: 140.w,
                                              alignment: AlignmentDirectional.center,
                                              decoration: BoxDecoration(
                                                  color: const Color(0xFFd59f0b),
                                                  borderRadius: BorderRadius.all(Radius.circular(10.h))
                                              ),
                                              child: Text(
                                                matches![index].staduim.toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: const Color(0xFF0e3151),
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: FontSize.s8,



                                                ),
                                              ),
                                            ),
                                          )),
                                    ],
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
