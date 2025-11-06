import 'package:ciempresas/core/i18n/app_localizations_extension.dart';
import 'package:ciempresas/core/theme/app_theme.dart';
import 'package:ciempresas/features/affiliation/providers/company_details_provider.dart';
import 'package:ciempresas/features/affiliation/services/client_service.dart';
import 'package:ciempresas/routing/app_routes.dart';
import 'package:ciempresas/widgets/forms/custom_text_form_field.dart';
import 'package:ciempresas/widgets/layout/centered_content_with_buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompanyDetailsScreen extends StatefulWidget {
  const CompanyDetailsScreen({super.key});

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  final _companyNameController = TextEditingController();
  final _rfcController = TextEditingController();

  @override
  void dispose() {
    _companyNameController.dispose();
    _rfcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          CompanyDetailsProvider(context.read<ClientService>())
            ..loadClientData(),
      child: Consumer<CompanyDetailsProvider>(
        builder: (context, provider, _) {
          // Update controllers when data is loaded
          if (provider.state == CompanyDetailsState.success) {
            _companyNameController.text = provider.clientName;
            _rfcController.text = provider.clientRFC;
          }

          Widget formContent = Card(
            color: context.theme.appColors.background,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('company_details_title'),
                    style: context.theme.appTextTheme.cardTitle,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.tr('company_details_description'),
                    style: context.theme.appTextTheme.cardSubtitle,
                  ),
                  const SizedBox(height: 24),
                  if (provider.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (provider.hasError) ...[
                    Text(
                      provider.errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                  ],
                  CustomTextFormField(
                    labelText: context.tr('company_name_label'),
                    controller: _companyNameController,
                    enabled: !provider.isLoading,
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    labelText: context.tr('rfc_label'),
                    controller: _rfcController,
                    enabled: !provider.isLoading,
                  ),
                ],
              ),
            ),
          );

          return CenteredContentWithButtons(
            appBarImagePath: 'assets/images/progress_three.png',
            content: formContent,
            primaryButtonText: context.tr('continue'),
            secondaryButtonText: context.tr('info_incorrect'),
            onPrimaryButtonPressed: provider.isLoading
                ? null
                : () {
                    Navigator.of(
                      context,
                    ).pushNamed(AppRoute.nipSetupScreen.path);
                  },
            onSecondaryButtonPressed: provider.isLoading
                ? null
                : () {
                    provider.loadClientData();
                  },
          );
        },
      ),
    );
  }
}
