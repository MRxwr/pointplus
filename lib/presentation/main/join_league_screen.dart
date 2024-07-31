import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:point/domain/join_league_error_model.dart';
import 'package:point/domain/join_league_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/point_services.dart';
import '../../app/constant.dart';
import '../../domain/leagues_model.dart';
import '../../providers/model_hud.dart';
import '../photo/photo_screen.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import '../web/webview_screen.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
class JoinLeagueScreen extends StatefulWidget {
  GlobalKey<NavigatorState> page;
  LeaguesModel leaguesModel;
   JoinLeagueScreen({Key? key,required this.page,required this.leaguesModel}) : super(key: key);

  @override
  State<JoinLeagueScreen> createState() => _JoinLeagueScreenState();
}

class _JoinLeagueScreenState extends State<JoinLeagueScreen> {
  final TextEditingController _codeController =  TextEditingController();
  int _current =0;
  String mLanguage = "";
  final CarouselController _controller = CarouselController();
  void initState() {
    // TODO: implement initState
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    init().then((value) {
      setState(() {
        mLanguage = value;
      });

    });
  }
  Future<String>init() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("id")??"";

    mLanguage = sharedPreferences.getString(LANG_CODE)??"";
    return mLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("After clicking the Android Back Button");
        if (Navigator.of(context).userGestureInProgress) {

          return false;
        } else {

          return true;
        }

      },
      child: ModalProgressHUD(
        inAsyncCall: Provider.of<ModelHud>(context).isLoading,
        child: Scaffold(
          backgroundColor: ColorManager.primary,
          body: Container(
            child:mLanguage == ""?
            Container():ListView(
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Container(height: AppSize.s10,),
                Container(
                  child:widget.leaguesModel.data!.banners!.isEmpty?
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
                          items: widget.leaguesModel?.data!.banners!.map((item) =>
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

                        )


                      ),
                      Container(height: AppSize.s20,),
                    ],
                  ),
                ),
                Container(
                    alignment: AlignmentDirectional.center,
                    child: Text("invitation".tr(),
                      style: TextStyle(
                        color: ColorManager.white,
                        fontWeight: FontWeight.w500,
                        fontSize: FontSize.s17,
                      ),)),
                Container(height: AppSize.s20,),
                Container(
                  alignment: AlignmentDirectional.centerStart,
                  margin: EdgeInsets.symmetric(horizontal: AppSize.s30),
                  child: Text("leagueCode".tr(),
                    style: TextStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s12,
                      fontWeight: FontWeight.w500
                    ),

                  ),
                ),
                SizedBox(
                  height: AppSize.s40,

                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal:AppSize.s30),

                    // decoration: BoxDecoration(
                    //     color: ColorManager.white,
                    //
                    // ),

                    child: TextField(


                      textAlignVertical: TextAlignVertical.center,



                      style: TextStyle(color:ColorManager.black,fontSize: FontSize.s12),
                      textAlign: TextAlign.start,
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.text ,


                      textInputAction: TextInputAction.done,
                      maxLines: 1,
                      minLines: 1,
                      controller: _codeController,
                      decoration:  InputDecoration(


                        filled: true,

                        fillColor: ColorManager.white,
                        hintStyle: TextStyle(
                            color: ColorManager.black,
                            fontSize: FontSize.s12,
                            fontWeight: FontWeight.normal
                        ),


                        labelStyle:  TextStyle(color: ColorManager.black,
                            fontSize: FontSize.s12),

                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(height: AppSize.s40,),
                GestureDetector(
                  onTap: (){
                    validate(context);
                  },
                  child: Container(height: AppSize.s70,
                  alignment: AlignmentDirectional.center,
                  margin: EdgeInsets.symmetric(horizontal: AppSize.s30),
                  decoration: BoxDecoration(
                    color: ColorManager.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(AppSize.s35))
                  ),
                    child: Text("joinLeagues".tr(),
                    style: TextStyle(
                      color: ColorManager.black,
                      fontSize: FontSize.s16,
                      fontWeight: FontWeight.w500,

                    ),),
                  ),
                ), Container(height: AppSize.s10,),
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
                )

              ],
            ),
          ),



        ),
      ),
    );
  }
  void validate(BuildContext context) async{
    String mName = _codeController.text;
    if(mName.trim().isNotEmpty){
      final modelHud = Provider.of<ModelHud>(context,listen: false);
      modelHud.changeIsLoading(true);
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String id = sharedPreferences.getString("id")??"";
      PointServices pointServices = PointServices();
      Map<String,dynamic> map = {};
      map['userId'] = id;
      map['code'] = mName;

      dynamic response = await pointServices.joinLeague(map);
      modelHud.changeIsLoading(false);
      bool  isOk  = response['ok'];
      if(isOk){
        JoinLeagueModel joinLeagueModel = JoinLeagueModel.fromJson(response);
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.success,
                title: "success".tr(),
                text:joinLeagueModel.data!.msg,
                confirmButtonColor: ColorManager.primary,
                confirmButtonText: "ok".tr()
            )
        );
      }else{
        JoinLeagueErrorModel joinLeagueErrorModel = JoinLeagueErrorModel.fromJson(response);
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "error".tr(),
                text:joinLeagueErrorModel.data!.msg,
                confirmButtonColor: ColorManager.primary,
                confirmButtonText: "ok".tr()
            ));
      }



    }else{
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "error".tr(),
              text:"leageCodeError".tr(),
              confirmButtonColor: ColorManager.primary,
              confirmButtonText: "ok".tr()
          )
      );
    }




    // if(!validateEmail(email)){
    //   ArtSweetAlert.show(
    //       context: context,
    //       artDialogArgs: ArtDialogArgs(
    //           type: ArtSweetAlertType.danger,
    //           title: AppStrings.error,
    //           text:AppStrings.emailError,
    //           confirmButtonColor: ColorManager.primary,
    //           confirmButtonText: AppStrings.ok
    //       )
    //   );
    //
    // }else


  }
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    widget.page.currentState!.pop(); // Do some stuff.
    return true;
  }
  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }
}
