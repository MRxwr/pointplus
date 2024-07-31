import 'package:dio/dio.dart';
import 'package:point/data/responses/responses.dart';
import 'package:retrofit/http.dart';

import '../../app/constant.dart';
part 'app_api.g.dart';

@RestApi(baseUrl: Constant.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;
  @MultiPart()
  @POST("?action=rooms")

  Future<RoomResponse> createRoom(

      @Part( name: "create") String create, @Part(name: "join") String join,@Part(name: "userId") String userId,
  @Part(name: "roomId") String roomId,@Part(name: "roomCode") String roomCode,@Part(name: "exit") String exit,
      );
  @GET("?action=quizCategories")

  Future<CategoryResponse> categories(


      );
  @GET("?action=quizQestions")

  Future<QuestionResponse> questions(
      @Query("userId") String userId,
      @Query("quizCategory") String quizCategory,
      @Query("noOfQuestions") String noOfQuestions


      );

  @MultiPart()
  @POST("?action=user&type=profile&update=0")

  Future<ProfileResponse> profile(
      @Part(name: "id") String userId,


      );
  @MultiPart()
  @POST("?action=submitRoom")

  Future<SumbitRoomResponse> sumbitRoom(
      @Part(name: "roomId") String roomId,
      @Part(name: "winner") String winner,
      @Part(name: "points") String points,
      );

}