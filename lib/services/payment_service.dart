import 'package:shared_preferences/shared_preferences.dart';

class PaymentService {
  static const String _isProKey = 'is_pro_user';

  // 检查是否为专业版用户
  Future<bool> isProUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isProKey) ?? false;
  }

  // 模拟购买成功
  Future<void> purchasePro() async {
    // 这里集成真实的 in_app_purchase
    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isProKey, true);
  }

  // 重置用于测试
  Future<void> resetProStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isProKey);
  }
}
