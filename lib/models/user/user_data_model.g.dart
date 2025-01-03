// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDataModelImpl _$$UserDataModelImplFromJson(Map<String, dynamic> json) =>
    _$UserDataModelImpl(
      uid: json['uid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      signInMethod: json['signInMethod'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String? ?? '',
      dateofBirth: json['dateofBirth'] == null
          ? null
          : DateTime.parse(json['dateofBirth'] as String),
    );

Map<String, dynamic> _$$UserDataModelImplToJson(_$UserDataModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'signInMethod': instance.signInMethod,
      'profileImageUrl': instance.profileImageUrl,
      'dateofBirth': instance.dateofBirth?.toIso8601String(),
    };
