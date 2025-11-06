import 'package:ciempresas/core/i18n/app_localizations_extension.dart';
import 'package:ciempresas/core/theme/app_theme.dart';
import 'package:ciempresas/routing/app_routes.dart';
import 'package:ciempresas/widgets/forms/custom_text_form_field.dart';
import 'package:ciempresas/widgets/layout/centered_content_with_buttons.dart';
import 'package:flutter/material.dart';

class LegalRepresentativeScreen extends StatefulWidget {
  const LegalRepresentativeScreen({super.key});

  @override
  State<LegalRepresentativeScreen> createState() =>
      _LegalRepresentativeScreenState();
}

class _LegalRepresentativeScreenState extends State<LegalRepresentativeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _motherLastNameController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  List<String> _legalRepresentativeData = [];

  @override
  void initState() {
    super.initState();
    _loadLegalRepresentativeData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _motherLastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Simula una llamada a API que retorna datos del representante legal
  Future<List<String>> _fetchLegalRepresentativeDataFromAPI() async {
    // Datos ficticios que simularían venir de la API
    return [
      "Carlos", // nombre
      "Perez", // apellido paterno
      "González", // apellido materno
      "perez@empresa.com", // email
      "1234567890", // teléfono
    ];
  }

  // Carga los datos de la API y los asigna a los controladores
  Future<void> _loadLegalRepresentativeData() async {
    try {
      final data = await _fetchLegalRepresentativeDataFromAPI();

      setState(() {
        _legalRepresentativeData = data;
      });

      // Asignar los datos a los controladores correspondientes
      if (_legalRepresentativeData.length >= 5) {
        _nameController.text = _legalRepresentativeData[0];
        _lastNameController.text = _legalRepresentativeData[1];
        _motherLastNameController.text = _legalRepresentativeData[2];
        _emailController.text = _legalRepresentativeData[3];
        _phoneController.text = _legalRepresentativeData[4];
      }
    } catch (e) {
      setState(() {});
      // Manejar error de API aquí
      debugPrint('Error cargando datos del representante legal: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget formContent = Card(
      color: context.theme.appColors.background,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('legal_representative_title'),
              style: context.theme.appTextTheme.cardTitle,
            ),
            SizedBox(height: 8),
            Text(
              context.tr('legal_representative_description'),
              style: context.theme.appTextTheme.cardSubtitle,
            ),
            SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    labelText: context.tr('name_label'),
                    controller: _nameController,
                    enabled: false, // Campo no editable
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    labelText: context.tr('paternal_surname_label'),
                    controller: _lastNameController,
                    enabled: false, // Campo no editable
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    labelText: context.tr('maternal_surname_label'),
                    controller: _motherLastNameController,
                    enabled: false, // Campo no editable
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    labelText: context.tr('email_label'),
                    controller: _emailController,
                    enabled: false, // Campo no editable
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    labelText: context.tr('phone_label'),
                    controller: _phoneController,
                    enabled: false, // Campo no editable
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return CenteredContentWithButtons(
      appBarImagePath: 'assets/images/progress_four.png',
      content: formContent,
      primaryButtonText: context.tr('continue'),
      secondaryButtonText: context.tr('cancel'),
      onPrimaryButtonPressed: () async {
        Navigator.of(context).pushNamed(AppRoute.credentialSetupScreen.path);
      },
      onSecondaryButtonPressed: () {
        //FocusScope.of(context).unfocus();
        Navigator.pop(context);
      },
    );
  }
}
