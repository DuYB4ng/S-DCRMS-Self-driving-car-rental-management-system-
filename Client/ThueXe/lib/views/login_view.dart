import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import 'home/home_navigation.dart';   // THÊM DÒNG NÀY !!

class LoginView extends StatelessWidget {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  LoginView({super.key});

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

              // LOGO
              Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 120,
                  ),
                ),
              ),

              SizedBox(height: 12),

              Text(
                "Đăng nhập để bắt đầu những chuyến đi dài",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),

              SizedBox(height: 40),

              /// Email
              _inputField("Email", "Nhập email", emailController),

              SizedBox(height: 12),

              /// Password
              _inputField("Mật khẩu", "Nhập mật khẩu", passController, isPass: true),

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
                    vm.setLoading(true);

                    // LẤY GIÁ TRỊ ĐÚNG
                    String email = emailController.text.trim();
                    String password = passController.text.trim();

                    bool result = await vm.login(email, password);

                    vm.setLoading(false);

                    if (result) {
                      if (vm.role == "OwnerCar") {
                        Navigator.pushReplacementNamed(context, "/owner-home");
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => HomeNavigation()),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Sai tài khoản hoặc mật khẩu")),
                      );
                    }
                  },
                  child: vm.isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Đăng nhập",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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

  Widget _inputField(String label, String hint, TextEditingController controller,
      {bool isPass = false}) {
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
