



import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:point/domain/coin_model.dart';
import 'package:point/domain/profile_model.dart';
import 'package:point/presentation/login/login.dart';
import 'package:point/presentation/main/change_password_screen.dart';
import 'package:point/presentation/main/edit_profile_screen.dart';
import 'package:point/presentation/resources/font_manager.dart';
import 'package:point/presentation/resources/strings_manager.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/point_services.dart';
import '../../app/constant.dart';
import '../../domain/DeleteUserModel.dart';
import '../../providers/model_hud.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/values_manager.dart';
import 'address_screen.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileModel? profileModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting("en");
    profile().then((value){
      profileModel = value;
      setState(() {

      });

    });
  }
  void successDialog({required BuildContext context,required String id, required CoinModel coinModel}) {

    showDialog(context: _scaffoldKey.currentState!.context,
        barrierDismissible:false,builder: (context){
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppSize.s10)),


        ),
        child: Container(

          width: AppSize.width,
          height: AppSize.s180,
          color: ColorManager.white,
          child: Container(

            child: Stack(
              children: [
                Positioned.directional(textDirection: Directionality.of(context), child:
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsetsDirectional.all(AppSize.s4),
                      child: Icon(Icons.close,size: AppSize.s20,
                      color: ColorManager.primary,),
                    ),
                  ),top: 0, start: 0,
                ),
                Positioned.directional(
                  textDirection: Directionality.of(context),
                  start: 0,
                  end: 0,
                  top: 0,
                  bottom: 0,

                  child: Column(
                    children: [

                      Expanded(flex:1,child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: AlignmentDirectional.center,
                            child: Text("no_of_points".tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorManager.rectangle,
                                  fontSize: FontSize.s15,
                                  fontWeight: FontWeight.w500
                              ),),
                          ),
                          Container(
                            alignment: AlignmentDirectional.center,
                            child: Text(coinModel!.data!.points!.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorManager.black,
                                  fontSize: FontSize.s15,
                                  fontWeight: FontWeight.w500
                              ),),
                          ),
                        ],
                      )),
                      Expanded(flex:1,child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: AlignmentDirectional.center,
                            child: Text("pointsToBeRedeemed".tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorManager.rectangle,
                                  fontSize: FontSize.s15,
                                  fontWeight: FontWeight.w500
                              ),),
                          ),
                          Container(
                            alignment: AlignmentDirectional.center,
                            child: Text(coinModel!.data!.pointsToBeRedeemed!.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorManager.black,
                                  fontSize: FontSize.s15,
                                  fontWeight: FontWeight.w500
                              ),),
                          ),
                        ],
                      )),
                      Expanded(flex:1,child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: AlignmentDirectional.center,
                            child: Text("no_of_coins".tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorManager.rectangle,
                                  fontSize: FontSize.s15,
                                  fontWeight: FontWeight.w500
                              ),),
                          ),
                          Container(
                            alignment: AlignmentDirectional.center,
                            child: Text(coinModel!.data!.coins!.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorManager.black,
                                  fontSize: FontSize.s15,
                                  fontWeight: FontWeight.w500
                              ),),
                          ),
                        ],
                      )),
                      Expanded(flex:1,child: Container(
                          margin: EdgeInsets.symmetric(vertical: AppSize.s5,horizontal: AppSize.s20),
                          alignment: AlignmentDirectional.center,
                          child: addressButton("redeem".tr(),context,id)
                      ))

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
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
      onPressed: () async{
        Navigator.pop(context);
        final modelHud = Provider.of<ModelHud>(context,listen: false);
        modelHud.changeIsLoading(true);
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String id = sharedPreferences.getString("id")??"";
        Map<String,dynamic> map = {};
        map['redeem']= "1";
        PointServices pointServices = PointServices();
        CoinModel? coinModel = await pointServices.coins(map,id);
        modelHud.changeIsLoading(false);
        bool? isOk = coinModel!.ok;
        if(isOk!){
          Fluttertoast.showToast(
              msg: coinModel.status!,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: FontSize.s16
          );
          profileModel = null;
          setState(() {

          });
          // sdd
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          String id = sharedPreferences.getString("id")??"";
          Map<String,dynamic> map = {};
          map['id']= id;
          PointServices pointServices = PointServices();
           profileModel = await pointServices.profile(map);
           setState(() {

           });

        }else{
          Fluttertoast.showToast(
              msg: coinModel.status!,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: FontSize.s16
          );
        }

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
  Future<ProfileModel?> profile() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("id")??"";
    Map<String,dynamic> map = {};
    map['id']= id;
    PointServices pointServices = PointServices();
    ProfileModel? profileModel = await pointServices.profile(map);
    return profileModel;

  }
  Future<void> coins(String redeem) async{
    final modelHud = Provider.of<ModelHud>(context,listen: false);
    modelHud.changeIsLoading(true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("id")??"";
    Map<String,dynamic> map = {};
    map['redeem']= redeem;
    PointServices pointServices = PointServices();
    CoinModel? profileModel = await pointServices.coins(map,id);
    modelHud.changeIsLoading(false);
    bool? isOk = profileModel!.ok;
    if(isOk!){
      successDialog(context: context, id: id, coinModel: profileModel);

    }

  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: Provider.of<ModelHud>(context).isLoading,
      child: WillPopScope(
        onWillPop: () async {
          if (Navigator.of(context).userGestureInProgress) {
            return false;
          } else {
            return true;
          }
        },
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
                child: profileModel == null?
                Container(
                  child: const CircularProgressIndicator(


                  ),
                  alignment: AlignmentDirectional.center,
                ):
                    ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Container(
                          child:profileModel!.data!.user![0].favoTeam!=null?
                          Column(
                            children: [
                              Center(
                                child: Container(
                                  height: AppSize.s200,
                                  width: AppSize.s200,
                                  alignment: AlignmentDirectional.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xAA092136),
                                      borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))

                                    ),
                                    child: Center(
                                      child:     CachedNetworkImage(
                                        height: AppSize.s140,
                                        width: AppSize.s140,

                                        imageUrl:'$TAG_LOGO_URL${profileModel!.data!.user![0].favoTeam!.logo.toString()}',
                                        imageBuilder: (context, imageProvider) => Stack(
                                          children: [
                                            ClipRRect(

                                              child: Container(
                                                  height: AppSize.s140,
                                                  width: AppSize.s140,


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
                                  ),
                                ),
                              ),
                              Container(
                                height: AppSize.s50,
                                alignment: AlignmentDirectional.center,
                                child: Text(profileModel!.data!.user![0].favoTeam!.enTitle.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ColorManager.white,
                                  fontSize: FontSize.s12,
                                  fontWeight: FontWeight.normal
                                ),),
                              ),
                            ],
                          ):Container(),
                        ),
                        Container(
                          height: AppSize.s300,
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
                                          Text("profileDetails".tr(),style: TextStyle(
                                            color: ColorManager.black,
                                            fontSize: FontSize.s15,
                                            fontWeight: FontWeight.w500
                                          ),),
                                          GestureDetector(
                                            onTap: () async{
                               dynamic result =          await   Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (BuildContext context){
                                                return  EditProfileScreen(profileModel: profileModel!,);
                                              }));
                               if(result.toString() != "null"){
                                 profileModel = null;
                                 setState(() {


                                 });
                                 SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                 String id = sharedPreferences.getString("id")??"";
                                 Map<String,dynamic> map = {};
                                 map['id']= id;
                                 PointServices pointServices = PointServices();
                                    profileModel = await pointServices.profile(map);
                                    setState(() {

                                    });


                               }
                                            },
                                            child: Image.asset(ImageAssets.editProfile,width: AppSize.s18,
                                            height: AppSize.s18,
                                            fit: BoxFit.fill,),
                                          )

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
                                              "nameString".tr(),
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
                                                  profileModel!.data!.user![0].name.toString(),
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
                                                  profileModel!.data!.user![0].username.toString(),
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
                                                  "teamName".tr(),
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
                                                  profileModel!.data!.user![0].team.toString(),
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
                                                  profileModel!.data!.user![0].country.toString(),
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
                                                  "birthDay".tr(),
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
                                                  profileModel!.data!.user![0].birthday.toString().split(" ")[0],
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
                        SizedBox(height: AppSize.s10,),
                        Container(
                          height: AppSize.s40,
                          margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
                          decoration: BoxDecoration(
                            color: ColorManager.secondary,
                            borderRadius: BorderRadius.all(Radius.circular(AppSize.s5)),
                          ),
                          child: Stack(
                            children: [
                              Positioned.directional(
                                textDirection: Directionality.of(context),
                                top: 0,
                                bottom: 0,
                                start: 0,
                                end: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(ImageAssets.prizeIcon,color: ColorManager.white,
                                    width: AppSize.s16,height: AppSize.s14,),
                                    SizedBox(width: AppSize.s2,),
                                    Text("coins".tr(),
                                    style: TextStyle(
                                      color: ColorManager.white,
                                      fontSize: FontSize.s12,
                                      fontWeight: FontWeight.normal
                                    ),),
                                    SizedBox(width: AppSize.s2,),
                                    Text('(${profileModel!.data!.user![0].coins.toString()})',
                                      style: TextStyle(
                                          color: ColorManager.white,
                                          fontSize: FontSize.s12,
                                          fontWeight: FontWeight.normal
                                      ),),
                                  ],

                                ),
                              ),
                              Positioned.directional(textDirection: Directionality.of(context),
                                  start: 0,
                                  end: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: GestureDetector(
                                    onTap: (){
                                      coins("0");

                                    },
                                    child: Container(
                                      width: AppSize.width,
                                      height: AppSize.height,
                                      color: Color(0x00000000),
                                    ),
                                  ))
                            ],
                          ),


                        ),
                        SizedBox(height: AppSize.s10,),
                        Container(
                            height: AppSize.s40,
                          margin: EdgeInsets.symmetric(horizontal: AppSize.s20),

                          child: signOutButton("logout".tr(),context)


                        ),
                        SizedBox(height: AppSize.s10,),
                        Container(
                            height: AppSize.s40,
                            margin: EdgeInsets.symmetric(horizontal: AppSize.s20),

                            child: changePasswordButton("changePassword".tr(),context)


                        ),
                        SizedBox(height: AppSize.s10,),
                        Container(
                            height: AppSize.s40,
                            margin: EdgeInsets.symmetric(horizontal: AppSize.s20),

                            child: deleteAccountButton("deleteAccount".tr(),context)


                        ),

                      ],
                    )
            ),
          ),
        ),
      ),
    );
  }
  TextButton signOutButton(String text,BuildContext context){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      primary: const Color(0xFF122436),


      shape:  RoundedRectangleBorder(

        borderRadius: BorderRadius.all(Radius.circular(AppSize.s5)),
      ),
      backgroundColor:  const Color(0xFF122436),
    );

    return TextButton(
      style: flatButtonStyle,
      onPressed: ()  async{
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

        sharedPreferences.setBool("isLoggedIn", false);

        Navigator.of(context,rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (BuildContext context){
          return const LoginView();
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
  TextButton changePasswordButton(String text,BuildContext context){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      primary: const Color(0xFF122436),


      shape:  RoundedRectangleBorder(

        borderRadius: BorderRadius.all(Radius.circular(AppSize.s5)),
      ),
      backgroundColor:  const Color(0xFF122436),
    );

    return TextButton(
      style: flatButtonStyle,
      onPressed: ()  async{
        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (BuildContext context){
          return  const ChangePasswordScreen();
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
  TextButton deleteAccountButton(String text,BuildContext context){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      primary: const Color(0xFF122436),


      shape:  RoundedRectangleBorder(

        borderRadius: BorderRadius.all(Radius.circular(AppSize.s5)),
      ),
      backgroundColor:  const Color(0xFF122436),
    );

    return TextButton(
      style: flatButtonStyle,
      onPressed: ()  async{
       DeleteDialog(context);

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



  Future<void> DeleteDialog(BuildContext context) async{
    var alert;
    var alertStyle = AlertStyle(

      animationType: AnimationType.fromBottom,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(fontWeight: FontWeight.normal,
          color: Color(0xFF0000000),
          fontSize: FontSize.s18),
      descTextAlign: TextAlign.start,
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
          color: Color(0xFF000000),
          fontWeight: FontWeight.normal,
          fontSize: FontSize.s16
      ),
      alertAlignment: AlignmentDirectional.center,
    );
    alert =   Alert(
      context: context,
      style: alertStyle,

      title: "deleteAccount".tr(),


      buttons: [
        DialogButton(
          child: Text(
            'yes'.tr(),
            style: TextStyle(color: Color(0xFFFFFFFF), fontSize: FontSize.s18),
          ),
          onPressed: ()async{
            await alert.dismiss();
            deleteUser();



          },
          color: ColorManager.primary,
          radius: BorderRadius.circular(AppSize.s6),
        ),
        DialogButton(
          child: Text(
            'no'.tr(),
            style: TextStyle(color: Color(0xFFFFFFFF), fontSize: FontSize.s18),
          ),
          onPressed: ()async {
            await alert.dismiss();

          },
          color: ColorManager.primary,
          radius: BorderRadius.circular(AppSize.s6),
        )
      ],
    );
    alert.show();

  }


  void deleteUser() async{

    final modelHud = Provider.of<ModelHud>(context,listen: false);
    modelHud.changeIsLoading(true);

    SharedPreferences _preferences = await SharedPreferences.getInstance();

    PointServices petMartService = PointServices();

    String id = _preferences.getString("id")??"";




    DeleteUserModel?  deleteUserModel = await petMartService.deleteUser(id);
    modelHud.changeIsLoading(false);

     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("id","");
    sharedPreferences.setBool("isLoggedIn", false);
    sharedPreferences.setString("email", "");
    sharedPreferences.setString("password", "");

    Navigator.of(context,rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (BuildContext context){
      return const LoginView();
    }));


  }
}
