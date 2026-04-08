import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/sell_bloc.dart';
import '../bloc/sell_event.dart';
import '../bloc/sell_state.dart';
import 'sell_form_page.dart';

class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  @override
  void initState() {
    super.initState();
    context.read<SellBloc>().add(LoadSellItemsEvent());
  }

  void _showUndoSnackbar(BuildContext context, SellState state) {
     if (state.lastDeletedItems != null && state.lastDeletedItems!.isNotEmpty) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${state.lastDeletedItems!.length} item(s) deleted.'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                context.read<SellBloc>().add(UndoDeleteSellItemEvent(state.lastDeletedItems!));
              },
            ),
            duration: const Duration(seconds: 4),
          ),
        );
     }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SellBloc, SellState>(
      listenWhen: (previous, current) => previous.lastDeletedItems != current.lastDeletedItems,
      listener: (context, state) {
        _showUndoSnackbar(context, state);
      },
      builder: (context, state) {
        final isSelectionMode = state.selectedIds.isNotEmpty;

        return Scaffold(
          appBar: AppBar(
            title: Text(isSelectionMode ? '${state.selectedIds.length} Selected' : 'To-Sell List'),
            leading: isSelectionMode
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => context.read<SellBloc>().add(ClearSelectionEvent()),
                  )
                : null,
            actions: [
              if (isSelectionMode)
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context.read<SellBloc>().add(BulkDeleteSelectedEvent());
                  },
                ),
            ],
          ),
          body: _buildBody(state),
          floatingActionButton: FloatingActionButton(
            heroTag: 'sell_fab',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<SellBloc>(),
                    child: const SellFormPage(),
                  ),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildBody(SellState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.items.isEmpty) {
      return const Center(child: Text('No items to sell. Add one!'));
    }

    return ListView.builder(
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final item = state.items[index];
        final isSelected = state.selectedIds.contains(item.id);

        return ListTile(
          onLongPress: () {
            if (item.id != null) {
              context.read<SellBloc>().add(ToggleSelectionEvent(item.id!));
            }
          },
          onTap: () {
            if (state.selectedIds.isNotEmpty) {
               if (item.id != null) {
                 context.read<SellBloc>().add(ToggleSelectionEvent(item.id!));
               }
            } else {
               Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<SellBloc>(),
                    child: SellFormPage(item: item),
                  ),
                ),
              );
            }
          },
          selected: isSelected,
          selectedTileColor: Colors.blue.withOpacity(0.2),
          leading: isSelected 
              ? const CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.check, color: Colors.white))
              : CircleAvatar(child: Text(item.name[0].toUpperCase())),
          title: Text(item.name),
          subtitle: Text('Qty: ${item.quantity} | \$${item.price.toStringAsFixed(2)} - ${item.syncStatus}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              context.read<SellBloc>().add(DeleteSellItemEvent(item));
            },
          ),
        );
      },
    );
  }
}
