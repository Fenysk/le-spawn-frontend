import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/reports/3_presentation/bloc/report-game.cubit.dart';
import 'package:le_spawn_fr/features/reports/3_presentation/bloc/report-game.state.dart';

class ReportGameDialog extends StatefulWidget {
  final GameEntity game;
  final BuildContext parentContext;

  const ReportGameDialog({
    super.key,
    required this.game,
    required this.parentContext,
  });

  @override
  State<ReportGameDialog> createState() => _ReportGameDialogState();
}

class _ReportGameDialogState extends State<ReportGameDialog> {
  final _formKey = GlobalKey<FormState>();
  final _explicationsController = TextEditingController();

  @override
  void dispose() {
    _explicationsController.dispose();
    super.dispose();
  }

  void _submitReport(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<ReportGameCubit>().submitReport(
          widget.game.id,
          _explicationsController.text,
        );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(widget.parentContext).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportGameCubit(),
      child: BlocConsumer<ReportGameCubit, ReportGameState>(
        listener: (context, state) {
          if (state is ReportGameFailureState) {
            _showSnackBar(state.errorMessage, isError: true);
          } else if (state is ReportGameSuccessState) {
            Navigator.pop(context);
            _showSnackBar('Merci pour votre signalement. Notre équipe va l\'examiner.');
          }
        },
        builder: (context, state) {
          return AlertDialog(
            title: const Text('Signaler un problème'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jeu : ${widget.game.name}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _explicationsController,
                    decoration: const InputDecoration(
                      labelText: 'Explications',
                      hintText: 'Expliquez le problème que vous avez constaté...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez expliquer le problème';
                      }
                      if (value.length < 10) {
                        return 'Les explications doivent faire au moins 10 caractères';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: state is ReportGameLoadingState ? null : () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              FilledButton(
                onPressed: state is ReportGameLoadingState ? null : () => _submitReport(context),
                child: state is ReportGameLoadingState
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Envoyer'),
              ),
            ],
          );
        },
      ),
    );
  }
}
