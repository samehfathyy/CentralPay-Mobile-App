import 'package:budgeta/core/helpers/DateHelpers.dart';
import 'package:budgeta/core/theming/App_Colors.dart';
import 'package:budgeta/normal%20user%20features/add%20transaction/cubit/cubit/add_transaction_cubit.dart';
import 'package:budgeta/normal%20user%20features/add%20transaction/ui/select_categories_screen.dart';
import 'package:budgeta/normal%20user%20features/show%20transactions/cubit/transactions_cubit.dart';
import 'package:budgeta/models/category.dart' as model;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddTransactionScreen extends StatefulWidget {
  final double? amount;
  final int? date;
  final String? category;
  const AddTransactionScreen({
    super.key,
    required this.onSaveCallBack,
    this.amount,
    this.date,
    this.category,
  });
  final void Function(int i) onSaveCallBack;
  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  late TextEditingController _textEditingController;
  String selected = "expense";

  // late bool isexpense;
  @override
  void initState() {
    // TODO: implement initState
    _textEditingController = TextEditingController();
    // context.read<AddTransactionCubit>().getCategories();
    // isexpense = context.read<AddTransactionCubit>().isExpense ?? true;
    // context.read<AddTransactionCubit>().getExpenseCategories();
    // context.read<AddTransactionCubit>().getIncomeCategories();
    context.read<AddTransactionCubit>().clearAllFields();
    if (widget.amount != null) {
      _textEditingController.text = widget.amount.toString();
      context.read<AddTransactionCubit>().updateAmount(widget.amount!);
    }
    if (widget.date != null) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(widget.date!);
      context.read<AddTransactionCubit>().updateDate(date);
    }
    if (widget.category != null) {
      context.read<AddTransactionCubit>().setCategoryByName(widget.category!);
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AddTransactionCubit, AddTransactionState, bool>(
      selector: (state) => state.isExpense,
      builder: (context, isExpense) {
        // print("is expense $isExpense");
        return Scaffold(
          appBar: AppBar(
            backgroundColor: isExpense ? AppColors.red : AppColors.green,
            iconTheme: IconThemeData(color: Colors.white),
          ),

          backgroundColor: const Color.fromARGB(255, 236, 236, 236),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //red green box
                      Container(
                        color: isExpense ? AppColors.red : AppColors.green,
                        // color: context.read<AddTransactionCubit>().isExpense
                        //     ? AppColors.red
                        //     : AppColors.green,
                        padding: EdgeInsets.only(
                          left: 10.w,
                          right: 10.w,
                          top: 10.w,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: SegmentedButton<String>(
                                    selected: {selected},
                                    segments: [
                                      ButtonSegment(
                                        value: "expense",
                                        label: Text(
                                          "Expense",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: isExpense
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                      ButtonSegment(
                                        value: "income",
                                        label: Text(
                                          "Income",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: isExpense
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                    onSelectionChanged:
                                        (Set<String> newSelection) {
                                          selected = newSelection.first;
                                          context
                                              .read<AddTransactionCubit>()
                                              .setIsExpense(
                                                newSelection.first == "expense",
                                              );
                                          context
                                              .read<AddTransactionCubit>()
                                              .resetCategorySelection();
                                        },
                                    showSelectedIcon: false,
                                    style: SegmentedButton.styleFrom(
                                      // selectedForegroundColor: AppColors.blue,
                                      backgroundColor: Color.fromARGB(
                                        58,
                                        83,
                                        83,
                                        83,
                                      ),
                                      selectedBackgroundColor: AppColors.white,

                                      side: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  isExpense ? "-" : "+",
                                  style: TextStyle(
                                    fontSize: 45.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _textEditingController,
                                    autofocus: true,
                                    maxLength: 9,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      context
                                          .read<AddTransactionCubit>()
                                          .updateAmount(
                                            double.tryParse(value) ?? 0.0,
                                          );
                                    },
                                    inputFormatters: [
                                      TextInputFormatter.withFunction((
                                        oldValue,
                                        newValue,
                                      ) {
                                        final text = newValue.text;

                                        // Allow only digits and dot
                                        if (!RegExp(
                                          r'^[0-9.]*$',
                                        ).hasMatch(text)) {
                                          return oldValue;
                                        }

                                        // Allow empty
                                        if (text.isEmpty) return newValue;

                                        // Allow only one dot
                                        if ('.'.allMatches(text).length > 1) {
                                          return oldValue;
                                        }

                                        return newValue;
                                      }),
                                    ],
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    style: TextStyle(
                                      fontSize: 60.sp,
                                      color: Colors.white,
                                    ),
                                    decoration: const InputDecoration(
                                      counter: SizedBox.shrink(),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      filled: false,
                                      hintText: '0',
                                      hintStyle: TextStyle(color: Colors.white),
                                    ),
                                    showCursor: false,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 10.h,
                        ),
                        child: Text(
                          "General",
                          style: TextStyle(fontSize: 18.sp),
                        ),
                      ),
                      Divider(height: 1, thickness: 0.5),
                      BlocBuilder<AddTransactionCubit, AddTransactionState>(
                        builder: (context, state) {
                          return ListTile(
                            leading: Icon(
                              Icons.category,
                              color: AppColors.grey,
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Category"),
                                BlocSelector<
                                  AddTransactionCubit,
                                  AddTransactionState,
                                  model.Category?
                                >(
                                  selector: (state) => state.selectedCategory,
                                  builder: (context, selectedCategory) {
                                    if (selectedCategory == null) {
                                      return SizedBox(width: 1, height: 1);
                                    }

                                    return Text(selectedCategory.name);
                                  },
                                ),
                              ],
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 16.sp,
                              color: AppColors.grey,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SelectCategoriesScreen(),
                                ),
                              );
                            },
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.w,
                            ),
                            tileColor: AppColors.white,
                          );
                        },
                      ),
                      Divider(height: 1, thickness: 0.5),
                      BlocSelector<
                        AddTransactionCubit,
                        AddTransactionState,
                        DateTime
                      >(
                        selector: (state) => state.dateTime,
                        builder: (context, date) {
                          return ListTile(
                            leading: Icon(
                              Icons.date_range,
                              color: AppColors.grey,
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Date"),
                                Text(date.toDateFormat_11jan2025()),
                              ],
                            ),
                            // subtitle: Text("today, 2:00"),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 16.sp,
                              color: AppColors.grey,
                            ),
                            onTap: () async {
                              changeDate(context, date);
                            },
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.w,
                            ),
                            tileColor: AppColors.white,
                          );
                        },
                      ),

                      Divider(height: 1, thickness: 0.5),
                    ],
                  ),
                ),
              ),
              SaveButton(onSaveCallBack: widget.onSaveCallBack),
            ],
          ),
        );
      },
    );
  }
}

