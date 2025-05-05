import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttereva/custom_widgets/barchar.dart';
import 'package:fluttereva/provider/evento/evento.provider.dart';
import 'package:fluttereva/provider/state/user.state.dart';
import 'package:fluttereva/provider/usuario/user.provider.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventoProvider>().fetchActiveEvent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Usuario? user =
        Provider.of<UsuarioProvider>(context, listen: true).usuario;
    final eventoActivo = context.watch<EventoProvider>().evento;
    return SizedBox(
      child:
          user == null
              ? const Center(
                child: CircularProgressIndicator(), // Indicador de carga
              )
              : Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    // TopBars(),
                    BarChar(),
                    // BarChartSample3(),
                    // Text(
                    //   'Bienvenido, \n$displayName',
                    //   style: const TextStyle(fontSize: 24),
                    // ),
                    SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              disabledBackgroundColor: Colors.grey.shade500,
                              disabledForegroundColor: Colors.white,
                            ),
                            onPressed:
                                user.rolId == 2
                                    ? null
                                    : () {
                                      Navigator.pushNamed(
                                        context,
                                        '/crear_evento',
                                      );
                                    },
                            label: const Text(
                              'Crear \nevento',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            icon: const Icon(Icons.add_box),
                          ),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(context, '/consultar_evento');
                            },
                            label: Text(
                              'Consultar evento',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            icon: const Icon(Icons.search),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              disabledBackgroundColor: Colors.grey.shade500,
                              disabledForegroundColor: Colors.white,
                            ),
                            onPressed:
                                eventoActivo == null
                                    ? null
                                    : () {
                                      Navigator.pushNamed(
                                        context,
                                        '/calificar',
                                      );
                                    },
                            label: const Text(
                              'Calificar',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            icon: const Icon(Icons.rate_review),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (FirebaseAuth.instance.currentUser != null) {
                                FirebaseAuth.instance.signOut();
                              }
                            },
                            label: Text('Cerrar sesión'),
                            icon: Icon(Icons.logout),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }
}
