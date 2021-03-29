import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Expenses',
      theme: ThemeData(
         
          primarySwatch: Colors.green,
          accentColor: Colors.amber,
          // errorColor: Colors.red,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                button: TextStyle(color: Colors.white),
              ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 16.53,
    //   date: DateTime.now(),
    // ),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
   final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape  ;
    final PreferredSizeWidget appBar =Platform.isIOS ?CupertinoNavigationBar(
       middle: Text (
         'My Expenses'
       ),
       trailing: Row(
         mainAxisSize: MainAxisSize.min,
       children: [
         GestureDetector(
         child : Icon(CupertinoIcons.add),
         onTap: () => _startAddNewTransaction(context),

         ),
       ],

       ),
    ) 
    :  AppBar(
        title: Text(
          'My Expenses',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startAddNewTransaction(context),
          ),
        ],
      );
     final txListWidget = Container(
              height: (MediaQuery.of(context).size.height-
              appBar.preferredSize.height
              -MediaQuery.of(context).padding.top
              )*0.8,
     

              child: TransactionList(_userTransactions, _deleteTransaction));

    final pageBody =SafeArea( child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: <Widget>[
           if (isLandscape)  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children :<Widget> [
              Text('Show Chart',style: Theme.of(context).textTheme.headline6,),
              Switch.adaptive(value: _showChart, onChanged: (val){
                setState(() {
                _showChart = val;
                                });

              },
              
              ),
              ],
            ),
            if (!isLandscape) Container(
              height: (MediaQuery.of(context).size.height-
              appBar.preferredSize.height -MediaQuery.of(context).padding.top
              )*0.2,
              child: Chart(_recentTransactions)),
              if(!isLandscape) txListWidget,

              if(isLandscape)_showChart ? Container(
              height: (MediaQuery.of(context).size.height-
              appBar.preferredSize.height -MediaQuery.of(context).padding.top
              )*0.5,
              child: Chart(_recentTransactions))
              :txListWidget
             
          ],
        ),
    ),
      ); 
    return Platform.isIOS ?CupertinoPageScaffold(child: pageBody, navigationBar: appBar,) : Scaffold(
      appBar:appBar,
      
      body: pageBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
      ? Container()
      :
      FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
 