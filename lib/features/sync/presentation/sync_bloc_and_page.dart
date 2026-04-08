import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../domain/sync_domain_data.dart';

// EVENTS
abstract class SyncEvent extends Equatable {
  const SyncEvent();
  @override
  List<Object?> get props => [];
}
class LoadPendingCountEvent extends SyncEvent {}
class PerformSyncEvent extends SyncEvent {}

// STATE
class SyncState extends Equatable {
  final int pendingCount;
  final bool isSyncing;
  final String? errorMessage;
  final bool syncSuccess;

  const SyncState({
    this.pendingCount = 0,
    this.isSyncing = false,
    this.errorMessage,
    this.syncSuccess = false,
  });

  SyncState copyWith({
    int? pendingCount,
    bool? isSyncing,
    String? Function()? errorMessage,
    bool? syncSuccess,
  }) {
    return SyncState(
      pendingCount: pendingCount ?? this.pendingCount,
      isSyncing: isSyncing ?? this.isSyncing,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      syncSuccess: syncSuccess ?? this.syncSuccess,
    );
  }

  @override
  List<Object?> get props => [pendingCount, isSyncing, errorMessage, syncSuccess];
}

// BLOC
class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final GetPendingCountUseCase getPendingCountUseCase;
  final TriggerSyncUseCase triggerSyncUseCase;

  SyncBloc({
    required this.getPendingCountUseCase,
    required this.triggerSyncUseCase,
  }) : super(const SyncState()) {
    on<LoadPendingCountEvent>(_onLoadCount);
    on<PerformSyncEvent>(_onPerformSync);
  }

  Future<void> _onLoadCount(LoadPendingCountEvent event, Emitter<SyncState> emit) async {
    final result = await getPendingCountUseCase.call();
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: () => failure.message)),
      (count) => emit(state.copyWith(pendingCount: count, syncSuccess: false)),
    );
  }

  Future<void> _onPerformSync(PerformSyncEvent event, Emitter<SyncState> emit) async {
    if (state.pendingCount == 0) return;
    emit(state.copyWith(isSyncing: true, errorMessage: () => null, syncSuccess: false));
    
    final result = await triggerSyncUseCase.call();
    result.fold(
      (failure) => emit(state.copyWith(isSyncing: false, errorMessage: () => failure.message)),
      (_) {
        emit(state.copyWith(isSyncing: false, syncSuccess: true, pendingCount: 0));
      }
    );
  }
}

// UI PAGE
class SyncPage extends StatefulWidget {
  const SyncPage({super.key});

  @override
  State<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> {
  @override
  void initState() {
    super.initState();
    context.read<SyncBloc>().add(LoadPendingCountEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manual Sync')),
      body: BlocConsumer<SyncBloc, SyncState>(
        listener: (context, state) {
          if (state.syncSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sync completed successfully!')));
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${state.errorMessage}')));
          }
        },
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_upload_outlined, size: 100, color: Colors.blueGrey),
                const SizedBox(height: 24),
                Text(
                  'Pending Items to Sync: ${state.pendingCount}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 32),
                if (state.isSyncing)
                  const CircularProgressIndicator()
                else
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    icon: const Icon(Icons.sync),
                    label: const Text('SYNC NOW', style: TextStyle(fontSize: 18)),
                    onPressed: state.pendingCount > 0
                        ? () => context.read<SyncBloc>().add(PerformSyncEvent())
                        : null,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
