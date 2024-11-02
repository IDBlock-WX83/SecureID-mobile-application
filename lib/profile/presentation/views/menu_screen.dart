import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/common/utils/blockchain_record.dart';
import 'package:ztech_mobile_application/profile/presentation/views/transaction_history_screen.dart';

class MenuScreenAutoridades extends StatefulWidget {
  final Blockchain blockchain; // Propiedad para almacenar la instancia de Blockchain

  MenuScreenAutoridades({required this.blockchain}); // Modificar el constructor

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreenAutoridades> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00747C), // Color de fondo
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botón de Residentes
            MenuButton(
              label: 'Residentes',
              icon: Icons.people,
              onTap: () {
                // Aquí puedes agregar más lógica en el futuro
                Navigator.pushNamed(context, 'resident_screen');
                print('Residentes');
              },
            ),
            SizedBox(height: 20), // Espacio entre botones
            // Botón de Servicios
            MenuButton(
              label: 'Servicios',
              icon: Icons.build,
              onTap: () {
                // Aquí puedes agregar más lógica en el futuro
                print('Servicios');
              },
            ),
            SizedBox(height: 20), // Espacio entre botones
            // Botón de Historial de Transacciones
            MenuButton(
              label: 'Historial de Transacciones',
              icon: Icons.history,
              onTap: () {
                // Navegar a la pantalla de historial de transacciones y pasar la instancia de Blockchain
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionHistoryScreen(blockchain: widget.blockchain),
                  ),
                );

                print('Historial de Transacciones');
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para un botón de menú
class MenuButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  MenuButton({required this.label, required this.icon, required this.onTap});

  @override
  _MenuButtonState createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  bool _isPressed = false; // Estado del botón

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() {
        _isPressed = true; // Cambiar estado al presionar
      }),
      onTapUp: (_) => setState(() {
        _isPressed = false; // Cambiar estado al soltar
      }),
      onTapCancel: () => setState(() {
        _isPressed = false; // Cambiar estado si se cancela el toque
      }),
      onTap: widget.onTap, // Llamar a la función onTap proporcionada
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Margen alrededor del botón
        padding: EdgeInsets.symmetric(horizontal: 10), // Espacio dentro del botón
        decoration: BoxDecoration(
          color: _isPressed ? Color(0xFF00747C) : Color(0xFF005B5B), // Cambiar color al presionar
          borderRadius: BorderRadius.circular(8), // Bordes redondeados
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espacio entre texto e icono
          children: [
            Text(
              widget.label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(widget.icon, color: Colors.white, size: 30),
          ],
        ),
      ),
    );
  }
}
