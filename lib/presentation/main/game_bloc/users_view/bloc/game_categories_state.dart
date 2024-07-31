part of 'game_categories_bloc.dart';

sealed class GameCategoriesState extends Equatable {
  const GameCategoriesState();
}

final class GameCategoriesInitial extends GameCategoriesState {
  @override
  List<Object> get props => [];
}
class GameCategoriesStateLoading extends GameCategoriesState {
  const GameCategoriesStateLoading();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GameCategoriesStateFailure extends GameCategoriesState {
  final String message;

  const GameCategoriesStateFailure({required this.message});

  @override
  List<Object> get props => [message];
}
class GameCategoriesStateSuccess extends GameCategoriesState {
  final CategoryResponseModel categoryResponseModel;

  const GameCategoriesStateSuccess({required this.categoryResponseModel});

  @override
  List<Object> get props => [categoryResponseModel];
}
