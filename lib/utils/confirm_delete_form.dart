import 'package:flutter/material.dart';
import 'package:tcc_app/models/financial_form_data_model.dart';
import 'package:tcc_app/services/db_helper.dart';
import 'package:tcc_app/services/financial_data_service.dart';

Future<void> confirmDelete(FinancialFormData data, context) async {
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Apagar?'),
      content: const Text('Deseja realmente deletar este item?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Deletar'),
        ),
      ],
    ),
  );

  if (shouldDelete == true) {
    final db = await DbHelper.instance.database;
    if (data.id != null) {
      await db.delete('expenses', where: 'id = ?', whereArgs: [data.id]);
      await FinancialDataService.instance.refresh();
    }
  }
}
