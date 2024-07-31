import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point/app/constant.dart';
import 'package:share_plus/share_plus.dart';

import '../../../game_categories/game_categories_screen.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/values_manager.dart';
class ShareDialog extends StatelessWidget {
  String code;
  String userId;

    ShareDialog({super.key,required this.code,required this.userId,required
    });
  void show(BuildContext context,String code ,{Key? key}) {




    showDialog<void>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (_) => ShareDialog(key: key,code: code,userId: userId,),
    );}

  void hide(BuildContext context) {

    Navigator.of(context).pop();


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.w),
      alignment: AlignmentDirectional.center,
      child: Card(
        child: Container(


          width: AppSize.width,
          height: AppSize.s170,
          color: ColorManager.white,
          child: Container(

            child: Stack(
              children: [
                Positioned.directional(textDirection: Directionality.of(context), child:
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(AppSize.s4),
                    child: Icon(Icons.close,size: AppSize.s20,
                      color: ColorManager.primary,),
                  ),
                ),top: 0, start: 0,
                ),
                Positioned.directional(
                  textDirection: Directionality.of(context),
                  start: 0,
                  end: 0,
                  top: 0,
                  bottom: 0,

                  child: Column(
                    children: [

                      Expanded(flex:1,child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: AlignmentDirectional.center,
                            child: Text("code".tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorManager.rectangle,
                                  fontSize: FontSize.s15,
                                  fontWeight: FontWeight.w500
                              ),),
                          ),
                          Container(
                            alignment: AlignmentDirectional.center,
                            child: Text(code.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorManager.black,
                                  fontSize: FontSize.s15,
                                  fontWeight: FontWeight.w500
                              ),),
                          ),
                        ],
                      )),

                      Expanded(flex:1,child: Container(
                          margin: EdgeInsets.symmetric(vertical: AppSize.s5,horizontal: AppSize.s20),
                          alignment: AlignmentDirectional.center,
                          child: addressButton("share".tr(),context,1)
                      )),
                      Expanded(flex:1,child: Container(
                          margin: EdgeInsets.symmetric(vertical: AppSize.s5,horizontal: AppSize.s20),
                          alignment: AlignmentDirectional.center,
                          child: addressButton("start_game".tr(),context,2)
                      ))

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  TextButton addressButton(String text,BuildContext context,int type){
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
      onPressed: () async{
        if(type == 1){
          _onShare(context,code);


        }else if(type == 2){
      





        }






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

  void _onShare(BuildContext context,String code) async {
    // A builder is used to retrieve the context immediately
    // surrounding the ElevatedButton.
    //
    // The context's `findRenderObject` returns the first
    // RenderObject in its descendent tree when it's not
    // a RenderObjectWidget. The ElevatedButton's RenderObject
    // has its position and size after it's built.
    final box = context.findRenderObject() as RenderBox?;


      await Share.share(code,
          subject: "POINT+",
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);

  }

}
