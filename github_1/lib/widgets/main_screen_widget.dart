import 'package:ciempresas/core/i18n/app_localizations_extension.dart';
import 'package:ciempresas/core/restFull/rest_manager_v2.dart';
import 'package:ciempresas/core/theme/app_theme.dart';
import 'package:ciempresas/core/utils/secure_storage_service.dart';
import 'package:ciempresas/features/home/providers/main_screen_provider.dart';
import 'package:ciempresas/features/home/services/main_screen_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreenWidget extends StatelessWidget {
  final String userName;
  final Function(String)? onError;
  final VoidCallback? onLogoutSuccess;
  const MainScreenWidget({
    super.key,
    required this.userName,
    this.onError,
    this.onLogoutSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainScreenProvider(
        MainScreenServiceImpl(RestManagerV2()),
        SecureStorageService(),
      ),
      child: Consumer<MainScreenProvider>(
        builder: (context, provider, _) => _buildContent(context, provider),
      ),
    );
  }

  Widget _buildContent(BuildContext context, MainScreenProvider provider) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: context.theme.appColors.background,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 0.0, 12.0),
            child: Image.asset(
              'assets/images/iconUser.png',
              fit: BoxFit.contain,
            ),
          ),
          title: Text(userName),
          backgroundColor: context.theme.appColors.background,
          foregroundColor: context.theme.appColors.onBackground,
        ),
        endDrawer: MenuDrawer(
          provider: provider,
          onError: onError,
          onLogoutSuccess: onLogoutSuccess,
        ),
        body: const Center(
          child: Image(
            image: AssetImage('assets/images/llave.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class MenuDrawer extends StatelessWidget {
  final MainScreenProvider provider;
  final Function(String)? onError;
  final VoidCallback? onLogoutSuccess;
  const MenuDrawer({
    super.key,
    required this.provider,
    this.onError,
    this.onLogoutSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: context.theme.appColors.background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              color: context.theme.appColors.customGreen,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/logo_ciempresa.png',
                      height: 30,
                      width: 30,
                    ),
                    SizedBox(width: 10),
                    Text(
                      context.tr('organization'),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.lock,
              color: context.theme.appColors.onBackground,
            ),
            title: Text(
              context.tr('change_password_title'),
              style: context.theme.appTextTheme.menuoption,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/change-password');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.lock,
              color: context.theme.appColors.onBackground,
            ),
            title: Text(
              context.tr('change_email_title'),
              style: context.theme.appTextTheme.menuoption,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/change-email');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: context.theme.appColors.onBackground,
            ),
            title: Text('Logout', style: context.theme.appTextTheme.menuoption),
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    final success = await provider.logout();

    if (success) {
      if (onLogoutSuccess != null) {
        onLogoutSuccess!();
      }
    } else {
      if (onError != null) {
        onError!(provider.errorMessage);
      }
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.theme.appColors.background,
        title: Text('Logout', style: context.theme.appTextTheme.cardTitle),
        content: Text(
          '¿Estás seguro que deseas cerrar sesión?',
          style: context.theme.appTextTheme.cardSubtitle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: context.theme.appTextTheme.title3),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              logout();
            },
            child: Text('Confirmar', style: context.theme.appTextTheme.title3),
          ),
        ],
      ),
    );
  }
}
