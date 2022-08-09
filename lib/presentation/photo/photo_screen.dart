import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:point/presentation/resources/color_manager.dart';
import 'package:point/presentation/resources/values_manager.dart';
class PhotoScreen extends StatefulWidget {

  PhotoScreen({Key? key,

    required this.imageProvider,

    this.minScale,
    this.maxScale,
  }) : super(key: key);

   ImageProvider imageProvider;

   dynamic minScale;
   dynamic maxScale;


  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  ScreenUtil screenUtil = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton:  FloatingActionButton(
        backgroundColor: ColorManager.primary,
        onPressed: () {
          print("true");
          Navigator.pop(context);
        },
        tooltip: 'Increment',
        child:Container(

            alignment: AlignmentDirectional.center,
            width:AppSize.s60, height: AppSize.s60, child: Center(child: Icon(Icons.close,color: ColorManager.white,))),
        elevation: 2.0,
      ),
      body:
      Container(
        color: ColorManager.white,
        child: Stack(
          fit: StackFit.expand,

          children: [
            Container(
              color: ColorManager.white,
              constraints: BoxConstraints.expand(
                height: MediaQuery.of(context).size.height,
              ),
              child: PhotoView(
                imageProvider: widget.imageProvider,

                minScale: widget.minScale,
                maxScale: widget.maxScale,
                heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
              ),
            ),

          ],
        ),
      ) ,
    );
  }
}
