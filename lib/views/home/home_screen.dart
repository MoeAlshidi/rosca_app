import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controllers/rosca_cubit.dart';
import '../../controllers/auth_cubit.dart';
import '../../models/rosca.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../widgets/rosca_card.dart';
import '../../widgets/duration_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RoscaCubit>().loadRoscas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticated) {
              Navigator.pushReplacementNamed(context, '/login');
            }
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.background,
                elevation: 0,
                pinned: true,
                title: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthAuthenticated) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back!',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                          Text(
                            'Explore circles',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    color: AppColors.textPrimary,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    color: AppColors.textPrimary,
                    onPressed: () {},
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose duration',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      BlocBuilder<RoscaCubit, RoscaState>(
                        builder: (context, state) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                DurationChip(
                                  label: 'Monthly',
                                  isSelected: state is RoscaLoaded &&
                                      state.selectedDuration == RoscaDuration.monthly,
                                  onTap: () {
                                    context
                                        .read<RoscaCubit>()
                                        .filterByDuration(RoscaDuration.monthly);
                                  },
                                ),
                                const SizedBox(width: AppConstants.paddingSmall),
                                DurationChip(
                                  label: 'Quarterly',
                                  isSelected: state is RoscaLoaded &&
                                      state.selectedDuration == RoscaDuration.quarterly,
                                  onTap: () {
                                    context
                                        .read<RoscaCubit>()
                                        .filterByDuration(RoscaDuration.quarterly);
                                  },
                                ),
                                const SizedBox(width: AppConstants.paddingSmall),
                                DurationChip(
                                  label: 'Bi-Monthly',
                                  isSelected: state is RoscaLoaded &&
                                      state.selectedDuration == RoscaDuration.biMonthly,
                                  onTap: () {
                                    context
                                        .read<RoscaCubit>()
                                        .filterByDuration(RoscaDuration.biMonthly);
                                  },
                                ),
                                const SizedBox(width: AppConstants.paddingSmall),
                                DurationChip(
                                  label: 'All',
                                  isSelected: state is RoscaLoaded &&
                                      state.selectedDuration == null,
                                  onTap: () {
                                    context.read<RoscaCubit>().loadRoscas();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              BlocBuilder<RoscaCubit, RoscaState>(
                builder: (context, state) {
                  if (state is RoscaLoading) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                    );
                  }

                  if (state is RoscaError) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Something went wrong',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                            ),
                            const SizedBox(height: AppConstants.paddingSmall),
                            Text(
                              state.message,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppConstants.paddingMedium),
                            TextButton(
                              onPressed: () {
                                context.read<RoscaCubit>().loadRoscas();
                              },
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is RoscaLoaded) {
                    return SliverList(
                      delegate: SliverChildListDelegate([
                        _buildCategorySection(
                          context,
                          'Recommend',
                          context.read<RoscaCubit>().getRoscasByCategory(RoscaCategory.recommend),
                          AppColors.recommendCard,
                        ),
                        _buildCategorySection(
                          context,
                          'High Demand',
                          context.read<RoscaCubit>().getRoscasByCategory(RoscaCategory.highDemand),
                          AppColors.highDemandCard,
                        ),
                        _buildCategorySection(
                          context,
                          'Discover More',
                          context.read<RoscaCubit>().getRoscasByCategory(RoscaCategory.discoverMore),
                          AppColors.discoverMoreCard,
                        ),
                      ]),
                    );
                  }

                  return const SliverFillRemaining(
                    child: Center(
                      child: Text('No ROSCAs available'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment_outlined),
            activeIcon: Icon(Icons.payment),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    String title,
    List<Rosca> roscas,
    Color cardColor,
  ) {
    if (roscas.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: _getCategoryIcon(title),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: roscas.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < roscas.length - 1 ? AppConstants.paddingMedium : 0,
                  ),
                  child: RoscaCard(
                    rosca: roscas[index],
                    backgroundColor: cardColor,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryIcon(String category) {
    switch (category) {
      case 'Recommend':
        return AppColors.warning;
      case 'High Demand':
        return AppColors.error;
      case 'Discover More':
        return AppColors.secondary;
      default:
        return AppColors.primary;
    }
  }
} 