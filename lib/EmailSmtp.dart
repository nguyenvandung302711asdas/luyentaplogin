import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> sendEmail(String toEmail, String newPassword) async {
  final smtpServer = gmail('nguyenvandung30271@gmail.com', 'zxmbfyayryyqitte');

  final message =
      Message()
        ..from = Address('nguyenvandung30271@gmail.com', 'App Support')
        ..recipients.add(toEmail)
        ..subject = 'Mật khẩu mới của bạn'
        ..text = 'Mật khẩu mới của bạn là: $newPassword';

  try {
    final sendReport = await send(message, smtpServer);
    print('Email sent: ' + sendReport.toString());
  } catch (e) {
    print('Email send failed: $e');
  }
}

Future<void> senEmailNotify(String toEmail) async {
  //cau hinh email
  final smtpServer = gmail('nguyenvandung30271@gmail.com', 'zxmbfyayryyqitte');
  final message = Message()
  ..from = Address('nguyenvandung30271@gmail.com','App Support')
  ..recipients.add(toEmail)
  ..subject = 'Thông báo đăng nhập'
  ..text = 'Bạn đã đăng nhập thành công';
  try{
    final sendReport = await send(message, smtpServer);
    print('Email sent: ' + sendReport.toString());
  }catch(e){
    print('Email send failed: $e');
  }
}
