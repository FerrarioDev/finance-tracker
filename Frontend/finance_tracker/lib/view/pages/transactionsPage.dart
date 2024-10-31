import 'package:finance_tracker/controller/transactionsController.dart';
import 'package:finance_tracker/model/Transaction.dart';
import 'package:finance_tracker/view/widgets/AddTransactionModal.dart';
import 'package:finance_tracker/view/widgets/transactionsList.dart';
import 'package:flutter/material.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  TransactionType selectedFilter = TransactionType.ALL; // Default filter is ALL
  List<Transaction> transactions = [];
  List<Transaction> filteredTransactions = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    // Fetch initial transactions
    _loadTransactions();
  }

  void _loadTransactions() async {
    setState(() {
      loading = true; // Start loading
    });

    final fetchedTransactions = await getTransactions();

    setState(() {
      transactions = fetchedTransactions;
      _applyFilter();
      loading = false; // End loading
    });
  }

  // Apply the filter based on the selected transaction type
  void _applyFilter() {
    setState(() {
      if (selectedFilter == TransactionType.ALL) {
        filteredTransactions = transactions;
      } else {
        filteredTransactions = transactions.where((transaction) {
          return transaction.transactionType.index ==
              selectedFilter.index; // Assuming 'type' is a string like "INCOME"
        }).toList();
      }
    });
  }

  void _showAddTransactionModal(BuildContext context) async {
    final newTransaction = await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the modal full height
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return AddTransactionModal(
          onTransactionAdded: (Transaction newTransaction) {
            // Update transactions list and refresh UI
            setState(() {
              transactions
                  .add(newTransaction); // Add new transaction to the list
              _applyFilter(); // Apply the filter again after adding a new transaction
            });
          },
        );
      },
    );

    if (newTransaction != null) {
      setState(() {
        transactions.add(newTransaction);
        _applyFilter();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: loading
            ? const CircularProgressIndicator() // Show loading indicator
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: TransactionType.values.map((type) {
                      String filterLabel;
                      switch (type) {
                        case TransactionType.ALL:
                          filterLabel = "All";
                          break;
                        case TransactionType.EXPENSE:
                          filterLabel = "Expenses";
                          break;
                        case TransactionType.INCOME:
                          filterLabel = "Income";
                          break;
                        case TransactionType.TRANSFER:
                          filterLabel = "Transfers";
                          break;
                      }

                      return ChoiceChip(
                        label: Text(filterLabel),
                        selected: selectedFilter == type,
                        onSelected: (bool selected) {
                          if (selected) {
                            setState(() {
                              selectedFilter = type;
                              _applyFilter();
                            });
                          }
                        },
                        backgroundColor: Colors.grey[10],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(
                            color: selectedFilter == type
                                ? Colors.blue
                                : const Color.fromARGB(255, 204, 204, 204),
                            width: 1.0,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  TransactionsList(
                    transactions: filteredTransactions,
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
