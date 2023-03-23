import 'dart:io';
import 'package:expenses_app/widgets/chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import './widgets/new_transaction.dart';
import './model/transaction.dart';
import 'package:flutter/material.dart';
import './widgets/transaction_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expenses',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 20,
                  fontWeight: FontWeight.bold))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // late String titleInput;

  final titleControler = TextEditingController();
  final amountControler = TextEditingController();

  final List<Transaction> _userTransaction = [
    // Transaction(
    //     id: 't1', title: 'T-Shirt', amount: 55.99, date: DateTime.now()),
    // Transaction(id: 't2', title: 'Shoes', amount: 99.99, date: DateTime.now()),
    // Transaction(id: 't3', title: 'Watch', amount: 89.88, date: DateTime.now()),
  ];
  bool showChart = false;
  List<Transaction> get _recentTransaction {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void addnewtransaction(String txTitle, double txAmount, DateTime chosenDate) {
    final newTX = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
    );

    setState(() {
      _userTransaction.add(newTX);
    });
  }

  void startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return NewTransaction(addnewtransaction);
        });
  }

  void deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final landScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final PreferredSizeWidget appbar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Expenses',
              // style: TextStyle(fontFamily: 'OpenSans'),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            // backgroundColor: Colors.red,
            title: Center(
                child: Text(
              'Expenses',
              // style: TextStyle(fontFamily: 'OpenSans'),
            )),
            actions: <Widget>[
              IconButton(
                  onPressed: () => startAddNewTransaction(context),
                  icon: Icon(
                    Icons.add,
                    // color: Colors.pink[100],
                    // size: 30.0,
                  ))
            ],
          ) as PreferredSizeWidget;
    final TXlist = Container(
      height: (MediaQuery.of(context).size.height -
              appbar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.7,
      child: TransactionList(
        transaction: _userTransaction,
        deleteTX: deleteTransaction,
      ),
    );
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            if (landScape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Show Chart',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Switch.adaptive(
                      activeColor: Theme.of(context).colorScheme.secondary,
                      value: showChart,
                      onChanged: (val) {
                        setState(() {
                          showChart = val;
                        });
                      })
                ],
              ),
            if (!landScape)
              Container(
                  height: (MediaQuery.of(context).size.height -
                          appbar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.3,
                  child: Chart(_recentTransaction)),
            if (!landScape) TXlist,
            if (landScape)
              showChart
                  ? Container(
                      height: (MediaQuery.of(context).size.height -
                              appbar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.7,
                      child: Chart(_recentTransaction))
                  : TXlist
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appbar as ObstructingPreferredSizeWidget,
          )
        : Scaffold(
            appBar: appbar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => startAddNewTransaction(context),
                    child: Icon(Icons.add),
                  ),
          );
  }
}
