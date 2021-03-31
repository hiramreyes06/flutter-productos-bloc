
import 'dart:convert';
import 'dart:io';

import 'package:formvalidation/src/preferenciasDeUsuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:formvalidation/src/modelos/producto_model.dart';

//Para extraer la exrension de los archivos 
import 'package:mime_type/mime_type.dart';

class ProductosProvider{

//Establecemos el rul base que se neceitara en todas las acciones
final String _urlFirebase = 'https://productosflutter-f74ae-default-rtdb.firebaseio.com';

final _prefs = new PreferenciasUsuario();


 Future<bool> crearProducto( ProductoModel producto ) async {

  final url = '$_urlFirebase/productos.json?auth=${ _prefs.token }';

  //Necesitamos enviar el modelo en formato json
  final resp = await  http.post( url , body: productoModelToJson( producto ) );

  final decodedData = jsonDecode( resp.body );
  
  print( decodedData );

  return true;

  }

  Future<bool> editarProducto( ProductoModel producto ) async {

  final url = '$_urlFirebase/productos/${producto.id}.json?auth=${ _prefs.token }';

  //Necesitamos enviar el modelo en formato json
  final resp = await  http.put( url , body: productoModelToJson( producto ) );

  final decodedData = jsonDecode( resp.body );
  
  print( decodedData );

  return true;

  }


  Future<List<ProductoModel>> cargarProductos() async {

    final url = '$_urlFirebase/productos.json?auth=${ _prefs.token }';
    final resp = await http.get(url);

    final Map<String,dynamic> decodedData = json.decode( resp.body );
    final List<ProductoModel>  productos = new List();

    print(decodedData);

    if ( decodedData == null ) return [];

    //Apartir de aqui podemos validar si el token expiro para retornarlo al login
    if ( decodedData['error'] != null ) return [];

    decodedData.forEach(( id, producto) {

      final prodTemp = ProductoModel.fromJson( producto );
      prodTemp.id = id;

      productos.add( prodTemp );

    });

    print(productos);

    return productos;


  }

  Future<bool> eliminarProducto( String id) async {



    final url = '$_urlFirebase/productos/$id.json?auth=${ _prefs.token }';

    final resp = await http.delete(url);

    print(  resp.body );

    return true;

  }


  Future<String> subirImagen( File imagen) async{

    final url = Uri.parse('https://api.cloudinary.com/v1_1/hiramreyes06/image/upload?upload_preset=flutterApp');

    final  mimeType = mime( imagen.path ).split('/');

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath(
      'file', 
     imagen.path,
     contentType: MediaType( mimeType[0], mimeType[1] )
    );

    imageUploadRequest.files.add(file);

  final streamRespose = await imageUploadRequest.send();

  final resp = await http.Response.fromStream( streamRespose );

  if( resp.statusCode != 200 && resp.statusCode != 201){
    print('Algo salio mal ${resp.body}');
    return null;
  }

  final respData = json.decode( resp.body );
  print('Response del cloudinary $respData');

  return respData['secure_url'];


  }


}