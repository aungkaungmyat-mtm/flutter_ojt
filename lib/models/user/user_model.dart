import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ojt/models/user_model_export.dart';
import 'package:flutter_ojt/utils/converters/address_model_converter.dart';
import 'package:flutter_ojt/utils/converters/timestamp_converter.dart';
import 'package:flutter_ojt/utils/converters/user_data_model_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  factory UserModel({
    String? id,
    @UserDataModelConverter() UserDataModel? userData,
    @NullableAddressModelConverter() AddressModel? address,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
