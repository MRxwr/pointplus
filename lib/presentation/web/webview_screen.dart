
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point/presentation/resources/color_manager.dart';
import 'package:point/presentation/resources/font_manager.dart';
import 'package:provider/provider.dart';

import '../../providers/model_hud.dart';
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
        backgroundColor:ColorManager.white,
          appBar:   AppBar(
            elevation: AppSize.s0,
            backgroundColor: ColorManager.backGroundColor,
            centerTitle: true,
            title:Container(
              width: screenUtil.screenWidth,
              child: Center(
                child: Text(widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorManager.white,
                      fontWeight: FontWeight.w500,

                      fontSize: FontSize.s16
                  ),),
              ),
            ),

            leading:
            GestureDetector(
              onTap: (){
                Navigator.pop(context);

              },
              child: Icon(Icons.arrow_back_ios_outlined,color: ColorManager.white,size:AppSize.s20,),
            ),

            actions: [






            ],

          ),
        body: Container(
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


                onLoadStart: (InAppWebViewController controller, Uri? url) {
                  modelHud.changeIsLoading(true);
                },
                onLoadStop: (InAppWebViewController controller, Uri? url) async {
                  modelHud.changeIsLoading(false);
                  // print(url);

                },
              ),

            ],
          ) ,
        ),


      ),
    );
  }
}