class SaveButton extends StatefulWidget {
  const SaveButton({super.key, required this.onSaveCallBack});
  final void Function(int i) onSaveCallBack;

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: pressed ? AppColors.grey : AppColors.blue,
            ),
            onPressed: pressed
                ? null
                : () async {
                    setState(() {
                      pressed = true;
                    });
                    bool success = await context
                        .read<AddTransactionCubit>()
                        .saveTransaction();
                    // print("screen ${success}");
                    if (!mounted) return;
                    if (success) {
                      context
                          .read<TransactionsCubit>()
                          .refreshRecentTransactions();
                      Navigator.pop(context);
                      widget.onSaveCallBack(0);
                      return;
                    }
                    setState(() {
                      pressed = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Please enter a valid amount and select a category.",
                        ),
                      ),
                    );
                  },
            child: Text(
              "Save Transaction",
              style: TextStyle(fontSize: 18.sp, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

// Future<void> changeDate(BuildContext context, DateTime dateTime) async {
//   final selectedDate = await showRoundedDatePicker(
//     context: context,
//     initialDate: dateTime,
//     firstDate: DateTime(2000),
//     lastDate: DateTime(2100),
//     theme: ThemeData(
//       primaryColor: AppColors.red, // header background
//       colorScheme: ColorScheme.light(
//         primary: AppColors.red,
//         onPrimary: Colors.white,
//         onSurface: Colors.black,
//       ),
//       textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(
//           foregroundColor: AppColors.red, // buttons
//         ),
//       ),
//     ),
//     styleDatePicker: MaterialRoundedDatePickerStyle(
//       backgroundHeader: Colors.transparent,
//       //done
//       textStyleDayButton: const TextStyle(color: Colors.black, fontSize: 0),
//       textStyleYearButton: TextStyle(fontSize: 0),
//       //
//       textStyleDayHeader: TextStyle(color: AppColors.black),
//       textStyleMonthYearHeader: TextStyle(
//         color: AppColors.black,
//         fontSize: 16.sp,
//         fontWeight: FontWeight.bold,
//       ),

//       // textStyleButtonAction: TextStyle(fontSize: 0),
//       // textStyleCurrentDayOnCalendar: TextStyle(fontSize: 0),
//       // textStyleDayOnCalendar: TextStyle(fontSize: 0),
//       // textStyleDayOnCalendarSelected: TextStyle(fontSize: 0),
//       // textStyleDayOnCalendarDisabled: TextStyle(fontSize: 0),
//       // textStyleButtonNegative: TextStyle(fontSize: 0),
//       // textStyleButtonPositive: TextStyle(fontSize: 0),
//       backgroundPicker: Colors.white,
//       paddingDatePicker: EdgeInsets.all(0),
//       paddingActionBar: EdgeInsets.all(0),
//       paddingDateYearHeader: EdgeInsets.all(0),
//       paddingMonthHeader: EdgeInsets.all(0),
//       // sizeArrow: 5,
//       // paddingMonthHeader: const EdgeInsets.symmetric(vertical: 10),
//       // paddingActionBar: const EdgeInsets.all(10),
//     ),
//   );

//   if (selectedDate != null) {
//     context.read<AddTransactionCubit>().changeDate(selectedDate);
//   }
// }

Future<void> changeDate(BuildContext context, DateTime dateTime) async {
  DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: dateTime,
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
    initialDatePickerMode: DatePickerMode.day,
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    helpText: "",

    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.red, // header background
            onPrimary: Colors.white, // header text
            onSurface: Colors.black, // body text
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.red, // button color
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            // remove the text field
            border: InputBorder.none,
          ),
        ),
        child: child!,
      );
    },
  );

  if (selectedDate != null) {
    selectedDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      DateTime.now().hour,
      DateTime.now().minute,
      DateTime.now().second,
    );
    print("selected date: $selectedDate");
    context.read<AddTransactionCubit>().updateDate(selectedDate);
  }
}
