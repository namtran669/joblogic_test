import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workmanager/workmanager.dart';
import 'core/di/injection_container.dart' as di;
import 'features/home/presentation/pages/home_page.dart';

// Blocs
import 'features/call/presentation/bloc/call_bloc.dart';
import 'features/buy/presentation/bloc/buy_bloc.dart';
import 'features/sell/presentation/bloc/sell_bloc.dart';
import 'features/sync/presentation/sync_bloc_and_page.dart';
import 'features/sync/domain/sync_domain_data.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await di.init();
    final triggerSync = di.sl<TriggerSyncUseCase>();
    await triggerSync.call();
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  
  // Register recurring background sync
  Workmanager().registerPeriodicTask(
    "1",
    "backgroundSyncTask",
    frequency: const Duration(hours: 1),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<CallBloc>()),
        BlocProvider(create: (_) => di.sl<BuyBloc>()),
        BlocProvider(create: (_) => di.sl<SellBloc>()),
        BlocProvider(create: (_) => di.sl<SyncBloc>()),
      ],
      child: MaterialApp(
        title: 'Joblogic App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomePage(),
      ),
    );
  }
}
