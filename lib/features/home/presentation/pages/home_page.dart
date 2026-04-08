import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_joblogic/features/call/presentation/pages/call_page.dart';
import 'package:test_joblogic/features/buy/presentation/pages/buy_page.dart';
import 'package:test_joblogic/features/sell/presentation/pages/sell_page.dart';
import 'package:test_joblogic/features/sync/presentation/sync_bloc_and_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: const Text('Joblogic Dashboard'),
         centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashCard(
              context,
              title: 'To Call List',
              icon: Icons.phone_in_talk,
              color: Colors.blue,
              destination: const CallPage(),
            ),
            _buildDashCard(
              context,
              title: 'To Buy List',
              icon: Icons.shopping_cart,
              color: Colors.orange,
              destination: const BuyPage(),
            ),
            _buildDashCard(
              context,
              title: 'To Sell List',
              icon: Icons.storefront,
              color: Colors.green,
              destination: const SellPage(),
            ),
             _buildDashCard(
              context,
              title: 'Manual Sync',
              icon: Icons.sync,
              color: Colors.purple,
              destination: const SyncPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashCard(BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Widget destination,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color.withOpacity(0.2),
                child: Icon(icon, size: 36, color: color),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
