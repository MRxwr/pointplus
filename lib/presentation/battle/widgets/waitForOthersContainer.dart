import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point/presentation/battle/widgets/rectangleUserProfileContainer.dart';
import 'package:point/presentation/resources/color_manager.dart';

import '../../../views/questionBackgroundCard.dart';
import '../../../views/ui_utils.dart';


class WaitForOthersContainer extends StatelessWidget {
  const WaitForOthersContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top +
            MediaQuery.of(context).size.height *
                RectangleUserProfileContainer.userDetailsHeightPercentage *
                2.75,
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          const QuestionBackgroundCard(
            heightPercentage: UiUtils.questionContainerHeightPercentage - 0.045,
            opacity: 0.7,
            topMarginPercentage: 0.05,
            widthPercentage: 0.65,
          ),
          const QuestionBackgroundCard(
            heightPercentage: UiUtils.questionContainerHeightPercentage - 0.045,
            opacity: 0.85,
            topMarginPercentage: 0.03,
            widthPercentage: 0.75,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            width: MediaQuery.of(context).size.width * (0.85),
            height: MediaQuery.of(context).size.height *
                UiUtils.questionContainerHeightPercentage,
            decoration: BoxDecoration(
              color: ColorManager.secondary,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(context.tr('waitOtherComplete')!,
              style: TextStyle(
                color: ColorManager.white,
                fontWeight: FontWeight.w500,
                fontSize: ScreenUtil().setSp(16)
              ),),
            ),
          ),
        ],
      ),
    );
  }
}
