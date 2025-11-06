# Configuración de Entornos

## Archivos de configuración creados:

- `.env.dev` - Desarrollo
- `.env.qa` - QA/Testing  
- `.env.prod` - Producción

## Uso:

### Desde VS Code:
1. Presiona F5 o Ctrl+F5
2. Selecciona el entorno: Development, QA o Production

### Desde terminal:
```bash
# Desarrollo
flutter run --dart-define=BASE_URL=https://apidev.cibanco.com --dart-define=BASIC_AUTH=ZGV2X2NsaWVudF9pZDpkZXZfc2VjcmV0X2tleQ== --dart-define=ENVIRONMENT=development

# QA
flutter run --dart-define=BASE_URL=https://apiqa.cibanco.com --dart-define=BASIC_AUTH=UnNQVGZzd2NOY3dQOVZLQVBRWW82OTB2SElya2pyejJ4SVRYNGxwaGs0NUhwMWx0OmFPeHRkUk9vN2llcUlWeFI3SndlaHpLc1d5Rk1rMXRhY3V6Y212R3BudVZBZlo4NjViV3dDYWZsVEVHeUczeWQ= --dart-define=ENVIRONMENT=qa

# Producción
flutter run --dart-define=BASE_URL=https://api.cibanco.com --dart-define=BASIC_AUTH=cHJvZF9jbGllbnRfaWQ6cHJvZF9zZWNyZXRfa2V5 --dart-define=ENVIRONMENT=production
```

### Para builds:
```bash
# Build para producción
flutter build apk --dart-define=BASE_URL=https://api.cibanco.com --dart-define=BASIC_AUTH=cHJvZF9jbGllbnRfaWQ6cHJvZF9zZWNyZXRfa2V5 --dart-define=ENVIRONMENT=production
```

## Seguridad:
- Los archivos `.env.*` están en `.gitignore`
- Las URLs y tokens no están hardcodeados en el código
- Cada entorno tiene sus propias credenciales