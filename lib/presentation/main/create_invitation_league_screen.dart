import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:point/domain/league_details_model.dart';
import 'package:point/presentation/main/league_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/point_services.dart';
import '../../providers/model_hud.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
class CreateInvitationLeagueScreen extends StatefulWidget {
  GlobalKey<NavigatorState> page;
   CreateInvitationLeagueScreen({Key? key, required this.page}) : super(key: key);

  @override
  State<CreateInvitationLeagueScreen> createState() => _CreateInvitationLeagueScreenState();
}

class _CreateInvitationLeagueScreenState extends State<CreateInvitationLeagueScreen> {
  final TextEditingController _codeController =  TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: Provider.of<ModelHud>(context).isLoading,
      child: Scaffold(
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
                child: Text(AppStrings.createInvitation,
                  style: TextStyle(
                    color: ColorManager.white,
                    fontWeight: FontWeight.w500,
                    fontSize: FontSize.s17,
                  ),)),
            Container(height: AppSize.s20,),
            Container(
              alignment: AlignmentDirectional.centerStart,
              margin: EdgeInsets.symmetric(horizontal: AppSize.s30),
              child: Text(AppStrings.leagueName,
                style: TextStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s10,
                    fontWeight: FontWeight.normal
                ),

              ),
            ),
            SizedBox(height: AppSize.s4,),
            Container(
              alignment: AlignmentDirectional.centerStart,
              margin: EdgeInsets.symmetric(horizontal: AppSize.s30),
              child: Text(AppStrings.maxChratcters,
                style: TextStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s10,
                    fontWeight: FontWeight.normal
                ),

              ),
            ),
            SizedBox(height: AppSize.s4,),
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
            Container(height: AppSize.s20,),
            Container(
              alignment: AlignmentDirectional.centerStart,
              margin: EdgeInsets.symmetric(horizontal: AppSize.s30),
              child: Text(AppStrings.notes,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s10,
                    fontWeight: FontWeight.normal
                ),

              ),
            ),
            Container(height: AppSize.s40,),
          GestureDetector(
            onTap: (){
              validate(context);
            },
              child: Container(height: AppSize.s70,
                alignment: AlignmentDirectional.center,
                margin: EdgeInsets.symmetric(horizontal: AppSize.s30),
                decoration: BoxDecoration(
                    color: ColorManager.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(AppSize.s35))
                ),
                child: Text(AppStrings.create,
                  style: TextStyle(
                    color: ColorManager.black,
                    fontSize: FontSize.s16,
                    fontWeight: FontWeight.w500,

                  ),),
              ),
            )
            , Container(height: AppSize.s10,),
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



      ),
    );
  }
  void validate(BuildContext context) async{
    String mName = _codeController.text;
    if(mName.trim().isNotEmpty & (mName.length<=30)){
      final modelHud = Provider.of<ModelHud>(context,listen: false);
      modelHud.changeIsLoading(true);
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String id = sharedPreferences.getString("id")??"";
      PointServices pointServices = PointServices();
      Map<String,dynamic> map = {};
      map['userId'] = id;
      map['title'] = mName;

      LeagueDetailsModel? leagueDetailsModel = await pointServices.addLeague(map);
      modelHud.changeIsLoading(false);
      bool?  isOk  = leagueDetailsModel!.ok;
      if(isOk!){
        widget.page.currentState!.push(MaterialPageRoute(builder: (context) =>  LeagueDetailsScreen(page: widget.page,leagueDetailsModel: leagueDetailsModel,)));


      }else{

        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: AppStrings.error,
                text:leagueDetailsModel.error,
                confirmButtonColor: ColorManager.primary,
                confirmButtonText: AppStrings.ok
            )
        );

      }
    }else{
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: AppStrings.error,
                text:AppStrings.leageNameError,
                confirmButtonColor: ColorManager.primary,
                confirmButtonText: AppStrings.ok
            )
        );
    }




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


  }
}
