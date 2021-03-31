
import 'dart:async';

import 'package:formvalidation/src/bloc/validators.dart';

import 'package:rxdart/rxdart.dart';

//Aqui podemos agregar los validators personalizados para los stream
class LoginBloc with Validators{

//Libreria rx con el patron observable
//Por defecto funciona con el metodo brodcoast() para varios widget a la vez
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //Escuhar datos emitodos por el stream
  //AL agregar un transform podemos establecer las validaciones personalizadas
  Stream<String> get emailStream => _emailController.stream.transform( validarEmail );
  Stream<String> get passwordStream => _passwordController.stream.transform( validarPassword );
  
  //Crear metodos para insertar valores al stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //Observar 2 streams a la vez
  //Cuando los 2 flujos de stream son validos se activara este stream
  Stream<bool> get formValidStream =>
    Rx.combineLatest2( emailStream , passwordStream, (email, password ) => true);

//El objecto BehaviorSubjec tinene en como propiedad el ultimo valor emitido
String get emailValue => _emailController.value;
String get passwordValue => _passwordController.value;

//Siempre sera necesario declarar el metodo que cerrara el flujo de los stream
  dispose(){
    _emailController?.close();
    _passwordController?.close();

  }

}