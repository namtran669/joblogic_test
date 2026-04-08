import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/buy_item.dart';
import '../bloc/buy_bloc.dart';
import '../bloc/buy_event.dart';
import '../bloc/buy_state.dart';

class BuyDetailPage extends StatelessWidget {
  final BuyItem item;
  const BuyDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: BlocBuilder<BuyBloc, BuyState>(
        builder: (context, state) {
          final currentItem = state.items.firstWhere((e) => e.id == item.id, orElse: () => item);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(Icons.image, size: 120, color: Colors.grey.shade400),
                ),
                const SizedBox(height: 24),
                Text(
                  currentItem.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${currentItem.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Save to Wishlist', style: TextStyle(fontSize: 18)),
                    Switch(
                      value: currentItem.isWishlisted,
                      onChanged: (val) {
                        context.read<BuyBloc>().add(ToggleWishlistEvent(currentItem));
                      },
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to cart (Mock)')),
                      );
                    },
                    child: const Text('Add to Cart', style: TextStyle(fontSize: 16)),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
