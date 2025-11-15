import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import 'home_view.dart';
class LoginView extends StatelessWidget {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LoginViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: 40),

              /// Title
              Text(
                "Welcome Back\nUTH Carrental",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 12),

              Text(
                "Login to continue using the app",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: 40),

              /// Email
              _inputField("Email", "Nhập email", emailController),

              SizedBox(height: 12),

              /// Password
              _inputField("Mật khẩu", "Nhập mật khẩu", passController, isPass: true),

              SizedBox(height: 15),

              /// Error Message
              if (vm.errorMessage != null)
                Text(
                  vm.errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),

              SizedBox(height: 20),

              /// Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: vm.isLoading
                      ? null
                      : () async {
                    bool ok = await vm.login(
                      emailController.text.trim(),
                      passController.text.trim(),
                    );

                    if (ok) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => HomeView()),
                      );
                    }

                  },
                  child: vm.isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Đăng nhập"),
                ),
              ),

              SizedBox(height: 30),

              /// Link to Register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Chưa có tài khoản? "),
                  GestureDetector(
                    child: Text(
                      "Đăng ký",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/register");
                    },
                  ),
                ],
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(
      String label,
      String hint,
      TextEditingController controller,
      {bool isPass = false}
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: isPass,
          decoration: InputDecoration(
            hintText: hint,
            fillColor: Colors.grey.shade100,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
