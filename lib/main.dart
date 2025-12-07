import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:audit_cloud_app/screens/login/login_screen.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/data/providers/auth_provider.dart';
import 'package:audit_cloud_app/data/providers/auditor_provider.dart';
import 'package:audit_cloud_app/data/providers/supervisor_provider.dart';
import 'package:audit_cloud_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('[Main] Inicializando Firebase...');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('[Main] Firebase inicializado correctamente');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AuditorProvider()),
        ChangeNotifierProvider(create: (_) => SupervisorProvider()),
        // TODO: Agregar ClienteProvider
      ],
      child: MaterialApp(
        title: 'Audit Cloud App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(AppColors.primaryGreen),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: Color(AppColors.backgroundColor),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
