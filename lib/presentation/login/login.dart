import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:point/domain/LoginModel.dart';
import 'package:point/domain/home_model.dart';
import 'package:point/presentation/forget_password/forget_password.dart';
import 'package:point/presentation/register/register.dart';
import 'package:point/presentation/resources/color_manager.dart';
import 'package:point/presentation/resources/font_manager.dart';
import 'package:point/presentation/resources/strings_manager.dart';
import 'package:point/presentation/resources/values_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/point_services.dart';
import '../../domain/ErrorModel.dart';
import '../../providers/model_hud.dart';
import '../main/main.dart';
import '../resources/assets_manager.dart';
class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController =  TextEditingController();
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final TextEditingController _passwordController =  TextEditingController();
  String? userEmail;
  String? password;
  bool isLoggedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isUserLogIn().then((value) {
      setState(() {
        userEmail = value;
      });

    });
  }
  bool isBioEnabled = false;
  Future<String> isUserLogIn()async{

    isBioEnabled = await checkingForBioMetrics();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isLoggedIn = sharedPreferences.getBool("isLoggedIn")??false;
  String  email = sharedPreferences.getString("email")??"";
    password = sharedPreferences.getString("password")??"";
    return email;

  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
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
                  AppStrings.login,
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
                child: Image.asset(ImageAssets.loginLogo),
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
                      hintText: AppStrings.email,

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
              SizedBox(height: AppSize.s20,),
              SizedBox(
                height: AppSize.s40,

                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,



                    style: TextStyle(color:ColorManager.white,fontSize: FontSize.s12),
                    textAlign: TextAlign.start,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.visiblePassword ,
                    obscureText: true,

                    textInputAction: TextInputAction.done,
                    maxLines: 1,
                    minLines: 1,
                    controller: _passwordController,
                    decoration:  InputDecoration(
                      prefixIcon: Container(
                          margin: EdgeInsets.all(10),
                          child: Image.asset(ImageAssets.passwordLogin,height: 5,width: 5,fit: BoxFit.fitHeight,)),
                      hintText: AppStrings.password,

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
              SizedBox(height: AppSize.s40,),
              Container(
                alignment: AlignmentDirectional.center,
                child: isLoggedIn?isBioEnabled?
                GestureDetector(
                  onTap: (){
                    _authenticateMe();
                  },
                  child: Image.asset(ImageAssets.faceIdLogin,height: AppSize.s57,width: AppSize.s57,
                  fit: BoxFit.fill,),
                ):Container(height:AppSize.s57 ,):Container(height:AppSize.s57 ,)
              ),
              SizedBox(height: AppSize.s40,),
              Container(
                  alignment: AlignmentDirectional.center,
                  margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
                  child: loginButton(AppStrings.login,context)
              ),
              SizedBox(height: AppSize.s20,),
              Container(
                alignment: AlignmentDirectional.center,
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context,rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (BuildContext context){
                      return  const RegisterView();
                    }));
                  },
                  child: Text(AppStrings.register,
                  style: TextStyle(
                      decoration: TextDecoration.underline,

                    color: ColorManager.white,
                    fontSize: FontSize.s16,
                    fontWeight: FontWeight.normal
                  ),),
                ),
              ),
              SizedBox(height: AppSize.s20,),
              Container(
                alignment: AlignmentDirectional.center,
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (BuildContext context){
                      return  const ForgetPassworView();
                    }));
                  },
                  child: Text(AppStrings.forgetPassword,
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
  bool validateEmail(String value) {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);

    if (!emailValid) {
      return false;
    }else{
      return true;
    }


  }


  bool validateName(String value) {
    bool errorMessage ;

    if(value.trim().length < 5){
      errorMessage = false;
    }else{
      errorMessage = true;
    }




    return errorMessage;
  }
  void validate(BuildContext context) async{

    String email = _emailController.text;
    String password  = _passwordController.text;

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
      if(!validateName(password)){
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: AppStrings.error,
              text:AppStrings.passwordError,
              confirmButtonColor: ColorManager.primary,
              confirmButtonText: AppStrings.ok
          )
      );
    }else{
      final modelHud = Provider.of<ModelHud>(context,listen: false);
      modelHud.changeIsLoading(true);
      PointServices pointServices = PointServices();
      Map<String, dynamic>   response = await pointServices.login( email, password);
      modelHud.changeIsLoading(false);
      bool  isOk  = response['ok'];
      if(isOk){
        LoginModel loginModel = LoginModel.fromJson(response);
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String? id = loginModel?.data!.id;
        sharedPreferences.setString("id", id!);
        sharedPreferences.setBool("isLoggedIn", true);

        sharedPreferences.setString('email', _emailController.text);
        sharedPreferences.setString('password', _passwordController.text);
        sharedPreferences.setBool('isUser', true);
        // HomeModel? homeModel = await pointServices.home(id);


        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainView()),
        );
      }else{
        ErrorModel errorModel = ErrorModel.fromJson(response);
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: AppStrings.error,
                text:errorModel?.data!.msg,
                confirmButtonColor: ColorManager.primary,
                confirmButtonText: AppStrings.ok
            )
        );

      }

    }

  }
  Future<bool> checkingForBioMetrics() async {
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    print(canCheckBiometrics);
    return canCheckBiometrics;
  }
  Future<void> _authenticateMe() async {
// 8. this method opens a dialog for fingerprint authentication.
//    we do not need to create a dialog nut it popsup from device natively.
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticate(
        localizedReason: "Login With Biometric", // message for dialog

        // native process
      );
      if( authenticated){
        _emailController.text = userEmail!;
        _passwordController.text = password!;

        validate(context);


      }else{
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: AppStrings.error,
                text:AppStrings.notAuthorized,
                confirmButtonColor: ColorManager.primary,
                confirmButtonText: AppStrings.ok
            )
        );

      }

    } catch (e) {
      print(e);
    }
    if (!mounted) return;
  }
}
