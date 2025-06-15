import 'dart:math';
import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';
import 'EmailSmtp.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final db = DatabaseHelper();

  String generatePassword() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(8, (index) => chars[Random().nextInt(chars.length)]).join();
  }

  void resetPassword() async {
    final email = emailController.text;
    final user = await db.getUserByEmail(email);

    if (user != null) {
      final newPass = generatePassword();
      await db.updatePassword(email, newPass);
      await sendEmail(email, newPass);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Đã gửi mật khẩu mới về email'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Không tìm thấy email'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quen mat khau'),),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1F3C88), Color(0xFF1F3C88)],
                  ),
                ),
                child: Column(
                  children: [
                    Image.asset('assets/logoo.png', height: 80), // 🔄 đổi path ảnh nếu cần
                    const SizedBox(height: 12),
                    const Text(
                      'Chào mừng trở lại',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    const Text(
                      'Đăng nhập vào tài khoản của bạn',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Hướng dẫn
              Container(
                padding: const EdgeInsets.all(12),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [

                    Icon(Icons.info, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(

                        'Nhập địa chỉ email đã đăng ký để nhận liên kết đặt lại mật khẩu. Kiểm tra cả hộp thư rác nếu không thấy email.',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Email input
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Địa chỉ email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: Icon(Icons.email),
                ),
              ),

              const SizedBox(height: 20),

              // Nút gửi
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: resetPassword,
                  icon: Icon(Icons.send),
                  label: Text('Gửi liên kết đặt lại'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Quay lại đăng nhập
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  '← Quay lại đăng nhập',
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Vẫn gặp vấn đề? Liên hệ hỗ trợ',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
