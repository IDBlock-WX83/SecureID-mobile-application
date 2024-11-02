import 'package:flutter/material.dart';
import 'package:ztech_mobile_application/common/utils/local_residentes_persistance.dart';
import 'package:ztech_mobile_application/common/utils/blockchain_record.dart'; // Importa la clase Blockchain
import 'package:ztech_mobile_application/profile/presentation/views/resident_detail_screen.dart';

class ResidentsScreen extends StatefulWidget {
  @override
  _ResidentsScreenState createState() => _ResidentsScreenState();
}

class _ResidentsScreenState extends State<ResidentsScreen> {
  String searchQuery = '';
  final Blockchain blockchain = Blockchain(); // Instancia de Blockchain

  @override
  Widget build(BuildContext context) {
    List<Resident> residents = LocalResidentPersistence.getResidents();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Residentes'),
        backgroundColor: Color(0xFF00C2CB), // Color de fondo
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Buscar por DNI',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            if (searchQuery.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: residents.length,
                  itemBuilder: (context, index) {
                    if (!residents[index].idDigital.contains(searchQuery)) {
                      return Container();
                    }

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(residents[index].profileImage),
                      ),
                      title: Text('${residents[index].name} ${residents[index].paternalSurname}'),
                      subtitle: Text('DNI: ${residents[index].idDigital}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResidentDetailScreen(
                              resident: residents[index],
                              blockchain: blockchain, // Pasar la instancia de blockchain
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
