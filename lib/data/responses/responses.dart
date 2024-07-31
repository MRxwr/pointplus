import 'package:json_annotation/json_annotation.dart';
part 'responses.g.dart';
@JsonSerializable()
class BaseResponse{

  @JsonKey(name:"ok" )
  bool? isOk;
  @JsonKey(name:"error" )
  String? error;
  @JsonKey(name:"status" )
  String? status;


}
@JsonSerializable()
class RoomResponse extends BaseResponse{
  @JsonKey(name:"data" )
  RoomResult? roomResult;
  RoomResponse(this.roomResult);
  factory RoomResponse.fromJson(Map<String,dynamic> json) =>_$RoomResponseFromJson(json);
// to json
  Map<String,dynamic> toJson() => _$RoomResponseToJson(this);
}

@JsonSerializable()
class RoomResult{
  @JsonKey(name:"room" )
  RoomDataResponse? roomDataResponse;
  RoomResult(this.roomDataResponse);
  factory RoomResult.fromJson(Map<String,dynamic> json) =>_$RoomResultFromJson(json);
// to json
  Map<String,dynamic> toJson() => _$RoomResultToJson(this);
}
@JsonSerializable()
class RoomDataResponse{
  @JsonKey(name:"id" )
  String? id;
  @JsonKey(name:"code" )
  String? code;
  @JsonKey(name:"listOfUsers" )
  List<UsersRoomResponse>? users;
  @JsonKey(name:"type" )
  String? type;
  @JsonKey(name:"winner" )
  String? winner;
  @JsonKey(name:"total" )
  String? total;
  @JsonKey(name:"status" )
  String? status;
  @JsonKey(name:"hidden" )
  String? hidden;
  RoomDataResponse(this.id,this.code,this.users,this.type,this.winner,this.total,this.status,this.hidden);
  factory RoomDataResponse.fromJson(Map<String,dynamic> json) =>_$RoomDataResponseFromJson(json);
// to json
  Map<String,dynamic> toJson() => _$RoomDataResponseToJson(this);

}
@JsonSerializable()
class UsersRoomResponse{
  @JsonKey(name:"id" )
  String? id;
  UsersRoomResponse(this.id);
  factory UsersRoomResponse.fromJson(Map<String,dynamic> json) =>_$UsersRoomResponseFromJson(json);
// to json
  Map<String,dynamic> toJson() => _$UsersRoomResponseToJson(this);
}
@JsonSerializable()
class CategoryModelResponse{
  @JsonKey(name:"id" )
  String? id;
  @JsonKey(name:"arTitle" )
  String? arTitle;
  @JsonKey(name:"enTitle" )
  String? enTitle;
  CategoryModelResponse(this.id,this.arTitle,this.enTitle);
  factory CategoryModelResponse.fromJson(Map<String,dynamic> json) =>_$CategoryModelResponseFromJson(json);
// to json
  Map<String,dynamic> toJson() => _$CategoryModelResponseToJson(this);

}
@JsonSerializable()
class CategoryResult{
  @JsonKey(name:"categories" )
  List<CategoryModelResponse>? categories;
  CategoryResult(this.categories);
  factory CategoryResult.fromJson(Map<String,dynamic> json) =>_$CategoryResultFromJson(json);
// to json
  Map<String,dynamic> toJson() => _$CategoryResultToJson(this);

}

@JsonSerializable()
class CategoryResponse extends BaseResponse{
  @JsonKey(name:"data" )
  CategoryResult? categoryResult;
  CategoryResponse(this.categoryResult);
  factory CategoryResponse.fromJson(Map<String,dynamic> json) =>_$CategoryResponseFromJson(json);
// to json
  Map<String,dynamic> toJson() => _$CategoryResponseToJson(this);
}
@JsonSerializable()
class QuestionModelResponse{
  @JsonKey(name:"id" )
  String? id;
  @JsonKey(name:"question" )
  String? question;
  @JsonKey(name:"answer1" )
  String? answer1;
  @JsonKey(name:"answer2" )
  String? answer2;
  @JsonKey(name:"answer3" )
  String? answer3;
  @JsonKey(name:"isCorrect1" )
  String? isCorrect1;
  @JsonKey(name:"isCorrect2" )
  String? isCorrect2;
  @JsonKey(name:"isCorrect3" )
  String? isCorrect3;
  @JsonKey(name:"points" )
  String? points;
  @JsonKey(name:"image" )
  String? image;

