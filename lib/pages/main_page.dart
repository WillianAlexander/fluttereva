import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttereva/custom_widgets/resources/top_bars_label.dart';
import 'package:fluttereva/custom_widgets/top_bars.dart';
import 'package:fluttereva/provider/state/user.state.dart';
import 'package:fluttereva/provider/usuario/user.provider.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final Usuario? user =
        Provider.of<UsuarioProvider>(context, listen: false).usuario;
    final displayName = user?.nombres.split(" ")[0];

    // return Scaffold(
    //   body: Stack(
    //     children: [
    //       // Fondo principal
    //       Container(
    //         padding: EdgeInsets.only(top: 28),
    //         height: MediaQuery.of(context).size.height,
    //         width: MediaQuery.of(context).size.width,
    //         decoration: BoxDecoration(color: theme.primary),
    //         child: Column(
    //           children: [
    //             Transform.scale(
    //               alignment: Alignment.topCenter,
    //               scale: 0.25, // Escala la imagen al 50% de su tamaño original
    //               child: Image.asset('assets/logo.png'),
    //             ),
    //           ],
    //         ),
    //       ),
    //       Container(
    //         margin: const EdgeInsets.only(top: 85),
    //         height: MediaQuery.of(context).size.height,
    //         width: MediaQuery.of(context).size.width,
    //         decoration: BoxDecoration(
    //           color: theme.background,
    //           borderRadius: const BorderRadius.only(
    //             topLeft: Radius.elliptical(40, 25),
    //             topRight: Radius.elliptical(40, 25),
    //           ),
    //           boxShadow: [
    //             BoxShadow(
    //               color: Colors.black.withAlpha(51),
    //               spreadRadius: 4,
    //               blurRadius: 25,
    //               offset: const Offset(0, 4), // changes position of shadow
    //             ),
    //           ],
    //         ),
    //         child:
    //             user == null
    //                 ? const Center(
    //                   child: CircularProgressIndicator(), // Indicador de carga
    //                 )
    //                 : Padding(
    //                   padding: const EdgeInsets.all(30.0),
    //                   child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.start,
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Text(
    //                         'Bienvenido, \n$displayName',
    //                         style: const TextStyle(fontSize: 24),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //       ),
    //     ],
    //   ),
    // );
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
                    TopBars(),
                    BarChartSample3(),
                    // Text(
                    //   'Bienvenido, \n$displayName',
                    //   style: const TextStyle(fontSize: 24),
                    // ),
                    SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
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
                            onPressed: () {},
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
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
