
 class Usuario{

   String id;
   String celular;
   String password;
   String nombre;
   String apellidoP;
   String apellidoM;
   String sangreTipo;
   String nss;
   String grua;

   Usuario.fromJson( Map<String, dynamic> jsonString ){

    id = jsonString['id'];
    celular = jsonString['celular'];
    password = jsonString['password'];
    nombre = jsonString['nombre'];
    apellidoP= jsonString['apellidop'];
    apellidoM = jsonString['apellidom'];
    sangreTipo = jsonString['tipo'];
    nss = jsonString['nss'];
    grua = jsonString['grua'];

   }

}