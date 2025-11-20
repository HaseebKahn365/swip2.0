import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../blocs/navigation/navigation_cubit.dart';
import '../../blocs/devices/devices_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Cubits
  getIt.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(getIt<SharedPreferences>()),
  );
  
  getIt.registerLazySingleton<NavigationCubit>(
    () => NavigationCubit(),
  );
  
  getIt.registerLazySingleton<DevicesCubit>(
    () => DevicesCubit(),
  );
}
