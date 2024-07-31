class FavTeamModel{
  String id;
  String logo;
  FavTeamModel(this.id,this.logo);
}
class UserDataModel{

  String? id;

  String? date;

  String? username;

  String? name;

  String? mobile;

  String? logo;

  String? userId;

  String? country;

  String? team;
  FavTeamModel? favTeamModel;
  UserDataModel(this.id,this.date,this.username,this.name,this.mobile,this.logo,this.userId,this.country,this.team,this.favTeamModel);

}

class ProfileResultModel{
  List<UserDataModel>? userDataList;
  ProfileResultModel(this.userDataList);
}
class ProfileDataModel{
  ProfileResultModel? profileResultModel;
  ProfileDataModel(this.profileResultModel);
}