import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:le_spawn_fr/core/configs/app-routes.config.dart';
import 'package:le_spawn_fr/core/widgets/loading-button/bloc/loading-button.state-cubit.dart';
import 'package:le_spawn_fr/core/widgets/loading-button/bloc/loading-button.state.dart';
import 'package:le_spawn_fr/core/widgets/loading-button/custom-loading-button.widget.dart';
import 'package:le_spawn_fr/features/auth/1_data/dto/login.request.dart';
import 'package:le_spawn_fr/features/auth/2_domain/usecase/login.usecase.dart';
import 'package:le_spawn_fr/service-locator.dart';

class LoginTab extends StatefulWidget {
  final VoidCallback onGoToRegisterTab;

  const LoginTab({
    super.key,
    required this.onGoToRegisterTab,
  });

  @override
  State<LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Invalid email format';
    }

    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    return null;
  }

  void _onLoginPressed(BuildContext buttonContext) {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      buttonContext.read<LoadingButtonCubit>().execute(
            usecase: serviceLocator<LoginUsecase>(),
            params: LoginRequest(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return BlocProvider(
      create: (context) => LoadingButtonCubit(),
      child: BlocListener<LoadingButtonCubit, LoadingButtonState>(
        listener: (context, state) {
          if (state is LoadingButtonSuccessState) {
            context.go(AppRoutesConfig.collections);
          }

          if (state is LoadingButtonFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error logging in: ${state.errorMessage}',
                  style: themeData.textTheme.bodyMedium?.copyWith(
                    color: themeData.colorScheme.onError,
                  ),
                ),
                backgroundColor: themeData.colorScheme.error,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Login',
                    style: themeData.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
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
                    controller: _passwordController,
                    validator: _validatePassword,
                    style: themeData.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: themeData.textTheme.bodyMedium,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  Builder(
                    builder: (buttonContext) {
                      return CustomLoadingButton(
                        text: 'Login',
                        onPressed: () => _onLoginPressed(buttonContext),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: widget.onGoToRegisterTab,
                    child: Text(
                      'Create an account',
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
