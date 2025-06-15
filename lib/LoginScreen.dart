// LoginScreen.dart
import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';
import 'EmailSmtp.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  final db = DatabaseHelper();

  void login() async {
    final user = await db.getUserByEmailAndPassword(
      emailController.text,
      passController.text,
    );



    if (user != null) {
      await senEmailNotify(user['email']);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đăng nhập thành công. Xin chào ${user['name']}!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sai email hoặc mật khẩu')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng nhập')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Mật khẩu'),
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: login, child: Text('Đăng nhập')),

            // 🔽 Nút điều hướng sang Quên mật khẩu
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/forgot');
              },
              child: Text('Quên mật khẩu?'),
            ),

            // 🔽 Nút điều hướng sang Đăng ký
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Chưa có tài khoản? Đăng ký'),
            ),
          ],
        ),
      ),
    );
  }
}
