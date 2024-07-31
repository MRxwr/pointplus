

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:point/domain/add_address_model.dart';
import 'package:point/domain/add_order_model.dart';
import 'package:point/presentation/resources/strings_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/point_services.dart';
import '../../providers/model_hud.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/values_manager.dart';
import 'main.dart';
class AddressScreen extends StatefulWidget {
  String itemId;
   AddressScreen({Key? key,required this.itemId}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController _nameController =  TextEditingController();
  final TextEditingController _emailController =  TextEditingController();
  final TextEditingController _phoneController =  TextEditingController();
  final TextEditingController _addressLineOneController =  TextEditingController();
  final TextEditingController _addressLineTwoController =  TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Country? _selectedCountry;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.itemId);
    initCountry();
  }
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
              margin: EdgeInsets.symmetric(horizontal: AppSize.s50),
              child: _selectedCountry == null?
              Container(
                child: const CircularProgressIndicator(


                ),
                alignment: AlignmentDirectional.center,
              ):ListView(
                padding: EdgeInsets.zero,
                children: [
               SizedBox(height: AppSize.s20,),
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
                      keyboardType: TextInputType.emailAddress ,
                      controller: _emailController,
                      style: TextStyle(
                          color: ColorManager.white,
                          fontWeight: FontWeight.normal,
                          fontSize: FontSize.s12
                      ),
                      decoration:  InputDecoration(
                        prefix:
                        Image.asset(ImageAssets.emailLogin,width: AppSize.s15,height: AppSize.s17,
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
                    alignment: AlignmentDirectional.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            _showCountryPicker();
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(AppSize.s4),
                                child: Image.asset(ImageAssets.arrowDownKw,width: AppSize.s9,
                                    height: AppSize.s6,),
                              ),
                              Image.asset( _selectedCountry!.flag,
                              package: countryCodePackageName,

                              width: AppSize.s21,height: AppSize.s11,),
                              SizedBox(width: AppSize.s4,),
                              Text(_selectedCountry!.callingCode.toString(),style: TextStyle(
                                color: ColorManager.white,
                                fontSize: FontSize.s12

                              ),),
                              SizedBox(width: AppSize.s4,),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextField(
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSize.s20,),
                  TextField(
                      keyboardType: TextInputType.multiline ,
                      maxLines: null,
                      controller: _addressLineOneController,
                      style: TextStyle(
                          color: ColorManager.white,
                          fontWeight: FontWeight.normal,
                          fontSize: FontSize.s12
                      ),
                      decoration:  InputDecoration(
                        prefix:
                        Image.asset(ImageAssets.locationIcon,width: AppSize.s12,height: AppSize.s17,
                          fit: BoxFit.fill,),



                        labelText: "addressLineOne".tr(),

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
                      keyboardType: TextInputType.multiline ,
                      maxLines: null,
                      controller: _addressLineTwoController,
                      style: TextStyle(
                          color: ColorManager.white,
                          fontWeight: FontWeight.normal,
                          fontSize: FontSize.s12
                      ),
                      decoration:  InputDecoration(
                        prefix:
                        Image.asset(ImageAssets.locationIcon,width: AppSize.s12,height: AppSize.s17,
                          fit: BoxFit.fill,),



                        labelText: "addressLineTwo".tr(),

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
                  SizedBox(height: AppSize.s100,),
                  Container(

                      child: loginButton("sumbit".tr(), context)),
                  SizedBox(height: AppSize.s20,),
                  Text("addressDetails".tr(),style: TextStyle(color: ColorManager.white,
                      fontSize: FontSize.s14,

                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,),
                  SizedBox(height: AppSize.s20,)
                ],

            ),
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

  void validate(BuildContext context) async {
    String name = _nameController.text;
    String mEmail = _emailController.text;

    String phoneNumber = _phoneController.text;
    String addressLineOne = _addressLineOneController.text;
    String addressLineTwo = _addressLineTwoController.text;
    print(mEmail);
    if(!validateName(name)){
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "error".tr(),
                text:"nameError".tr(),
                confirmButtonColor: ColorManager.primary,
                confirmButtonText: "ok".tr()
            )
        );
    }
    else if(!validateEmail(mEmail)){
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
    }
    else if(!validatePhone(phoneNumber)){
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
    }
    else if((addressLineOne.trim()=="") &( addressLineTwo.trim()=="")){
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "error".tr(),
              text:"addressLineError".tr(),
              confirmButtonColor: ColorManager.primary,
              confirmButtonText: "ok".tr()
          )
      );
    }else{
      final modelHud = Provider.of<ModelHud>(context,listen: false);
      modelHud.changeIsLoading(true);
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String id = sharedPreferences.getString("id")??"";
      Map<String,dynamic> map = {};
      map['userId']= id;
      map['name']= name;
      map['email']= mEmail;
      map['mobile']= '${_selectedCountry?.callingCode}$phoneNumber';
      map['country']= _selectedCountry?.name;
      map['address1']= addressLineOne;
      map['address2']= addressLineTwo;
      PointServices pointServices = PointServices();
      AddAddressModel? addAddressModel = await pointServices.addAddress(map);

      bool?  isOk = addAddressModel!.ok;
      if(isOk!){
        Map<String,dynamic> maps = {};
        maps['itemId']= widget.itemId;
        maps['userId']= id;
        maps['addressId']= addAddressModel.data!.address!.id;
        AddOrderModel? addOrderModel =  await pointServices.addOrder(maps);
        bool?  isOks = addOrderModel!.ok;
        modelHud.changeIsLoading(false);
        if(isOks!){
          successDialog(context: context);
        }

      }else{
        modelHud.changeIsLoading(false);
      }

    }
    }
  void successDialog({required BuildContext context}) {

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
                  child: Text("congratulations".tr(),
                    style: TextStyle(
                        color: ColorManager.black,
                        fontSize: FontSize.s15,
                        fontWeight: FontWeight.w500
                    ),),
                )),
                Expanded(flex:1,child: Container(
                  alignment: AlignmentDirectional.center,
                  child: Text("prizeWay".tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorManager.rectangle,
                        fontSize: FontSize.s15,
                        fontWeight: FontWeight.w500
                    ),),
                )),Expanded(flex:1,child: Container(
                  alignment: AlignmentDirectional.center,
                  child: Image.asset(ImageAssets.prizeIcon,width: AppSize.s30,
                    height: AppSize.s30,fit: BoxFit.fill,),
                )),
                Expanded(flex:1,child: Container(
                    margin: EdgeInsets.symmetric(vertical: AppSize.s5,horizontal: AppSize.s20),
                    alignment: AlignmentDirectional.center,
                    child: addressButton("home".tr(),context)
                ))

              ],
            ),
          ),
        ),
      );
    });
  }
  TextButton addressButton(String text,BuildContext context){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(



      shape:  RoundedRectangleBorder(

        borderRadius: BorderRadius.all(Radius.circular(AppSize.s5)),
      ),
      backgroundColor: ColorManager.secondary,
    );

    return TextButton(
      style: flatButtonStyle,
      onPressed: () {
        Navigator.of(context,rootNavigator: true).pushReplacement( MaterialPageRoute(builder: (BuildContext context){
          return  const MainView();
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

    if(value.trim().length < 0){
      errorMessage = false;
    }else{
      errorMessage = true;
    }




    return errorMessage;
  }
  bool validatePhone(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{8}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return false;
    }
    else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;





  }
}
