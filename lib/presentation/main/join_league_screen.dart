import 'package:flutter/material.dart';

import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
class JoinLeagueScreen extends StatefulWidget {
  GlobalKey<NavigatorState> page;
   JoinLeagueScreen({Key? key,required this.page}) : super(key: key);

  @override
  State<JoinLeagueScreen> createState() => _JoinLeagueScreenState();
}

class _JoinLeagueScreenState extends State<JoinLeagueScreen> {

  final TextEditingController _codeController =  TextEditingController();
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
          Container(height: AppSize.s20,),
          Container(
              alignment: AlignmentDirectional.center,
              child: Text(AppStrings.invitation,
                style: TextStyle(
                  color: ColorManager.white,
                  fontWeight: FontWeight.w500,
                  fontSize: FontSize.s17,
                ),)),
          Container(height: AppSize.s20,),
          Container(
            alignment: AlignmentDirectional.centerStart,
            margin: EdgeInsets.symmetric(horizontal: AppSize.s30),
            child: Text(AppStrings.leagueCode,
              style: TextStyle(
                color: ColorManager.white,
                fontSize: FontSize.s12,
                fontWeight: FontWeight.w500
              ),

            ),
          ),
          SizedBox(
            height: AppSize.s40,

            child: Container(
              margin: EdgeInsets.symmetric(horizontal:AppSize.s30),

              // decoration: BoxDecoration(
              //     color: ColorManager.white,
              //
              // ),

              child: TextField(


                textAlignVertical: TextAlignVertical.center,



                style: TextStyle(color:ColorManager.black,fontSize: FontSize.s12),
                textAlign: TextAlign.start,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.text ,


                textInputAction: TextInputAction.done,
                maxLines: 1,
                minLines: 1,
                controller: _codeController,
                decoration:  InputDecoration(


                  filled: true,

                  fillColor: ColorManager.white,
                  hintStyle: TextStyle(
                      color: ColorManager.black,
                      fontSize: FontSize.s12,
                      fontWeight: FontWeight.normal
                  ),


                  labelStyle:  TextStyle(color: ColorManager.black,
                      fontSize: FontSize.s12),

                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(height: AppSize.s40,),
          Container(height: AppSize.s70,
          alignment: AlignmentDirectional.center,
          margin: EdgeInsets.symmetric(horizontal: AppSize.s30),
          decoration: BoxDecoration(
            color: ColorManager.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s35))
          ),
            child: Text(AppStrings.joinLeagues,
            style: TextStyle(
              color: ColorManager.black,
              fontSize: FontSize.s16,
              fontWeight: FontWeight.w500,

            ),),
          ), Container(height: AppSize.s10,),
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
          )

        ],
      ),



    );
  }
}
