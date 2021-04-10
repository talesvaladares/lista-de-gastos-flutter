import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;

  TransactionForm(this.onSubmit);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final titleController = TextEditingController();
  final valueController = TextEditingController();
  DateTime selecetedDate = DateTime.now();

  _submitForm() {
    final title = titleController.text;
    final value = double.tryParse(valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0 || selecetedDate == null) {
      return;
    }

    widget.onSubmit(title, value, selecetedDate);
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((dateSelected) {
      if (dateSelected == null) return;
      setState(() {
        selecetedDate = dateSelected;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                //quando o usuario apertar ok no teclado
                //onSumitted vai chamar a função _submitForm para cadastarr uma nova transaction
                //a notação de (_) siginifica que recebemos um parametro mas não o usamos
                onSubmitted: (_) => _submitForm(),
                decoration: InputDecoration(labelText: "Título"),
              ),
              TextField(
                controller: valueController,
                onSubmitted: (_) => _submitForm(),
                decoration: InputDecoration(labelText: "Valor(R\$)"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    //Componente faz o seu filho pegar todo o espaço disponivel
                    Expanded(
                      child: Text(
                        selecetedDate == null
                            ? "Nenhuma data selecionada."
                            : 'Data selecionada: ${DateFormat('dd/MM/y').format(selecetedDate)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    TextButton(
                      child: Text(
                        "Selecionar data",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: _showDatePicker,
                    )
                  ],
                ),
              ),
              ElevatedButton(
                child: Text("Nova transação"),
                style: ElevatedButton.styleFrom(primary: Colors.purple),
                onPressed: _submitForm,
              )
            ],
          ),
        ),
      ),
    );
  }
}
