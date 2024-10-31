import 'package:finance_tracker/model/Budget.dart';
import 'package:flutter/material.dart';

class BudgetCard extends StatelessWidget {
  final Budget budget;
  const BudgetCard({super.key, required this.budget});
  @override
  Widget build(BuildContext context) {
    final spentAmount = budget.progress ?? 0;
    final remainingAmount = budget.amount - spentAmount;
    final progress = spentAmount / budget.amount;
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(
                      budget.name,
                      style: const TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      "Spent \$${spentAmount.toStringAsFixed(2)} of ${budget.amount}",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 50, 97, 116),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "\$${remainingAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation(
                  progress < 1
                      ? Theme.of(context).colorScheme.primary
                      : Colors.red,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
