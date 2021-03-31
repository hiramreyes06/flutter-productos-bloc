import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/login_bloc.dart';
import 'package:formvalidation/src/bloc/productos_bloc.dart';

//De esta forma podemos exportar la clase desde el provider y usarla
export 'package:formvalidation/src/bloc/login_bloc.dart';

//Con esta clase vamos a poder manejar la informacion en toda mi apliacion
class Provider extends InheritedTheme{

  final loginBloc = LoginBloc();

  final _productosBloc = ProductosBloc();

  static Provider _instancia;

  //De esta forma restringimos que la clase sea instanceada fuera de la clase
   Provider._internal( { Key key, Widget child })
  : super( key: key, child: child );

  //El proposito del factory es determinar si ya existe una instancea
    factory Provider({ Key key, Widget child }){

      if( _instancia == null ){
        _instancia = new Provider._internal( key:  key, child: child );
      }

      return _instancia;

    }

  

  //Este metodo es una condicion para establecer si se tendra que 
  //Notificar a los hijos si ocurre un cambio
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;



//Con la instancea del provider , podremos agregar como parametro el widget Padre o principal
  // Provider( { Key key, Widget child })
  // : super( key: key, child: child );
  
  //Para obtner la instancea de un bloc con el estado que tenga la instancea
  static LoginBloc of ( BuildContext context ){
    /*
    Esto lo que hace es buscar en el contexto, el arbol de widgets y va a buscar
    Esta misma clase del provider y retornara la instancea que del login bloc
    */
   return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
}


  //De esta forma tenemos 2 bloc para el provider principal
  static ProductosBloc productosBloc  ( BuildContext context ){
   return context.dependOnInheritedWidgetOfExactType<Provider>()._productosBloc;
}

    @override
    Widget wrap(BuildContext context, Widget child) {
    // TODO: implement wrap
    throw UnimplementedError();
  }

  


}