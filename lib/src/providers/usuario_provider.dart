
import 'dart:convert';

import 'package:formvalidation/src/modelos/usuario.dart';
import 'package:formvalidation/src/preferenciasDeUsuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;


class UsuarioProvider{

  final String _firebaseKey = 'AIzaSyA7396-NjK8vIlo0vu2LmmR0jzW9i9QkQo';

  final _prefs = new PreferenciasUsuario();


  Future<Map<String, dynamic>> nuevoUsuaro( String email, String password ) async{

    final authData = {
      'email' : email,
      'password' : password,
      'returnSecureToken': true
    };

  final resp = await http.post(
    'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseKey',
    body: json.encode( authData )
  );

  Map<String, dynamic> decodedResp = json.decode( resp.body );

  print( decodedResp );

    if( decodedResp.containsKey('idToken')){
      //De esta forma guardamos el token en el dispositivo
      _prefs.token = decodedResp['idToken'];

      return { 
        'ok': true,
       'token' : decodedResp['idToken']
       };
    }else{

      return {
        'ok' : false,
        'mensaje': decodedResp['error']['message']
      };
    }

  }

Future<Map<String, dynamic>> loginUsuario( String email, String password ) async{

    final authData = {
      'email' : email,
      'password' : password,
      'returnSecureToken': true
    };

  final resp = await http.post(
    'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseKey',
    body: json.encode( authData )
  );

  Map<String, dynamic> decodedResp = json.decode( resp.body );

  print( decodedResp );

    if( decodedResp.containsKey('idToken')){

      _prefs.token = decodedResp['idToken'];
      return { 
        'ok': true,
       'token' : decodedResp['idToken']
       };
    }else{

      return {
        'ok' : false,
        'mensaje': decodedResp['error']['message']
      };
    }

  }
//   Future iniciarSesion( int telefono , String password) async{
 
    
//  final  resp = await http.get('https://operadores.corporativogysa.com/dao/session_dao.php?action=1&telefono=3310728145&password=12345');

//   // _phpSesion = resp.headers['set-cookie'];

  

//   //print('Todos los headers $_phpSesion',);

//  // resp.headers.forEach((key, value) { print('La cookie $headers' ); });
//   //resp.headers.values.forEach((element) {print(element); });
//   print('COmpleto $_phpSesion ');
//  print(' La cookieee de php es ---- ${_phpSesionId()}') ;

//   if( resp.body == 'ok' ){

  

//     Map<String, String> headers = {
//       'log_operador' :  _phpSesion
//     };

//     final usuarioResp  = await http.get('https://operadores.corporativogysa.com/dao/session_dao.php?action=3', headers: headers);

//     final jsonString = json.decode( usuarioResp.body );

//     print('EL usuario rope ${jsonString.toString()}');


//   }else{



//   }
    

//   }

//   String _phpSesionId(){

//     return _phpSesion.substring(10,36);

//   }

 


}