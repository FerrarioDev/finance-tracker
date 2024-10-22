import 'package:flutter/material.dart';
import 'package:finance_tracker/model/Transaction.dart';

class TransactionsList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionsList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(child: Text('No transactions available'));
    }

    return Expanded(
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Container(
            height: 80,
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(transaction.description),
                  Text("\$${transaction.amount.toString()}"),
                ],
              ),
              subtitle: Text(
                "${transaction.transactionDate.toLocal()}".split(' ')[0],
                style: const TextStyle(color: Color.fromARGB(255, 50, 97, 116)),
              ),
            ),
          );
        },
      ),
    );
  }
}
