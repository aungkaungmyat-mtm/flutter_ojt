import 'package:flutter_ojt/models/user_model_export.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class UserDataModelConverter
    implements JsonConverter<UserDataModel, Map<String, dynamic>> {
  const UserDataModelConverter();

  @override
  UserDataModel fromJson(dynamic data) {
    if (data == null) {
      return UserDataModel();
    }
    final json = data as Map<String, dynamic>;
    return UserDataModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(UserDataModel userDataModel) {
    return userDataModel.toJson();
  }
}
