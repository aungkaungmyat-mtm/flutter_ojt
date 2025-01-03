import 'package:flutter_ojt/models/user_model_export.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class AddressModelConverter
    implements JsonConverter<AddressModel, Map<String, dynamic>> {
  const AddressModelConverter();

  @override
  AddressModel fromJson(Map<String, dynamic> json) =>
      AddressModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(AddressModel data) => data.toJson();
}

class NullableAddressModelConverter
    implements JsonConverter<AddressModel?, Map<String, dynamic>?> {
  const NullableAddressModelConverter();

  @override
  AddressModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return AddressModel.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AddressModel? data) => data?.toJson();
}
