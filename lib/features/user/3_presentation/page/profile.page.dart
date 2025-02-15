import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:le_spawn_fr/core/configs/app-routes.config.dart';
import 'package:le_spawn_fr/core/widgets/loading-button/bloc/loading-button.state-cubit.dart';
import 'package:le_spawn_fr/core/widgets/loading-button/bloc/loading-button.state.dart';
import 'package:le_spawn_fr/features/auth/3_presentation/widget/logout-button.widget.dart';
import 'package:le_spawn_fr/features/user/3_presentation/widget/user-display.widget.dart';

class ProfilePage extends StatelessWidget {
  final String? userId;

  const ProfilePage({
    super.key,
    this.userId,
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
        child: Column(
          children: [
            const SizedBox(height: 30),
            UserDisplayWidget(userId: userId),
            const Spacer(),
            const LogoutButton(),
          ],
        ),
      ),
    );
  }
}
