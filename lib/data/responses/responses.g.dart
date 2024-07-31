// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse _$BaseResponseFromJson(Map<String, dynamic> json) => BaseResponse()
  ..isOk = json['ok'] as bool?
  ..error = json['error'] as String?
  ..status = json['status'] as String?;

Map<String, dynamic> _$BaseResponseToJson(BaseResponse instance) =>
    <String, dynamic>{
      'ok': instance.isOk,
      'error': instance.error,
      'status': instance.status,
    };

RoomResponse _$RoomResponseFromJson(Map<String, dynamic> json) => RoomResponse(
      json['data'] == null
          ? null
          : RoomResult.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..isOk = json['ok'] as bool?
      ..error = json['error'] as String?
      ..status = json['status'] as String?;

Map<String, dynamic> _$RoomResponseToJson(RoomResponse instance) =>
    <String, dynamic>{
      'ok': instance.isOk,
      'error': instance.error,
      'status': instance.status,
      'data': instance.roomResult,
    };

RoomResult _$RoomResultFromJson(Map<String, dynamic> json) => RoomResult(
      json['room'] == null
          ? null
          : RoomDataResponse.fromJson(json['room'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RoomResultToJson(RoomResult instance) =>
    <String, dynamic>{
      'room': instance.roomDataResponse,
    };

RoomDataResponse _$RoomDataResponseFromJson(Map<String, dynamic> json) =>
    RoomDataResponse(
      json['id'] as String?,
      json['code'] as String?,
      (json['listOfUsers'] as List<dynamic>?)
          ?.map((e) => UsersRoomResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['type'] as String?,
      json['winner'] as String?,
      json['total'] as String?,
      json['status'] as String?,
      json['hidden'] as String?,
    );

Map<String, dynamic> _$RoomDataResponseToJson(RoomDataResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'listOfUsers': instance.users,
      'type': instance.type,
      'winner': instance.winner,
      'total': instance.total,
      'status': instance.status,
      'hidden': instance.hidden,
    };

UsersRoomResponse _$UsersRoomResponseFromJson(Map<String, dynamic> json) =>
    UsersRoomResponse(
      json['id'] as String?,
    );

Map<String, dynamic> _$UsersRoomResponseToJson(UsersRoomResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

CategoryModelResponse _$CategoryModelResponseFromJson(
        Map<String, dynamic> json) =>
    CategoryModelResponse(
      json['id'] as String?,
      json['arTitle'] as String?,
      json['enTitle'] as String?,
    );

Map<String, dynamic> _$CategoryModelResponseToJson(
        CategoryModelResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'arTitle': instance.arTitle,
      'enTitle': instance.enTitle,
    };

CategoryResult _$CategoryResultFromJson(Map<String, dynamic> json) =>
    CategoryResult(
      (json['categories'] as List<dynamic>?)
          ?.map(
              (e) => CategoryModelResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryResultToJson(CategoryResult instance) =>
    <String, dynamic>{
      'categories': instance.categories,
    };

CategoryResponse _$CategoryResponseFromJson(Map<String, dynamic> json) =>
    CategoryResponse(
      json['data'] == null
          ? null
          : CategoryResult.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..isOk = json['ok'] as bool?
      ..error = json['error'] as String?
      ..status = json['status'] as String?;

Map<String, dynamic> _$CategoryResponseToJson(CategoryResponse instance) =>
    <String, dynamic>{
      'ok': instance.isOk,
      'error': instance.error,
      'status': instance.status,
      'data': instance.categoryResult,
    };

QuestionModelResponse _$QuestionModelResponseFromJson(
        Map<String, dynamic> json) =>
    QuestionModelResponse(
      json['id'] as String?,
      json['question'] as String?,
      json['answer1'] as String?,
      json['answer2'] as String?,
      json['answer3'] as String?,
      json['isCorrect1'] as String?,
      json['isCorrect2'] as String?,
      json['isCorrect3'] as String?,
      json['points'] as String?,
      json['image'] as String?,
    );

Map<String, dynamic> _$QuestionModelResponseToJson(
        QuestionModelResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answer1': instance.answer1,
      'answer2': instance.answer2,
      'answer3': instance.answer3,
      'isCorrect1': instance.isCorrect1,
      'isCorrect2': instance.isCorrect2,
      'isCorrect3': instance.isCorrect3,
      'points': instance.points,
      'image': instance.image,
    };

QuestionResult _$QuestionResultFromJson(Map<String, dynamic> json) =>
    QuestionResult(
      (json['questions'] as List<dynamic>?)
          ?.map(
              (e) => QuestionModelResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuestionResultToJson(QuestionResult instance) =>
    <String, dynamic>{
      'questions': instance.questions,
    };

QuestionResponse _$QuestionResponseFromJson(Map<String, dynamic> json) =>
    QuestionResponse(
      json['data'] == null
          ? null
          : QuestionResult.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..isOk = json['ok'] as bool?
      ..error = json['error'] as String?
      ..status = json['status'] as String?;

Map<String, dynamic> _$QuestionResponseToJson(QuestionResponse instance) =>
    <String, dynamic>{
      'ok': instance.isOk,
      'error': instance.error,
      'status': instance.status,
      'data': instance.questionResult,
    };

FavTeamResponse _$FavTeamResponseFromJson(Map<String, dynamic> json) =>
    FavTeamResponse(
      json['id'] as String?,
      json['logo'] as String?,
    );

Map<String, dynamic> _$FavTeamResponseToJson(FavTeamResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'logo': instance.logo,
    };

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
      json['id'] as String?,
      json['date'] as String?,
      json['username'] as String?,
      json['name'] as String?,
      json['mobile'] as String?,
      json['logo'] as String?,
      json['userId'] as String?,
      json['country'] as String?,
      json['team'] as String?,
      json['favoTeam'] == null
          ? null
          : FavTeamResponse.fromJson(json['favoTeam'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'username': instance.username,
      'name': instance.name,
      'mobile': instance.mobile,
      'logo': instance.logo,
      'userId': instance.userId,
      'country': instance.country,
      'team': instance.team,
      'favoTeam': instance.favTeamResponse,
    };

ProfileResult _$ProfileResultFromJson(Map<String, dynamic> json) =>
    ProfileResult(
      (json['user'] as List<dynamic>?)
          ?.map((e) => UserResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProfileResultToJson(ProfileResult instance) =>
    <String, dynamic>{
      'user': instance.userResponseList,
    };

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) =>
    ProfileResponse(
      json['data'] == null
          ? null
          : ProfileResult.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..isOk = json['ok'] as bool?
      ..error = json['error'] as String?
      ..status = json['status'] as String?;

Map<String, dynamic> _$ProfileResponseToJson(ProfileResponse instance) =>
    <String, dynamic>{
      'ok': instance.isOk,
      'error': instance.error,
      'status': instance.status,
      'data': instance.profileResult,
    };

SumbitRoomResponse _$SumbitRoomResponseFromJson(Map<String, dynamic> json) =>
    SumbitRoomResponse(
      json['ok'] as bool?,
      json['error'] as String?,
      json['status'] as String?,
    );

Map<String, dynamic> _$SumbitRoomResponseToJson(SumbitRoomResponse instance) =>
    <String, dynamic>{
      'ok': instance.isOk,
      'error': instance.error,
      'status': instance.status,
    };
