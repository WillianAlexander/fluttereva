import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttereva/pages/calificar/calificacion.dart';
import 'package:fluttereva/pages/evento/consultar_evento.dart';
import 'package:fluttereva/pages/evento/crear_evento.dart';
import 'package:fluttereva/pages/login/login_page.dart';
import 'package:fluttereva/pages/register/register_page.dart';
import 'package:fluttereva/pages/register/register_report.dart';
import 'package:fluttereva/provider/criterios/criterios.provider.dart';
import 'package:fluttereva/provider/departamento/departamento.provider.dart';
import 'package:fluttereva/provider/evaluacion/evaluacion.provider.dart';
import 'package:fluttereva/provider/evento/evento.provider.dart';
import 'package:fluttereva/provider/top/top.provider.dart';
import 'package:fluttereva/provider/usuario/user.provider.dart';
import 'package:fluttereva/services/user_service.dart';
import 'package:fluttereva/theme/apptheme.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configurar persistencia de sesión como 'none'
  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.NONE);
  } else {
    // await FirebaseAuth.instance.signOut();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsuarioProvider()),
        ChangeNotifierProvider(create: (_) => DepartamentoProvider()),
        ChangeNotifierProvider(create: (_) => EventoProvider()),
        ChangeNotifierProvider(create: (_) => CalificacionProvider()),
        ChangeNotifierProvider(create: (_) => CriteriosProvider()),
        ChangeNotifierProvider(create: (_) => TopProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eva - Cooperativa Gualaquiza',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'), // Español
        Locale('en'), // Inglés (opcional)
      ],
      locale: const Locale('es'), // Establecer español como predeterminado
      theme: AppTheme.light,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData == true) {
            final user = snapshot.data;
            return FutureBuilder<bool>(
              future: UserService().userExists(
                user,
                context,
              ), // Verifica si el usuario ya está registrado
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: const Center(child: CircularProgressIndicator()),
                  );
                } else if (userSnapshot.hasError ||
                    userSnapshot.data == false) {
                  return RegistrationPage(user: user);
                } else {
                  return RegisterReport();
                }
              },
            );
          } else {
            return LoginPage();
          }
        },
      ),
      routes: {
        '/main': (context) => RegisterReport(),
        '/login': (context) => const LoginPage(),
        '/crear_evento': (context) => const CrearEvento(),
        '/consultar_evento': (context) => const ConsultarEvento(),
        '/calificar': (context) => Calificacion(),
      },
    );
  }
}
