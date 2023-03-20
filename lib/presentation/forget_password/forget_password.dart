import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:point/domain/ForgetPasswordModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/point_services.dart';
import '../../providers/model_hud.dart';
import '../login/login.dart';
import '../register/register.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
class ForgetPassworView extends StatefulWidget {
  const ForgetPassworView({Key? key}) : super(key: key);

  @override
  State<ForgetPassworView> createState() => _ForgetPassworViewState();
}

class _ForgetPassworViewState extends State<ForgetPassworView> {
  final TextEditingController _emailController =  TextEditingController();

  final TextEditingController _passwordController =  TextEditingController();

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
          body: Container(
            decoration:   const BoxDecoration(
                image:  DecorationImage(
                  image: AssetImage(ImageAssets.background),
                  fit: BoxFit.cover,
                )),
            child: Column(
              children: [
                Container(
                  height: AppSize.s120,
                  alignment: AlignmentDirectional.center,
                  child: Text(
                   "forgotPassword".tr(),
                    style: TextStyle(
                        color: ColorManager.secondary,
                        fontSize: FontSize.s20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  height: AppSize.s60,
                  alignment: AlignmentDirectional.center,
                  child:SvgPicture.asset(
                    'assets/images/app_logo.svg',
                    height: AppSize.s60,


                  ),
                ),
                SizedBox(height: AppSize.s60,),
                SizedBox(
                  height: AppSize.s40,

                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,



                      style: TextStyle(color:ColorManager.white,fontSize: FontSize.s12),
                      textAlign: TextAlign.start,
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.emailAddress ,

                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      minLines: 1,
                      controller: _emailController,
                      decoration:  InputDecoration(
                        prefixIcon: Container(
                            margin: EdgeInsets.all(10),
                            child: Image.asset(ImageAssets.emailLogin,height: 5,width: 5,fit: BoxFit.fitHeight,)),
                        hintText: "email".tr(),

                        hintStyle: TextStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s12,
                            fontWeight: FontWeight.normal
                        ),


                        labelStyle:  TextStyle(color: ColorManager.white,
                            fontSize: FontSize.s12),

                        enabledBorder:      UnderlineInputBorder(

                            borderSide: BorderSide(
                                color: ColorManager.white
                                ,width: AppSize.s1
                            )
                        ),
                        focusedBorder: UnderlineInputBorder(

                            borderSide: BorderSide(
                                color: ColorManager.white
                                ,width: AppSize.s1
                            )
                        ),
                        border: UnderlineInputBorder(

                            borderSide: BorderSide(
                                color: ColorManager.white
                                ,width:AppSize.s1
                            )
                        ),
                      ),
                    ),
                  ),
                ),


                SizedBox(height: AppSize.s100,),
                Container(
                    alignment: AlignmentDirectional.center,
                    margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
                    child: loginButton("resetPassword".tr(),context)
                ),
                SizedBox(height: AppSize.s40,),

                Container(
                  alignment: AlignmentDirectional.center,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginView()),
                      );
                    },
                    child: Text("back".tr(),
                      style: TextStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s16,
                          fontWeight: FontWeight.normal
                      ),),
                  ),
                ),
                Container()

              ],
            ),

          ),
        ),
      ),
    );
  }
  TextButton loginButton(String text,BuildContext context){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      primary: ColorManager.secondary,
      minimumSize: Size(width, AppSize.s55 ),

      shape:  RoundedRectangleBorder(

        borderRadius: BorderRadius.all(Radius.circular(AppSize.s27)),
      ),
      backgroundColor: ColorManager.secondary,
    );

    return TextButton(
      style: flatButtonStyle,
      onPressed: () {
        validate(context);


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
  void validate(BuildContext context) async{

    String email = _emailController.text;


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
    final modelHud = Provider.of<ModelHud>(context,listen: false);
    modelHud.changeIsLoading(true);
    PointServices pointServices = PointServices();
    Map<String, dynamic>   response = await pointServices.forgetPassword(email);
    modelHud.changeIsLoading(false);
    bool  isOk  = response['ok'];
    if(isOk){
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      ForgetPasswordModel forgetPasswordModel = ForgetPasswordModel.fromJson(response);
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.success,
              title: "success".tr(),
              text:forgetPasswordModel?.data!.msg,
              confirmButtonColor: ColorManager.primary,
              confirmButtonText: "ok".tr()
          )
      );
    }else{
      ForgetPasswordModel errorModel = ForgetPasswordModel.fromJson(response);
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "error".tr(),
              text:errorModel.data!.msg,
              confirmButtonColor: ColorManager.primary,
              confirmButtonText: "ok".tr()
          )
      );

    }

  }

}
