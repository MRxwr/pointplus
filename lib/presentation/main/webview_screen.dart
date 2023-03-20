
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point/presentation/resources/color_manager.dart';
import 'package:provider/provider.dart';

import '../../providers/model_hud.dart';
import '../resources/assets_manager.dart';
import '../resources/font_manager.dart';
import '../resources/values_manager.dart';
class WebViewScreen extends StatefulWidget {
  String url;
  String title;
   WebViewScreen({Key? key,required this.url,required this.title}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  ScreenUtil screenUtil = ScreenUtil();
  bool isLoading=true;
  final _key = UniqueKey();
  late InAppWebViewController webView;
  @override
  Widget build(BuildContext context) {
    final modelHud = Provider.of<ModelHud>(context,listen: false);
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
          appBar:   AppBar(
            centerTitle: true,
            backgroundColor: ColorManager.navColor,
            title:Center(
              child: Image.asset(ImageAssets.titleBarImage,height: AppSize.s32, width: AppSize.s110,fit: BoxFit.fill,),
            ),

            leading:
            GestureDetector(
              onTap: (){
                Navigator.pop(context);

              },
              child: Icon(Icons.arrow_back_ios_outlined,color: Colors.white,size: AppSize.s20,),
            ),

            actions: [


              SizedBox(width: AppSize.s30,)



            ],

          ),
        body: Container(
          color: ColorManager.primary,
          child:    Stack(
            children: <Widget>[
              InAppWebView(

                initialUrlRequest:
                URLRequest(url: Uri.parse(widget.url)),


                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(


                    preferredContentMode: UserPreferredContentMode.MOBILE,

                  ),
                ),
                onWebViewCreated: (InAppWebViewController controller) {
                  webView = controller;
                },


                onLoadStart: (InAppWebViewController controller, Uri? url) async {
                  modelHud.changeIsLoading(true);
                },
                onLoadStop: (InAppWebViewController controller, Uri? url) async {
                  modelHud.changeIsLoading(false);
                  print(url);

                },
              ),

            ],
          ) ,
        ),


      ),
    );
  }
}
