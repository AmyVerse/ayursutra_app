// auth_service.dart
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'app_cache_manager.dart';
import 'user_cache_service.dart';

class User {
  final int id;
  final String? ayursutraId;
  final String? name;
  final String? email;
  final String? phone;
  final String role;
  final bool emailVerified;
  final bool phoneVerified;
  final DateTime createdAt;

  User({
    required this.id,
    this.ayursutraId,
    this.name,
    this.email,
    this.phone,
    required this.role,
    required this.emailVerified,
    required this.phoneVerified,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      ayursutraId: json['ayursutraId'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      emailVerified: json['emailVerified'] ?? false,
      phoneVerified: json['phoneVerified'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class AuthService {
  final String baseUrl = 'https://ayursutra.amyverse.in/api';
  final storage = FlutterSecureStorage();

  // For development
  final String devApiKey = 'ayursutra_rollar';

  // For production - use a more secure key
  final String prodApiKey = 'ayursutra_rollar';

  // Choose the right key based on environment
  String get apiKey {
    // You can determine which environment you're in
    bool isProduction = const bool.fromEnvironment('dart.vm.product');
    return isProduction ? prodApiKey : devApiKey;
  }

  // Headers with API key
  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'x-api-key': apiKey,
  };

  // Step 1: Send OTP
  Future<bool> sendOTP(String identifier) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/otp/send'),
        headers: headers,
        body: jsonEncode({'identifier': identifier}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(data['error'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      print('Error sending OTP: $e');
      return false;
    }
  }

  // Step 2: Verify OTP
  Future<Map<String, dynamic>> verifyOTP(
    String identifier,
    String otp, {
    bool isDoctor = false,
    String? hprId,
    String? abhaId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/otp/verify'),
        headers: headers,
        body: jsonEncode({
          'identifier': identifier,
          'otp': otp,
          'isDoctor': isDoctor,
          if (hprId != null) 'hprId': hprId,
          if (abhaId != null) 'abhaId': abhaId,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success']) {
        // Store user data securely - convert to string if needed
        await storage.write(key: 'userId', value: data['userId'].toString());
        await storage.write(key: 'userRole', value: data['role'].toString());
        return data;
      } else {
        throw Exception(data['error'] ?? 'Failed to verify OTP');
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      rethrow;
    }
  }

  // Get stored user data
  Future<String?> getUserId() async {
    return await storage.read(key: 'userId');
  }

  Future<String?> getUserRole() async {
    return await storage.read(key: 'userRole');
  }

  // Get user details from API or cache
  Future<User?> getUserDetails() async {
    try {
      // Get stored user ID
      final userId = await storage.read(key: 'userId');
      if (userId == null) {
        return null; // User not logged in
      }

      // Try to get user from cache first
      final cachedUser = await UserCacheService.getCachedUserDetails();
      if (cachedUser != null) {
        print('Retrieved user details from cache');
        return cachedUser;
      }

      // If not in cache, fetch from API
      print('Cache miss - Fetching user details from API for userId: $userId');

      final response = await http.post(
        Uri.parse('$baseUrl/user/details'),
        headers: headers,
        body: jsonEncode({'userId': userId}),
      );

      print('API Response status: ${response.statusCode}');
      print('API Response body: ${response.body}');

      User? user;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if data is wrapped in a 'user' property
        if (data['user'] != null) {
          print('User data found in response["user"]');
          user = User.fromJson(data['user']);
        }
        // Check if the response has the expected user fields
        else if (data['id'] != null) {
          print('User data found directly in response');
          user = User.fromJson(data);
        }
        // Handle success response but no user data
        else if (data['success'] == true && data['message'] != null) {
          print('Success response but no user data: ${data['message']}');

          // Create a placeholder user with minimal information
          // This is a temporary workaround if the API doesn't return complete data
          user = User(
            id: int.tryParse(userId) ?? 0,
            ayursutraId: 'AYUR${userId}', // Generate a fake ayursutra ID
            name: 'User', // Placeholder name
            role: await storage.read(key: 'userRole') ?? 'patient',
            emailVerified: false,
            phoneVerified: false,
            createdAt: DateTime.now(),
          );
        }
        // Fallback for unexpected response format
        else {
          print('Unexpected response format: $data');
          return null;
        }
      } else {
        print('Error fetching user details: ${response.statusCode}');
        print('Error response: ${response.body}');

        // Return a placeholder user in development mode
        // This is helpful for testing when the API is not fully implemented
        if (const bool.fromEnvironment('dart.vm.product') == false) {
          print('Creating placeholder user for development');
          user = User(
            id: int.tryParse(userId) ?? 0,
            ayursutraId: 'AYUR${userId}', // Generate a fake ayursutra ID
            name: 'Test User', // Placeholder name
            email: 'test@example.com',
            phone: '9876543210',
            role: await storage.read(key: 'userRole') ?? 'patient',
            emailVerified: true,
            phoneVerified: true,
            createdAt: DateTime.now(),
          );
        } else {
          return null;
        }
      }

      // Cache the fetched user
      await UserCacheService.cacheUserDetails(user);

      return user;
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }

  // Check if logged in
  Future<bool> isLoggedIn() async {
    final userId = await storage.read(key: 'userId');
    return userId != null;
  }

  // Logout
  Future<void> logout() async {
    await storage.deleteAll();
    // Clear all app caches when logging out
    await AppCacheManager.clearAllCaches();
  }
}
