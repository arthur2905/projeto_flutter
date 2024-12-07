import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/contact.dart';
import '../utils/contact_util.dart';

class ContactScreen extends StatefulWidget {
  final Contact contact;

  const ContactScreen({super.key, required this.contact});

  @override
  ContactScreenState createState() => ContactScreenState();
}

class ContactScreenState extends State<ContactScreen> {
  final _dbHelper = DatabaseHelper.instance;
  final _contactUtil = ContactUtil();
  late Contact _contact;

  @override
  void initState() {
    super.initState();
    _contact = widget.contact;
  }

  Widget _buildInfoSection(String title, String info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            info,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  void _loadInfos() async {
    Contact contact = await _dbHelper.getContact(_contact.id);
    setState(() {
      _contact = contact;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoSection('Nome', _contact.name),
            const SizedBox(height: 24),
            _buildInfoSection('Email', _contact.email),
            const SizedBox(height: 24),
            _buildInfoSection('Telefone', _contact.phone),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
            IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async => {
                      await _contactUtil.addContact(
                          contact: _contact, context: context),
                      _loadInfos(),
                    }),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async => {
                await _contactUtil.deleteContact(_contact),
                Navigator.pop(context),
              },
            ),
          ])),
    );
  }
}

class GradientLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.grey.withOpacity(0.3),
          Colors.grey,
          Colors.grey.withOpacity(0.3),
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Desenhar a linha
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
