import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Cubit/auth_cubit.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 120),

              // eFinder logo with fade-in effect
              FadeInUp(
                duration: Duration(milliseconds: 1000),
                child:
                Image.asset('assets/images/efinder_logo.png',
                    width: 200),
              ),
              SizedBox(height: 30),

              // Email input field
              FadeInUp(
                duration: Duration(milliseconds: 1200),
                child: _buildTextField(
                  'Email',
                  TextInputType.emailAddress,
                  controller: _emailController,
                ),
              ),

              // Password input field
              FadeInUp(
                duration: Duration(milliseconds: 1300),
                child: _buildTextField(
                  'Password',
                  TextInputType.text,
                  obscureText: true,
                  controller: _passwordController,
                ),
              ),

              SizedBox(height: 20),

              // Login button with a styled MaterialButton
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    Navigator.pushReplacementNamed(context, '/HumanListScreen');
                  }
                  if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return CircularProgressIndicator();
                  }
                  return FadeInUp(
                    duration: Duration(milliseconds: 1400),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      child: MaterialButton(
                        onPressed: () {
                          print('Email: ${_emailController.text}, Password: ${_passwordController.text}');
                          BlocProvider.of<AuthCubit>(context).login(
                            _emailController.text,
                            _passwordController.text,
                          );
                        },
                        color: Color(0xff3A405A),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 20),

              // Sign up prompt with text styling
              FadeInUp(
                duration: Duration(milliseconds: 1500),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/register');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don’t have an account? "),
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextInputType inputType, {bool obscureText = false, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: inputType,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
