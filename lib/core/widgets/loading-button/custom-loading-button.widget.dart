import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/core/theme/app.theme.dart';
import 'package:le_spawn_fr/core/widgets/loading-button/bloc/loading-button.state-cubit.dart';
import 'package:le_spawn_fr/core/widgets/loading-button/bloc/loading-button.state.dart';

class CustomLoadingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomLoadingButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingButtonCubit, LoadingButtonState>(
      builder: (context, state) {
        return switch (state) {
          LoadingButtonLoadingState() => _buildLoading(),
          LoadingButtonSuccessState() => _buildSuccess(),
          LoadingButtonFailureState() => _buildFailure(state),
          _ => _buildInitial(),
        };
      },
    );
  }

  Widget _buildLoading() {
    return ElevatedButton(
      onPressed: null,
      child: const CircularProgressIndicator(),
    );
  }

  Widget _buildInitial() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.accentYellow,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: AppTheme.primaryText),
      ),
    );
  }

  Widget _buildSuccess() {
    return ElevatedButton(
      onPressed: null,
      child: const Text('Success'),
    );
  }

  Widget _buildFailure(LoadingButtonFailureState state) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      child: Text(state.errorMessage),
    );
  }
}
