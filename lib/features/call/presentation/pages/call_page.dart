import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/call_bloc.dart';
import '../bloc/call_event.dart';
import '../bloc/call_state.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<CallBloc>().add(const FetchCallsEvent());
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CallBloc>().add(const FetchCallsEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Call List'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name or phone...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                context.read<CallBloc>().add(FilterCallsEvent(val));
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<CallBloc, CallState>(
        builder: (context, state) {
          return Column(
            children: [
              if (state.lastSynced != null)
                Container(
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Center(
                    child: Text(
                      'Last Synced: ${state.lastSynced!.toLocal().toString().split('.')[0]}',
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ),
                ),
              Expanded(
                child: _buildBody(state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(CallState state) {
    final displayCalls = state.filteredCalls;

    if (state.calls.isEmpty) {
      if (state.isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.errorMessage != null) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${state.errorMessage}', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<CallBloc>().add(const FetchCallsEvent(isRefresh: true));
                  },
                  child: const Text('Retry'),
                )
              ],
            ),
          ),
        );
      } else {
        return const Center(child: Text('No calls available.'));
      }
    }

    if (displayCalls.isEmpty) {
      return const Center(child: Text('No calls match your search.'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<CallBloc>().add(const FetchCallsEvent(isRefresh: true));
      },
      child: ListView.separated(
        controller: _scrollController,
        itemCount: displayCalls.length + (state.isLoading ? 1 : 0),
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index >= displayCalls.length) {
            return const BottomLoader();
          }
          final call = displayCalls[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.phone, color: Colors.white),
            ),
            title: Text(call.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(call.phone),
            trailing: IconButton(
              icon: const Icon(Icons.call, color: Colors.green),
              onPressed: () {
                 ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text('Calling ${call.name} at ${call.phone}'))
                 );
              },
            ),
          );
        },
      ),
    );
  }
}

class BottomLoader extends StatelessWidget {
  const BottomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(strokeWidth: 2.0),
        ),
      ),
    );
  }
}
