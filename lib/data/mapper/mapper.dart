import 'package:point/app/extensions.dart';
import 'package:point/data/responses/responses.dart';
import 'package:point/domain/models/profile_data_model.dart';
import 'package:point/domain/models/sumbit_room_model.dart';

import '../../app/constant.dart';
import '../../domain/models/models.dart';


extension UsereMapper on UsersRoomResponse?{
  UserGameModel toDomain(){
    return UserGameModel(this?.id.orEmpty()??Constant.empty);

  }

}
extension RoomDataMapper on RoomDataResponse?{

  RoomDataModel toDomain(){
    List<UserGameModel> users = (this

        ?.users
        ?.map((bannerResponse) => bannerResponse.toDomain()) ??
        const Iterable.empty())
        .cast<UserGameModel>()
        .toList();
    return RoomDataModel(this?.id.orEmpty()??Constant.empty,this?.code.orEmpty()??Constant.empty,users,
        this?.type.orEmpty()??Constant.empty,this?.winner.orEmpty()??Constant.empty,
        this?.total.orEmpty()??Constant.empty,
      this?.status.orEmpty()??Constant.empty,
      this?.hidden.orEmpty()??Constant.empty,
    );

  }
}
extension RoomResultMapper on RoomResult?{
  RoomResultModel toDomain(){
    return RoomResultModel(this!.roomDataResponse.toDomain());

  }
}
extension RoomMapper on RoomResponse?{
  RoomModel toDomain(){
    return RoomModel(this!.roomResult.toDomain());

  }
}

extension CategryModelMapper on CategoryModelResponse?{
  CategoryDataModel toDomain(){
    return CategoryDataModel(this!.id.orEmpty()??Constant.empty,this!.arTitle.orEmpty()??Constant.empty,this!.enTitle.orEmpty()??Constant.empty);

  }
}
extension CategoryResultMapper on CategoryResult?{

  CategoryResultModel toDomain(){
    List<CategoryDataModel> categoriesList = (this

        ?.categories
        ?.map((bannerResponse) => bannerResponse.toDomain()) ??
        const Iterable.empty())
        .cast<CategoryDataModel>()
        .toList();
    return CategoryResultModel(categoriesList
    );

  }
}

extension CategoriesMapper on CategoryResponse?{
  CategoryResponseModel toDomain(){
    return CategoryResponseModel(this!.categoryResult.toDomain());

  }
}



extension QuestionModelMapper on QuestionModelResponse?{
  QuestionDataModel toDomain(){
    return QuestionDataModel(this!.id.orEmpty()??Constant.empty,this!.question.orEmpty()??Constant.empty,this!.answer1.orEmpty()??Constant.empty,
      this!.answer2.orEmpty()??Constant.empty,this!.answer3.orEmpty()??Constant.empty,this!.isCorrect1.orEmpty()??Constant.empty,
      this!.isCorrect2.orEmpty()??Constant.empty,this!.isCorrect3.orEmpty()??Constant.empty,this!.points.orEmpty()??Constant.empty,
        this!.image.orEmpty()??Constant.empty
    );

  }
}
extension QuestionResultMapper on QuestionResult?{

  QuestionResultModel toDomain(){
    List<QuestionDataModel> questions = (this

        ?.questions
        ?.map((bannerResponse) => bannerResponse.toDomain()) ??
        const Iterable.empty())
        .cast<QuestionDataModel>()
        .toList();
    return QuestionResultModel(questions
    );

  }
}

extension QuestionMapper on QuestionResponse?{
  QuestionResponseModel toDomain(){
    return QuestionResponseModel(this!.questionResult.toDomain());

  }
}
extension FavTeamResponseMapper on FavTeamResponse?{
  FavTeamModel toDomain(){
    return FavTeamModel(this?.id.orEmpty()??Constant.empty,

      this?.logo.orEmpty()??Constant.empty,

    );

  }

}
extension UserResponseMapper on UserResponse?{
  UserDataModel toDomain(){
    return UserDataModel(this?.id.orEmpty()??Constant.empty,
      this?.date.orEmpty()??Constant.empty,
      this?.username.orEmpty()??Constant.empty,
      this?.name.orEmpty()??Constant.empty,
      this?.mobile.orEmpty()??Constant.empty,
      this?.logo.orEmpty()??Constant.empty,
      this?.userId.orEmpty()??Constant.empty,
      this?.country.orEmpty()??Constant.empty,
      this?.team.orEmpty()??Constant.empty,
      this?.favTeamResponse.toDomain()
    );

  }

}
extension ProfileResultMapper on ProfileResult?{

  ProfileResultModel toDomain(){
    List<UserDataModel> users = (this

        ?.userResponseList
        ?.map((bannerResponse) => bannerResponse.toDomain()) ??
        const Iterable.empty())
        .cast<UserDataModel>()
        .toList();
    return ProfileResultModel(users
    );

  }
}


extension ProfileResponseMapper on ProfileResponse?{
  ProfileDataModel toDomain(){
    return ProfileDataModel(this!.profileResult.toDomain());

  }
}

extension SumbitRoomResponseMapper on SumbitRoomResponse?{
  SumbitRoomModel toDomain(){
    return SumbitRoomModel(this?.isOk.orBoolFalse()??Constant.falseBool,
      this?.error.orEmpty()??Constant.empty, this?.status.orEmpty()??Constant.empty
    );

  }

}