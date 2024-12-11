import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:client/common/constants/server_constants.dart';
import 'package:client/common/failures/app_failure.dart';
import 'package:client/features/auth/model/user.dart';
part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<AppFailure, User>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        // 10.0.2.2 = Android emulator's way of getting the host machine's localhost IP
        Uri.parse('${ServerConstants.serverURL}/auth/signup'),
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

      final responseBodyMap = jsonDecode(response.body);

      if (response.statusCode != 201) {
        return Left(
          AppFailure(
            responseBodyMap['detail'],
          ),
        );
      }

      final User user = User.fromMap(responseBodyMap);
      return Right(user);
    } catch (e) {
      return Left(
        AppFailure(
          e.toString(),
        ),
      );
    }
  }

  Future<Either<AppFailure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstants.serverURL}/auth/login'),
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
      final responseBodyMap = jsonDecode(response.body);
      if (response.statusCode != 200) {
        return Left(
          AppFailure(
            responseBodyMap['detail'],
          ),
        );
      }
      return Right(
        User.fromMap(
          responseBodyMap['user'],
        ).copyWith(
          accessToken: responseBodyMap['access_token'],
        ),
      );
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, User>> fetchUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ServerConstants.serverURL}/auth/'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );
      final responseBodyMap = jsonDecode(response.body);
      if (response.statusCode != 200) {
        return Left(
          AppFailure(
            responseBodyMap['detail'],
          ),
        );
      }
      return Right(
        User.fromMap(
          responseBodyMap,
        ).copyWith(
          accessToken: token,
        ),
      );
    } catch (e) {
      return Left(
        AppFailure(
          e.toString(),
        ),
      );
    }
  }
}
