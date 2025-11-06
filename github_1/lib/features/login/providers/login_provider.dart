import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  bool get rememberMe => _rememberMe;
  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _isLoading;

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> login() async {
    if (!formKey.currentState!.validate()) return false;
    
    setLoading(true);
    
    // Simulación de login
    await Future.delayed(const Duration(seconds: 2));
    
    setLoading(false);
    return true;
  }

  void clearForm() {
    usernameController.clear();
    passwordController.clear();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}