import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttereva/dto/user.dto.dart';
import 'package:fluttereva/provider/departamento/departamento.provider.dart';
import 'package:fluttereva/services/departament_service.dart';
import 'package:fluttereva/services/user_service.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  final User? user;

  const RegistrationPage({super.key, required this.user});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _identificacionController = TextEditingController();
  final _departamentoController = TextEditingController();
  String _selectedOption = '1';
  final _showInformesSubOptions = false;

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
    final departamentos =
        Provider.of<DepartamentoProvider>(context).departamentos;
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                controller: _nombresController,
                decoration: const InputDecoration(labelText: 'Nombres'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _apellidosController,
                decoration: const InputDecoration(labelText: 'Apellidos'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _identificacionController,
                decoration: const InputDecoration(labelText: 'Identificación'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Departamento'),
                value: _selectedOption,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedOption = value;
                  });
                },
                menuMaxHeight: 250,
                items:
                    departamentos.map((departamento) {
                      return DropdownMenuItem(
                        value: departamento.id.toString(),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 200),
                          child: Text(departamento.nombre),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      // Validar que widget.user no sea null
                      if (widget.user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error: Usuario no autenticado'),
                          ),
                        );
                        return;
                      }

                      // Crear el DTO usando el constructor de fábrica
                      final usuarioDto = UsuarioDto.fromFirebaseUser(
                        user: widget.user!,
                        nombres: _nombresController.text,
                        apellidos: _apellidosController.text,
                        identificacion: _identificacionController.text,
                        departamentoId: int.parse(_selectedOption),
                      );

                      final success = await UserService().createUser(
                        usuarioDto,
                        context,
                      );

                      if (success) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Usuario registrado con éxito'),
                          ),
                        );
                        // Navegar a MainPage pasando el objeto User como argumento
                        Navigator.pushReplacementNamed(context, '/main');
                      } else {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error al registrar usuario'),
                          ),
                        );
                      }
                    } catch (e) {
                      // Manejar cualquier excepción
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error inesperado: $e')),
                      );
                    }
                  }
                },
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
