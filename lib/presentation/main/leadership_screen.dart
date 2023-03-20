import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:point/domain/view_league_model.dart';

import '../../api/point_services.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
class LeaderShipScreen extends StatefulWidget {
  GlobalKey<NavigatorState> page;
   LeaderShipScreen({Key? key, required this.page}) : super(key: key);

  @override
  State<LeaderShipScreen> createState() => _LeaderShipScreenState();
}

class _LeaderShipScreenState extends State<LeaderShipScreen> {
  ViewleagueModel? viewleagueModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLeagues().then((value){
      setState(() {
        viewleagueModel = value;
      });

    });
  }

  Future<ViewleagueModel?> getLeagues() async{
    PointServices pointServices = PointServices();
    ViewleagueModel? viewleagueModel = await pointServices.viewLeagues();
    return viewleagueModel;


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
      child: Scaffold(
        backgroundColor: ColorManager.primary,
        body: Container(
          child: viewleagueModel == null?
          Container(
            child: const CircularProgressIndicator(


            ),
            alignment: AlignmentDirectional.center,
          ):
          ListView(
            padding: EdgeInsets.zero,
            physics: AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(margin: EdgeInsets.symmetric(horizontal: AppSize.s45),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text( "league".tr(),
                          style: TextStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s12,
                            fontWeight: FontWeight.w500,
                          ),),
                        Text( "currentRank".tr(),
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
                          return GestureDetector(
                            onTap: (){

                            },
                            child: Container(
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
                                            '${viewleagueModel!.data!.users![index].rank}',
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
                                      child: Text(viewleagueModel!.data!.users![index].username.toString(),
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
                                            child: getRank(viewleagueModel!.data!.users![index].pRank.toString(), viewleagueModel!.data!.users![index].rank.toString()) == 0?
                                            Image.asset(ImageAssets.equalArrow,
                                              height: AppSize.s7,width: AppSize.s7,
                                              fit: BoxFit.fill,):getRank(viewleagueModel!.data!.users![index].pRank.toString(), viewleagueModel!.data!.users![index].rank.toString()) == 1?
                                            Image.asset(ImageAssets.upArrow,
                                              height: AppSize.s5,width: AppSize.s9,
                                              fit: BoxFit.fill,):Image.asset(ImageAssets.downArrow,
                                              height: AppSize.s5,width: AppSize.s9,
                                              fit: BoxFit.fill,),

                                          ),
                                          Text(viewleagueModel!.data!.users![index].points.toString(),
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
                            ),
                          );
                        }, separatorBuilder: (context,index){
                      return Container(height: AppSize.s20);
                    }, itemCount: viewleagueModel!.data!.users!.length),
                  ),
                  SizedBox(height: AppSize.s50,),
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
                      child: Text("back".tr(),
                        style: TextStyle(
                          color: ColorManager.black,
                          fontSize: FontSize.s16,
                          fontWeight: FontWeight.w500,

                        ),),
                    ),
                  ),
                  SizedBox(height: AppSize.s50,),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  int getRank(String pRank,String rank){
    int result =0;
    if(int.parse(pRank)<int.parse(rank)){
      result = -1;


    }else if(int.parse(pRank)>int.parse(rank)){
      result = 1;
    }else{
      result = 0;
    }
    return result;

  }
}
