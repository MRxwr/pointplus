import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:point/domain/change_password_model.dart';
import 'package:point/presentation/login/login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/point_services.dart';
import '../../providers/model_hud.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/values_manager.dart';
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController =  TextEditingController();
  final TextEditingController _confirmpasswordController =  TextEditingController();
  final TextEditingController _oldPasswordController =  TextEditingController();
  String userId="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId().then((value) {
      setState(() {
        userId = value;
      });

    });
  }
Future<String> getUserId() async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();


  String id = sharedPreferences.getString("id")??"";
  print("UserId ---> ${id}");
  return id;
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
              margin: EdgeInsets.all(AppSize.s30),
              child: userId == ""?Container():Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: AppSize.s20),
                    alignment: AlignmentDirectional.center,
                    child: Text("changePassword".tr(),style: TextStyle(
                        color: ColorManager.white,
                        fontWeight: FontWeight.w500,
                        fontSize: FontSize.s18


                    ),),
                  ),
                  SizedBox(height: AppSize.s20,),
                  TextField(
                      keyboardType: TextInputType.text ,
                      controller: _oldPasswordController,
                      obscureText: true,
                      style: TextStyle(
                          color: ColorManager.white,
                          fontWeight: FontWeight.normal,
                          fontSize: FontSize.s12
                      ),
                      decoration:  InputDecoration(
                        prefix:
                        Image.asset(ImageAssets.passwordIcon,width: AppSize.s15,height: AppSize.s17,
                          fit: BoxFit.fill,),





                        labelText: "oldPassword".tr(),

                        labelStyle:  TextStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s16,
                            fontWeight: FontWeight.normal

                        ),enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorManager.white),
                      ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.white),
                        ),
                      )
                  ),
                  SizedBox(height: AppSize.s20,),
                  TextField(
                      keyboardType: TextInputType.text ,
                      controller: _passwordController,
                      obscureText: true,
                      style: TextStyle(
                          color: ColorManager.white,
                          fontWeight: FontWeight.normal,
                          fontSize: FontSize.s12
                      ),
                      decoration:  InputDecoration(
                        prefix:
                        Image.asset(ImageAssets.passwordIcon,width: AppSize.s15,height: AppSize.s17,
                          fit: BoxFit.fill,),





                        labelText: "NewPassword".tr(),

                        labelStyle:  TextStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s16,
                            fontWeight: FontWeight.normal

                        ),enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorManager.white),
                      ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.white),
                        ),
                      )
                  ),
                  SizedBox(height: AppSize.s20,),
                  TextField(
                      keyboardType: TextInputType.text ,
                      controller: _confirmpasswordController,
                      obscureText: true,
                      style: TextStyle(
                          color: ColorManager.white,
                          fontWeight: FontWeight.normal,
                          fontSize: FontSize.s12
                      ),
                      decoration:  InputDecoration(
                        prefix:
                        Image.asset(ImageAssets.passwordIcon,width: AppSize.s15,height: AppSize.s17,
                          fit: BoxFit.fill,),





                        labelText: "confirmNewPassword".tr(),

                        labelStyle:  TextStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s16,
                            fontWeight: FontWeight.normal

                        ),enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorManager.white),
                      ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorManager.white),
                        ),
                      )
                  ),
                  SizedBox(height: AppSize.s40,),
                  regsterButton("changePassword".tr(), context),
                ],

              ),
            ),
          ),
        ),
      ),
    );
  }
  TextButton regsterButton(String text,BuildContext context){
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
      onPressed: ()async {
        String oldPassword = _oldPasswordController.text;
        String newPassword = _passwordController.text;
        String confirmNewPassword = _confirmpasswordController.text;
        if(oldPassword.trim() == ""){
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.danger,
                  title: "error".tr(),
                  text:"passwordError".tr(),
                  confirmButtonColor: ColorManager.primary,
                  confirmButtonText: "ok".tr()
              )
          );
        }else if(newPassword.trim() ==""){
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.danger,
                  title: "error".tr(),
                  text:"passwordError".tr(),
                  confirmButtonColor: ColorManager.primary,
                  confirmButtonText: "ok".tr()
              )
          );
        }else if(confirmNewPassword.trim() == ""){
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.danger,
                  title: "error".tr(),
                  text:"passwordError".tr(),
                  confirmButtonColor: ColorManager.primary,
                  confirmButtonText: "ok".tr()
              )
          );
        }else if(newPassword.trim()!= confirmNewPassword.trim()){
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.danger,
                  title: "error".tr(),
                  text:"passwordConfirmError".tr(),
                  confirmButtonColor: ColorManager.primary,
                  confirmButtonText: "ok".tr()
              )
          );
        }else{
          Map<String,dynamic> map ={};
          map['id'] = userId;
          map['oldPassword'] = oldPassword;
          map['newPassword'] = newPassword;
          map['confirmPassword'] = confirmNewPassword;

          final modelHud = Provider.of<ModelHud>(context,listen: false);
          modelHud.changeIsLoading(true);
          PointServices pointServices = PointServices();
          ChangePasswordModel? changePasswordModel = await pointServices.changePassword(map);
          modelHud.changeIsLoading(false);
          bool?  isOk  = changePasswordModel!.ok;
          if(isOk!){

            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

            sharedPreferences.setString("id", userId);



            sharedPreferences.setString('password', _passwordController.text);

            // HomeModel? homeModel = await pointServices.home(id);


            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginView()),
            );
          }else{

            ArtSweetAlert.show(
                context: context,
                artDialogArgs: ArtDialogArgs(
                    type: ArtSweetAlertType.danger,
                    title: "error".tr(),
                    text:changePasswordModel.data!.msg,
                    confirmButtonColor: ColorManager.primary,
                    confirmButtonText: "ok".tr()
                )
            );

          }
        }





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

}
