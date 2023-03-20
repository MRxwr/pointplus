import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:point/api/point_services.dart';
import 'package:point/domain/profile_model.dart';
import 'package:point/domain/shop_model.dart';
import 'package:point/presentation/main/address_screen.dart';
import 'package:point/presentation/resources/font_manager.dart';
import 'package:point/presentation/resources/strings_manager.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/constant.dart';
import '../../providers/model_hud.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/values_manager.dart';
class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  ShopModel? shopModel;
  String language ="";
  Future<ShopModel?> shops() async{
    PointServices pointServices = PointServices();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    language = sharedPreferences.getString(LANG_CODE)??"";
    ShopModel? shopModel = await pointServices.shop();
    return shopModel;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shops().then((value) {
      setState(() {
        shopModel = value;
      });

    });
  }
  double? itemWidth;
  double? itemHeight;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    itemWidth = AppSize.width / 2;
    itemHeight =AppSize.s220;
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
            width: AppSize.width,
            height: AppSize.height,
            decoration: const BoxDecoration(
                image:  DecorationImage(
                  image: AssetImage(ImageAssets.background),
                  fit: BoxFit.cover,
                )),
            child: Container(
              margin: EdgeInsets.all(AppSize.s10),
              child: shopModel == null?
              Container(
                child: const CircularProgressIndicator(


                ),
                alignment: AlignmentDirectional.center,
              ):ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Container(
                    alignment: AlignmentDirectional.center,
                    child: Text("shops".tr(),style: TextStyle(
                      color: ColorManager.white,
                      fontWeight: FontWeight.w500,
                      fontSize: FontSize.s18


                    ),),
                  ),
                  GridView.builder(scrollDirection: Axis.vertical,


                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                        childAspectRatio:itemWidth!/itemHeight!),
                    itemCount: shopModel?.data!.items!.length,

                    itemBuilder: (context,index){
                      return GestureDetector(
                        onTap: (){

                        },
                        child: Container(
                            margin: EdgeInsets.all(AppSize.s6),


                            child:
                            Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation: AppSize.s1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(AppSize.s10),
                                  topRight: Radius.circular(AppSize.s10))
                                ),
                                color: ColorManager.white,
                                child: buildItem(shopModel?.data!.items![index],context))),
                      );
                    },
                  ),

                ],
              ) ,

            ),
          ),

        ),
      ),
    );
  }

  buildItem(Items? items, BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            flex: 9,
            child:
            CachedNetworkImage(
              width: itemWidth,
              imageUrl:'$TAG_PRODUCTS_URL${items?.image}',
              imageBuilder: (context, imageProvider) => Stack(
                children: [
                  ClipRRect(

                    child: Container(
                        width: itemWidth,

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
          ),
          Expanded(
              flex:3,child: Container(
            color: ColorManager.white,
            child: Column(
              children: [
                Expanded(flex: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: AppSize.s10),
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        language == "en"?
                        items!.enTitle!:items!.arTitle!,
                        style: TextStyle(
                          color: ColorManager.black,
                          fontSize: FontSize.s9,
                          fontWeight: FontWeight.w500

                        ),
                        textAlign: TextAlign.start,
                      ),
                    )),
                Expanded(flex: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: AppSize.s10),
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(

                        "${items.coins} ${"coins".tr()}",
                        style: TextStyle(
                            color: ColorManager.rectangle,
                            fontSize: FontSize.s9,
                            fontWeight: FontWeight.w500

                        ),
                        textAlign: TextAlign.start,
                      ),
                    ))

              ],
            ),

          )),
          Expanded(flex:2,child: GestureDetector(
            onTap: (){
              validatePoints(context,int.parse(items.coins.toString()),items.id.toString());

            },
            child: Container(
              color: ColorManager.rectangle,
              alignment: AlignmentDirectional.center,
              child: Text(
                "redem".tr(),
                style: TextStyle(
                  color: ColorManager.white,
                  fontWeight: FontWeight.w500,
                  fontSize: FontSize.s9
                ),
              ),
            ),
          ))

        ],
      ),

    );


  }

  void errorDialog({required BuildContext context}) {

    showDialog(context:  _scaffoldKey.currentState!.context, builder: (context){
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
                  child: Text("shops".tr(),
                  style: TextStyle(
                    color: ColorManager.black,
                    fontSize: FontSize.s15,
                    fontWeight: FontWeight.w500
                  ),),
                )),
                Expanded(flex:1,child: Container(
                  alignment: AlignmentDirectional.center,
                  child: Text("notEnoughCoins".tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorManager.rectangle,
                        fontSize: FontSize.s15,
                        fontWeight: FontWeight.w500
                    ),),
                )),Expanded(flex:1,child: Container(
                  alignment: AlignmentDirectional.center,
                  child: Image.asset(ImageAssets.sadIcon,width: AppSize.s30,
                  height: AppSize.s30,fit: BoxFit.fill,),
                )),
                Expanded(flex:1,child: Container(
                  margin: EdgeInsets.symmetric(vertical: AppSize.s5,horizontal: AppSize.s20),
                  alignment: AlignmentDirectional.center,
                  child: backButton("back".tr(),context)
                ))

              ],
            ),
          ),
        ),
      );
    });
  }
  void successDialog({required BuildContext context,required String id}) {

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
                  child: Text("shops".tr(),
                    style: TextStyle(
                        color: ColorManager.black,
                        fontSize: FontSize.s15,
                        fontWeight: FontWeight.w500
                    ),),
                )),
                Expanded(flex:1,child: Container(
                  alignment: AlignmentDirectional.center,
                  child: Text("redemProduct".tr(),
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
                    child: addressButton("address".tr(),context,id)
                ))

              ],
            ),
          ),
        ),
      );
    });
  }
  TextButton backButton(String text,BuildContext context){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      primary: ColorManager.secondary,


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
  TextButton addressButton(String text,BuildContext context,String id){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      primary: ColorManager.secondary,


      shape:  RoundedRectangleBorder(

        borderRadius: BorderRadius.all(Radius.circular(AppSize.s5)),
      ),
      backgroundColor: ColorManager.secondary,
    );

    return TextButton(
      style: flatButtonStyle,
      onPressed: () {
        Navigator.of(context,rootNavigator: true).push( MaterialPageRoute(builder: (BuildContext context){
          return   AddressScreen(itemId: id,);
        }));
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
  validatePoints(BuildContext context,int productPoints,String itemId) async{
    final modelHud = Provider.of<ModelHud>(context,listen: false);
    modelHud.changeIsLoading(true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("id")??"";
    Map<String,dynamic> map = {};
    map['id']= id;
    PointServices pointServices = PointServices();
    ProfileModel? profileModel = await pointServices.profile(map);
    int profilePoints =int.parse(profileModel!.data!.user![0].coins.toString());
    modelHud.changeIsLoading(false);
    if(profilePoints>productPoints){
      successDialog(context: context,id: itemId);

    }else{
      errorDialog(context: context);
    }
  }
}
