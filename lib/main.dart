import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'services/api_service.dart';
import 'controllers/auth_cubit.dart';
import 'controllers/rosca_cubit.dart';
import 'utils/app_router.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(const RoscaApp());
}

class RoscaApp extends StatelessWidget {
  const RoscaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(apiService)..checkAuthStatus(),
        ),
        BlocProvider<RoscaCubit>(
          create: (context) => RoscaCubit(apiService),
        ),
      ],
      child: Builder(
        builder: (context) {
          final authCubit = context.read<AuthCubit>();
          final router = AppRouter.createRouter(authCubit);

          return MaterialApp.router(
            title: 'ROSCA App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              scaffoldBackgroundColor: AppColors.background,
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.background,
                elevation: 0,
                titleTextStyle: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                iconTheme: IconThemeData(color: AppColors.textPrimary),
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: AppColors.textPrimary),
                bodyMedium: TextStyle(color: AppColors.textPrimary),
                bodySmall: TextStyle(color: AppColors.textSecondary),
                titleLarge: TextStyle(color: AppColors.textPrimary),
                titleMedium: TextStyle(color: AppColors.textPrimary),
                titleSmall: TextStyle(color: AppColors.textPrimary),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            routerConfig: router,
          );
        },
      ),
    );
  }
}
