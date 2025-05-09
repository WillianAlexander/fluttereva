import 'package:flutter/material.dart';
import 'package:fluttereva/custom_widgets/barchar.dart';
import 'package:fluttereva/models/evento.dart';
import 'package:fluttereva/provider/evento/evento.provider.dart';
import 'package:fluttereva/provider/state/evento.state.dart';
import 'package:fluttereva/provider/state/user.state.dart';
import 'package:fluttereva/provider/usuario/user.provider.dart';
import 'package:fluttereva/services/evento_participante_service.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Usuario? _lastUser;
  EventoState? _lastEvento;
  bool _canCalificar = false;
  bool _loadingCalificar = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventoProvider>().fetchActiveEvent();
      _checkIfCanCalificar();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<UsuarioProvider>(context).usuario;
    final evento = context.watch<EventoProvider>().evento;
    if (user != _lastUser || evento?.id != _lastEvento?.id) {
      _lastUser = user;
      _lastEvento = evento;
      _checkIfCanCalificar();
    } else {
      _checkIfCanCalificar();
    }
  }

  void _checkIfCanCalificar() async {
    final user = context.read<UsuarioProvider>().usuario;
    final evento = context.read<EventoProvider>().evento;
    if (user != null && evento != null) {
      if (user.rolId == 1) {
        setState(() {
          _canCalificar = true;
          _loadingCalificar = false;
        });
        return;
      }
      setState(() => _loadingCalificar = true);
      try {
        final result = await EventoParticipanteService().getEventParticipant(
          evento.id,
          user.departamento!.id,
        );
        setState(() {
          _canCalificar = result['id'] != null;
          _loadingCalificar = false;
        });
      } catch (e) {
        setState(() {
          _canCalificar = false;
          _loadingCalificar = false;
        });
      }
    } else {
      setState(() {
        _canCalificar = false;
        _loadingCalificar = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final Usuario? user =
        Provider.of<UsuarioProvider>(context, listen: true).usuario;
    return SizedBox(
      child:
          user == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    BarChar(),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(120, 60),
                                disabledBackgroundColor: Colors.grey.shade500,
                                disabledForegroundColor: Colors.white,
                              ),
                              onPressed:
                                  ((user.rolId == 2 &&
                                          (_loadingCalificar ||
                                              !_canCalificar)))
                                      ? null
                                      : () {
                                        Navigator.pushNamed(
                                          context,
                                          '/calificar',
                                        );
                                      },
                              label:
                                  _loadingCalificar
                                      ? SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                      : const Text(
                                        'Calificar',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                              icon: const Icon(Icons.check_box_outlined),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(0, 60),
                                disabledBackgroundColor: Colors.grey.shade500,
                                disabledForegroundColor: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/consultar_evento',
                                );
                              },
                              label: Text(
                                'Consultar eventos',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              icon: const Icon(Icons.calendar_month_outlined),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryContainer,
                                fixedSize: const Size(0, 60),
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
                                'Crear evento',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              icon: const Icon(Icons.add_box_outlined),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
