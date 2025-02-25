import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:le_spawn_fr/core/configs/app-routes.config.dart';
import 'package:le_spawn_fr/core/widgets/loading-button/bloc/loading-button.state-cubit.dart';
import 'package:le_spawn_fr/core/widgets/loading-button/bloc/loading-button.state.dart';
import 'package:le_spawn_fr/features/auth/3_presentation/widget/logout-button.widget.dart';
import 'package:le_spawn_fr/features/user/3_presentation/widget/user-display.widget.dart';
import 'package:le_spawn_fr/features/home-widgets/3_presentation/page/game-counter-widget.page.dart';

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
            const SizedBox(height: 40),
            _buildWidgetConfigButton(context),
            const Spacer(),
            const LogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetConfigButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const GameCounterWidgetPage(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.widgets_outlined,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Widget Compteur de Jeux',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Configurer le widget pour votre écran d\'accueil',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
