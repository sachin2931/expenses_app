import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../model/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final Function deleteTX;
  const TransactionList(
      {super.key, required this.transaction, required this.deleteTX});
  final List<Transaction> transaction;

  // TransactionList(this.transaction);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      child: transaction.isEmpty
          ? LayoutBuilder(builder: (context, Constraints) {
              return Column(
                children: <Widget>[
                  RichText(
                      text: TextSpan(
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          children: [
                        TextSpan(text: 'No '),
                        TextSpan(
                          text: 'transaction',
                          style: TextStyle(
                              color: Colors.purple,
                              fontFamily: 'Quicksand',
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                            text: ' added',
                            style: TextStyle(
                                fontSize: 32,
                                color: Color.fromARGB(255, 4, 114, 145),
                                fontWeight: FontWeight.bold)),
                        TextSpan(text: ' yet!!'),
                      ])
                      //'No transaction yet!',
                      // style: Theme.of(context).textTheme.titleLarge,
                      ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: Constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            })
          : ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: FittedBox(
                          child: Text(
                              '\₹${transaction[index].amount.toStringAsFixed(2)}'),
                        ),
                      ),
                    ),
                    title: Text('${transaction[index].title}',
                        style: Theme.of(context).textTheme.titleLarge),
                    subtitle: Text(
                        '${DateFormat.yMMMd().format(transaction[index].date)}',
                        style: TextStyle(color: Colors.grey)),
                    trailing: MediaQuery.of(context).size.width > 400
                        ? TextButton.icon(
                            onPressed: () => deleteTX(transaction[index].id),
                            icon: Icon(Icons.delete),
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context).colorScheme.error)),
                            label: Text('Delete'))
                        : IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => deleteTX(transaction[index].id),
                            color: Theme.of(context).colorScheme.error,
                          ),
                  ),
                );
              },
              itemCount: transaction.length,
            ),
    );
  }
}

// Card(
//                 child: Row(
//                   children: [
//                     Container(
//                       margin: EdgeInsets.symmetric(
//                         vertical: 10,
//                         horizontal: 15,
//                       ),
//                       decoration: BoxDecoration(
//                           border: Border.all(
//                               color: Theme.of(context).primaryColor,
//                               width: 2)),
//                       padding: EdgeInsets.all(10),
//                       child: Text(
//                         '\₹${transaction[index].amount.toStringAsFixed(2)}', //₹
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20,
//                             color: Theme.of(context).primaryColor),
//                       ),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(transaction[index].title,
//                             style: Theme.of(context).textTheme.titleLarge),
//                         Text(
//                           DateFormat.yMMMd().format(transaction[index].date),
//                           style: TextStyle(color: Colors.grey),
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               );
