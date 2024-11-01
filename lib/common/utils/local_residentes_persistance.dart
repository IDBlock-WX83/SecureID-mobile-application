
class Resident {
  String name;
  String paternalSurname;
  String maternalSurname;
  String idDigital;
  String address;
  String phone;
  String birthDate;
  String profileImage; // Campo para la imagen de perfil

  Resident({
    required this.name,
    required this.paternalSurname,
    required this.maternalSurname,
    required this.idDigital,
    required this.address,
    required this.phone,
    required this.birthDate,
    required this.profileImage, // Inicializa el nuevo campo
  });
}


class LocalResidentPersistence {
  // Esta lista estática simula una base de datos local
  static List<Resident> residents = [
    Resident(
      name: 'Juan',
      paternalSurname: 'Pérez',
      maternalSurname: 'González',
      idDigital: '12345657',
      address: 'Av. Siempre Viva 742',
      phone: '987654321',
      birthDate: '01/01/1990',
      profileImage: 'assets/juan.jpg', // Ruta del asset de imagen
    ),
    Resident(
      name: 'María',
      paternalSurname: 'López',
      maternalSurname: 'Hernández',
      idDigital: '6543215665',
      address: 'Calle Girasoles 123',
      phone: '912345678',
      birthDate: '05/05/1985',
      profileImage: 'assets/maria.jpg', // Ruta del asset de imagen
    ),
    Resident(
      name: 'Carlos',
      paternalSurname: 'Gómez',
      maternalSurname: 'Ramírez',
      idDigital: '8745634123',
      address: 'Avenida Central 456',
      phone: '934567891',
      birthDate: '10/08/1978',
      profileImage: 'assets/carlos.jpg',
    ),
    Resident(
      name: 'Ana',
      paternalSurname: 'Martínez',
      maternalSurname: 'Castro',
      idDigital: '2134876590',
      address: 'Calle Luna 789',
      phone: '912356789',
      birthDate: '12/12/1990',
      profileImage: 'assets/ana.jpg',
    ),
    Resident(
      name: 'Luis',
      paternalSurname: 'Fernández',
      maternalSurname: 'Ortiz',
      idDigital: '3456782345',
      address: 'Calle Rosas 101',
      phone: '956789234',
      birthDate: '02/03/1982',
      profileImage: 'assets/luis.jpg',
    ),
    Resident(
      name: 'Elena',
      paternalSurname: 'Pérez',
      maternalSurname: 'Lara',
      idDigital: '8765123490',
      address: 'Calle del Sol 321',
      phone: '923456123',
      birthDate: '25/07/1989',
      profileImage: 'assets/elena.jpg',
    ),
    Resident(
      name: 'José',
      paternalSurname: 'Sánchez',
      maternalSurname: 'Medina',
      idDigital: '4321567890',
      address: 'Calle del Mar 200',
      phone: '945678345',
      birthDate: '30/01/1975',
      profileImage: 'assets/jose.jpg',
    ),
    Resident(
      name: 'Lucía',
      paternalSurname: 'Hernández',
      maternalSurname: 'Rivas',
      idDigital: '1983456723',
      address: 'Calle Flores 178',
      phone: '912345789',
      birthDate: '19/09/1992',
      profileImage: 'assets/lucia.jpg',
    ),
    Resident(
      name: 'Miguel',
      paternalSurname: 'Castillo',
      maternalSurname: 'Vega',
      idDigital: '6574832109',
      address: 'Avenida de los Olivos 300',
      phone: '932456789',
      birthDate: '15/06/1980',
      profileImage: 'assets/miguel.jpg',
    ),
    Resident(
      name: 'Sofía',
      paternalSurname: 'Morales',
      maternalSurname: 'Núñez',
      idDigital: '7654321890',
      address: 'Boulevard Norte 98',
      phone: '987654321',
      birthDate: '23/04/1993',
      profileImage: 'assets/sofia.jpg',
    ),
    Resident(
      name: 'Raúl',
      paternalSurname: 'Vázquez',
      maternalSurname: 'Díaz',
      idDigital: '1098765432',
      address: 'Calle Las Nubes 45',
      phone: '976543210',
      birthDate: '14/11/1986',
      profileImage: 'assets/raul.jpg',
    ),


  ];

  // Método para guardar o actualizar un residente
  static void saveResident(Resident resident) {
    // Busca si el residente ya existe en la lista
    int index = residents.indexWhere((r) => r.idDigital == resident.idDigital);

    if (index != -1) {
      // Si existe, lo actualiza
      residents[index] = resident;
    } else {
      // Si no existe, lo agrega
      residents.add(resident);
    }
  }

  // Método para obtener todos los residentes
  static List<Resident> getResidents() {
    return residents;
  }

  // Método para obtener un residente específico por su ID
  // Método para obtener un residente específico por su ID
  static Resident? getResidentById(String id) {
    try {
      return residents.firstWhere((r) => r.idDigital == id);
    } catch (e) {
      return null; // Si no se encuentra, retornar null
    }
  }


  // Método para eliminar un residente por su ID (opcional)
  static void deleteResident(String id) {
    residents.removeWhere((r) => r.idDigital == id);
  }
}
