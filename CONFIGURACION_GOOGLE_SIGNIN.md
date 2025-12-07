# Configuración de Google Sign-In para obtener idToken

## ✅ CONFIGURADO CORRECTAMENTE

El Google Sign-In ya está configurado con el Web Client ID:
- **Web Client ID**: `417831327586-01dvdhj92iao6kgcfpkp20dkiseiv4bq.apps.googleusercontent.com`
- **Archivo**: `google-services.json` actualizado con client_type: 3
- **Código**: `auth_repository.dart` configurado con serverClientId

---

## Verificación de Login

Después de ejecutar `flutter clean && flutter pub get && flutter run`, deberías ver estos logs al hacer login con Google:

```
[AuthRepository] Iniciando Google Sign-In...
[AuthRepository] Usuario de Google obtenido: tu-email@gmail.com
[AuthRepository] Obteniendo GoogleSignInAuthentication...
[AuthRepository] GoogleSignInAuthentication obtenido
[AuthRepository] accessToken presente: true
[AuthRepository] idToken presente: true  ← AHORA DEBE SER TRUE
[AuthRepository] idToken obtenido exitosamente, autenticando con backend...
[ApiService] POST http://10.0.2.2:3000/api/auth/google
[ApiService] Response status: 200
[AuthRepository] ✅ Login con Google exitoso
[LoginScreen] Navegando a HomeScreen...
```

---

## Problema Original (Ya Resuelto)

### Paso 1: Obtener el Web Client ID

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto: `auditcloud-45700`
3. Ve a **Project Settings** (⚙️ > Project settings)
4. En la pestaña **General**, baja hasta la sección **Your apps**
5. Busca la aplicación Web (icono `</>`). Si no existe, créala:
   - Click en "Add app" > Web (`</>`)
   - Nombre: `AuditCloud Web` (o cualquier nombre)
   - **NO** marques "Set up Firebase Hosting"
   - Click en "Register app"

6. Una vez creada la app Web, verás el **Web Client ID** en:
   - Firebase Console > Project Settings > General > Web app > Web client ID
   
   O también puedes encontrarlo en:
   
7. [Google Cloud Console](https://console.cloud.google.com/)
   - Selecciona el proyecto
   - Ve a **APIs & Services** > **Credentials**
   - Busca el OAuth 2.0 Client ID de tipo "Web application"
   - El Client ID tiene el formato: `417831327586-XXXXXXXXXXXX.apps.googleusercontent.com`

### Paso 2: Configurar en el código

Edita el archivo `lib/data/repositories/auth_repository.dart`:

```dart
final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile'],
  serverClientId: 'TU_WEB_CLIENT_ID_AQUI.apps.googleusercontent.com', // ← Pega aquí tu Web Client ID
);
```

**Ejemplo:**
```dart
final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile'],
  serverClientId: '417831327586-abc123def456.apps.googleusercontent.com',
);
```

### Paso 3: Actualizar google-services.json (Opcional pero recomendado)

Si quieres que el archivo `google-services.json` tenga el Web Client ID, descarga la versión actualizada:

1. En Firebase Console > Project Settings
2. Scroll down hasta "Your apps"
3. En la app Android, click en el icono de download (google-services.json)
4. Reemplaza el archivo en: `android/app/google-services.json`

### Paso 4: Rebuild y probar

```bash
flutter clean
flutter pub get
flutter run
```

## Verificación

Una vez configurado, deberías ver estos logs al hacer login con Google:

```
[AuthRepository] Iniciando Google Sign-In...
[AuthRepository] Usuario de Google obtenido: tu-email@gmail.com
[AuthRepository] Obteniendo GoogleSignInAuthentication...
[AuthRepository] GoogleSignInAuthentication obtenido
[AuthRepository] accessToken presente: true
[AuthRepository] idToken presente: true  ← ESTO DEBE SER TRUE
[AuthRepository] idToken obtenido exitosamente, autenticando con backend...
[AuthRepository] ✅ Login con Google exitoso
```

## Notas Adicionales

### ¿Por qué necesitamos el Web Client ID?

- El `idToken` JWT es necesario para autenticar con el backend
- Solo se genera cuando configuras el `serverClientId` en GoogleSignIn
- El backend usa este token para verificar la identidad del usuario con Google OAuth2

### Diferencia entre Client IDs

- **Android Client ID**: Permite login básico de Google en Android
- **Web Client ID**: Permite obtener el `idToken` JWT necesario para el backend

### Alternativa: Usar accessToken (NO RECOMENDADO)

Si no puedes obtener el Web Client ID, podrías modificar el backend para aceptar `accessToken` en lugar de `idToken`, pero **NO es recomendado** porque:
- Es menos seguro
- No sigue las mejores prácticas de OAuth2
- El `idToken` es estándar para autenticación

## Documentación Oficial

- [Google Sign-In for Flutter](https://pub.dev/packages/google_sign_in)
- [Firebase Authentication](https://firebase.google.com/docs/auth/android/google-signin)
- [OAuth 2.0 Client IDs](https://developers.google.com/identity/protocols/oauth2)
