


 import 'package:freezed_annotation/freezed_annotation.dart';

 part 'freezed_data_class.freezed.dart';
@freezed
class LoginObject with _$LoginObject{
 factory LoginObject(String userName,String password) = _LoginObject;

}
 @freezed
 class RoomRequestObject with _$RoomRequestObject{
  factory RoomRequestObject(String create, String join,String userId,String roomId,String roomCode,String exit) = _RoomRequestObject;

 }
 @freezed
 class ForgetPasswordObject with _$ForgetPasswordObject{
  factory ForgetPasswordObject(String email) = _ForgetPasswordObject;

 }
 @freezed
 class RegisterObject with _$RegisterObject{
  factory RegisterObject(String firstName, String lastName,String phone,String email,String password,String confirmPassword,String fireBaseToken,int countryCode) = _RegisterObject;

 }
 @freezed
 class ChangePasswordObject with _$ChangePasswordObject{
  factory ChangePasswordObject(String oldPassword, String newPassword,String confirmPassword) = _ChangePasswordObject;

 }
 @freezed
 class CountryObject with _$CountryObject{
  factory CountryObject(int id, String countryCode,String currencyCode,String countryEnTitle,String countryArTitle,int areaCode,String flag) = _CountryObject;

 }

 @freezed
 class SearchObject with _$SearchObject{
  factory SearchObject(int sportId, int genderId,int  governorateId,int  areaId) = _SearchObject;

 }
 @freezed
 class SearchObjectText with _$SearchObjectText{
  factory SearchObjectText(String sportName, String genderName,String  governorateName,String  areaName) = _SearchObjectText;

 }

 @freezed
 class AcademyObject with _$AcademyObject{
  factory AcademyObject(int  academyId, int sessionId,int count,int subscriptionId) = _AcademyObject;

 }
 @freezed
 class SubscriptionObject with _$SubscriptionObject{
  factory SubscriptionObject(int  userId, int Type) = _SubscriptionObject;

 }
 @freezed
 class CancelSubscriptionObject with _$CancelSubscriptionObject{
  factory CancelSubscriptionObject(int  userId, int orderId) = _CancelSubscriptionObject;

 }
 @freezed
 class ClothesObject with _$ClothesObject{
  factory ClothesObject(int count) = _ClothesObject;

 }
 @freezed
 class UserObject with _$UserObject{
  factory UserObject(String firstName,String lastName,String email,String phoneNumber,int gender) = _UserObject;

 }
 @freezed
 class ContactUsObject with _$ContactUsObject{
  factory ContactUsObject(String title,String email,String phoneNumber,String message) = _ContactUsObject;

 }

 @freezed
 class PayObject with _$PayObject{
  factory PayObject(int userId,int academyId,int subscriptionId,int sessionId,int subscriptionCount,int subscriptionPrice,double clothesPrice,int clothesCount,int paymentMethod,String voucher) = _PayObject;

 }
 @freezed
 class OrderObject with _$OrderObject{
  factory OrderObject(String invoiceId,String status,String url) = _OrderObject;

 }

 @freezed
 class OrderDetailsObject with _$OrderDetailsObject{
  factory OrderDetailsObject(String orderId) = _OrderDetailsObject;

 }
