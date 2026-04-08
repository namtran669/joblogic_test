import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/buy_bloc.dart';
import '../bloc/buy_event.dart';
import '../bloc/buy_state.dart';
import 'buy_detail_page.dart';

class BuyPage extends StatefulWidget {
  const BuyPage({super.key});

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  @override
  void initState() {
    super.initState();
    context.read<BuyBloc>().add(FetchBuyItemsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Buy List'),
        actions: [
          BlocBuilder<BuyBloc, BuyState>(
            builder: (context, state) {
              return PopupMenuButton<String>(
                onSelected: (val) {
                  context.read<BuyBloc>().add(SortBuyItemsEvent(val));
                },
                icon: const Icon(Icons.sort),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'none', child: Text('Default Sorting')),
                  const PopupMenuItem(value: 'name_asc', child: Text('Name (A-Z)')),
                  const PopupMenuItem(value: 'price_asc', child: Text('Price (Low to High)')),
                  const PopupMenuItem(value: 'price_desc', child: Text('Price (High to Low)')),
                ],
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search items...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                context.read<BuyBloc>().add(FilterBuyItemsEvent(val));
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<BuyBloc, BuyState>(
        builder: (context, state) {
          if (state.isLoading && state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null && state.items.isEmpty) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }
          final items = state.displayItems;
          if (items.isEmpty) {
            return const Center(child: Text('No items found.'));
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<BuyBloc>().add(FetchBuyItemsEvent());
            },
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.shopping_bag)),
                  title: Text(item.name),
                  subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(
                      item.isWishlisted ? Icons.favorite : Icons.favorite_border,
                      color: item.isWishlisted ? Colors.red : null,
                    ),
                    onPressed: () {
                      context.read<BuyBloc>().add(ToggleWishlistEvent(item));
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<BuyBloc>(),
                          child: BuyDetailPage(item: item),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
