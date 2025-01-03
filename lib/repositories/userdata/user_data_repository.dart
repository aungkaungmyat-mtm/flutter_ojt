import 'dart:convert';
import 'dart:io';

import 'package:flutter_ojt/config/logger.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

abstract class BaseUserDataRepository {
  Future<String?> uploadProfileImage({
    required String userId,
    required File image,
  });
}

class UserDataRepository implements BaseUserDataRepository {
  final String cloudName = 'dqalk0yp8'; // Replace with your cloud name
  final String uploadPreset =
      'profile_image_preset'; // Replace with your upload preset

  @override
  Future<String?> uploadProfileImage({
    required String userId,
    required File image,
  }) async {
    try {
      // Construct the Cloudinary upload URL
      final uploadUrl =
          'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

      // Read the image file as bytes
      final bytes = await image.readAsBytes();

      // Create a multipart request
      final request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
        ..fields['upload_preset'] = uploadPreset
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: '$userId${extension(image.path)}',
        ));

      // Send the request
      final response = await request.send();

      // Check the response
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final imageUrl = jsonDecode(responseData)['secure_url'];
        logger.i("Image uploaded successfully: $imageUrl");
        return imageUrl;
      } else {
        logger.e("Failed to upload image: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      logger.e("Error during image upload: $e");
      return null;
    }
  }
}
