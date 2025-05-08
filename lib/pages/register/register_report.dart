import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttereva/pages/main_page.dart';
import 'package:fluttereva/provider/departamento/departamento.provider.dart';
import 'package:fluttereva/provider/evento/evento.provider.dart';
import 'package:fluttereva/provider/top/top.provider.dart';
import 'package:fluttereva/provider/usuario/user.provider.dart';
import 'package:fluttereva/services/departament_service.dart';
import 'package:fluttereva/services/user_service.dart';
import 'package:provider/provider.dart';

class RegisterReport extends StatefulWidget {
  final User? user;
  const RegisterReport({super.key, this.user});

  @override
  State<RegisterReport> createState() => _RegisterReportState();
}

class _RegisterReportState extends State<RegisterReport> {
  @override
  void initState() {
    super.initState();
    cargarDepartamentosGlobal();
  }

  void cargarDepartamentosGlobal() async {
    final departamentos = await DepartamentService().getDepartamentos();
    Provider.of<DepartamentoProvider>(
      context,
      listen: false,
    ).cargarDesdeJson(departamentos.map((e) => e.toJson()).toList());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            width: 1.5,
            height: 35,
            color: Colors.grey[300],
            margin: const EdgeInsets.symmetric(vertical: 10),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              if (FirebaseAuth.instance.currentUser != null) {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
          SizedBox(width: 10),
        ],
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
                await Provider.of<TopProvider>(
                  context,
                  listen: false,
                ).fetchTopEvents();
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
