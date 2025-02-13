import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_frontend/features/user/2_domain/entity/user.entity.dart';
import 'package:le_spawn_frontend/features/user/3_presentation/bloc/user-display.cubit.dart';
import 'package:le_spawn_frontend/features/user/3_presentation/bloc/user-display.state.dart';

class UserDisplayWidget extends StatelessWidget {
  final String? userId;

  const UserDisplayWidget({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return BlocProvider(
      create: (context) => UserDisplayCubit()..displayUser(userId: userId),
      child: BlocBuilder<UserDisplayCubit, UserDisplayState>(
        builder: (context, state) {
          return switch (state) {
            UserDisplayLoaded() => buildLoadedContent(state, themeData),
            UserDisplayFailure() => buildFailureContent(state),
            _ => buildLoadingContent(),
          };
        },
      ),
    );
  }

  Widget buildLoadingContent() => const Center(child: CircularProgressIndicator());

  Widget buildFailureContent(UserDisplayFailure state) => Center(child: Text(state.errorMessage));

  Widget buildLoadedContent(UserDisplayLoaded state, ThemeData themeData) => Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.user.profile?.displayName ?? 'No displayName',
                      style: themeData.textTheme.headlineLarge,
                    ),
                    Text(
                      state.user.profile?.pseudo ?? 'No pseudo',
                      style: themeData.textTheme.bodySmall,
                    ),
                  ],
                ),
                const Spacer(),
                AvatarWidget(user: state.user, diameter: 60),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              state.user.profile?.biography ?? 'No biography',
              style: themeData.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: themeData.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                        children: [
                          if (state.user.profile?.link != null && state.user.profile!.link!.isNotEmpty)
                            TextSpan(
                              text: state.user.profile?.link,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
}

class AvatarWidget extends StatelessWidget {
  final UserEntity user;
  final double diameter;

  const AvatarWidget({
    super.key,
    required this.user,
    required this.diameter,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return CircleAvatar(
      radius: diameter / 2,
      foregroundImage: NetworkImage(user.profile?.avatarUrl ?? ''),
      onForegroundImageError: (exception, stackTrace) {},
      backgroundColor: Colors.grey,
      child: user.profile?.avatarUrl == null
          ? Text(
              user.profile?.pseudo?.toUpperCase().substring(0, 2) ?? '',
              style: themeData.textTheme.labelMedium,
            )
          : null,
    );
  }
}
