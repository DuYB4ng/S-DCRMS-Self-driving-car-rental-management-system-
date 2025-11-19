import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/register_viewmodel.dart';

class RegisterView extends StatelessWidget {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passController = TextEditingController();
  final rePassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RegisterViewModel>(context);

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
                    height: 120,  // giảm 1 chút để nhìn gọn hơn
                  ),
                ),
              ),


              SizedBox(height: 18),

              Text(
                "Đăng Ký Và Bắt Đầu \n Một Hành Trình Tươi Đẹp ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: 30),

              /// Email
              _inputField("Email", "Nhập email", emailController),

              SizedBox(height: 12),

              /// Phone
              _inputField("Số điện thoại", "Nhập số điện thoại", phoneController),

              SizedBox(height: 12),

              /// Password
              _inputField("Nhập mật khẩu", "Nhập mật khẩu", passController, isPass: true),

              SizedBox(height: 12),

              /// Re-enter password
              _inputField("Nhập lại mật khẩu", "Nhập lại mật khẩu", rePassController, isPass: true),

              SizedBox(height: 20),

              /// Error Message
              if (vm.errorMessage != null)
                Text(
                  vm.errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),

              SizedBox(height: 20),

              /// Button
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
                      : () => vm.register(
                    emailController.text.trim(),
                    phoneController.text.trim(),
                    passController.text.trim(),
                    rePassController.text.trim(),
                  ),
                  child: vm.isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Đăng ký",
                    style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),),
                ),
              ),

              SizedBox(height: 30),

              /// Sign in link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Đã có tài khoản  "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: Text(
                      "Đăng Nhập",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

  /// Custom input widget
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
