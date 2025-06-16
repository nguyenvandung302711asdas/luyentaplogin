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
        SnackBar(content: Text('Đăng nhập thành công. Xin chào ${user['name']}!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sai email hoặc mật khẩu')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔷 Logo + Chào mừng
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

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // 🔶 Email
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🔶 Password
                  TextField(
                    controller: passController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Mật khẩu',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔷 Đăng nhập
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: login,
                      icon: const Icon(Icons.login),
                      label: const Text('Đăng nhập'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF8800),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),

                  // 🔷 Quên mật khẩu
                  TextButton.icon(
                    icon: const Icon(Icons.key),
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgot');
                    },
                    label: const Text('Quên mật khẩu?'),
                  ),

                  const Text("hoặc"),

                  // 🔷 Đăng ký
                  OutlinedButton.icon(
                    icon: const Icon(Icons.person_add),
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    label: const Text('Đăng ký ngay'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // bo vuông
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
