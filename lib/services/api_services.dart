import 'dart:convert';
import 'dart:io'; // Import this for SocketException

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dummyapi/models/user_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String appId = '61dbf9b1d7efe0f95bc1e1a6';
  final String baseUrl = 'https://dummyapi.io/data/v1';

  Future<List<UserModel>> fetchUsers() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return [];
      }

      final url = Uri.parse('$baseUrl/user?limit=10');
      final response = await http.get(url, headers: {'app-id': appId});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> usersJson = data['data'];
        return usersJson.map((json) => UserModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } on SocketException catch (e) {
      print('Network error: $e');
      return [];
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  Future<UserModel> fetchUserDetails(String userId) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception('No internet connection');
      }

      final url = Uri.parse('$baseUrl/user/$userId');
      final response = await http.get(url, headers: {'app-id': appId});

      if (response.statusCode == 200) {
        final userJson = json.decode(response.body);
        return UserModel.fromJson(userJson);
      } else {
        throw Exception('No internet connection');
      }
    } on SocketException catch (e) {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('No internet connection');
    }
  }
}
