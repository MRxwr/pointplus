import 'package:flutter/material.dart';
import 'package:point/domain/leagues_model.dart';
import 'package:point/presentation/main/join_league_screen.dart';
import 'package:point/presentation/resources/font_manager.dart';
import 'package:point/presentation/resources/strings_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/point_services.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/values_manager.dart';
class StatsScreen extends StatefulWidget {
  GlobalKey<NavigatorState> page;
   StatsScreen({Key? key, required this.page}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  LeaguesModel? leaguesModel;
  int overAllPoints =0;
  int rank = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    leagues().then((value) {
      setState(() {
        leaguesModel = value;
      });

    });
  }
  Future<LeaguesModel?> leagues() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("id")??"";
    PointServices pointServices = PointServices();
    LeaguesModel? leaguesModel = await pointServices.leagues("0");
    int size =0;
    for(int i =0;i<leaguesModel!.data!.users!.length;i++){
      overAllPoints += int.parse(leaguesModel.data!.users![i].points!);
      size++;

    }
    double dRank =overAllPoints.toDouble()/size.toDouble();
    rank = dRank.toInt();
    return leaguesModel;
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: Container(
        child: leaguesModel == null?
        Container(
          child: const CircularProgressIndicator(


          ),
          alignment: AlignmentDirectional.center,
        ):
            ListView(
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
                Container(height: AppSize.s20,),
                Container(margin: EdgeInsets.symmetric(horizontal: AppSize.s45),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text( AppStrings.overAllPoints + overAllPoints.toString(),
                      style: TextStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s12,
                        fontWeight: FontWeight.w500,
                      ),),
                      Text( AppStrings.overAllRank + rank.toString(),
                        style: TextStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s12,
                          fontWeight: FontWeight.w500,
                        ),)
                    ],
                  ),


                ),
                Container(height: AppSize.s20,),

                Container(
                  alignment: AlignmentDirectional.center,
                    child: Text(AppStrings.leagues,
                    style: TextStyle(
                      color: ColorManager.white,
                      fontWeight: FontWeight.w500,
                      fontSize: FontSize.s12,
                    ),)),
                Container(height: AppSize.s10,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: AppSize.s45),
                  height: AppSize.s42,
                  child: Row(
                    children: [
                      Expanded(flex:1,
                          child: GestureDetector(
                            onTap: (){
                              widget.page.currentState!.push(MaterialPageRoute(builder: (context) => const JoinLeagueScreen()));
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => const JoinLeagueScreen()),
                              // );
                            },
                            child: Container(
                              alignment: AlignmentDirectional.center,
                              decoration: BoxDecoration(
                                  color: ColorManager.rectangle,

                                  borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
                              ),
                              child: Text(
                                AppStrings.joinLeagues,
                                style: TextStyle(
                                  color: ColorManager.black,
                                  fontSize: FontSize.s12,
                                  fontWeight: FontWeight.w500
                                ),
                              ),


                            ),
                          )),
                      SizedBox(width: AppSize.s10,),
                      Expanded(flex:1,
                          child: Container(
                            alignment: AlignmentDirectional.center,
                            decoration: BoxDecoration(
                                color: ColorManager.rectangle,

                                borderRadius: BorderRadius.all(Radius.circular(AppSize.s10))
                            ),
                            child: Text(
                              AppStrings.createLeagues,
                              style: TextStyle(
                                  color: ColorManager.black,
                                  fontSize: FontSize.s12,
                                  fontWeight: FontWeight.w500
                              ),
                            ),


                          )),
                    ],
                  ),

                ),
                Container(height: AppSize.s20,),
                Container(margin: EdgeInsets.symmetric(horizontal: AppSize.s45),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text( AppStrings.league,
                        style: TextStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s12,
                          fontWeight: FontWeight.w500,
                        ),),
                      Text( AppStrings.currentRank,
                        style: TextStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s12,
                          fontWeight: FontWeight.w500,
                        ),)
                    ],
                  ),


                ),
                Container(height: AppSize.s10,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: AppSize.s40),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context,index){
                    return Container(
                      height: AppSize.s33,
                      decoration: BoxDecoration(
                        color: ColorManager.white,
                        borderRadius: BorderRadius.all(Radius.circular(AppSize.s8)),
                        border: Border.all(color: ColorManager.rectangle,width: AppSize.s2)



                      ),
                      child: Container(
                        margin: EdgeInsets.all(AppSize.s4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex:1,
                              child: Container(
                                alignment: AlignmentDirectional.centerStart,
                                child: Container(
                                  alignment: AlignmentDirectional.center,
                                  height:AppSize.s24,
                                  width: AppSize.s24,

                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorManager.primary
                                  ),
                                  child: Text(
                                    '${leaguesModel!.data!.users![index].rank}',
                                    style: TextStyle(
                                      color: ColorManager.white,
                                      fontSize: FontSize.s11,
                                      fontWeight: FontWeight.w500

                                    ),
                                  ),

                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(leaguesModel!.data!.users![index].username.toString(),
                              style: TextStyle(
                                color: ColorManager.selectedRectangle,
                                fontSize: FontSize.s11
                              ),),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [

                                  Container(
                                    alignment: AlignmentDirectional.center,
                                    child: getRank(leaguesModel!.data!.users![index].pRank.toString(), leaguesModel!.data!.users![index].rank.toString()) == 0?
                                  Image.asset(ImageAssets.equalArrow,
                                  height: AppSize.s7,width: AppSize.s7,
                                  fit: BoxFit.fill,):getRank(leaguesModel!.data!.users![index].pRank.toString(), leaguesModel!.data!.users![index].rank.toString()) == 1?
                                    Image.asset(ImageAssets.upArrow,
                                      height: AppSize.s5,width: AppSize.s9,
                                      fit: BoxFit.fill,):Image.asset(ImageAssets.downArrow,
                                      height: AppSize.s5,width: AppSize.s9,
                                      fit: BoxFit.fill,),

                                  ),
                                  Text(leaguesModel!.data!.users![index].points.toString(),
                                    style: TextStyle(
                                        color: ColorManager.selectedRectangle,
                                        fontSize: FontSize.s11
                                    ),),
                                ],
                              ),
                            )

                          ],
                        ),
                      ),
                    );
                  }, separatorBuilder: (context,index){
                    return Container(height: AppSize.s20);
                  }, itemCount: leaguesModel!.data!.users!.length),
                ),
                SizedBox(height: AppSize.s100,)

              ],

            )


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
