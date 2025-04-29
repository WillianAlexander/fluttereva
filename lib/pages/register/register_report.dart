import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttereva/pages/informe/form_page.dart';
import 'package:fluttereva/pages/main_page.dart';
import 'package:fluttereva/provider/evento/evento.provider.dart';
import 'package:fluttereva/provider/usuario/user.provider.dart';
import 'package:fluttereva/services/user_service.dart';
import 'package:provider/provider.dart';

class RegisterReport extends StatefulWidget {
  final User? user;
  const RegisterReport({super.key, this.user});

  @override
  State<RegisterReport> createState() => _RegisterReportState();
}

class _RegisterReportState extends State<RegisterReport> {
  // Estado para controlar la vista seleccionada
  // String _selectedOption = 'home';
  // bool _showInformesSubOptions =
  //     false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: SafeArea(
          child: Center(
            child: Transform.scale(
              alignment: Alignment.center,
              scale: 1,
              child: Image.asset('assets/LOGOTIPO-BLANCO-HORIZONTAL.png'),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: theme.primary),
          ),
          RefreshIndicator(
            onRefresh: () async {
              final usuarioProvider = Provider.of<UsuarioProvider>(
                context,
                listen: false,
              );
              final userService = UserService();
              if (usuarioProvider.usuario != null) {
                final nuevoUsuario = await userService.getUserData(
                  usuarioProvider.usuario!.usuario,
                );
                if (nuevoUsuario != null) {
                  usuarioProvider.setUsuario(nuevoUsuario);
                }
              }
              if (context.mounted) {
                await Provider.of<EventoProvider>(
                  context,
                  listen: false,
                ).fetchActiveEvent();
              }
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: theme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(51),
                    spreadRadius: 4,
                    blurRadius: 25,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.of(context).size.height -
                        kToolbarHeight - // Si tienes AppBar, réstalo
                        MediaQuery.of(context).padding.top,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: const MainPage(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({super.key, required this.theme});

  final ColorScheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      color: theme.primary, // Color de fondo
      child: Center(
        child: Transform.scale(
          alignment: Alignment.center,
          scale: 0.8,
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }
}
