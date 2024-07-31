import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point/data/network/failure.dart';
import 'package:point/domain/models/models.dart';
import 'package:point/domain/usecases/categories_usecase.dart';

@immutable
abstract class QuizCategoryState {}

class QuizCategoryInitial extends QuizCategoryState {}

class QuizCategoryProgress extends QuizCategoryState {}

class QuizCategorySuccess extends QuizCategoryState {
  QuizCategorySuccess(this.categories);

  final CategoryResponseModel categories;
}
class QuizCategoryFailure extends QuizCategoryState {
  QuizCategoryFailure(this.failure);

  final Failure failure;
}

class QuizCategoryCubit extends Cubit<QuizCategoryState> {
  QuizCategoryCubit(this._categoriesUseCase) : super(QuizCategoryInitial());
  final CategoriesUseCase _categoriesUseCase;

  Future<void> getQuizCategoryWithUserId() async {
    emit(QuizCategoryProgress());
    (await _categoriesUseCase.execute(CategoriesCaseInput())).
    fold((failure)  {



      emit(QuizCategoryFailure(failure));


    }, (data)  {






      emit(QuizCategorySuccess(data));



      //right --> success
      // inputState.add(ContentState());

      //navigate to main Screen

    });

  }

  Future<void> getQuizCategory() async {
    emit(QuizCategoryProgress());
    (await _categoriesUseCase.execute(CategoriesCaseInput())).
    fold((failure)  {



      emit(QuizCategoryFailure(failure));


    }, (data)  {






      emit(QuizCategorySuccess(data));



      //right --> success
      // inputState.add(ContentState());

      //navigate to main Screen

    });
  }

  void updateState(QuizCategoryState updatedState) {
    emit(updatedState);
  }

  // void unlockPremiumCategory({required String id}) {
  //   if (state is QuizCategorySuccess) {
  //     final categories = (state as QuizCategorySuccess).categories;
  //
  //     final idx = categories.indexWhere((c) => c.id == id);
  //
  //     if (idx != -1) {
  //       emit(QuizCategoryProgress());
  //
  //       categories[idx] = categories[idx].copyWith(hasUnlocked: true);
  //
  //       emit(QuizCategorySuccess(categories));
  //     }
  //   }
  // }

  // bool isPremiumCategoryUnlocked(String categoryId) {
  //   if (state is QuizCategorySuccess) {
  //     final categories = (state as QuizCategorySuccess).categories;
  //
  //     final idx = categories.indexWhere((c) => c.id == categoryId);
  //
  //     if (idx != -1) {
  //       final cate = categories[idx];
  //       return !cate.isPremium || (cate.isPremium && cate.hasUnlocked);
  //     }
  //   }
  //   return false;
  // }

  CategoryResponseModel getCategories() {

      return (state as QuizCategorySuccess).categories;

  }
}
