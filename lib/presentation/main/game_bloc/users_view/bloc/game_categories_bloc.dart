import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:point/domain/usecases/categories_usecase.dart';

import '../../../../../domain/models/models.dart';

part 'game_categories_event.dart';
part 'game_categories_state.dart';

class GameCategoriesBloc extends Bloc<GameCategoriesEvent, GameCategoriesState> {
  final CategoriesUseCase categoriesUseCase;

  GameCategoriesBloc(this.categoriesUseCase) : super(GameCategoriesInitial()) {
    on<FetchGameCategoriesEvent>((event, emit) async {
      emit( const GameCategoriesStateLoading());
      (await categoriesUseCase.execute(CategoriesCaseInput())).fold(
            (failure) {

          print("failture ---> $failure");
          emit(GameCategoriesStateFailure(message: failure.message)) ;
        },
            (response) async {


          emit(GameCategoriesStateSuccess(categoryResponseModel: response));



        },
      );

    });
  }
}

