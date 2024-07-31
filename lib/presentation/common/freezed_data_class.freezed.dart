// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'freezed_data_class.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LoginObject {
  String get userName => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LoginObjectCopyWith<LoginObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginObjectCopyWith<$Res> {
  factory $LoginObjectCopyWith(
          LoginObject value, $Res Function(LoginObject) then) =
      _$LoginObjectCopyWithImpl<$Res, LoginObject>;
  @useResult
  $Res call({String userName, String password});
}

/// @nodoc
class _$LoginObjectCopyWithImpl<$Res, $Val extends LoginObject>
    implements $LoginObjectCopyWith<$Res> {
  _$LoginObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userName = null,
    Object? password = null,
  }) {
    return _then(_value.copyWith(
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoginObjectImplCopyWith<$Res>
    implements $LoginObjectCopyWith<$Res> {
  factory _$$LoginObjectImplCopyWith(
          _$LoginObjectImpl value, $Res Function(_$LoginObjectImpl) then) =
      __$$LoginObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userName, String password});
}

/// @nodoc
class __$$LoginObjectImplCopyWithImpl<$Res>
    extends _$LoginObjectCopyWithImpl<$Res, _$LoginObjectImpl>
    implements _$$LoginObjectImplCopyWith<$Res> {
  __$$LoginObjectImplCopyWithImpl(
      _$LoginObjectImpl _value, $Res Function(_$LoginObjectImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userName = null,
    Object? password = null,
  }) {
    return _then(_$LoginObjectImpl(
      null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LoginObjectImpl implements _LoginObject {
  _$LoginObjectImpl(this.userName, this.password);

  @override
  final String userName;
  @override
  final String password;

  @override
  String toString() {
    return 'LoginObject(userName: $userName, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginObjectImpl &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userName, password);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginObjectImplCopyWith<_$LoginObjectImpl> get copyWith =>
      __$$LoginObjectImplCopyWithImpl<_$LoginObjectImpl>(this, _$identity);
}

abstract class _LoginObject implements LoginObject {
  factory _LoginObject(final String userName, final String password) =
      _$LoginObjectImpl;

  @override
  String get userName;
  @override
  String get password;
  @override
  @JsonKey(ignore: true)
  _$$LoginObjectImplCopyWith<_$LoginObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RoomRequestObject {
  String get create => throw _privateConstructorUsedError;
  String get join => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get roomId => throw _privateConstructorUsedError;
  String get roomCode => throw _privateConstructorUsedError;
  String get exit => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RoomRequestObjectCopyWith<RoomRequestObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomRequestObjectCopyWith<$Res> {
  factory $RoomRequestObjectCopyWith(
          RoomRequestObject value, $Res Function(RoomRequestObject) then) =
      _$RoomRequestObjectCopyWithImpl<$Res, RoomRequestObject>;
  @useResult
  $Res call(
      {String create,
      String join,
      String userId,
      String roomId,
      String roomCode,
      String exit});
}

/// @nodoc
class _$RoomRequestObjectCopyWithImpl<$Res, $Val extends RoomRequestObject>
    implements $RoomRequestObjectCopyWith<$Res> {
  _$RoomRequestObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? create = null,
    Object? join = null,
    Object? userId = null,
    Object? roomId = null,
    Object? roomCode = null,
    Object? exit = null,
  }) {
    return _then(_value.copyWith(
      create: null == create
          ? _value.create
          : create // ignore: cast_nullable_to_non_nullable
              as String,
      join: null == join
          ? _value.join
          : join // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      roomId: null == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      roomCode: null == roomCode
          ? _value.roomCode
          : roomCode // ignore: cast_nullable_to_non_nullable
              as String,
      exit: null == exit
          ? _value.exit
          : exit // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoomRequestObjectImplCopyWith<$Res>
    implements $RoomRequestObjectCopyWith<$Res> {
  factory _$$RoomRequestObjectImplCopyWith(_$RoomRequestObjectImpl value,
          $Res Function(_$RoomRequestObjectImpl) then) =
      __$$RoomRequestObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String create,
      String join,
      String userId,
      String roomId,
      String roomCode,
      String exit});
}

/// @nodoc
class __$$RoomRequestObjectImplCopyWithImpl<$Res>
    extends _$RoomRequestObjectCopyWithImpl<$Res, _$RoomRequestObjectImpl>
    implements _$$RoomRequestObjectImplCopyWith<$Res> {
  __$$RoomRequestObjectImplCopyWithImpl(_$RoomRequestObjectImpl _value,
      $Res Function(_$RoomRequestObjectImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? create = null,
    Object? join = null,
    Object? userId = null,
    Object? roomId = null,
    Object? roomCode = null,
    Object? exit = null,
  }) {
    return _then(_$RoomRequestObjectImpl(
      null == create
          ? _value.create
          : create // ignore: cast_nullable_to_non_nullable
              as String,
      null == join
          ? _value.join
          : join // ignore: cast_nullable_to_non_nullable
              as String,
      null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      null == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      null == roomCode
          ? _value.roomCode
          : roomCode // ignore: cast_nullable_to_non_nullable
              as String,
      null == exit
          ? _value.exit
          : exit // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$RoomRequestObjectImpl implements _RoomRequestObject {
  _$RoomRequestObjectImpl(this.create, this.join, this.userId, this.roomId,
      this.roomCode, this.exit);

  @override
  final String create;
  @override
  final String join;
  @override
  final String userId;
  @override
  final String roomId;
  @override
  final String roomCode;
  @override
  final String exit;

  @override
  String toString() {
    return 'RoomRequestObject(create: $create, join: $join, userId: $userId, roomId: $roomId, roomCode: $roomCode, exit: $exit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoomRequestObjectImpl &&
            (identical(other.create, create) || other.create == create) &&
            (identical(other.join, join) || other.join == join) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.roomCode, roomCode) ||
                other.roomCode == roomCode) &&
            (identical(other.exit, exit) || other.exit == exit));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, create, join, userId, roomId, roomCode, exit);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoomRequestObjectImplCopyWith<_$RoomRequestObjectImpl> get copyWith =>
      __$$RoomRequestObjectImplCopyWithImpl<_$RoomRequestObjectImpl>(
          this, _$identity);
}

abstract class _RoomRequestObject implements RoomRequestObject {
  factory _RoomRequestObject(
      final String create,
      final String join,
      final String userId,
      final String roomId,
      final String roomCode,
      final String exit) = _$RoomRequestObjectImpl;

  @override
  String get create;
  @override
  String get join;
  @override
  String get userId;
  @override
  String get roomId;
  @override
  String get roomCode;
  @override
  String get exit;
  @override
  @JsonKey(ignore: true)
  _$$RoomRequestObjectImplCopyWith<_$RoomRequestObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ForgetPasswordObject {
  String get email => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ForgetPasswordObjectCopyWith<ForgetPasswordObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgetPasswordObjectCopyWith<$Res> {
  factory $ForgetPasswordObjectCopyWith(ForgetPasswordObject value,
          $Res Function(ForgetPasswordObject) then) =
      _$ForgetPasswordObjectCopyWithImpl<$Res, ForgetPasswordObject>;
  @useResult
  $Res call({String email});
}

/// @nodoc
class _$ForgetPasswordObjectCopyWithImpl<$Res,
        $Val extends ForgetPasswordObject>
    implements $ForgetPasswordObjectCopyWith<$Res> {
  _$ForgetPasswordObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ForgetPasswordObjectImplCopyWith<$Res>
    implements $ForgetPasswordObjectCopyWith<$Res> {
  factory _$$ForgetPasswordObjectImplCopyWith(_$ForgetPasswordObjectImpl value,
          $Res Function(_$ForgetPasswordObjectImpl) then) =
      __$$ForgetPasswordObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email});
}

/// @nodoc
class __$$ForgetPasswordObjectImplCopyWithImpl<$Res>
    extends _$ForgetPasswordObjectCopyWithImpl<$Res, _$ForgetPasswordObjectImpl>
    implements _$$ForgetPasswordObjectImplCopyWith<$Res> {
  __$$ForgetPasswordObjectImplCopyWithImpl(_$ForgetPasswordObjectImpl _value,
      $Res Function(_$ForgetPasswordObjectImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_$ForgetPasswordObjectImpl(
      null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ForgetPasswordObjectImpl implements _ForgetPasswordObject {
  _$ForgetPasswordObjectImpl(this.email);

  @override
  final String email;

  @override
  String toString() {
    return 'ForgetPasswordObject(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgetPasswordObjectImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ForgetPasswordObjectImplCopyWith<_$ForgetPasswordObjectImpl>
      get copyWith =>
          __$$ForgetPasswordObjectImplCopyWithImpl<_$ForgetPasswordObjectImpl>(
              this, _$identity);
}

abstract class _ForgetPasswordObject implements ForgetPasswordObject {
  factory _ForgetPasswordObject(final String email) =
      _$ForgetPasswordObjectImpl;

  @override
  String get email;
  @override
  @JsonKey(ignore: true)
  _$$ForgetPasswordObjectImplCopyWith<_$ForgetPasswordObjectImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RegisterObject {
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get confirmPassword => throw _privateConstructorUsedError;
  String get fireBaseToken => throw _privateConstructorUsedError;
  int get countryCode => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RegisterObjectCopyWith<RegisterObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterObjectCopyWith<$Res> {
  factory $RegisterObjectCopyWith(
          RegisterObject value, $Res Function(RegisterObject) then) =
      _$RegisterObjectCopyWithImpl<$Res, RegisterObject>;
  @useResult
  $Res call(
      {String firstName,
      String lastName,
      String phone,
      String email,
      String password,
      String confirmPassword,
      String fireBaseToken,
      int countryCode});
}

/// @nodoc
class _$RegisterObjectCopyWithImpl<$Res, $Val extends RegisterObject>
    implements $RegisterObjectCopyWith<$Res> {
  _$RegisterObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? phone = null,
    Object? email = null,
    Object? password = null,
    Object? confirmPassword = null,
    Object? fireBaseToken = null,
    Object? countryCode = null,
  }) {
    return _then(_value.copyWith(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      confirmPassword: null == confirmPassword
          ? _value.confirmPassword
          : confirmPassword // ignore: cast_nullable_to_non_nullable
              as String,
      fireBaseToken: null == fireBaseToken
          ? _value.fireBaseToken
          : fireBaseToken // ignore: cast_nullable_to_non_nullable
              as String,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegisterObjectImplCopyWith<$Res>
    implements $RegisterObjectCopyWith<$Res> {
  factory _$$RegisterObjectImplCopyWith(_$RegisterObjectImpl value,
          $Res Function(_$RegisterObjectImpl) then) =
      __$$RegisterObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String firstName,
      String lastName,
      String phone,
      String email,
      String password,
      String confirmPassword,
      String fireBaseToken,
      int countryCode});
}

/// @nodoc
class __$$RegisterObjectImplCopyWithImpl<$Res>
    extends _$RegisterObjectCopyWithImpl<$Res, _$RegisterObjectImpl>
    implements _$$RegisterObjectImplCopyWith<$Res> {
  __$$RegisterObjectImplCopyWithImpl(
      _$RegisterObjectImpl _value, $Res Function(_$RegisterObjectImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? phone = null,
    Object? email = null,
    Object? password = null,
    Object? confirmPassword = null,
    Object? fireBaseToken = null,
    Object? countryCode = null,
  }) {
    return _then(_$RegisterObjectImpl(
      null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      null == confirmPassword
          ? _value.confirmPassword
          : confirmPassword // ignore: cast_nullable_to_non_nullable
              as String,
      null == fireBaseToken
          ? _value.fireBaseToken
          : fireBaseToken // ignore: cast_nullable_to_non_nullable
              as String,
      null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$RegisterObjectImpl implements _RegisterObject {
  _$RegisterObjectImpl(
      this.firstName,
      this.lastName,
      this.phone,
      this.email,
      this.password,
      this.confirmPassword,
      this.fireBaseToken,
      this.countryCode);

  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String phone;
  @override
  final String email;
  @override
  final String password;
  @override
  final String confirmPassword;
  @override
  final String fireBaseToken;
  @override
  final int countryCode;

  @override
  String toString() {
    return 'RegisterObject(firstName: $firstName, lastName: $lastName, phone: $phone, email: $email, password: $password, confirmPassword: $confirmPassword, fireBaseToken: $fireBaseToken, countryCode: $countryCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterObjectImpl &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.confirmPassword, confirmPassword) ||
                other.confirmPassword == confirmPassword) &&
            (identical(other.fireBaseToken, fireBaseToken) ||
                other.fireBaseToken == fireBaseToken) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, firstName, lastName, phone,
      email, password, confirmPassword, fireBaseToken, countryCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterObjectImplCopyWith<_$RegisterObjectImpl> get copyWith =>
      __$$RegisterObjectImplCopyWithImpl<_$RegisterObjectImpl>(
          this, _$identity);
}

abstract class _RegisterObject implements RegisterObject {
  factory _RegisterObject(
      final String firstName,
      final String lastName,
      final String phone,
      final String email,
      final String password,
      final String confirmPassword,
      final String fireBaseToken,
      final int countryCode) = _$RegisterObjectImpl;

  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get phone;
  @override
  String get email;
  @override
  String get password;
  @override
  String get confirmPassword;
  @override
  String get fireBaseToken;
  @override
  int get countryCode;
  @override
  @JsonKey(ignore: true)
  _$$RegisterObjectImplCopyWith<_$RegisterObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ChangePasswordObject {
  String get oldPassword => throw _privateConstructorUsedError;
  String get newPassword => throw _privateConstructorUsedError;
  String get confirmPassword => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChangePasswordObjectCopyWith<ChangePasswordObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangePasswordObjectCopyWith<$Res> {
  factory $ChangePasswordObjectCopyWith(ChangePasswordObject value,
          $Res Function(ChangePasswordObject) then) =
      _$ChangePasswordObjectCopyWithImpl<$Res, ChangePasswordObject>;
  @useResult
  $Res call({String oldPassword, String newPassword, String confirmPassword});
}

/// @nodoc
class _$ChangePasswordObjectCopyWithImpl<$Res,
        $Val extends ChangePasswordObject>
    implements $ChangePasswordObjectCopyWith<$Res> {
  _$ChangePasswordObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oldPassword = null,
    Object? newPassword = null,
    Object? confirmPassword = null,
  }) {
    return _then(_value.copyWith(
      oldPassword: null == oldPassword
          ? _value.oldPassword
          : oldPassword // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
      confirmPassword: null == confirmPassword
          ? _value.confirmPassword
          : confirmPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChangePasswordObjectImplCopyWith<$Res>
    implements $ChangePasswordObjectCopyWith<$Res> {
  factory _$$ChangePasswordObjectImplCopyWith(_$ChangePasswordObjectImpl value,
          $Res Function(_$ChangePasswordObjectImpl) then) =
      __$$ChangePasswordObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String oldPassword, String newPassword, String confirmPassword});
}

/// @nodoc
class __$$ChangePasswordObjectImplCopyWithImpl<$Res>
    extends _$ChangePasswordObjectCopyWithImpl<$Res, _$ChangePasswordObjectImpl>
    implements _$$ChangePasswordObjectImplCopyWith<$Res> {
  __$$ChangePasswordObjectImplCopyWithImpl(_$ChangePasswordObjectImpl _value,
      $Res Function(_$ChangePasswordObjectImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oldPassword = null,
    Object? newPassword = null,
    Object? confirmPassword = null,
  }) {
    return _then(_$ChangePasswordObjectImpl(
      null == oldPassword
          ? _value.oldPassword
          : oldPassword // ignore: cast_nullable_to_non_nullable
              as String,
      null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
      null == confirmPassword
          ? _value.confirmPassword
          : confirmPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ChangePasswordObjectImpl implements _ChangePasswordObject {
  _$ChangePasswordObjectImpl(
      this.oldPassword, this.newPassword, this.confirmPassword);

  @override
  final String oldPassword;
  @override
  final String newPassword;
  @override
  final String confirmPassword;

  @override
  String toString() {
    return 'ChangePasswordObject(oldPassword: $oldPassword, newPassword: $newPassword, confirmPassword: $confirmPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangePasswordObjectImpl &&
            (identical(other.oldPassword, oldPassword) ||
                other.oldPassword == oldPassword) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword) &&
            (identical(other.confirmPassword, confirmPassword) ||
                other.confirmPassword == confirmPassword));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, oldPassword, newPassword, confirmPassword);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangePasswordObjectImplCopyWith<_$ChangePasswordObjectImpl>
      get copyWith =>
          __$$ChangePasswordObjectImplCopyWithImpl<_$ChangePasswordObjectImpl>(
              this, _$identity);
}

abstract class _ChangePasswordObject implements ChangePasswordObject {
  factory _ChangePasswordObject(
      final String oldPassword,
      final String newPassword,
      final String confirmPassword) = _$ChangePasswordObjectImpl;

  @override
  String get oldPassword;
  @override
  String get newPassword;
  @override
  String get confirmPassword;
  @override
  @JsonKey(ignore: true)
  _$$ChangePasswordObjectImplCopyWith<_$ChangePasswordObjectImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CountryObject {
  int get id => throw _privateConstructorUsedError;
  String get countryCode => throw _privateConstructorUsedError;
  String get currencyCode => throw _privateConstructorUsedError;
  String get countryEnTitle => throw _privateConstructorUsedError;
  String get countryArTitle => throw _privateConstructorUsedError;
  int get areaCode => throw _privateConstructorUsedError;
  String get flag => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CountryObjectCopyWith<CountryObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CountryObjectCopyWith<$Res> {
  factory $CountryObjectCopyWith(
          CountryObject value, $Res Function(CountryObject) then) =
      _$CountryObjectCopyWithImpl<$Res, CountryObject>;
  @useResult
  $Res call(
      {int id,
      String countryCode,
      String currencyCode,
      String countryEnTitle,
      String countryArTitle,
      int areaCode,
      String flag});
}

/// @nodoc
class _$CountryObjectCopyWithImpl<$Res, $Val extends CountryObject>
    implements $CountryObjectCopyWith<$Res> {
  _$CountryObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? countryCode = null,
    Object? currencyCode = null,
    Object? countryEnTitle = null,
    Object? countryArTitle = null,
    Object? areaCode = null,
    Object? flag = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      countryEnTitle: null == countryEnTitle
          ? _value.countryEnTitle
          : countryEnTitle // ignore: cast_nullable_to_non_nullable
              as String,
      countryArTitle: null == countryArTitle
          ? _value.countryArTitle
          : countryArTitle // ignore: cast_nullable_to_non_nullable
              as String,
      areaCode: null == areaCode
          ? _value.areaCode
          : areaCode // ignore: cast_nullable_to_non_nullable
              as int,
      flag: null == flag
          ? _value.flag
          : flag // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CountryObjectImplCopyWith<$Res>
    implements $CountryObjectCopyWith<$Res> {
  factory _$$CountryObjectImplCopyWith(
          _$CountryObjectImpl value, $Res Function(_$CountryObjectImpl) then) =
      __$$CountryObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String countryCode,
      String currencyCode,
      String countryEnTitle,
      String countryArTitle,
      int areaCode,
      String flag});
}

/// @nodoc
class __$$CountryObjectImplCopyWithImpl<$Res>
    extends _$CountryObjectCopyWithImpl<$Res, _$CountryObjectImpl>
    implements _$$CountryObjectImplCopyWith<$Res> {
  __$$CountryObjectImplCopyWithImpl(
      _$CountryObjectImpl _value, $Res Function(_$CountryObjectImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? countryCode = null,
    Object? currencyCode = null,
    Object? countryEnTitle = null,
    Object? countryArTitle = null,
    Object? areaCode = null,
    Object? flag = null,
  }) {
    return _then(_$CountryObjectImpl(
      null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
      null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      null == countryEnTitle
          ? _value.countryEnTitle
          : countryEnTitle // ignore: cast_nullable_to_non_nullable
              as String,
      null == countryArTitle
          ? _value.countryArTitle
          : countryArTitle // ignore: cast_nullable_to_non_nullable
              as String,
      null == areaCode
          ? _value.areaCode
          : areaCode // ignore: cast_nullable_to_non_nullable
              as int,
      null == flag
          ? _value.flag
          : flag // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CountryObjectImpl implements _CountryObject {
  _$CountryObjectImpl(this.id, this.countryCode, this.currencyCode,
      this.countryEnTitle, this.countryArTitle, this.areaCode, this.flag);

  @override
  final int id;
  @override
  final String countryCode;
  @override
  final String currencyCode;
  @override
  final String countryEnTitle;
  @override
  final String countryArTitle;
  @override
  final int areaCode;
  @override
  final String flag;

  @override
  String toString() {
    return 'CountryObject(id: $id, countryCode: $countryCode, currencyCode: $currencyCode, countryEnTitle: $countryEnTitle, countryArTitle: $countryArTitle, areaCode: $areaCode, flag: $flag)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CountryObjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.countryEnTitle, countryEnTitle) ||
                other.countryEnTitle == countryEnTitle) &&
            (identical(other.countryArTitle, countryArTitle) ||
                other.countryArTitle == countryArTitle) &&
            (identical(other.areaCode, areaCode) ||
                other.areaCode == areaCode) &&
            (identical(other.flag, flag) || other.flag == flag));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, countryCode, currencyCode,
      countryEnTitle, countryArTitle, areaCode, flag);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CountryObjectImplCopyWith<_$CountryObjectImpl> get copyWith =>
      __$$CountryObjectImplCopyWithImpl<_$CountryObjectImpl>(this, _$identity);
}

abstract class _CountryObject implements CountryObject {
  factory _CountryObject(
      final int id,
      final String countryCode,
      final String currencyCode,
      final String countryEnTitle,
      final String countryArTitle,
      final int areaCode,
      final String flag) = _$CountryObjectImpl;

  @override
  int get id;
  @override
  String get countryCode;
  @override
  String get currencyCode;
  @override
  String get countryEnTitle;
  @override
  String get countryArTitle;
  @override
  int get areaCode;
  @override
  String get flag;
  @override
  @JsonKey(ignore: true)
  _$$CountryObjectImplCopyWith<_$CountryObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SearchObject {
  int get sportId => throw _privateConstructorUsedError;
  int get genderId => throw _privateConstructorUsedError;
  int get governorateId => throw _privateConstructorUsedError;
  int get areaId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SearchObjectCopyWith<SearchObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchObjectCopyWith<$Res> {
  factory $SearchObjectCopyWith(
          SearchObject value, $Res Function(SearchObject) then) =
      _$SearchObjectCopyWithImpl<$Res, SearchObject>;
  @useResult
  $Res call({int sportId, int genderId, int governorateId, int areaId});
}

/// @nodoc
class _$SearchObjectCopyWithImpl<$Res, $Val extends SearchObject>
    implements $SearchObjectCopyWith<$Res> {
  _$SearchObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sportId = null,
    Object? genderId = null,
    Object? governorateId = null,
    Object? areaId = null,
  }) {
    return _then(_value.copyWith(
      sportId: null == sportId
          ? _value.sportId
          : sportId // ignore: cast_nullable_to_non_nullable
              as int,
      genderId: null == genderId
          ? _value.genderId
          : genderId // ignore: cast_nullable_to_non_nullable
              as int,
      governorateId: null == governorateId
          ? _value.governorateId
          : governorateId // ignore: cast_nullable_to_non_nullable
              as int,
      areaId: null == areaId
          ? _value.areaId
          : areaId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchObjectImplCopyWith<$Res>
    implements $SearchObjectCopyWith<$Res> {
  factory _$$SearchObjectImplCopyWith(
          _$SearchObjectImpl value, $Res Function(_$SearchObjectImpl) then) =
      __$$SearchObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int sportId, int genderId, int governorateId, int areaId});
}

/// @nodoc
class __$$SearchObjectImplCopyWithImpl<$Res>
    extends _$SearchObjectCopyWithImpl<$Res, _$SearchObjectImpl>
    implements _$$SearchObjectImplCopyWith<$Res> {
  __$$SearchObjectImplCopyWithImpl(
      _$SearchObjectImpl _value, $Res Function(_$SearchObjectImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sportId = null,
    Object? genderId = null,
    Object? governorateId = null,
    Object? areaId = null,
  }) {
    return _then(_$SearchObjectImpl(
      null == sportId
          ? _value.sportId
          : sportId // ignore: cast_nullable_to_non_nullable
              as int,
      null == genderId
          ? _value.genderId
          : genderId // ignore: cast_nullable_to_non_nullable
              as int,
      null == governorateId
          ? _value.governorateId
          : governorateId // ignore: cast_nullable_to_non_nullable
              as int,
      null == areaId
          ? _value.areaId
          : areaId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$SearchObjectImpl implements _SearchObject {
  _$SearchObjectImpl(
      this.sportId, this.genderId, this.governorateId, this.areaId);

  @override
  final int sportId;
  @override
  final int genderId;
  @override
  final int governorateId;
  @override
  final int areaId;

  @override
  String toString() {
    return 'SearchObject(sportId: $sportId, genderId: $genderId, governorateId: $governorateId, areaId: $areaId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchObjectImpl &&
            (identical(other.sportId, sportId) || other.sportId == sportId) &&
            (identical(other.genderId, genderId) ||
                other.genderId == genderId) &&
            (identical(other.governorateId, governorateId) ||
                other.governorateId == governorateId) &&
            (identical(other.areaId, areaId) || other.areaId == areaId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, sportId, genderId, governorateId, areaId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchObjectImplCopyWith<_$SearchObjectImpl> get copyWith =>
      __$$SearchObjectImplCopyWithImpl<_$SearchObjectImpl>(this, _$identity);
}

abstract class _SearchObject implements SearchObject {
  factory _SearchObject(final int sportId, final int genderId,
      final int governorateId, final int areaId) = _$SearchObjectImpl;

  @override
  int get sportId;
  @override
  int get genderId;
  @override
  int get governorateId;
  @override
  int get areaId;
  @override
  @JsonKey(ignore: true)
  _$$SearchObjectImplCopyWith<_$SearchObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SearchObjectText {
  String get sportName => throw _privateConstructorUsedError;
  String get genderName => throw _privateConstructorUsedError;
  String get governorateName => throw _privateConstructorUsedError;
  String get areaName => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SearchObjectTextCopyWith<SearchObjectText> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchObjectTextCopyWith<$Res> {
  factory $SearchObjectTextCopyWith(
          SearchObjectText value, $Res Function(SearchObjectText) then) =
      _$SearchObjectTextCopyWithImpl<$Res, SearchObjectText>;
  @useResult
  $Res call(
      {String sportName,
      String genderName,
      String governorateName,
      String areaName});
}

/// @nodoc
class _$SearchObjectTextCopyWithImpl<$Res, $Val extends SearchObjectText>
    implements $SearchObjectTextCopyWith<$Res> {
  _$SearchObjectTextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sportName = null,
    Object? genderName = null,
    Object? governorateName = null,
    Object? areaName = null,
  }) {
    return _then(_value.copyWith(
      sportName: null == sportName
          ? _value.sportName
          : sportName // ignore: cast_nullable_to_non_nullable
              as String,
      genderName: null == genderName
          ? _value.genderName
          : genderName // ignore: cast_nullable_to_non_nullable
              as String,
      governorateName: null == governorateName
          ? _value.governorateName
          : governorateName // ignore: cast_nullable_to_non_nullable
              as String,
      areaName: null == areaName
          ? _value.areaName
          : areaName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchObjectTextImplCopyWith<$Res>
    implements $SearchObjectTextCopyWith<$Res> {
  factory _$$SearchObjectTextImplCopyWith(_$SearchObjectTextImpl value,
          $Res Function(_$SearchObjectTextImpl) then) =
      __$$SearchObjectTextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sportName,
      String genderName,
      String governorateName,
      String areaName});
}

/// @nodoc
class __$$SearchObjectTextImplCopyWithImpl<$Res>
    extends _$SearchObjectTextCopyWithImpl<$Res, _$SearchObjectTextImpl>
    implements _$$SearchObjectTextImplCopyWith<$Res> {
  __$$SearchObjectTextImplCopyWithImpl(_$SearchObjectTextImpl _value,
      $Res Function(_$SearchObjectTextImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sportName = null,
    Object? genderName = null,
    Object? governorateName = null,
    Object? areaName = null,
  }) {
    return _then(_$SearchObjectTextImpl(
      null == sportName
          ? _value.sportName
          : sportName // ignore: cast_nullable_to_non_nullable
              as String,
      null == genderName
          ? _value.genderName
          : genderName // ignore: cast_nullable_to_non_nullable
              as String,
      null == governorateName
          ? _value.governorateName
          : governorateName // ignore: cast_nullable_to_non_nullable
              as String,
      null == areaName
          ? _value.areaName
          : areaName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SearchObjectTextImpl implements _SearchObjectText {
  _$SearchObjectTextImpl(
      this.sportName, this.genderName, this.governorateName, this.areaName);

  @override
  final String sportName;
  @override
  final String genderName;
  @override
  final String governorateName;
  @override
  final String areaName;

  @override
  String toString() {
    return 'SearchObjectText(sportName: $sportName, genderName: $genderName, governorateName: $governorateName, areaName: $areaName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchObjectTextImpl &&
            (identical(other.sportName, sportName) ||
                other.sportName == sportName) &&
            (identical(other.genderName, genderName) ||
                other.genderName == genderName) &&
            (identical(other.governorateName, governorateName) ||
                other.governorateName == governorateName) &&
            (identical(other.areaName, areaName) ||
                other.areaName == areaName));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, sportName, genderName, governorateName, areaName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchObjectTextImplCopyWith<_$SearchObjectTextImpl> get copyWith =>
      __$$SearchObjectTextImplCopyWithImpl<_$SearchObjectTextImpl>(
          this, _$identity);
}

abstract class _SearchObjectText implements SearchObjectText {
  factory _SearchObjectText(
      final String sportName,
      final String genderName,
      final String governorateName,
      final String areaName) = _$SearchObjectTextImpl;

  @override
  String get sportName;
  @override
  String get genderName;
  @override
  String get governorateName;
  @override
  String get areaName;
  @override
  @JsonKey(ignore: true)
  _$$SearchObjectTextImplCopyWith<_$SearchObjectTextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AcademyObject {
  int get academyId => throw _privateConstructorUsedError;
  int get sessionId => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  int get subscriptionId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AcademyObjectCopyWith<AcademyObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AcademyObjectCopyWith<$Res> {
  factory $AcademyObjectCopyWith(
          AcademyObject value, $Res Function(AcademyObject) then) =
      _$AcademyObjectCopyWithImpl<$Res, AcademyObject>;
  @useResult
  $Res call({int academyId, int sessionId, int count, int subscriptionId});
}

/// @nodoc
class _$AcademyObjectCopyWithImpl<$Res, $Val extends AcademyObject>
    implements $AcademyObjectCopyWith<$Res> {
  _$AcademyObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? academyId = null,
    Object? sessionId = null,
    Object? count = null,
    Object? subscriptionId = null,
  }) {
    return _then(_value.copyWith(
      academyId: null == academyId
          ? _value.academyId
          : academyId // ignore: cast_nullable_to_non_nullable
              as int,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as int,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      subscriptionId: null == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AcademyObjectImplCopyWith<$Res>
    implements $AcademyObjectCopyWith<$Res> {
  factory _$$AcademyObjectImplCopyWith(
          _$AcademyObjectImpl value, $Res Function(_$AcademyObjectImpl) then) =
      __$$AcademyObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int academyId, int sessionId, int count, int subscriptionId});
}

/// @nodoc
class __$$AcademyObjectImplCopyWithImpl<$Res>
    extends _$AcademyObjectCopyWithImpl<$Res, _$AcademyObjectImpl>
    implements _$$AcademyObjectImplCopyWith<$Res> {
  __$$AcademyObjectImplCopyWithImpl(
      _$AcademyObjectImpl _value, $Res Function(_$AcademyObjectImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? academyId = null,
    Object? sessionId = null,
    Object? count = null,
    Object? subscriptionId = null,
  }) {
    return _then(_$AcademyObjectImpl(
      null == academyId
          ? _value.academyId
          : academyId // ignore: cast_nullable_to_non_nullable
              as int,
      null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as int,
      null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      null == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$AcademyObjectImpl implements _AcademyObject {
  _$AcademyObjectImpl(
      this.academyId, this.sessionId, this.count, this.subscriptionId);

  @override
  final int academyId;
  @override
  final int sessionId;
  @override
  final int count;
  @override
  final int subscriptionId;

  @override
  String toString() {
    return 'AcademyObject(academyId: $academyId, sessionId: $sessionId, count: $count, subscriptionId: $subscriptionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AcademyObjectImpl &&
            (identical(other.academyId, academyId) ||
                other.academyId == academyId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.subscriptionId, subscriptionId) ||
                other.subscriptionId == subscriptionId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, academyId, sessionId, count, subscriptionId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AcademyObjectImplCopyWith<_$AcademyObjectImpl> get copyWith =>
      __$$AcademyObjectImplCopyWithImpl<_$AcademyObjectImpl>(this, _$identity);
}

abstract class _AcademyObject implements AcademyObject {
  factory _AcademyObject(final int academyId, final int sessionId,
      final int count, final int subscriptionId) = _$AcademyObjectImpl;

  @override
  int get academyId;
  @override
  int get sessionId;
  @override
  int get count;
  @override
  int get subscriptionId;
  @override
  @JsonKey(ignore: true)
  _$$AcademyObjectImplCopyWith<_$AcademyObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SubscriptionObject {
  int get userId => throw _privateConstructorUsedError;
  int get Type => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SubscriptionObjectCopyWith<SubscriptionObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionObjectCopyWith<$Res> {
  factory $SubscriptionObjectCopyWith(
          SubscriptionObject value, $Res Function(SubscriptionObject) then) =
      _$SubscriptionObjectCopyWithImpl<$Res, SubscriptionObject>;
  @useResult
  $Res call({int userId, int Type});
}

/// @nodoc
class _$SubscriptionObjectCopyWithImpl<$Res, $Val extends SubscriptionObject>
    implements $SubscriptionObjectCopyWith<$Res> {
  _$SubscriptionObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? Type = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      Type: null == Type
          ? _value.Type
          : Type // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionObjectImplCopyWith<$Res>
    implements $SubscriptionObjectCopyWith<$Res> {
  factory _$$SubscriptionObjectImplCopyWith(_$SubscriptionObjectImpl value,
          $Res Function(_$SubscriptionObjectImpl) then) =
      __$$SubscriptionObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int userId, int Type});
}

/// @nodoc
class __$$SubscriptionObjectImplCopyWithImpl<$Res>
    extends _$SubscriptionObjectCopyWithImpl<$Res, _$SubscriptionObjectImpl>
    implements _$$SubscriptionObjectImplCopyWith<$Res> {
  __$$SubscriptionObjectImplCopyWithImpl(_$SubscriptionObjectImpl _value,
      $Res Function(_$SubscriptionObjectImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? Type = null,
  }) {
    return _then(_$SubscriptionObjectImpl(
      null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      null == Type
          ? _value.Type
          : Type // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$SubscriptionObjectImpl implements _SubscriptionObject {
  _$SubscriptionObjectImpl(this.userId, this.Type);

  @override
  final int userId;
  @override
  final int Type;

  @override
  String toString() {
    return 'SubscriptionObject(userId: $userId, Type: $Type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionObjectImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.Type, Type) || other.Type == Type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, Type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionObjectImplCopyWith<_$SubscriptionObjectImpl> get copyWith =>
      __$$SubscriptionObjectImplCopyWithImpl<_$SubscriptionObjectImpl>(
          this, _$identity);
}

abstract class _SubscriptionObject implements SubscriptionObject {
  factory _SubscriptionObject(final int userId, final int Type) =
      _$SubscriptionObjectImpl;

  @override
  int get userId;
  @override
  int get Type;
  @override
  @JsonKey(ignore: true)
  _$$SubscriptionObjectImplCopyWith<_$SubscriptionObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CancelSubscriptionObject {
  int get userId => throw _privateConstructorUsedError;
  int get orderId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CancelSubscriptionObjectCopyWith<CancelSubscriptionObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CancelSubscriptionObjectCopyWith<$Res> {
  factory $CancelSubscriptionObjectCopyWith(CancelSubscriptionObject value,
          $Res Function(CancelSubscriptionObject) then) =
      _$CancelSubscriptionObjectCopyWithImpl<$Res, CancelSubscriptionObject>;
  @useResult
  $Res call({int userId, int orderId});
}

/// @nodoc
class _$CancelSubscriptionObjectCopyWithImpl<$Res,
        $Val extends CancelSubscriptionObject>
    implements $CancelSubscriptionObjectCopyWith<$Res> {
  _$CancelSubscriptionObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? orderId = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CancelSubscriptionObjectImplCopyWith<$Res>
    implements $CancelSubscriptionObjectCopyWith<$Res> {
  factory _$$CancelSubscriptionObjectImplCopyWith(
          _$CancelSubscriptionObjectImpl value,
          $Res Function(_$CancelSubscriptionObjectImpl) then) =
      __$$CancelSubscriptionObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int userId, int orderId});
}

/// @nodoc
class __$$CancelSubscriptionObjectImplCopyWithImpl<$Res>
    extends _$CancelSubscriptionObjectCopyWithImpl<$Res,
        _$CancelSubscriptionObjectImpl>
    implements _$$CancelSubscriptionObjectImplCopyWith<$Res> {
  __$$CancelSubscriptionObjectImplCopyWithImpl(
      _$CancelSubscriptionObjectImpl _value,
      $Res Function(_$CancelSubscriptionObjectImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? orderId = null,
  }) {
    return _then(_$CancelSubscriptionObjectImpl(
      null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$CancelSubscriptionObjectImpl implements _CancelSubscriptionObject {
  _$CancelSubscriptionObjectImpl(this.userId, this.orderId);

  @override
  final int userId;
  @override
  final int orderId;

  @override
  String toString() {
    return 'CancelSubscriptionObject(userId: $userId, orderId: $orderId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CancelSubscriptionObjectImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.orderId, orderId) || other.orderId == orderId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, orderId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CancelSubscriptionObjectImplCopyWith<_$CancelSubscriptionObjectImpl>
      get copyWith => __$$CancelSubscriptionObjectImplCopyWithImpl<
          _$CancelSubscriptionObjectImpl>(this, _$identity);
}

abstract class _CancelSubscriptionObject implements CancelSubscriptionObject {
  factory _CancelSubscriptionObject(final int userId, final int orderId) =
      _$CancelSubscriptionObjectImpl;

  @override
  int get userId;
  @override
  int get orderId;
  @override
  @JsonKey(ignore: true)
  _$$CancelSubscriptionObjectImplCopyWith<_$CancelSubscriptionObjectImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ClothesObject {
  int get count => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ClothesObjectCopyWith<ClothesObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClothesObjectCopyWith<$Res> {
  factory $ClothesObjectCopyWith(
          ClothesObject value, $Res Function(ClothesObject) then) =
      _$ClothesObjectCopyWithImpl<$Res, ClothesObject>;
  @useResult
  $Res call({int count});
}

/// @nodoc
class _$ClothesObjectCopyWithImpl<$Res, $Val extends ClothesObject>
    implements $ClothesObjectCopyWith<$Res> {
  _$ClothesObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClothesObjectImplCopyWith<$Res>
    implements $ClothesObjectCopyWith<$Res> {
  factory _$$ClothesObjectImplCopyWith(
          _$ClothesObjectImpl value, $Res Function(_$ClothesObjectImpl) then) =
      __$$ClothesObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int count});
}

/// @nodoc
class __$$ClothesObjectImplCopyWithImpl<$Res>
    extends _$ClothesObjectCopyWithImpl<$Res, _$ClothesObjectImpl>
    implements _$$ClothesObjectImplCopyWith<$Res> {
  __$$ClothesObjectImplCopyWithImpl(
      _$ClothesObjectImpl _value, $Res Function(_$ClothesObjectImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
  }) {
    return _then(_$ClothesObjectImpl(
      null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ClothesObjectImpl implements _ClothesObject {
  _$ClothesObjectImpl(this.count);

  @override
  final int count;

  @override
  String toString() {
    return 'ClothesObject(count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClothesObjectImpl &&
            (identical(other.count, count) || other.count == count));
  }

  @override
  int get hashCode => Object.hash(runtimeType, count);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ClothesObjectImplCopyWith<_$ClothesObjectImpl> get copyWith =>
      __$$ClothesObjectImplCopyWithImpl<_$ClothesObjectImpl>(this, _$identity);
}

abstract class _ClothesObject implements ClothesObject {
  factory _ClothesObject(final int count) = _$ClothesObjectImpl;

  @override
  int get count;
  @override
  @JsonKey(ignore: true)
  _$$ClothesObjectImplCopyWith<_$ClothesObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UserObject {
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  int get gender => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserObjectCopyWith<UserObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserObjectCopyWith<$Res> {
  factory $UserObjectCopyWith(
          UserObject value, $Res Function(UserObject) then) =
      _$UserObjectCopyWithImpl<$Res, UserObject>;
  @useResult
  $Res call(
      {String firstName,
      String lastName,
      String email,
      String phoneNumber,
      int gender});
}

/// @nodoc
class _$UserObjectCopyWithImpl<$Res, $Val extends UserObject>
    implements $UserObjectCopyWith<$Res> {
  _$UserObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? phoneNumber = null,
    Object? gender = null,
  }) {
    return _then(_value.copyWith(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserObjectImplCopyWith<$Res>
    implements $UserObjectCopyWith<$Res> {
  factory _$$UserObjectImplCopyWith(
          _$UserObjectImpl value, $Res Function(_$UserObjectImpl) then) =
      __$$UserObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String firstName,
      String lastName,
      String email,
      String phoneNumber,
      int gender});
}

/// @nodoc
class __$$UserObjectImplCopyWithImpl<$Res>
    extends _$UserObjectCopyWithImpl<$Res, _$UserObjectImpl>
    implements _$$UserObjectImplCopyWith<$Res> {
  __$$UserObjectImplCopyWithImpl(
      _$UserObjectImpl _value, $Res Function(_$UserObjectImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? phoneNumber = null,
    Object? gender = null,
  }) {
    return _then(_$UserObjectImpl(
      null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$UserObjectImpl implements _UserObject {
  _$UserObjectImpl(
      this.firstName, this.lastName, this.email, this.phoneNumber, this.gender);

  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String email;
  @override
  final String phoneNumber;
  @override
  final int gender;

  @override
  String toString() {
    return 'UserObject(firstName: $firstName, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, gender: $gender)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserObjectImpl &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.gender, gender) || other.gender == gender));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, firstName, lastName, email, phoneNumber, gender);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserObjectImplCopyWith<_$UserObjectImpl> get copyWith =>
      __$$UserObjectImplCopyWithImpl<_$UserObjectImpl>(this, _$identity);
}

abstract class _UserObject implements UserObject {
  factory _UserObject(
      final String firstName,
      final String lastName,
      final String email,
      final String phoneNumber,
      final int gender) = _$UserObjectImpl;

  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get email;
  @override
  String get phoneNumber;
  @override
  int get gender;
  @override
  @JsonKey(ignore: true)
  _$$UserObjectImplCopyWith<_$UserObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ContactUsObject {
  String get title => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ContactUsObjectCopyWith<ContactUsObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactUsObjectCopyWith<$Res> {
  factory $ContactUsObjectCopyWith(
          ContactUsObject value, $Res Function(ContactUsObject) then) =
      _$ContactUsObjectCopyWithImpl<$Res, ContactUsObject>;
  @useResult
  $Res call({String title, String email, String phoneNumber, String message});
}

/// @nodoc
class _$ContactUsObjectCopyWithImpl<$Res, $Val extends ContactUsObject>
    implements $ContactUsObjectCopyWith<$Res> {
  _$ContactUsObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? email = null,
    Object? phoneNumber = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactUsObjectImplCopyWith<$Res>
    implements $ContactUsObjectCopyWith<$Res> {
  factory _$$ContactUsObjectImplCopyWith(_$ContactUsObjectImpl value,
          $Res Function(_$ContactUsObjectImpl) then) =
      __$$ContactUsObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String email, String phoneNumber, String message});
}

/// @nodoc
class __$$ContactUsObjectImplCopyWithImpl<$Res>
    extends _$ContactUsObjectCopyWithImpl<$Res, _$ContactUsObjectImpl>
    implements _$$ContactUsObjectImplCopyWith<$Res> {
  __$$ContactUsObjectImplCopyWithImpl(
      _$ContactUsObjectImpl _value, $Res Function(_$ContactUsObjectImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? email = null,
    Object? phoneNumber = null,
    Object? message = null,
  }) {
    return _then(_$ContactUsObjectImpl(
      null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ContactUsObjectImpl implements _ContactUsObject {
  _$ContactUsObjectImpl(this.title, this.email, this.phoneNumber, this.message);

  @override
  final String title;
  @override
  final String email;
  @override
  final String phoneNumber;
  @override
  final String message;

  @override
  String toString() {
    return 'ContactUsObject(title: $title, email: $email, phoneNumber: $phoneNumber, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactUsObjectImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, title, email, phoneNumber, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactUsObjectImplCopyWith<_$ContactUsObjectImpl> get copyWith =>
      __$$ContactUsObjectImplCopyWithImpl<_$ContactUsObjectImpl>(
          this, _$identity);
}

abstract class _ContactUsObject implements ContactUsObject {
  factory _ContactUsObject(final String title, final String email,
      final String phoneNumber, final String message) = _$ContactUsObjectImpl;

  @override
  String get title;
  @override
  String get email;
  @override
  String get phoneNumber;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$ContactUsObjectImplCopyWith<_$ContactUsObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PayObject {
  int get userId => throw _privateConstructorUsedError;
  int get academyId => throw _privateConstructorUsedError;
  int get subscriptionId => throw _privateConstructorUsedError;
  int get sessionId => throw _privateConstructorUsedError;
  int get subscriptionCount => throw _privateConstructorUsedError;
  int get subscriptionPrice => throw _privateConstructorUsedError;
  double get clothesPrice => throw _privateConstructorUsedError;
  int get clothesCount => throw _privateConstructorUsedError;
  int get paymentMethod => throw _privateConstructorUsedError;
  String get voucher => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PayObjectCopyWith<PayObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PayObjectCopyWith<$Res> {
  factory $PayObjectCopyWith(PayObject value, $Res Function(PayObject) then) =
      _$PayObjectCopyWithImpl<$Res, PayObject>;
  @useResult
  $Res call(
      {int userId,
      int academyId,
      int subscriptionId,
      int sessionId,
      int subscriptionCount,
      int subscriptionPrice,
      double clothesPrice,
      int clothesCount,
      int paymentMethod,
      String voucher});
}

/// @nodoc
class _$PayObjectCopyWithImpl<$Res, $Val extends PayObject>
    implements $PayObjectCopyWith<$Res> {
  _$PayObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? academyId = null,
    Object? subscriptionId = null,
    Object? sessionId = null,
    Object? subscriptionCount = null,
    Object? subscriptionPrice = null,
    Object? clothesPrice = null,
    Object? clothesCount = null,
    Object? paymentMethod = null,
    Object? voucher = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      academyId: null == academyId
          ? _value.academyId
          : academyId // ignore: cast_nullable_to_non_nullable
              as int,
      subscriptionId: null == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as int,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as int,
      subscriptionCount: null == subscriptionCount
          ? _value.subscriptionCount
          : subscriptionCount // ignore: cast_nullable_to_non_nullable
              as int,
      subscriptionPrice: null == subscriptionPrice
          ? _value.subscriptionPrice
          : subscriptionPrice // ignore: cast_nullable_to_non_nullable
              as int,
      clothesPrice: null == clothesPrice
          ? _value.clothesPrice
          : clothesPrice // ignore: cast_nullable_to_non_nullable
              as double,
      clothesCount: null == clothesCount
          ? _value.clothesCount
          : clothesCount // ignore: cast_nullable_to_non_nullable
              as int,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as int,
      voucher: null == voucher
          ? _value.voucher
          : voucher // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PayObjectImplCopyWith<$Res>
    implements $PayObjectCopyWith<$Res> {
  factory _$$PayObjectImplCopyWith(
          _$PayObjectImpl value, $Res Function(_$PayObjectImpl) then) =
      __$$PayObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int userId,
      int academyId,
      int subscriptionId,
      int sessionId,
      int subscriptionCount,
      int subscriptionPrice,
      double clothesPrice,
      int clothesCount,
      int paymentMethod,
      String voucher});
}

/// @nodoc
class __$$PayObjectImplCopyWithImpl<$Res>
    extends _$PayObjectCopyWithImpl<$Res, _$PayObjectImpl>
    implements _$$PayObjectImplCopyWith<$Res> {
  __$$PayObjectImplCopyWithImpl(
      _$PayObjectImpl _value, $Res Function(_$PayObjectImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? academyId = null,
    Object? subscriptionId = null,
    Object? sessionId = null,
    Object? subscriptionCount = null,
    Object? subscriptionPrice = null,
    Object? clothesPrice = null,
    Object? clothesCount = null,
    Object? paymentMethod = null,
    Object? voucher = null,
  }) {
    return _then(_$PayObjectImpl(
      null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      null == academyId
          ? _value.academyId
          : academyId // ignore: cast_nullable_to_non_nullable
              as int,
      null == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as int,
      null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as int,
      null == subscriptionCount
          ? _value.subscriptionCount
          : subscriptionCount // ignore: cast_nullable_to_non_nullable
              as int,
      null == subscriptionPrice
          ? _value.subscriptionPrice
          : subscriptionPrice // ignore: cast_nullable_to_non_nullable
              as int,
      null == clothesPrice
          ? _value.clothesPrice
          : clothesPrice // ignore: cast_nullable_to_non_nullable
              as double,
      null == clothesCount
          ? _value.clothesCount
          : clothesCount // ignore: cast_nullable_to_non_nullable
              as int,
      null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as int,
      null == voucher
          ? _value.voucher
          : voucher // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PayObjectImpl implements _PayObject {
  _$PayObjectImpl(
      this.userId,
      this.academyId,
      this.subscriptionId,
      this.sessionId,
      this.subscriptionCount,
      this.subscriptionPrice,
      this.clothesPrice,
      this.clothesCount,
      this.paymentMethod,
      this.voucher);

  @override
  final int userId;
  @override
  final int academyId;
  @override
  final int subscriptionId;
  @override
  final int sessionId;
  @override
  final int subscriptionCount;
  @override
  final int subscriptionPrice;
  @override
  final double clothesPrice;
  @override
  final int clothesCount;
  @override
  final int paymentMethod;
  @override
  final String voucher;

  @override
  String toString() {
    return 'PayObject(userId: $userId, academyId: $academyId, subscriptionId: $subscriptionId, sessionId: $sessionId, subscriptionCount: $subscriptionCount, subscriptionPrice: $subscriptionPrice, clothesPrice: $clothesPrice, clothesCount: $clothesCount, paymentMethod: $paymentMethod, voucher: $voucher)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PayObjectImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.academyId, academyId) ||
                other.academyId == academyId) &&
            (identical(other.subscriptionId, subscriptionId) ||
                other.subscriptionId == subscriptionId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.subscriptionCount, subscriptionCount) ||
                other.subscriptionCount == subscriptionCount) &&
            (identical(other.subscriptionPrice, subscriptionPrice) ||
                other.subscriptionPrice == subscriptionPrice) &&
            (identical(other.clothesPrice, clothesPrice) ||
                other.clothesPrice == clothesPrice) &&
            (identical(other.clothesCount, clothesCount) ||
                other.clothesCount == clothesCount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.voucher, voucher) || other.voucher == voucher));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      academyId,
      subscriptionId,
      sessionId,
      subscriptionCount,
      subscriptionPrice,
      clothesPrice,
      clothesCount,
      paymentMethod,
      voucher);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PayObjectImplCopyWith<_$PayObjectImpl> get copyWith =>
      __$$PayObjectImplCopyWithImpl<_$PayObjectImpl>(this, _$identity);
}

abstract class _PayObject implements PayObject {
  factory _PayObject(
      final int userId,
      final int academyId,
      final int subscriptionId,
      final int sessionId,
      final int subscriptionCount,
      final int subscriptionPrice,
      final double clothesPrice,
      final int clothesCount,
      final int paymentMethod,
      final String voucher) = _$PayObjectImpl;

  @override
  int get userId;
  @override
  int get academyId;
  @override
  int get subscriptionId;
  @override
  int get sessionId;
  @override
  int get subscriptionCount;
  @override
  int get subscriptionPrice;
  @override
  double get clothesPrice;
  @override
  int get clothesCount;
  @override
  int get paymentMethod;
  @override
  String get voucher;
  @override
  @JsonKey(ignore: true)
  _$$PayObjectImplCopyWith<_$PayObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OrderObject {
  String get invoiceId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrderObjectCopyWith<OrderObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderObjectCopyWith<$Res> {
  factory $OrderObjectCopyWith(
          OrderObject value, $Res Function(OrderObject) then) =
      _$OrderObjectCopyWithImpl<$Res, OrderObject>;
  @useResult
  $Res call({String invoiceId, String status, String url});
}

/// @nodoc
class _$OrderObjectCopyWithImpl<$Res, $Val extends OrderObject>
    implements $OrderObjectCopyWith<$Res> {
  _$OrderObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? invoiceId = null,
    Object? status = null,
    Object? url = null,
  }) {
    return _then(_value.copyWith(
      invoiceId: null == invoiceId
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderObjectImplCopyWith<$Res>
    implements $OrderObjectCopyWith<$Res> {
  factory _$$OrderObjectImplCopyWith(
          _$OrderObjectImpl value, $Res Function(_$OrderObjectImpl) then) =
      __$$OrderObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String invoiceId, String status, String url});
}

/// @nodoc
class __$$OrderObjectImplCopyWithImpl<$Res>
    extends _$OrderObjectCopyWithImpl<$Res, _$OrderObjectImpl>
    implements _$$OrderObjectImplCopyWith<$Res> {
  __$$OrderObjectImplCopyWithImpl(
      _$OrderObjectImpl _value, $Res Function(_$OrderObjectImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? invoiceId = null,
    Object? status = null,
    Object? url = null,
  }) {
    return _then(_$OrderObjectImpl(
      null == invoiceId
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as String,
      null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$OrderObjectImpl implements _OrderObject {
  _$OrderObjectImpl(this.invoiceId, this.status, this.url);

  @override
  final String invoiceId;
  @override
  final String status;
  @override
  final String url;

  @override
  String toString() {
    return 'OrderObject(invoiceId: $invoiceId, status: $status, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderObjectImpl &&
            (identical(other.invoiceId, invoiceId) ||
                other.invoiceId == invoiceId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.url, url) || other.url == url));
  }

  @override
  int get hashCode => Object.hash(runtimeType, invoiceId, status, url);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderObjectImplCopyWith<_$OrderObjectImpl> get copyWith =>
      __$$OrderObjectImplCopyWithImpl<_$OrderObjectImpl>(this, _$identity);
}

abstract class _OrderObject implements OrderObject {
  factory _OrderObject(
          final String invoiceId, final String status, final String url) =
      _$OrderObjectImpl;

  @override
  String get invoiceId;
  @override
  String get status;
  @override
  String get url;
  @override
  @JsonKey(ignore: true)
  _$$OrderObjectImplCopyWith<_$OrderObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OrderDetailsObject {
  String get orderId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrderDetailsObjectCopyWith<OrderDetailsObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderDetailsObjectCopyWith<$Res> {
  factory $OrderDetailsObjectCopyWith(
          OrderDetailsObject value, $Res Function(OrderDetailsObject) then) =
      _$OrderDetailsObjectCopyWithImpl<$Res, OrderDetailsObject>;
  @useResult
  $Res call({String orderId});
}

/// @nodoc
class _$OrderDetailsObjectCopyWithImpl<$Res, $Val extends OrderDetailsObject>
    implements $OrderDetailsObjectCopyWith<$Res> {
  _$OrderDetailsObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
  }) {
    return _then(_value.copyWith(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderDetailsObjectImplCopyWith<$Res>
    implements $OrderDetailsObjectCopyWith<$Res> {
  factory _$$OrderDetailsObjectImplCopyWith(_$OrderDetailsObjectImpl value,
          $Res Function(_$OrderDetailsObjectImpl) then) =
      __$$OrderDetailsObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String orderId});
}

/// @nodoc
class __$$OrderDetailsObjectImplCopyWithImpl<$Res>
    extends _$OrderDetailsObjectCopyWithImpl<$Res, _$OrderDetailsObjectImpl>
    implements _$$OrderDetailsObjectImplCopyWith<$Res> {
  __$$OrderDetailsObjectImplCopyWithImpl(_$OrderDetailsObjectImpl _value,
      $Res Function(_$OrderDetailsObjectImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
  }) {
    return _then(_$OrderDetailsObjectImpl(
      null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$OrderDetailsObjectImpl implements _OrderDetailsObject {
  _$OrderDetailsObjectImpl(this.orderId);

  @override
  final String orderId;

  @override
  String toString() {
    return 'OrderDetailsObject(orderId: $orderId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderDetailsObjectImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, orderId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderDetailsObjectImplCopyWith<_$OrderDetailsObjectImpl> get copyWith =>
      __$$OrderDetailsObjectImplCopyWithImpl<_$OrderDetailsObjectImpl>(
          this, _$identity);
}

abstract class _OrderDetailsObject implements OrderDetailsObject {
  factory _OrderDetailsObject(final String orderId) = _$OrderDetailsObjectImpl;

  @override
  String get orderId;
  @override
  @JsonKey(ignore: true)
  _$$OrderDetailsObjectImplCopyWith<_$OrderDetailsObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
