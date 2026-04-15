import 'package:flutter/foundation.dart';
import '../services/payment_service.dart';

class AppStateProvider extends ChangeNotifier {
  bool _isPro = false;
  bool get isPro => _isPro;

  AppStateProvider() {
    _checkProStatus();
  }

  Future<void> _checkProStatus() async {
    _isPro = await PaymentService().isProUser();
    notifyListeners();
  }

  Future<void> upgradeToPro() async {
    await PaymentService().purchasePro();
    _isPro = true;
    notifyListeners();
  }
}
