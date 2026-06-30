import 'package:budgeta/business%20features/select%20sms%20provider/cubit/select_sms_provider_cubit.dart';
import 'package:budgeta/core/theming/App_Colors.dart';
import 'package:budgeta/core/theming/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectSmsProvidersScreen extends StatefulWidget {
  const SelectSmsProvidersScreen({super.key});

  @override
  State<SelectSmsProvidersScreen> createState() =>
      _SelectSmsProvidersScreenState();
}

class _SelectSmsProvidersScreenState extends State<SelectSmsProvidersScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<SelectSmsProviderCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Your Banks and Mobile Wallets")),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<SelectSmsProviderCubit, SelectSmsProviderState>(
              builder: (context, state) {
                if (state is SelectSmsProviderLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.blue),
                  );
                }
                if (state is SelectSmsProviderError) {
                  return Center(child: Text(state.message));
                }
                if (state is SelectSmsProviderLoadded) {
                  return SelectedAndNotSelectedProvidersList(
                    notSelected: state.notSelected,
                    selected: state.selected,
                  );
                }
                if (state is SelectSmsProviderError) {
                  return Center(child: Text(state.message));
                }
                print(state);
                return Center(child: Text("error"));
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(15.w),
              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                  ),
                  onPressed: () async {
                    context.read<SelectSmsProviderCubit>().saveChanges();
                    Navigator.pop(context);
                  },
                  child: Text("Save Changes", style: AppFonts.white18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectedAndNotSelectedProvidersList extends StatelessWidget {
  const SelectedAndNotSelectedProvidersList({
    super.key,
    required this.selected,
    required this.notSelected,
  });
  final List<dynamic> selected;
  final List<dynamic> notSelected;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Header for Selected
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Selected",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),

        // First List
        selected.isEmpty
            ? SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "No providers selected",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return ProviderTile(
                    provider: selected[index],
                    selected: true,
                  );
                }, childCount: selected.length),
              ),

        // Header for Not Selected
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Not Selected",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),

        // Second List
        notSelected.isEmpty
            ? SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "No providers available to select",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return ProviderTile(
                    provider: notSelected[index],
                    selected: false,
                  );
                }, childCount: notSelected.length),
              ),
      ],
    );
  }
}

class ProviderTile extends StatelessWidget {
  ProviderTile({super.key, required this.provider, required this.selected});
  String? name;
  // int? id;
  final bool selected;
  dynamic provider;

  @override
  Widget build(BuildContext context) {
    name = provider.name;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              print(provider);
              context.read<SelectSmsProviderCubit>().swapSelection(provider);
            },
            icon: Icon(
              selected ? Icons.check_circle_outline_outlined : Icons.circle,
            ),
          ),
          Text(name ?? ""),
        ],
      ),
    );
  }
}
