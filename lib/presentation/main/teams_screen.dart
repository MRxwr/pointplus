import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:point/domain/update_team_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/point_services.dart';
import '../../app/constant.dart';
import '../../domain/prediction_model.dart';
import '../../domain/team_model.dart';
import '../../providers/model_hud.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import 'league_model.dart';
import 'main.dart';
extension GroupingBy on Iterable<dynamic> {
  Map<String, List<dynamic>> groupingBy(String key){
    var result = <String, List<dynamic>>{};
    for(var element in this){
      result[element[key]] = (result[element[key]] ?? [])..add(element);
    }
    return result;
  }
}
class TeamsScreen extends StatefulWidget {
  const TeamsScreen({Key? key}) : super(key: key);

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  PredictionModel? predictionModel;
  String teamId = "";
  List? result;
  List<Teams> leaguesList =[];
  Map<String, List<dynamic>>? peopleByLocation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    predictions().then((value) {
      setState(() {
        peopleByLocation = value;
      });

    });



  }
  String language ="";
  Future< Map<String, List<dynamic>>> predictions() async{
    Map<String,dynamic> map = {};
    PointServices pointServices = PointServices();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    language = sharedPreferences.getString(LANG_CODE)??"";

    List  result  = await pointServices.teams(map);
   print('list ---> ${result}');
    Map<String, List<dynamic>> peopleByLocation = result.groupingBy('leagueId');
    print("peopleByLocation ---> ${peopleByLocation}");
    for(int i =0;i<peopleByLocation!.keys.toList().length;i++){
      print('i ---> ${i}');
      for(int j =0;j<peopleByLocation![peopleByLocation!.keys.toList()[i]]!.toList().length;j++){
        print('j ---> ${i}${j}');
        if((i == 0) & (j == 0)){
          teamId = peopleByLocation![peopleByLocation!.keys.toList()[i]]!.toList()[j]['teamId'];
          break;

        }

      }

    }


    // for(int i =0;i<peopleByLocation.keys.toList().length;i++){
    //   print("${peopleByLocation[peopleByLocation.keys.toList()[i]]} \n");
    // }

    return peopleByLocation;
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
              child:   Text("fovariteTeam".tr(),
                style: TextStyle(
                  color: ColorManager.secondary,
                  fontSize:FontSize.s20,
                  fontWeight: FontWeight.bold,

                ),),
            ),



          ),
          body: Container(
            decoration:  const BoxDecoration(
                image:  DecorationImage(
                  image: AssetImage(ImageAssets.background),
                  fit: BoxFit.cover,
                )),
            child: Container(
              margin: EdgeInsets.all(AppSize.s20),
              child:peopleByLocation == null?
              Container(
                child: const CircularProgressIndicator(


                ),
                alignment: AlignmentDirectional.center,
              ):ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,

                      itemBuilder: (context,index){
                    return Container(
                      height: AppSize.s170,

                      child: Column(
                        children: [
                          Expanded(flex:1,child: Container(
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  height: AppSize.s70,
                                  width: AppSize.s70,
                                  imageUrl:'$TAG_LOGO_URL${peopleByLocation![peopleByLocation!.keys.toList()[index]]!.toList()[0]['leagueLogo']}',
                                  imageBuilder: (context, imageProvider) => Stack(
                                    children: [
                                      ClipRRect(


                                        child: Container(
                                            height: AppSize.s70,
                                            width: AppSize.s70,


                                            decoration: BoxDecoration(

                                              shape: BoxShape.rectangle,

                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: imageProvider),
                                            )
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(AppSize.s5)),
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
                                SizedBox(width: AppSize.s20,),
                                Text(language == "en"?
                                    peopleByLocation![peopleByLocation!.keys.toList()[index]]!.toList()[0]['leagueEnTitle']:
                                peopleByLocation![peopleByLocation!.keys.toList()[index]]!.toList()[0]['leagueArTitle'] ,
                                  style: TextStyle(
                                    color: ColorManager.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: FontSize.s15
                                  ),
                                )
                              ],
                            ),
                          )),
                          Container(
                            height: AppSize.s1,
                            color: ColorManager.white,
                          ),
                          Expanded(flex:1,child:
                              ListView.separated(
                                scrollDirection: Axis.horizontal,
                                  itemBuilder: (context,ind){
                                  return GestureDetector(
                                    onTap: (){
                                      for(int i =0;i<peopleByLocation!.keys.toList().length;i++){
                                        print('i ---> ${i}');
                                        for(int j =0;j<peopleByLocation![peopleByLocation!.keys.toList()[i]]!.toList().length;j++){
                                          print('j ---> ${i}${j}');
                                          if((ind == j) & (i == index)){
                                            if(peopleByLocation![peopleByLocation!.keys.toList()[i]]!.toList()[j]['isSelected'] == true){
                                              peopleByLocation![peopleByLocation!.keys.toList()[i]]!.toList()[j]['isSelected'] = false;

                                            }else{
                                              teamId = peopleByLocation![peopleByLocation!.keys.toList()[i]]!.toList()[j]['teamId'];
                                              peopleByLocation![peopleByLocation!.keys.toList()[i]]!.toList()[j]['isSelected'] = true;
                                            }



                                          }else{
                                            peopleByLocation![peopleByLocation!.keys.toList()[i]]!.toList()[j]['isSelected'] = false;
                                          }

                                        }

                                      }

                                      setState(() {

                                      });


                                    },
                                    child: Container(
                                      alignment: AlignmentDirectional.center,
                                      width: AppSize.s70,
                                      height: AppSize.s70,
                                      decoration:   peopleByLocation![peopleByLocation!.keys.toList()[index]]!.toList()[ind]['isSelected']?
                                      BoxDecoration(
                                          border:
                                          Border.all(color: ColorManager.secondary,
                                          width: AppSize.s2),
                                          color: ColorManager.white,
                                          shape: BoxShape.circle
                                      ):BoxDecoration(
                                          color: ColorManager.white,
                                          shape: BoxShape.circle
                                      ),child:
                                      CachedNetworkImage(
                                        height: AppSize.s50,
                                        width: AppSize.s50,
                                        imageUrl:'$TAG_LOGO_URL${peopleByLocation![peopleByLocation!.keys.toList()[index]]!.toList()[ind]['teamLogo']}',
                                        imageBuilder: (context, imageProvider) => Stack(
                                          children: [
                                            ClipRRect(


                                              child: Container(
                                                  height: AppSize.s50,
                                                  width: AppSize.s50,


                                                  decoration: BoxDecoration(


                                                    shape: BoxShape.circle,

                                                    image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: imageProvider),
                                                  )
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(AppSize.s5)),
                                            ),
                                          ],
                                        ),
                                        placeholder: (context, url) =>
                                            Center(
                                              child: SizedBox(
                                                  height: AppSize.s30,
                                                  width: AppSize.s30,
                                                  child: const CircularProgressIndicator()),
                                            ),


                                        errorWidget: (context, url, error) => ClipRRect(
                                          child: Icon(Icons.image_not_supported_outlined,color: ColorManager.navColor,
                                            size: AppSize.s60,),

                                        ),
                                      ),


                                    ),
                                  );


                              }, separatorBuilder: (context,i){
                                  return Container(
                                    width: AppSize.s20,
                                  );

                              }, itemCount: peopleByLocation![peopleByLocation!.keys.toList()[index]]!.toList().length)
                          )

                        ],
                      )

                      // Text(
                      //   peopleByLocation![peopleByLocation!.keys.toList()[index]]!.toList()[0]['leagueLogo'],
                      // )
                    );
                  }, separatorBuilder: (context,index){
                    return Container(
                      height: AppSize.s20,

                    );

                  }, itemCount: peopleByLocation!.keys.toList().length),
                  SizedBox(height: AppSize.s30,),
                  addTeamButton("done".tr(),context),
                  SizedBox(height: AppSize.s50,),

                ],
              )

            ),
          ),
        ),
      ),
    );
  }
  TextButton addTeamButton(String text,BuildContext context){
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

    final modelHud = Provider.of<ModelHud>(context,listen: false);
    modelHud.changeIsLoading(true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("id")??"";
    PointServices pointServices = PointServices();
    Map<String,dynamic> map = {};
    map['userId']= id;
    map['favoTeam']= teamId;
    sharedPreferences.setBool("isLoggedOff", false);
    print(map);
    UpdateTeamModel? updateTeamModel = await pointServices.updateTeam(map);
    bool? isOk = updateTeamModel!.ok;
    modelHud.changeIsLoading(false);
    // if(isOk!){
      sharedPreferences.setBool("isLoggedIn", true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainView()),
      );
    // }

  }
}
