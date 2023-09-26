import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/functions.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:point/domain/profile_model.dart';
import 'package:point/presentation/resources/strings_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/point_services.dart';
import '../../domain/edit_profile_model.dart';
import '../../providers/model_hud.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/values_manager.dart';
class EditProfileScreen extends StatefulWidget {
  ProfileModel profileModel;
   EditProfileScreen({Key? key,required this.profileModel}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String birthDay ="";
  String countryText="";
  final TextEditingController _nameController =  TextEditingController();
  final TextEditingController _userNameController =  TextEditingController();
  final TextEditingController _teamNameController =  TextEditingController();
  Country? _selectedCountry;
  void _showCountryPicker() async{
    final country = await showCountryPickerDialog(context,);
    if (country != null) {
      setState(() {
        _selectedCountry = country;
        countryText = country.name;
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
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting("en");
    _nameController.text = widget.profileModel.data!.user![0].name.toString();
    _userNameController.text = widget.profileModel.data!.user![0].username.toString();
    _teamNameController.text = widget.profileModel.data!.user![0].team.toString();
    birthDay = widget.profileModel.data!.user![0].birthday.toString().split(" ")[0];
    countryText = widget.profileModel.data!.user![0].country.toString();
    setState(() {

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
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: AppSize.s20),
                  alignment: AlignmentDirectional.center,
                  child: Text("editProfile".tr(),style: TextStyle(
                      color: ColorManager.white,
                      fontWeight: FontWeight.w500,
                      fontSize: FontSize.s18


                  ),),
                ),
                Container(
                  width: AppSize.width,
                  margin: EdgeInsets.all(AppSize.s20),
                  decoration: BoxDecoration(
                      color: ColorManager.white,
                      borderRadius: BorderRadius.all(Radius.circular(AppSize.s5))
                  ),

                  child: Container(
                    margin: EdgeInsets.all(AppSize.s20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: AppSize.s50,
                          margin: EdgeInsets.symmetric(vertical: AppSize.s10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("name".tr(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorManager.black,
                                    fontSize: FontSize.s12,
                                    fontWeight: FontWeight.w500
                                ),),
                              SizedBox(height: AppSize.s4,),
                              Expanded(flex:1,child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ColorManager.secondary,
                                        width: AppSize.s1
                                    ),
                                    color: ColorManager.white,
                                    borderRadius: BorderRadius.all(Radius.circular(AppSize.s5))
                                ),
                                child: TextField(

                                  style: TextStyle(color:ColorManager.black,fontSize: FontSize.s12),
                                  textAlign: TextAlign.start,
                                  textCapitalization: TextCapitalization.words,
                                  keyboardType: TextInputType.name ,

                                  textInputAction: TextInputAction.next,
                                  controller: _nameController,
                                  maxLines: null,
                                  decoration: const InputDecoration(

                                    isDense: true,
                                    focusedBorder: InputBorder.none,

                                    enabledBorder: InputBorder.none,
                                  ),

                                ),
                              ))
                            ],
                          ),
                        ),
                        Container(
                          height: AppSize.s50,
                          margin: EdgeInsets.symmetric(vertical: AppSize.s10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("userName".tr(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorManager.black,
                                    fontSize: FontSize.s12,
                                    fontWeight: FontWeight.w500
                                ),),
                              SizedBox(height: AppSize.s4,),
                              Expanded(flex:1,child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ColorManager.secondary,
                                        width: AppSize.s1
                                    ),
                                    color: ColorManager.white,
                                    borderRadius: BorderRadius.all(Radius.circular(AppSize.s5))
                                ),
                                child: TextField(

                                  style: TextStyle(color:ColorManager.black,fontSize: FontSize.s12),
                                  textAlign: TextAlign.start,
                                  textCapitalization: TextCapitalization.words,
                                  keyboardType: TextInputType.name ,

                                  textInputAction: TextInputAction.next,
                                  controller: _userNameController,
                                  maxLines: null,
                                  decoration: const InputDecoration(

                                    isDense: true,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                  ),

                                ),
                              )),

                            ],
                          ),
                        ),
                        Container(
                          height: AppSize.s50,
                          margin: EdgeInsets.symmetric(vertical: AppSize.s10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("teamName".tr(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorManager.black,
                                    fontSize: FontSize.s12,
                                    fontWeight: FontWeight.w500
                                ),),
                              SizedBox(height: AppSize.s4,),
                              Expanded(flex:1,child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ColorManager.secondary,
                                        width: AppSize.s1
                                    ),
                                    color: ColorManager.white,
                                    borderRadius: BorderRadius.all(Radius.circular(AppSize.s5))
                                ),
                                child: TextField(
                                  style: TextStyle(color:ColorManager.black,fontSize: FontSize.s12),
                                  textAlign: TextAlign.start,
                                  textCapitalization: TextCapitalization.words,
                                  keyboardType: TextInputType.name ,

                                  textInputAction: TextInputAction.next,
                                  controller: _teamNameController,
                                  maxLines: null,
                                  decoration: const InputDecoration(

                                    isDense: true,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                  ),

                                ),
                              )),

                            ],
                          ),
                        ),
                        Container(
                          height: AppSize.s50,
                          margin: EdgeInsets.symmetric(vertical: AppSize.s10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("nationality".tr(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorManager.black,
                                    fontSize: FontSize.s12,
                                    fontWeight: FontWeight.w500
                                ),),
                              SizedBox(height: AppSize.s4,),
                              Expanded(flex:1,child: GestureDetector(
                                onTap: (){
                                  _showCountryPicker();

                                },
                                child: Container(
                                    width: AppSize.width,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: ColorManager.secondary,
                                            width: AppSize.s1
                                        ),
                                        color: ColorManager.white,
                                        borderRadius: BorderRadius.all(Radius.circular(AppSize.s5))
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned.directional(
                                            top: 0,
                                            bottom: 0,
                                            start: AppSize.s10,
                                            textDirection: Directionality.of(context), child: Container(
                                          alignment: AlignmentDirectional.centerStart,
                                          child: Text(
                                            countryText,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: ColorManager.black,
                                                fontSize: FontSize.s12,
                                                fontWeight: FontWeight.w500
                                            ),
                                          ),
                                        )),
                                        Positioned.directional(textDirection: Directionality.of(context), child: Container(
                                          alignment: AlignmentDirectional.centerEnd,
                                          child: Icon(Icons.keyboard_arrow_down_outlined,
                                            size: AppSize.s20,
                                            color: ColorManager.secondary,
                                          ),
                                        ),
                                          top: 0,
                                          bottom: 0,
                                          end: AppSize.s20,)
                                      ],
                                    )
                                ),
                              )),

                            ],
                          ),
                        ),
                        Container(
                          height: AppSize.s50,
                          margin: EdgeInsets.symmetric(vertical: AppSize.s10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("birthDay".tr(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorManager.black,
                                    fontSize: FontSize.s12,
                                    fontWeight: FontWeight.w500
                                ),),
                              SizedBox(height: AppSize.s4,),
                              Expanded(flex:1,child: GestureDetector(
                                onTap: (){
                                  showDateDialog();
                                },
                                child: Container(
                                    width: AppSize.width,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: ColorManager.secondary,
                                            width: AppSize.s1
                                        ),
                                        color: ColorManager.white,
                                        borderRadius: BorderRadius.all(Radius.circular(AppSize.s5))
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned.directional(
                                            top: 0,
                                            bottom: 0,
                                            start: AppSize.s10,
                                            textDirection: Directionality.of(context), child: Container(
                                          alignment: AlignmentDirectional.centerStart,
                                          child: Text(
                                            birthDay,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: ColorManager.black,
                                                fontSize: FontSize.s12,
                                                fontWeight: FontWeight.w500
                                            ),
                                          ),
                                        )),
                                        Positioned.directional(textDirection: Directionality.of(context), child: Container(
                                            alignment: AlignmentDirectional.centerEnd,
                                            child: Image.asset(ImageAssets.birthDayLogo,height: AppSize.s15,
                                              width: AppSize.s15,)
                                        ),
                                          top: 0,
                                          bottom: 0,
                                          end: AppSize.s20,)
                                      ],
                                    )
                                ),
                              )),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(height: AppSize.s30,),
                Container(
                  height: AppSize.s40,
                  margin: EdgeInsets.symmetric(vertical: AppSize.s10,horizontal: AppSize.s20),
                  child: signOutButton("editProfile".tr(),context),
                ),
                Container(height: AppSize.s30,),


              ],
            ),
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


        validate(context);



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
  showDateDialog()async{

    DateTime dt = DateTime.parse(birthDay);
    DateTime now = DateTime.now().subtract(const Duration(days: 356));
    DateTime start = now.subtract(const Duration(days: 356*100));
    final DateTime? pickedDate = await  showDatePicker(initialEntryMode:DatePickerEntryMode.calendarOnly,
        context: context, initialDate: dt, firstDate: start, lastDate: now);
    if (pickedDate != null && pickedDate != now){
      String formattedDate =
      DateFormat('yyyy-MM-dd','en').format(pickedDate);
      setState(() {
        birthDay =
            formattedDate; //set output date to TextField value.
      });
    }
    // Picker.DatePicker.showDatePicker(context,
    //
    //     showTitleActions: true,
    //     minTime: start,
    //     maxTime: now, onChanged: (date) {
    //         String formattedDate =
    //         DateFormat('yyyy-MM-dd','en').format(date);
    //         setState(() {
    //               birthDay =
    //                   formattedDate; //set output date to TextField value.
    //             });
    //
    //       print('change $date');
    //     }, onConfirm: (date) {
    //       print('confirm $date');
    //     }, currentTime: dt, locale: Picker.LocaleType.en);
    // DateTime? pickedDate = await showDatePicker(
    //     context: context,
    //     initialDate:dt,
    //     firstDate:start,
    //     //DateTime.now() - not to allow to choose before today.
    //     lastDate: now);
    //
    // if (pickedDate != null) {
    //   print(
    //       pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
    //   String formattedDate =
    //   DateFormat('yyyy-MM-dd','en').format(pickedDate);
    //   print(
    //       formattedDate); //formatted date output using intl package =>  2021-03-16
    //   setState(() {
    //     birthDay =
    //         formattedDate; //set output date to TextField value.
    //   });
    // } else {}
  }

  void validate(BuildContext context)async {
    String name = _nameController.text;
    String userName = _userNameController.text;
    String country = countryText;
    String teamName = _teamNameController.text;
    if(name.trim()==""){
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
    }else if(userName.trim() == ""){
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
    }else if(teamName.trim() == ""){
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
    }else{
      final modelHud = Provider.of<ModelHud>(context,listen: false);
      modelHud.changeIsLoading(true);
      PointServices pointServices = PointServices();
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String id = sharedPreferences.getString("id")??"";
      Map<String,dynamic> map = {};
      map['id']= id;
      map['name']= name;
      map['country']= country;
      map['birthday']= birthDay;
      map['team']= teamName;
      map['username']= userName;
      EditProfileModel? profileModel = await pointServices.editProfile(map);
      modelHud.changeIsLoading(false);
      bool? isOk = profileModel!.ok;
      if(isOk!){
        Navigator.pop(context,"true");
      }
    }




  }
}
