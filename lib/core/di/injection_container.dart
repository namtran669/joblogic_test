import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../database/database_helper.dart';
import '../network/mock_api_interceptor.dart';

// Call
import '../../features/call/domain/repositories/call_repository.dart';
import '../../features/call/domain/usecases/get_calls_usecase.dart';
import '../../features/call/data/datasources/call_remote_data_source.dart';
import '../../features/call/data/repositories/call_repository_impl.dart';
import '../../features/call/presentation/bloc/call_bloc.dart';

// Buy
import '../../features/buy/domain/repositories/buy_repository.dart';
import '../../features/buy/domain/usecases/buy_usecases.dart';
import '../../features/buy/data/datasources/buy_data_sources.dart';
import '../../features/buy/data/repositories/buy_repository_impl.dart';
import '../../features/buy/presentation/bloc/buy_bloc.dart';

// Sell
import '../../features/sell/domain/usecases/sell_usecases.dart';
import 'package:test_joblogic/features/sell/data/datasources/sell_local_data_source.dart';
import '../../features/sell/data/repositories/sell_repository_impl.dart';
import '../../features/sell/presentation/bloc/sell_bloc.dart';

// Sync
import '../../features/sync/domain/sync_domain_data.dart';
import '../../features/sync/presentation/sync_bloc_and_page.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);
  
  final dio = Dio();
  dio.interceptors.add(MockApiInterceptor());
  sl.registerLazySingleton<Dio>(() => dio);

  // --- Call Module ---
  sl.registerFactory(() => CallBloc(getCallsUseCase: sl()));
  sl.registerLazySingleton(() => GetCallsUseCase(sl()));
  sl.registerLazySingleton<CallRepository>(() => CallRepositoryImpl(sl()));
  sl.registerLazySingleton<CallRemoteDataSource>(() => CallRemoteDataSourceImpl(sl()));

  // --- Buy Module ---
  sl.registerFactory(() => BuyBloc(getBuyItemsUseCase: sl(), toggleWishlistUseCase: sl()));
  sl.registerLazySingleton(() => GetBuyItemsUseCase(sl()));
  sl.registerLazySingleton(() => ToggleWishlistUseCase(sl()));
  sl.registerLazySingleton<BuyRepository>(() => BuyRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()));
  sl.registerLazySingleton<BuyRemoteDataSource>(() => BuyRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<BuyLocalDataSource>(() => BuyLocalDataSourceImpl(sl()));

  // --- Sell Module ---
  sl.registerFactory(() => SellBloc(
    getSellItemsUseCase: sl(),
    addSellItemUseCase: sl(),
    updateSellItemUseCase: sl(),
    deleteSellItemUseCase: sl(),
    bulkDeleteSellItemUseCase: sl(),
  ));
  sl.registerLazySingleton(() => GetSellItemsUseCase(sl()));
  sl.registerLazySingleton(() => AddSellItemUseCase(sl()));
  sl.registerLazySingleton(() => UpdateSellItemUseCase(sl()));
  sl.registerLazySingleton(() => DeleteSellItemUseCase(sl()));
  sl.registerLazySingleton(() => BulkDeleteSellItemUseCase(sl()));
  sl.registerLazySingleton<SellRepository>(() => SellRepositoryImpl(sl()));
  sl.registerLazySingleton<SellLocalDataSource>(() => SellLocalDataSourceImpl(sl()));

  // --- Sync Module ---
  sl.registerFactory(() => SyncBloc(getPendingCountUseCase: sl(), triggerSyncUseCase: sl()));
  sl.registerLazySingleton(() => GetPendingCountUseCase(sl()));
  sl.registerLazySingleton(() => TriggerSyncUseCase(sl()));
  sl.registerLazySingleton<SyncRepository>(() => SyncRepositoryImpl(dbHelper: sl(), dio: sl()));
}
