part of 'game_categories_bloc.dart';

sealed class GameCategoriesEvent extends Equatable {
  const GameCategoriesEvent();
}
class FetchGameCategoriesEvent extends GameCategoriesEvent {






  const FetchGameCategoriesEvent();

  @override
  List<Object> get props => [];
}