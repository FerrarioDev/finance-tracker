import 'package:finance_tracker/controller/categoryController.dart';
import 'package:finance_tracker/controller/transactionsController.dart';
import 'package:finance_tracker/model/Category.dart';
import 'package:finance_tracker/model/Transaction.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddTransactionModal extends StatefulWidget {
  final Function(Transaction) onTransactionAdded;
  const AddTransactionModal({super.key, required this.onTransactionAdded});

  @override
  _AddTransactionModalState createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<AddTransactionModal> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // Default values for date and category
  DateTime selectedDate = DateTime.now();
  String selectedCategory = 'Groceries';
  int selectedTransactionIndex = 0; // 0: Income, 1: Expense, 2: Transfer
  List<MyCategory> categories = [];

  // Date picker function
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Category selector placeholder
  void _selectCategory() async {
    try {
      List<MyCategory> fetchedCategories =
          await getCategoryByType(CategoryType.TRANSACTION);
      setState(() {
        categories = fetchedCategories;
      });
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Select Category"),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(categories[index].name),
                    onTap: () {
                      setState(() {
                        selectedCategory = categories[index].name;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          );
        },
      );
    } catch (e) {
      print("Failed to load categories: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load categories.')),
      );
    }
  }

  // Placeholder for save transaction logic
  void _saveTransaction() {
    double? amount = double.tryParse(_amountController.text);

    if (amount == null) {
      // Show an error message or handle the invalid amount case
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount.')),
      );
      return; // Exit the method if the amount is invalid
    }

    TransactionType transactionType;

    switch (selectedTransactionIndex) {
      case 0:
        transactionType = TransactionType.INCOME;
        break;
      case 1:
        transactionType = TransactionType.EXPENSE;
        break;
      case 2:
        transactionType = TransactionType.TRANSFER;
        break;
      default:
        transactionType = TransactionType.EXPENSE;
    }

    Transaction transaction = Transaction(
      userId: 3,
      categoryId: 41,
      amount: amount,
      transactionType: transactionType,
      transactionDate: selectedDate,
      description: _descriptionController.text,
    );

    createTransaction(transaction);
    widget.onTransactionAdded(transaction);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title input
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 20),

            // Amount input
            TextField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Amount",
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 20),

            // Row for Date and Category buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Date Icon Button
                IconButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  icon: const Icon(Icons.calendar_today),
                  tooltip: 'Change Date',
                ),

                // Category Icon Button
                IconButton(
                  onPressed: _selectCategory,
                  icon: const Icon(Icons.category),
                  tooltip: 'Change Category',
                ),
                const Spacer(),
                ToggleButtons(
                  borderRadius: BorderRadius.circular(30.0),
                  isSelected: [
                    selectedTransactionIndex == 0,
                    selectedTransactionIndex == 1,
                    selectedTransactionIndex == 2,
                  ],
                  onPressed: (int index) {
                    setState(() {
                      selectedTransactionIndex = index;
                    });
                  },
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(Icons.arrow_circle_up,
                          color: Colors.green), // Income Icon
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(Icons.arrow_circle_down,
                          color: Colors.red), // Expense Icon
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(Icons.swap_horiz,
                          color: Colors.blue), // Transfer Icon
                    ),
                  ],
                ),

                Spacer(),

                ElevatedButton(
                  onPressed: () {
                    _saveTransaction();
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
            // Save button
          ],
        ),
      ),
    );
  }
}
