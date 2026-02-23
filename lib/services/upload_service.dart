import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firstreport/config/api_config.dart';
import 'package:firstreport/utils/user_registration.dart';

class UploadService {
  /// Uploads an image to your backend API (matches Postman screenshot)
  static Future<String?> uploadImage(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        print('❌ Upload Error: File does not exist at $filePath');
        return null;
      }
      
      // Get auth token if needed
      final token = await UserRegistration.getToken();
      
      // Endpoint matches backend: app.use("/api/upload", uploadRoutes)
      var uri = Uri.parse('${ApiConfig.baseUrl}/api/upload');
      var request = http.MultipartRequest('POST', uri);
      
      // Add auth header if your API requires it
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
        print('🔑 Token found: ${token.substring(0, 8)}...');
      } else {
        print('⚠️ No token found for upload!');
      }
      
      // Add the image file (Key 'image' from your Postman screenshot)
      request.files.add(await http.MultipartFile.fromPath('image', filePath));
      
      // Send request
      print('📤 Uploading image to: $uri');
      var response = await request.send().timeout(const Duration(seconds: 45));
      var responseString = await response.stream.bytesToString();
      
      print('📡 Server Response Status: ${response.statusCode}');
      print('📡 Server Body: $responseString');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = jsonDecode(responseString);
        if (jsonResponse['success'] == true) {
          final url = jsonResponse['url'];
          print('✅ Upload successful: $url');
          return url;
        }
      } else if (response.statusCode == 413) {
        print('❌ Upload failed: File too large (Max 10MB)');
      } else if (response.statusCode == 400) {
        var jsonResponse = jsonDecode(responseString);
        print('❌ Upload failed: ${jsonResponse['error']}');
      }
      
      print('❌ Upload failed with status ${response.statusCode}: $responseString');
      return null;
    } catch (e) {
      print('❌ Upload fatal error: $e');
      return null;
    }
  }
}
