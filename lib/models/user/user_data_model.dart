import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data_model.freezed.dart';
part 'user_data_model.g.dart';

@freezed
class UserDataModel with _$UserDataModel {
  factory UserDataModel({
    @Default('') String uid,
    @Default('') String name,
    @Default('') String email,
    @Default('') String signInMethod,
    @Default('') String profileImageUrl,
    DateTime? dateofBirth,
  }) = _UserDataModel;

  factory UserDataModel.fromJson(Map<String, dynamic> json) =>
      _$UserDataModelFromJson(json);
}
