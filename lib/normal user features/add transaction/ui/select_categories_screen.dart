import 'package:animate_do/animate_do.dart';
import 'package:budgeta/normal%20user%20features/add%20transaction/cubit/cubit/add_transaction_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgeta/models/category.dart' as model;

class SelectCategoriesScreen extends StatefulWidget {
  const SelectCategoriesScreen({super.key});

  @override
  State<SelectCategoriesScreen> createState() => _SelectCategoriesScreenState();
}

class _SelectCategoriesScreenState extends State<SelectCategoriesScreen> {
  @override
  void initState() {
    // TODO: implement initState
    // context.read<AddTransactionCubit>().getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select category"), centerTitle: true),
      body: BlocBuilder<AddTransactionCubit, AddTransactionState>(
        builder: (context, state) {
          final categories = state.isExpense
              ? context.read<AddTransactionCubit>().getExpenseCategories()
              : context.read<AddTransactionCubit>().getIncomeCategories();
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return BlocSelector<
                AddTransactionCubit,
                AddTransactionState,
                model.Category?
              >(
                selector: (state) => state.selectedCategory,
                builder: (context, selectedCategory) {
                  return FadeInUp(
                    delay: Duration(milliseconds: 100 * index),
                    duration: Duration(milliseconds: 200),
                    from: 10,
                    child: ListTile(
                      title: Text(categories[index].name.toString()),
                      onTap: () {
                        context.read<AddTransactionCubit>().selectCategory(
                          categories[index],
                        );
                        Navigator.pop(context);
                      },
                      trailing: selectedCategory?.id == categories[index].id
                          ? Icon(CupertinoIcons.check_mark)
                          : null,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
