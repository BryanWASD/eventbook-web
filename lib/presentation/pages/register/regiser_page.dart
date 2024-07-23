// import 'package:eventsapp/presentation/pages/home/home.dart';
import 'package:eventsapp/presentation/pages/login/cubit/login_cubit.dart';
import 'package:eventsapp/presentation/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final registerKey = GlobalKey<FormState>();
  final usenameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    // ignore: unused_local_variable
    bool isEnabled = true;
    String email;
    String password;
    String username;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: height,
          width: width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                  ),
                  child: Image.asset(
                    'assets/images/login_image.jpg',
                    fit: BoxFit.cover,
                    height: height,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: height,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: registerKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.asset(
                              'assets/images/eventBook2.png',
                              width: width * .15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 5.0),
                                  child: Text(
                                    'Bienvenido',
                                    style: theme.textTheme.titleLarge,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, bottom: 10.0),
                                  child: Text(
                                    'Crea tu cuenta para continuar',
                                    style: theme.textTheme.bodyMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 10.0),
                                        child: Text(
                                          'Nombre de usuario',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      TextFormField(
                                        controller: usenameController,
                                        decoration: const InputDecoration(
                                          hintText: 'Jhon Doe',
                                        ),
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'Por favor ingresa tu usuario';
                                          }
                                          if (value.length > 40) {
                                            return 'Límite de caracteres excedido';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 10.0),
                                        child: Text(
                                          'Correo electronico',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      TextFormField(
                                        controller: emailController,
                                        decoration: const InputDecoration(
                                          hintText: 'correo@correo.com',
                                        ),
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'Por favor ingresa tu correo electrónico';
                                          }
                                          if (value.length > 40) {
                                            return 'Límite de caracteres excedido';
                                          }

                                          if (!RegExp(
                                                  "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                              .hasMatch(value)) {
                                            return 'Por favor ingrese un correo valido.';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 10.0),
                                        child: Text(
                                          'Contraseña',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      TextFormField(
                                        controller: passwordController,
                                        decoration: const InputDecoration(
                                          hintText: '123456',
                                        ),
                                        obscuringCharacter: '*',
                                        obscureText: true,
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'Por favor ingresa tu contraseña';
                                          }
                                          if (value.length > 24) {
                                            return 'Límite de caracteres excedido';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                BlocConsumer<LoginCubit, LoginState>(
                                  listener: (context, state) {
                                    if (state is LoginError) {
                                      setState(() {
                                        isEnabled = true;
                                      });
                                    }
                                  },
                                  builder: (context, state) {
                                    return SizedBox(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: ElevatedButton(
                                          onPressed: state is LoginLoading
                                              ? null
                                              : () {
                                                  if (registerKey.currentState!
                                                      .validate()) {
                                                    username =
                                                        usenameController.text;
                                                    email =
                                                        emailController.text;
                                                    password =
                                                        passwordController.text;

                                                    cubit.register(
                                                        username,
                                                        email,
                                                        password,
                                                        context);
                                                  }
                                                },
                                          child: const Text(
                                            'Crear cuenta',
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        'Ya tienes una cuenta?',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Login(),
                                            ),
                                          );
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                              top: 10.0, left: 5.0),
                                          child: Text(
                                            'Inicia sesion',
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
