import 'package:ciempresas/core/utils/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/main_screen_widget.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  void _handleError(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $error'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      ),
    );
  }

  void _handleLogoutSuccess(BuildContext context) {
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final storageService = context.read<SecureStorageService>();
    return FutureBuilder<String?>(
      future: storageService.readString('username'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MainScreenWidget(
            userName: 'Cargando...',
            onError: (error) => _handleError(context, error),
            onLogoutSuccess: () => _handleLogoutSuccess(context),
          );
        }
        final userName = snapshot.data ?? 'Usuario';
        return MainScreenWidget(
          userName: userName,
          onError: (error) => _handleError(context, error),
          onLogoutSuccess: () => _handleLogoutSuccess(context),
        );
      },
    );
  }
}
