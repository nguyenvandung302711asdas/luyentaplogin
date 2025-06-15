// RegisterScreen.dart
import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passController = TextEditingController();

  final db = DatabaseHelper();

  void register() async {
    final email = emailController.text;
    final name = nameController.text;
    final pass = passController.text;

    await db.insertUser(email, name, pass);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Đăng ký thành công')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng ký')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Tên'),
            ),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Mật khẩu'),
            ),
            ElevatedButton(onPressed: register, child: Text('Đăng ký')),
          ],
        ),
      ),
    );
  }
}
