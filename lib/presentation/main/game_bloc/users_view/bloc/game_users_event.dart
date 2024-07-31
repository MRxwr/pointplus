part of 'game_users_bloc.dart';

sealed class GameUsersEvent extends Equatable {
  const GameUsersEvent();
}
class FetchGameDetail extends GameUsersEvent {


  String roomId;





  FetchGameDetail({required this.roomId});

  @override
  List<Object> get props => [roomId];
}
class DeleteRoom extends GameUsersEvent {


  String roomId;





  DeleteRoom({required this.roomId});

  @override
  List<Object> get props => [roomId];
}
class InitializeGame extends GameUsersEvent {








  @override
  List<Object> get props => [];
}
class FetchGameUsers extends GameUsersEvent {


  String roomId;
  String createdBy;
  String currentCategoryId;
  bool readyToPlay;
  int totalQuestions;
  UserModel userModel;
  String currentUserId;
  String room;




   FetchGameUsers({required this.roomId,required this.createdBy,required this.currentCategoryId,
  required this.readyToPlay,required this.totalQuestions,required this.userModel,required this.currentUserId,required this.room});

  @override
  List<Object> get props => [roomId,createdBy,currentCategoryId,readyToPlay,totalQuestions,userModel,room,Random().nextDouble()];
}
class JoinGameUsers extends GameUsersEvent {


  String roomId;

  UserModel userModel;




  JoinGameUsers({required this.roomId,required this.userModel});

  @override
  List<Object> get props => [roomId,userModel];
}
class StartPlayEvent extends GameUsersEvent {


  String roomId;






  StartPlayEvent({required this.roomId});

  @override
  List<Object> get props => [roomId];
}
class InitializeQuestionsEvent extends GameUsersEvent {


  String roomId;String currentUserId;List<UserModel> users;






  InitializeQuestionsEvent({required this.roomId,required this.currentUserId,required this.users});

  @override
  List<Object> get props => [roomId,currentUserId,users];
}


class UpdateCategoryEvent extends GameUsersEvent {


  String roomId;String currentCategoryId;List<UserModel> users;






  UpdateCategoryEvent({required this.roomId,required this.currentCategoryId,required this.users});

  @override
  List<Object> get props => [roomId,currentCategoryId,users];
}
class UpdateQuestionsEvent extends GameUsersEvent {


  String roomId;List<UserModel> users;






  UpdateQuestionsEvent({required this.roomId,required this.users});

  @override
  List<Object> get props => [roomId,users];
}
class UpdateUsersEvent extends GameUsersEvent {


  String roomId;List<UserModel> users;






  UpdateUsersEvent({required this.roomId,required this.users});

  @override
  List<Object> get props => [roomId,users];
}
class InsertFireBaseAnswer extends GameUsersEvent {

  final List<UserModel> users;
  final String roomId;




  const InsertFireBaseAnswer({required this.users,required this.roomId});

  @override
  List<Object> get props => [users,roomId];
}