import 'package:finance_tracker/controller/budgetController.dart';
import 'package:finance_tracker/view/widgets/budgetCard.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/model/Budget.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  List<Budget> budgets = [];
  bool isLoading = true; // For showing a loading indicator

  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  // Load budgets from API
  void _loadBudgets() async {
    try {
      final fetchedBudgets = await getBudgets();
      setState(() {
        budgets = fetchedBudgets;
        isLoading = false; // Stop loading indicator after data is fetched
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading indicator even if there's an error
      });
      // Optionally, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load budgets: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading spinner while fetching data
          : budgets.isEmpty
              ? const Center(child: Text("No budgets available"))
              : ListView.builder(
                  itemCount: budgets.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: BudgetCard(budget: budgets[index]),
                    );
                  },
                ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
            bottom: 12.0,
            right: 20,
            left: 20), // Add some padding for better appearance
        child: TextButton(
          onPressed: () {
            // Add a new budget
          },
          style: TextButton.styleFrom(
            backgroundColor: const Color.fromRGBO(232, 238, 242, 2),
            minimumSize: const Size(double.infinity, 40),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(15.0), // Adjust the radius as needed
            ),
          ),
          child: const Text(
            "Add a Budget",
            style: TextStyle(
                color: Color.fromARGB(255, 49, 49, 49),
                fontWeight: FontWeight.w600,
                fontSize: 17),
          ),
        ),
      ),
    );
  }
}
