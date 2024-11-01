import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:ztech_mobile_application/common/utils/blockchain_record.dart';
import 'package:ztech_mobile_application/common/utils/local_residentes_persistance.dart';

class ResidentDetailScreen extends StatefulWidget {
  final Resident resident;
  final Blockchain blockchain; // Agregar el parámetro

  ResidentDetailScreen({required this.resident, required this.blockchain}); // Modificar el constructor

  @override
  _ResidentDetailScreenState createState() => _ResidentDetailScreenState();
}

class _ResidentDetailScreenState extends State<ResidentDetailScreen> {
  late TextEditingController _nameController;
  late TextEditingController _paternalSurnameController;
  late TextEditingController _maternalSurnameController;
  late TextEditingController _idDigitalController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _birthDateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.resident.name);
    _paternalSurnameController = TextEditingController(text: widget.resident.paternalSurname);
    _maternalSurnameController = TextEditingController(text: widget.resident.maternalSurname);
    _idDigitalController = TextEditingController(text: widget.resident.idDigital);
    _addressController = TextEditingController(text: widget.resident.address);
    _phoneController = TextEditingController(text: widget.resident.phone);
    _birthDateController = TextEditingController(text: widget.resident.birthDate);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _paternalSurnameController.dispose();
    _maternalSurnameController.dispose();
    _idDigitalController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    Resident updatedResident = Resident(
      name: _nameController.text,
      paternalSurname: _paternalSurnameController.text,
      maternalSurname: _maternalSurnameController.text,
      idDigital: _idDigitalController.text,
      address: _addressController.text,
      phone: _phoneController.text,
      birthDate: _birthDateController.text,
      profileImage: widget.resident.profileImage,
    );

    // Convertir los datos a un String JSON para generar un hash único
    String dataString = jsonEncode({
      'name': updatedResident.name,
      'paternalSurname': updatedResident.paternalSurname,
      'maternalSurname': updatedResident.maternalSurname,
      'idDigital': updatedResident.idDigital,
      'address': updatedResident.address,
      'phone': updatedResident.phone,
      'birthDate': updatedResident.birthDate,
    });

    // Generar el hash SHA256
    String transactionHash = sha256.convert(utf8.encode(dataString)).toString();

    // Agregar un nuevo bloque a la blockchain
    final blockchain = Blockchain();
    blockchain.addBlock(transactionHash);

    // Guardar el residente actualizado
    LocalResidentPersistence.saveResident(updatedResident);

    Navigator.pop(context); // Regresar a la pantalla anterior
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Residente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage(widget.resident.profileImage),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombres'),
            ),
            TextField(
              controller: _paternalSurnameController,
              decoration: InputDecoration(labelText: 'Apellido Paterno'),
            ),
            TextField(
              controller: _maternalSurnameController,
              decoration: InputDecoration(labelText: 'Apellido Materno'),
            ),
            TextField(
              controller: _idDigitalController,
              decoration: InputDecoration(labelText: 'ID Digital'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Dirección'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Teléfono'),
            ),
            TextField(
              controller: _birthDateController,
              decoration: InputDecoration(labelText: 'Fecha de Nacimiento'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
