import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/contact.dart';

class ContactUtil {
  final _dbHelper = DatabaseHelper.instance;

  Future<void> addContact(
      {Contact? contact, required BuildContext context}) async {
    final nameController = TextEditingController(text: contact?.name ?? '');
    final emailController = TextEditingController(text: contact?.email ?? '');
    final phoneController = TextEditingController(text: contact?.phone ?? '');

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(contact == null ? 'Adicionar Contato' : 'Editar Contato'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome')),
            TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email')),
            TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Telefone')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              final newContact = Contact(
                id: contact?.id,
                name: nameController.text,
                email: emailController.text,
                phone: phoneController.text,
              );
              if (contact == null) {
                await _dbHelper.insertContact(newContact);
              } else {
                await _dbHelper.updateContact(newContact);
              }
              Navigator.pop(context);
            },
            child: Text(contact == null ? 'Adicionar' : 'Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> deleteContact(Contact contact) async {
    await _dbHelper.deleteContact(contact.id);
  }
}
