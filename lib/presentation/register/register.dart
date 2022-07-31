import 'package:flutter/material.dart';
import 'package:point/presentation/resources/font_manager.dart';
import 'package:point/presentation/resources/strings_manager.dart';

import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:  const BoxDecoration(
            image:  DecorationImage(
              image: AssetImage(ImageAssets.background),
              fit: BoxFit.cover,
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: AlignmentDirectional.bottomCenter,
                child: Text(AppStrings.completeProfile,
                style: TextStyle(
                  color: ColorManager.secondary,
                  fontSize:FontSize.s20,
                  fontWeight: FontWeight.bold,

                ),),
              ),
            ),
            Expanded(flex:9,child: Container(
              child: ListView(
                children: [

                ],
              ),
            ))
            

            
          ],
        )
      ),
    );
  }
}
