# Nueva Arquitectura de Red

Esta carpeta contiene la nueva arquitectura de red para la aplicación, diseñada siguiendo principios SOLID y patrones de diseño como Repository, Strategy y Factory.

## Estructura

```
network/
  ├── api/                  # Clientes API específicos
  │   ├── api_client.dart           # Cliente API base
  │   ├── auth_api_client.dart      # Cliente para autenticación
  │   ├── user_api_client.dart      # Cliente para gestión de usuarios
  │   ├── client_api_client.dart    # Cliente para datos de cliente
  │   └── api_client_factory.dart   # Fábrica para crear clientes
  ├── auth/                 # Gestión de autenticación
  │   └── token_manager.dart        # Gestor de tokens
  ├── config/               # Configuración
  │   └── api_config.dart           # Configuración de APIs
  ├── http/                 # Implementaciones HTTP
  │   ├── http_client.dart          # Interfaz base
  │   └── http_package_client.dart  # Implementación con http package
  ├── models/               # Modelos de datos
  └── network.dart          # Archivo de barril (exports)
```

## Patrones de Diseño Utilizados

1. **Patrón Repository**: Separación de la lógica de acceso a datos en repositorios específicos.
2. **Patrón Strategy**: Diferentes implementaciones de HttpClient.
3. **Patrón Factory**: Creación de instancias de clientes API.
4. **Principio de Responsabilidad Única**: Cada clase tiene una única responsabilidad.
5. **Principio de Inversión de Dependencias**: Las clases dependen de abstracciones.

## Migración desde RestManager

Se ha creado una clase `RestManager()` que utiliza la nueva arquitectura pero mantiene la compatibilidad con el código existente. Esta clase actúa como un adaptador entre el código antiguo y la nueva arquitectura.

Para migrar gradualmente:

1. Reemplazar las importaciones de `RestManager` por `RestManager()`.
2. Verificar que todas las funcionalidades sigan funcionando.
3. Gradualmente, migrar el código para utilizar directamente los nuevos clientes API.

## Ventajas de la Nueva Arquitectura

- **Testabilidad**: Facilita la creación de mocks para pruebas unitarias.
- **Mantenibilidad**: Código más organizado y con responsabilidades claras.
- **Escalabilidad**: Fácil añadir nuevos servicios o cambiar implementaciones.
- **Flexibilidad**: Permite cambiar la implementación HTTP sin afectar el resto del código.

## Ejemplo de Uso

```dart
// Crear un cliente API para autenticación
final authClient = ApiClientFactory.createAuthApiClient();

// Realizar login
final result = await authClient.login(
  username: 'usuario',
  password: 'contraseña',
  token: 'token',
  ip: '127.0.0.1',
  channel: 'mobile',
);

// Procesar resultado
if (result is Success) {
  print('Login exitoso: ${result.value}');
} else {
  print('Error en login: ${(result as Failure).exception}');
}
```