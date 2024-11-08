import 'package:api_efinder/Models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Services/api_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final ApiService apiService;

  AuthCubit(this.apiService) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final response = await apiService.login(email, password);
      print('API Response: $response');

      if (response['status'] == 'success' && response['user'] != null) {
        final userData = response['user'];
        if (userData != null) {
          // Now we safely parse the user data
          emit(AuthSuccess(User.fromJson(userData)));
        } else {
          // Handle the case where user data is still null, even if status is success
          emit(AuthFailure("User data is missing"));
        }
      } else {
        // If the status is not 'success', show an error
        emit(AuthFailure(response['message'] ?? "Unknown error"));
      }
    } catch (e) {
      print('Error occurred: $e');
      emit(AuthFailure("An error occurred"));
    }
  }

  Future<void> signup(String name, String phone, String email, String password) async {
    emit(AuthLoading());
    try {
      final response = await apiService.signup(name, phone, email, password);
      print(response); // Print to inspect the API response
      if (response['message'] == 'User registered successfully') {
        emit(AuthSignupSuccess());  // Emit success if message matches
      } else {
        emit(AuthFailure(response['message']));
      }
    } catch (e) {
      emit(AuthFailure("An error occurred"));
    }
  }
}

// Define the AuthState classes
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  AuthSuccess(this.user);
}

class AuthSignupSuccess extends AuthState {}  // New state for successful signup

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}
