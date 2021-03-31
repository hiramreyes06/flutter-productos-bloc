import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/paginas/home_page.dart';
import 'package:formvalidation/src/paginas/login_page.dart';
import 'package:formvalidation/src/paginas/producto_page.dart';
import 'package:formvalidation/src/paginas/registro_page.dart';

import 'src/preferenciasDeUsuario/preferencias_usuario.dart';
 
void main() async{
 //Esto soluciona el problema de inicializar las preferencias del usuario al iniciar la aplicacion
  WidgetsFlutterBinding.ensureInitialized();

  //Esto bloquea la rotacion de la pantalla del usuario
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

 
  final _prefs = new PreferenciasUsuario();
  await _prefs.initPrefs();

runApp(MyApp());

} 
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final _prefs = new PreferenciasUsuario();

    print('El token es ${_prefs.token}');
    //De esta forma le establecemos al provider el widget padre de la aplicacion
    //para poder manejar data a traves del arbol de widgets
    return Provider(
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplicacion de prueba',
      //De esta forma validamos si hay un token guardado para mostrar una pagina
      //  _prefs.token != '' ? 'home' : 'login
      initialRoute: 'login',
      routes: {
        'login': ( BuildContext context ) => LoginPage(),
        'home':  ( BuildContext context ) => HomePage(),
        'producto' : ( BuildContext context ) => ProductoPage(),
        'registro': ( BuildContext context ) => RegistroPage()
      },
      //De esta forma cambiamos el color por defecto de todos los label text de text fiel
      theme: ThemeData(
        primaryColor: Colors.orange
      ),
      )
    );
     
  }
}