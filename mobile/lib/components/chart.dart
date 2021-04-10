import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import './chartBar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);
  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));

      double sumTotal = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        bool sameDay = recentTransactions[i].date.day == weekDay.day;
        bool sameMonth = recentTransactions[i].date.month == weekDay.month;
        bool sameYear = recentTransactions[i].date.year == weekDay.year;

        if (sameMonth && sameDay && sameYear) {
          sumTotal += recentTransactions[i].value;
        }
      }

      return {'day': DateFormat.E().format(weekDay)[0], 'value': sumTotal};
    }).reversed.toList(); //inverte o valor da lista
  }

  double get _weekTotalValue {
    // semelhanate a um reduce do javascript
    // soma o valor total gasto durante toda a semana
    return groupedTransactions.fold(0.0, (sum, transaction) {
      return sum + transaction['value'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((transaction) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: transaction['day'],
                value: transaction['value'],
                //pega o valor gasto em um dia e dividite pelo total gasto na semana
                //assim tenho o porcentagme gasta do valor do total
                percentage:
                    ((transaction['value'] as double) / _weekTotalValue),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
