import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:point/app/di.dart';
import 'package:point/presentation/main/game_bloc/users_view/bloc/game_categories_bloc.dart';
import 'package:point/presentation/resources/color_manager.dart';

import '../../../../domain/models/models.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/values_manager.dart';

class CategoriesWidget extends StatelessWidget {
  final GameCategoriesBloc _gameCategoriesBloc = instance<GameCategoriesBloc>();


  CategoriesWidget({super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),


      ),


      elevation: 16.w,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 10),
            ),
          ],
        ),
        height: 300.w,
        alignment: AlignmentDirectional.center,

        child: BlocBuilder<GameCategoriesBloc, GameCategoriesState>(
          bloc: _gameCategoriesBloc..add(const FetchGameCategoriesEvent()),
          builder: (context, state) {
            if(state is GameCategoriesStateFailure){
              return Container(
                alignment: AlignmentDirectional.center,
                child: Text(
                  state.message,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.w500
                  ),
                ),
              );
            }else if(state is GameCategoriesStateLoading){
              return Container(

                  alignment: AlignmentDirectional.center,
                  child: SizedBox(
                      height: AppSize.s100,
                      width: AppSize.s100,
                      child: Lottie.asset(JsonAssets.loading)

                  ));
            }else if(state is GameCategoriesStateSuccess){
              return ListView.separated(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        String id =state.categoryResponseModel.categoryResultModel.categoryList[index].id;


                        Navigator.of(context).pop(id);
                      },
                      child: Container(
                        height: 50.h,
                        width: ScreenUtil().screenWidth,
                        alignment: Alignment.center,

                        child: Text(state.categoryResponseModel.categoryResultModel.categoryList[index].enTitle,
                          style: TextStyle(
                              color: ColorManager.primary,
                              fontSize: ScreenUtil().setSp(18),
                              fontWeight: FontWeight.w500
                          ),),
                      ),
                    );
                  }, separatorBuilder: (context, index) {
                return Container(height: 1.h, width: ScreenUtil().screenWidth,
                  color: ColorManager.secondary,);
              }, itemCount: state.categoryResponseModel.categoryResultModel.categoryList.length);
            }else{
              return Container();
            }

          },
        ),
      ),
    );
  }
}
