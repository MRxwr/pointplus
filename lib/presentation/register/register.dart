import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:point/domain/register_error_model.dart';
import 'package:point/domain/register_model.dart';
import 'package:point/presentation/login/login.dart';
import 'package:point/presentation/main/teams_screen.dart';
import 'package:point/presentation/resources/font_manager.dart';
import 'package:point/presentation/resources/strings_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/point_services.dart';
import '../../app/constant.dart';
import '../../providers/model_hud.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/values_manager.dart';
class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _nameController =  TextEditingController();
  final TextEditingController _userNameController =  TextEditingController();
  final TextEditingController _teamNameController =  TextEditingController();
  final TextEditingController _emailController =  TextEditingController();
  final TextEditingController _phoneController =  TextEditingController();
  final TextEditingController _passwordController =  TextEditingController();
  final TextEditingController _confirmpasswordController =  TextEditingController();
  String birthDay = "";
  String startDate ="1950-01-01";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
 initializeDateFormatting("en");
    initCountry();
  }
  Country? _selectedCountry;
  void _showCountryPicker() async{
    final country = await showCountryPickerDialog(context,);
    if (country != null) {
      setState(() {
        _selectedCountry = country;

      });
    }
  }
  void initCountry() async {
    final country = await getCountryByCountryCode(context,'KW');
    setState(() {
      _selectedCountry = country;
    });
  }
  @override
  Widget build(BuildContext context) {
    // initializeDateFormatting('en','');
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
            child:   Text("completeProfile".tr(),
              style: TextStyle(
                color: ColorManager.secondary,
                fontSize:FontSize.s20,
                fontWeight: FontWeight.bold,

              ),),
          ),
          actions: [
            SizedBox(width: AppSize.s30,)
          ],
          leading:
          GestureDetector(

            child:      SizedBox(width: AppSize.s30,)
          ),


        ),
          body: Container(
            decoration:  const BoxDecoration(
                image:  DecorationImage(
                  image: AssetImage(ImageAssets.background),
                  fit: BoxFit.cover,
                )),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: AppSize.s40),
              child: _selectedCountry == null?
              Container():ListView(

                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  TextField(
                      keyboardType: TextInputType.text ,
                      controller: _nameController,
                      style: TextStyle(
                          color: ColorManager.white,
                          fontWeight: FontWeight.normal,
                          fontSize: FontSize.s12
                      ),
                      decoration:  InputDecoration(
                        prefix:
                        Image.asset(ImageAssets.nameImage,width: AppSize.s15,height: AppSize.s17,
                          fit: BoxFit.fill,),





                        labelText: "name".tr(),

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
                      controller: _userNameController,
                      style: TextStyle(
                          color: ColorManager.white,
                          fontWeight: FontWeight.normal,
                          fontSize: FontSize.s12
                      ),
                      decoration:  InputDecoration(
                        prefix:
                        Image.asset(ImageAssets.userNameIcon,width: AppSize.s15,height: AppSize.s17,
                          fit: BoxFit.fill,),





                        labelText: "userName".tr(),

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
                      controller: _teamNameController,
                      style: TextStyle(
                          color: ColorManager.white,
                          fontWeight: FontWeight.normal,
                          fontSize: FontSize.s12
                      ),
                      decoration:  InputDecoration(
                        prefix:
                        Image.asset(ImageAssets.teamNameIcon,width: AppSize.s15,height: AppSize.s17,
                          fit: BoxFit.fill,),





                        labelText: "teamName".tr(),

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
                      keyboardType: TextInputType.emailAddress ,
                      controller: _emailController,
                      style: TextStyle(
                          color: ColorManager.white,
                          fontWeight: FontWeight.normal,
                          fontSize: FontSize.s12
                      ),
                      decoration:  InputDecoration(
                        prefix:
                        Image.asset(ImageAssets.emailIcon,width: AppSize.s15,height: AppSize.s17,
                          fit: BoxFit.fill,),





                        labelText: "email".tr(),

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
                  Container(
                    margin: EdgeInsets.symmetric(vertical: AppSize.s10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        GestureDetector(
                          onTap: (){
                            showDateDialog();
                          },
                          child: Container(
                            height: AppSize.s50,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width:AppSize.s1, color: ColorManager.white),
                              ),
                            ),
                            child: Row(
                              children: [

                                Padding(
                                  padding: EdgeInsets.all(AppSize.s5),
                                    child: Image.asset(ImageAssets.birthDayIcon,height: AppSize.s15,width: AppSize.s15,)),
                                Text(birthDay ==""?"birthDay".tr():birthDay,
                                style: TextStyle(
                                  color: ColorManager.white,
                                  fontSize: FontSize.s12,
                                  fontWeight: FontWeight.normal
                                ),)
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: AppSize.s20,),
                  Container(
                    height: AppSize.s50,
                    alignment: AlignmentDirectional.center,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            _showCountryPicker();
                          },
                          child: Row(
                            children: [
                              Image.asset( _selectedCountry!.flag,
                                package: countryCodePackageName,
                                width: AppSize.s20,
                              height: AppSize.s10,),
                              SizedBox(width: AppSize.s4,),
                              Text(_selectedCountry!.callingCode.toString(),style: TextStyle(
                                color: ColorManager.white,
                                fontSize: FontSize.s12,
                                fontWeight: FontWeight.normal
                              ),),
                              SizedBox(width: AppSize.s4,),
                            ],
                          ),
                        ),
                        Expanded(flex:1,child:  TextField(
                            keyboardType: TextInputType.phone ,
                            controller: _phoneController,
                            style: TextStyle(
                                color: ColorManager.white,
                                fontWeight: FontWeight.normal,
                                fontSize: FontSize.s12
                            ),
                            decoration:  InputDecoration(







                              labelText: "phone".tr(),

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
                        ),)


                      ],
                    ),
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





                        labelText: "password".tr(),

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





                        labelText: "confirmPassword".tr(),

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
                  regsterButton("register".tr(), context),
                  SizedBox(height: AppSize.s20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("alreadyHaveAccount".tr(),
                      style: TextStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s16,
                        fontWeight: FontWeight.normal,

                      ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context,rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (BuildContext context){
                            return  const LoginView();
                          }));
                        },
                        child: Text("login".tr(),
                          style: TextStyle(
                              decoration: TextDecoration.underline,

                              color: ColorManager.white,
                              fontSize: FontSize.s16,
                              fontWeight: FontWeight.normal
                          ),),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.s50,),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
  showDateDialog()async{


    DateTime now = DateTime.now().subtract(const Duration(days: 356));
    DateTime start = now.subtract(const Duration(days: 356*100));
    DatePicker.showDatePicker(context,

        showTitleActions: true,
        minTime: start,
        maxTime: now, onChanged: (date) {
          String formattedDate =
          DateFormat('yyyy-MM-dd','en').format(date);
          setState(() {
            birthDay =
                formattedDate; //set output date to TextField value.
          });

          print('change $date');
        }, onConfirm: (date) {
          print('confirm $date');
        }, currentTime: now, locale: LocaleType.en);

  }
  TextButton regsterButton(String text,BuildContext context){
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

  void validate(BuildContext context)async {
    String name = _nameController.text;
    String userName =_userNameController.text;
    String teamName = _teamNameController.text;
    String emailAddress = _emailController.text;
    String phoneNumber = _phoneController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmpasswordController.text;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String language = sharedPreferences.getString(LANG_CODE)??"en";
    String mToken =sharedPreferences.getString("token")??"";
    if(!validateName(name)){
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "error".tr(),
              text:"nameHint".tr(),
              confirmButtonColor: ColorManager.primary,
              confirmButtonText: "ok".tr()
          )
      );
    }else if(!validateName(userName)){
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "error".tr(),
              text:"userNameError".tr(),
              confirmButtonColor: ColorManager.primary,
              confirmButtonText: "ok".tr()
          )
      );
    }else if(!validateName(teamName)){
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "error".tr(),
              text:"teamNameError".tr(),
              confirmButtonColor: ColorManager.primary,
              confirmButtonText: "ok".tr()
          )
      );
    }else if(!validateEmail(emailAddress)){
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "error".tr(),
              text:"emailError".tr(),
              confirmButtonColor: ColorManager.primary,
              confirmButtonText: "ok".tr()
          )
      );
    }else if(phoneNumber.trim().isEmpty){
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "error".tr(),
              text:"phoneError".tr(),
              confirmButtonColor: ColorManager.primary,
              confirmButtonText: "ok".tr()
          )
      );
    }
    else if(!validateName(password)){
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
    }else if(!validateName(confirmPassword)){
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
    }else if(password!= confirmPassword){
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
      map['name'] = name;
      map['username'] = userName;
      map['email'] = emailAddress;
      map['mobile'] = "${_selectedCountry!.callingCode}${phoneNumber}";
      map['birthday'] = birthDay.isEmpty?"1111-11-11":birthDay;
      map['team'] = teamName;
      map['country'] = _selectedCountry!.name;
      map['password'] = password;
      map['confirmPassword'] = confirmPassword;
      map['firebase'] = mToken;
      print('map----> ${map}');
      final modelHud = Provider.of<ModelHud>(context,listen: false);
      modelHud.changeIsLoading(true);
      PointServices pointServices = PointServices();
      Map<String, dynamic>   response = await pointServices.register(map);
      modelHud.changeIsLoading(false);
      bool  isOk  = response['ok'];
      if(isOk){
        RegisterModel loginModel = RegisterModel.fromJson(response);
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String? id = loginModel.data!.id;
        sharedPreferences.setString("id", id!);
        sharedPreferences.setBool("isLoggedIn", false);

        sharedPreferences.setString('email', _emailController.text);
        sharedPreferences.setString('password', _passwordController.text);
        sharedPreferences.setBool('isUser', true);
        // HomeModel? homeModel = await pointServices.home(id);


        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TeamsScreen()),
        );
      }else{
        RegisterErrorModel errorModel = RegisterErrorModel.fromJson(response);
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



}
