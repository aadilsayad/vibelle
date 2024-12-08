import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fpdart/fpdart.dart';

class AuthRemoteRepository {
  Future<Either<String, Map<String, dynamic>>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        // 10.0.2.2 = Android emulator's way of getting the host machine's localhost IP
        Uri.parse('http://10.0.2.2:8000/auth/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'name': name,
            'email': email,
            'password': password,
          },
        ),
      );
      if (response.statusCode != 201) {
        return Left(response.body);
      }

      final createdUser = jsonDecode(response.body);
      return Right(createdUser);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'email': email,
            'password': password,
          },
        ),
      );
      print(response.statusCode);
      print(response.body);
    } catch (e) {
      print(e);
    }
  }
}
