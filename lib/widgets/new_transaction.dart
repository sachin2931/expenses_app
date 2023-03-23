import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTX;

  NewTransaction(this.addTX);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleControler = TextEditingController();
  final amountControler = TextEditingController();
  DateTime? selectedDate;
  void submitData() {
    if (amountControler.text.isEmpty) {
      return;
    }
    final enteredTitle = titleControler.text;
    final enteredAmount = double.parse(amountControler.text);

    // var isEmpty = null;
    if (enteredTitle.isEmpty || enteredAmount <= 0 || selectedDate == null) {
      return;
    }
    widget.addTX(enteredTitle, enteredAmount, selectedDate);

    Navigator.of(context).pop();
  }

  void presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: titleControler,
                keyboardType: TextInputType.text,
                onSubmitted: (_) => submitData(),
                // onChanged: (value) {
                //   titleInput = value;
                // },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                //onChanged: (value) => amountInput = value,
                controller: amountControler,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(selectedDate == null
                        ? 'No date chosen!'
                        : 'Picked Date: ${DateFormat.yMd().format(selectedDate!)}'),
                  ),
                  TextButton(
                      onPressed: presentDatePicker,
                      child: Text(
                        'choose date',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  submitData();
                },
                child: Text(
                  'Add Transaction',
                  style: TextStyle(fontFamily: 'Quicksand'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
