import 'package:flutter/material.dart';
import 'package:luyenthi/EmailSmtp.dart';
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
  final phoneController = TextEditingController();
  final dateController = TextEditingController();
  final sexController = TextEditingController();
  final confirmPassController = TextEditingController();
  final db = DatabaseHelper();

  bool acceptTerms = false;
  bool hidePass = true;
  bool hideConfirm = true;

  void register() async {
    final email = emailController.text.trim();
    final name = nameController.text.trim();
    final pass = passController.text;
    final confirmPass = confirmPassController.text;
    final phone = phoneController.text.trim();
    final date = dateController.text.trim();
    final sex = sexController.text.trim();

    // Validate rỗng
    if ([
      email,
      name,
      pass,
      confirmPass,
      phone,
      date,
      sex,
    ].any((e) => e.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng điền đầy đủ thông tin.')),
      );
      return;
    }

    // Validate định dạng email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Email không hợp lệ.')));
      return;
    }

    // Validate độ dài mật khẩu
    if (pass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mật khẩu phải có ít nhất 6 ký tự.')),
      );
      return;
    }

    // Kiểm tra khớp mật khẩu
    if (pass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mật khẩu và xác nhận mật khẩu không khớp.')),
      );
      return;
    }

    // Validate số điện thoại (10 chữ số)
    final phoneRegex = RegExp(r'^\d{10}$');
    if (!phoneRegex.hasMatch(phone)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Số điện thoại không hợp lệ.')));
      return;
    }

    // Validate ngày (dd/mm/yyyy)
    final dateRegex = RegExp(r'^([0-2]\d|3[01])/([0]\d|1[0-2])/\d{4}$');
    if (!dateRegex.hasMatch(date)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ngày không hợp lệ. Định dạng: dd/mm/yyyy')),
      );
      return;
    }

    // Kiểm tra giới tính hợp lệ
    if (!(sex.toLowerCase() == 'nam' || sex.toLowerCase() == 'nữ')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giới tính phải là "Nam" hoặc "Nữ".')),
      );
      return;
    }

    // Kiểm tra đồng ý điều khoản
    if (!acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bạn phải đồng ý với điều khoản sử dụng.')),
      );
      return;
    }

    // Lưu dữ liệu vào database
    await db.insertUser(email, name, pass, sex, phone, date);
    senEmailNotify_Register(email);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Đăng ký thành công')));

    // Xoá nội dung form
    emailController.clear();
    nameController.clear();
    passController.clear();
    confirmPassController.clear();
    phoneController.clear();
    dateController.clear();
    sexController.clear();
    setState(() {
      acceptTerms = false;
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final formattedDate =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      dateController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký')),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                    Image.asset('assets/logoo.png', height: 80),
                    // 🔄 đổi path ảnh nếu cần
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
              const SizedBox(height: 20),

              // Họ và tên
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Họ và tên',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Email
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Số điện thoại
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  hintText: 'Số điện thoại',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Ngày sinh
              TextField(
                controller: dateController,
                readOnly: true,
                onTap: _selectDate,
                decoration: InputDecoration(
                  hintText: 'dd/mm/yyyy',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Giới tính
              TextField(
                controller: sexController,
                decoration: InputDecoration(
                  hintText: 'Chọn giới tính',
                  prefixIcon: Icon(Icons.wc),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Mật khẩu
              TextField(
                controller: passController,
                obscureText: hidePass,
                decoration: InputDecoration(
                  hintText: 'Mật khẩu',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePass ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => hidePass = !hidePass),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Gõ mạnh mật khẩu',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 12),

              // Xác nhận mật khẩu
              TextField(
                controller: confirmPassController,
                obscureText: hideConfirm,
                decoration: InputDecoration(
                  hintText: 'Xác nhận mật khẩu',
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      hideConfirm ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => hideConfirm = !hideConfirm),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Đồng ý điều khoản
              Row(
                children: [
                  Checkbox(
                    value: acceptTerms,
                    onChanged: (val) => setState(() => acceptTerms = val!),
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'Tôi đồng ý với ',
                        children: [
                          TextSpan(
                            text: 'Điều khoản sử dụng',
                            style: TextStyle(color: Colors.blue),
                          ),
                          TextSpan(text: ' và '),
                          TextSpan(
                            text: 'Chính sách bảo mật',
                            style: TextStyle(color: Colors.blue),
                          ),
                          TextSpan(text: ' của UTC2'),
                        ],
                      ),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Nút Đăng ký
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(

                  onPressed: acceptTerms ? register : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Đăng ký tài khoản'),
                ),
              ),

              const SizedBox(height: 16),
              const Text('hoặc'),
              const SizedBox(height: 8),

              // Nút đăng nhập ngay
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.login),
                label: const Text('Đăng nhập ngay'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
