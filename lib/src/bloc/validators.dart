
import 'dart:async';

class Validators {

  final validarEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink){

      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp( pattern );

      if( regExp.hasMatch( email )){
        sink.add( email );
      }else{
        sink.addError('EL correo no es correcto');
      }


    }

  );

  //Si la data no es transmitida por el sink, el snapshot data tendra null o el error
  final validarPassword = StreamTransformer<String, String>.fromHandlers(
    //El primer parametro es el flujo que emite el stream
    //El segundo parametro es un objeto que nos permite fluir la data como queramos
    handleData: ( password, sink ){

      if( password.length >= 6){
        sink.add( password );
      }else{
        sink.addError('Debe ser mayor a 6 caracteres');
      }

    }

  );

}