import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/core/widgets/separation/separation.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.cubit.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/widget/barcode-scanner.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/widget/scan-barcode-button.widget.dart';

class GameDetectionTab extends StatefulWidget {
  const GameDetectionTab({
    super.key,
  });

  @override
  State<GameDetectionTab> createState() => _GameDetectionTabState();
}

class _GameDetectionTabState extends State<GameDetectionTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _showBarcodeDrawer({bool isDebug = false}) {
    if (!mounted) return;

    final cubit = BlocProvider.of<AddNewGameCubit>(context);
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: false,
      builder: (BuildContext modalContext) => BarcodeScannerWidget(
        addNewGameCubit: cubit,
        isDebug: isDebug,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScanBarcodeButtonWidget(
            text: 'Scanner un code-barre',
            onScanFirstGamePressed: _showBarcodeDrawer,
          ),
          SeparationWidget(
            padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 100),
          ),
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search your game',
            ),
            onSubmitted: (value) => context.read<AddNewGameCubit>().searchGames(value),
          ),
        ],
      ),
    );
  }
}
