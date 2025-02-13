import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:le_spawn_frontend/core/configs/app-routes.config.dart';
import 'package:le_spawn_frontend/core/widgets/loading-button/bloc/loading-button.state-cubit.dart';
import 'package:le_spawn_frontend/core/widgets/loading-button/bloc/loading-button.state.dart';
import 'package:le_spawn_frontend/core/widgets/loading-button/custom-loading-button.widget.dart';
import 'package:le_spawn_frontend/features/auth/1_data/dto/register.request.dart';
import 'package:le_spawn_frontend/features/auth/2_domain/usecase/register.usecase.dart';
import 'package:le_spawn_frontend/features/user/2_domain/repository/users.repository.dart';
import 'package:le_spawn_frontend/service-locator.dart';
import 'dart:async';

class RegisterTab extends StatefulWidget {
  final VoidCallback onGoToLoginTab;

  const RegisterTab({
    super.key,
    required this.onGoToLoginTab,
  });

  @override
  State<RegisterTab> createState() => _RegisterTabState();
}

class _RegisterTabState extends State<RegisterTab> {
  final _formKey = GlobalKey<FormState>();
  final _pseudoController = TextEditingController(text: 'Test');
  final _emailController = TextEditingController(text: 'test@test.test');
  final _passwordController = TextEditingController(text: 'Password1@');

  Timer? _checkIfPseudoExistDebounce;
  String? _checkIfPseudoExistErrorMessage;

  String? _validatePseudo(String? pseudo) {
    if (pseudo == null || pseudo.isEmpty) {
      return 'Pseudo is required';
    }

    return _checkIfPseudoExistErrorMessage;
  }

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }

    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Invalid email format';
    }

    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    final passwordRegex = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    if (!passwordRegex.hasMatch(password)) {
      return 'Password must contain at least 8 characters, 1 uppercase letter, 1 lowercase letter, 1 number and 1 special character';
    }

    return null;
  }

  Future<void> _checkIfPseudoExist(String pseudo) async {
    _checkIfPseudoExistDebounce?.cancel();

    _checkIfPseudoExistDebounce =
        Timer(const Duration(milliseconds: 300), () async {
      final result =
          await serviceLocator<UsersRepository>().checkIfPseudoExist(pseudo);
      _checkIfPseudoExistErrorMessage =
          result.fold((error) => error, (_) => null);
      _formKey.currentState?.validate();
    });
  }

  void _onRegisterPressed(BuildContext buttonContext) async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      buttonContext.read<LoadingButtonCubit>().execute(
            usecase: serviceLocator<RegisterUsecase>(),
            params: RegisterRequest(
              pseudo: _pseudoController.text,
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  void dispose() {
    _checkIfPseudoExistDebounce?.cancel();
    _pseudoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    _formKey.currentState?.validate();

    return BlocProvider(
      create: (context) => LoadingButtonCubit(),
      child: BlocListener<LoadingButtonCubit, LoadingButtonState>(
        listener: (context, state) {
          if (state is LoadingButtonSuccessState) {
            context.go(AppRoutes.collections);
          }

          if (state is LoadingButtonFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error creating account: ${state.errorMessage}',
                  style: themeData.textTheme.bodyMedium,
                ),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Create Account',
                    style: themeData.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _pseudoController,
                    validator: _validatePseudo,
                    onChanged: _checkIfPseudoExist,
                    style: themeData.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      labelText: 'Pseudo',
                      labelStyle: themeData.textTheme.bodyMedium,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    validator: _validateEmail,
                    style: themeData.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: themeData.textTheme.bodyMedium,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    validator: _validatePassword,
                    style: themeData.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: themeData.textTheme.bodyMedium,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Builder(
                    builder: (buttonContext) {
                      return CustomLoadingButton(
                        text: 'Register',
                        onPressed: () => _onRegisterPressed(buttonContext),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: widget.onGoToLoginTab,
                    child: Text(
                      'Go to login',
                      style: themeData.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
