// ForgotPasswordScreen.dart
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
    return List.generate(8, (index) => chars[Random().nextInt(chars.length)])
        .join();
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
        appBar: AppBar(title: Text('Quên mật khẩu')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            ElevatedButton(onPressed: resetPassword, child: Text('Gửi mật khẩu mới'))
          ]),
        ));
  }
}
