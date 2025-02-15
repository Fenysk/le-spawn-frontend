import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:le_spawn_fr/core/configs/app-routes.config.dart';
import 'package:le_spawn_fr/core/widgets/loading-button/bloc/loading-button.state-cubit.dart';
import 'package:le_spawn_fr/core/widgets/loading-button/bloc/loading-button.state.dart';
import 'package:le_spawn_fr/core/widgets/loading-button/custom-loading-button.widget.dart';
import 'package:le_spawn_fr/features/auth/2_domain/usecase/logout.usecase.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoadingButtonCubit(),
      child: BlocListener<LoadingButtonCubit, LoadingButtonState>(
        listener: (context, state) {
          if (state is LoadingButtonSuccessState) {
            context.go(AppRoutesConfig.auth);
          }
        },
        child: Builder(
          builder: (context) {
            return CustomLoadingButton(
              text: 'Déconnexion',
              onPressed: () => context.read<LoadingButtonCubit>().execute(usecase: LogoutUsecase()),
            );
          },
        ),
      ),
    );
  }
}
