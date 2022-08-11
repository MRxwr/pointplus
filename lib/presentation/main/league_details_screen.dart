import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:point/domain/league_details_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/point_services.dart';
import '../../domain/leagues_model.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
class LeagueDetailsScreen extends StatefulWidget {
  GlobalKey<NavigatorState> page;
  LeagueDetailsModel leagueDetailsModel;
   LeagueDetailsScreen({Key? key,required this.page,required this.leagueDetailsModel}) : super(key: key);

  @override
  State<LeagueDetailsScreen> createState() => _LeagueDetailsScreenState();
}

class _LeagueDetailsScreenState extends State<LeagueDetailsScreen> {
  bool isCopied = false;
  LeaguesModel? leaguesModel;
  int overAllPoints =0;
  int rank = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // leagues().then((value) {
    //   setState(() {
    //     leaguesModel = value;
    //   });
    //
    // });
  }
  // Future<LeaguesModel?> leagues() async{
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   String id = sharedPreferences.getString("id")??"";
  //   PointServices pointServices = PointServices();
  //   LeaguesModel? leaguesModel = await pointServices.leagues("0");
  //   int size =0;
  //   for(int i =0;i<leaguesModel!.data!.users!.length;i++){
  //     overAllPoints += int.parse(leaguesModel.data!.users![i].points!);
  //     size++;
  //
  //   }
  //   double dRank =overAllPoints.toDouble()/size.toDouble();
  //   rank = dRank.toInt();
  //   return leaguesModel;
  // }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: ListView(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Container(height: AppSize.s10,),
          Container(height: AppSize.s80,
            margin: EdgeInsets.symmetric(horizontal: AppSize.s20),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageAssets.header),
                  fit: BoxFit.cover,
                ),
              ),
            ),),
          Container(height: AppSize.s50,),
          Container(
              alignment: AlignmentDirectional.center,
              child: Text(widget.leagueDetailsModel.data!.league![0].title.toString(),
                style: TextStyle(
                  color: ColorManager.white,
                  fontWeight: FontWeight.w500,
                  fontSize: FontSize.s17,
                ),)),
          Container(height: AppSize.s5,),
          Container(
              alignment: AlignmentDirectional.center,
              child: Text(AppStrings.Joined+"(0)",
                style: TextStyle(
                  color: ColorManager.white,
                  fontWeight: FontWeight.w500,
                  fontSize: FontSize.s12,
                ),)),
          Container(height: AppSize.s10,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: AppSize.s30),
            height: AppSize.s34,
            child: Row(
              children: [
                Expanded(flex:1,
                    child: GestureDetector(
                      onTap: (){
                        // widget.page.currentState!.push(MaterialPageRoute(builder: (context) =>  JoinLeagueScreen(page: widget.page,)));
                        // // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const JoinLeagueScreen()),
                        // );
                      },
                      child: Container(
                        alignment: AlignmentDirectional.center,
                        decoration: BoxDecoration(
                            color: ColorManager.white,

                            borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
                        ),
                        child: Text(
                          AppStrings.leagueCode+" : "+widget.leagueDetailsModel.data!.league![0].code.toString(),
                          style: TextStyle(
                              color: ColorManager.background,
                              fontSize: FontSize.s10,
                              fontWeight: FontWeight.w500
                          ),
                        ),


                      ),
                    )),
                SizedBox(width: AppSize.s20,),
                Expanded(flex:1,
                    child: GestureDetector(
                      onTap: (){
                        Clipboard.setData( ClipboardData(text:widget.leagueDetailsModel.data!.league![0].code.toString() ));
                        isCopied = true;
                        setState(() {

                        });

                        // widget.page.currentState!.push(MaterialPageRoute(builder: (context) =>  CreateInvitationLeagueScreen(page: widget.page,)));

                      },
                      child: Container(
                        alignment: AlignmentDirectional.center,
                        decoration: BoxDecoration(
                            color: ColorManager.rectangle,

                            borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
                        ),
                        child: Text(
                          isCopied?AppStrings.copied: AppStrings.copyCode,
                          style: TextStyle(
                              color: ColorManager.backGroundColor,
                              fontSize: FontSize.s10,
                              fontWeight: FontWeight.w500
                          ),
                        ),


                      ),
                    )),
              ],
            ),

          ),
          Container(height: AppSize.s50,),
          Container(
              alignment: AlignmentDirectional.center,
              child: Text(AppStrings.invite +widget.leagueDetailsModel.data!.league![0].title.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(

                  color: ColorManager.white,
                  fontWeight: FontWeight.w500,
                  fontSize: FontSize.s17,
                ),)),

          Container(height: AppSize.s50,),
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
              child: Text(AppStrings.back,
                style: TextStyle(
                  color: ColorManager.black,
                  fontSize: FontSize.s16,
                  fontWeight: FontWeight.w500,

                ),),
            ),
          ),
          Container(height: AppSize.s50,),
        ],
      ),

    );
  }
  int getRank(String pRank,String rank){
    int result =0;
    if(int.parse(pRank)>int.parse(rank)){
      result = -1;


    }else if(int.parse(pRank)<int.parse(rank)){
      result = 1;
    }else{
      result = 0;
    }
    return result;

  }
}