  QuestionModelResponse(this.id,this.question,this.answer1,this.answer2,this.answer3,this.isCorrect1,this.isCorrect2,
      this.isCorrect3,this.points,this.image);
  factory QuestionModelResponse.fromJson(Map<String,dynamic> json) =>_$QuestionModelResponseFromJson(json);
// to json
  Map<String,dynamic> toJson() => _$QuestionModelResponseToJson(this);

}

@JsonSerializable()
class QuestionResult{
  @JsonKey(name:"questions" )
  List<QuestionModelResponse>? questions;
  QuestionResult(this.questions);
  factory QuestionResult.fromJson(Map<String,dynamic> json) =>_$QuestionResultFromJson(json);
// to json
  Map<String,dynamic> toJson() => _$QuestionResultToJson(this);

}
@JsonSerializable()
class QuestionResponse extends BaseResponse{
  @JsonKey(name:"data" )
  QuestionResult? questionResult;
  QuestionResponse(this.questionResult);
  factory QuestionResponse.fromJson(Map<String,dynamic> json) =>_$QuestionResponseFromJson(json);
// to json
  Map<String,dynamic> toJson() => _$QuestionResponseToJson(this);
}
@JsonSerializable()
class FavTeamResponse {
  @JsonKey(name:"id" )
  String? id;
  @JsonKey(name:"logo" )
  String? logo;
  FavTeamResponse(this.id,this.logo);
  factory FavTeamResponse.fromJson(Map<String,dynamic> json) =>_$FavTeamResponseFromJson(json);
// to json
  Map<String,dynamic> toJson() => _$FavTeamResponseToJson(this);
}
@JsonSerializable()
class UserResponse {
  @JsonKey(name:"id" )
  String? id;
  @JsonKey(name:"date" )
  String? date;
  @JsonKey(name:"username" )
  String? username;
  @JsonKey(name:"name" )
  String? name;
  @JsonKey(name:"mobile" )
  String? mobile;
  @JsonKey(name:"logo" )
  String? logo;
  @JsonKey(name:"userId" )
  String? userId;
  @JsonKey(name:"country" )
  String? country;
  @JsonKey(name:"team" )
  String? team;
  @JsonKey(name:"favoTeam" )
  FavTeamResponse? favTeamResponse;
  UserResponse(this.id,this.date,this.username,this.name,this.mobile,this.logo,this.userId,this.country,this.team,this.favTeamResponse);
  factory UserResponse.fromJson(Map<String,dynamic> json) =>_$UserResponseFromJson(json);
// to json
  Map<String,dynamic> toJson() => _$UserResponseToJson(this);
}

@JsonSerializable()
class ProfileResult {
  @JsonKey(name:"user" )
  List<UserResponse>? userResponseList;
  ProfileResult(this.userResponseList);
  factory ProfileResult.fromJson(Map<String,dynamic> json) =>_$ProfileResultFromJson(json);
// to json
  Map<String,dynamic> toJson() => _$ProfileResultToJson(this);
}

@JsonSerializable()
class ProfileResponse extends BaseResponse{
  @JsonKey(name:"data" )
  ProfileResult? profileResult;
  ProfileResponse(this.profileResult);
  factory ProfileResponse.fromJson(Map<String,dynamic> json) =>_$ProfileResponseFromJson(json);
// to json
  Map<String,dynamic> toJson() => _$ProfileResponseToJson(this);
}

@JsonSerializable()
class SumbitRoomResponse{

  @JsonKey(name:"ok" )
  bool? isOk;
  @JsonKey(name:"error" )
  String? error;
  @JsonKey(name:"status" )
  String? status;
  SumbitRoomResponse(this.isOk,this.error,this.status);
  factory SumbitRoomResponse.fromJson(Map<String,dynamic> json) =>_$SumbitRoomResponseFromJson(json);
// to json
  Map<String,dynamic> toJson() => _$SumbitRoomResponseToJson(this);


}
