import 'package:point/data/network/request.dart';
import 'package:point/data/responses/responses.dart';

import '../network/app_api.dart';

abstract class RemoteDataSource {
  Future<RoomResponse> room(RoomRequest roomRequest);
  Future<CategoryResponse> categories();
  Future<QuestionResponse> Questions(QuestionRequest questionRequest);
  Future<ProfileResponse> profile(String userId);
  Future<SumbitRoomResponse> sumbitRoom(String roomId,String winner,String points);

}

class RemoteDataSourceImpl implements RemoteDataSource {
  final AppServiceClient _appServiceClient;

  RemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<RoomResponse> room(RoomRequest roomRequest) async{
    return await _appServiceClient.createRoom(roomRequest.create,
        roomRequest.join, roomRequest.userId,roomRequest.roomId,roomRequest.roomCode,roomRequest.exit);
  }

  @override
  Future<CategoryResponse> categories() async{
    // TODO: implement categories
    return await _appServiceClient.categories();
  }

  @override
  Future<QuestionResponse> Questions(QuestionRequest questionRequest) async{
   return await _appServiceClient.questions(questionRequest.userId, questionRequest.quizCategory, questionRequest.noOfQuestions);
  }

  @override
  Future<ProfileResponse> profile(String userId)async {
    return await _appServiceClient.profile(userId);

  }

  @override
  Future<SumbitRoomResponse> sumbitRoom(String roomId, String winner, String points) async{
    return await _appServiceClient.sumbitRoom(roomId,winner,points);
  }
}