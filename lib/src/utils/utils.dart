
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool isNumeric( String valor ){

  if( valor.isEmpty) return false;

  final n = num.tryParse( valor );

  return ( n == null ) ? false : true;

}


void mostrarAlerta(BuildContext context, String titulo, String mensaje){

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text( titulo ),
        content: Text( mensaje),
        actions: <Widget>[
          FlatButton(
            onPressed: ()=> Navigator.of(context).pop(),
            child: Text('Entendido')
             )
        ],
      );
    }
    );


}