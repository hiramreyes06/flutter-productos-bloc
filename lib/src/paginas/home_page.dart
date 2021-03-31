

import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/productos_bloc.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/modelos/producto_model.dart';



class HomePage extends StatefulWidget {

//Es necesario convertir a statefulwidget para que al editar se actualice el elemento
  @override
  _HomePageState createState() => _HomePageState();
}

final scaffoldKey = GlobalKey<ScaffoldState>();

class _HomePageState extends State<HomePage> {

 
  /*
  Por la implementacion del bloc con el provider de los producos ya no se 
  necesitara una sola instancea del provider de los productos, ya que se ]
  manejara con el bloc
  */
  // final productosProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {

    final productosBloc = Provider.productosBloc(context);

    productosBloc.cargarProductos();



    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Home'),
      ),

      body: _crearListadoStream(productosBloc),
      floatingActionButton: _crearBoton( context ),
    );
  }

  Widget _crearListadoStream( ProductosBloc productosBloc){

    
    return StreamBuilder(
      stream:  productosBloc.productosStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
       if( snapshot.hasData ){

          final productos = snapshot.data;
          print('Que pedo weee $productos', );

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: ( context, i) => _crearItem( context, productosBloc ,productos[i] )
            );


        }else{

          print('data ${snapshot.hasData}');
          return Center( child: CircularProgressIndicator() );
        }
      }
    );


  }


  

  /*
   Se puede hacer de esta forma si no es necesario estar al tanto en mas lugares por
   la data del provider
   */
  // Widget _crearListado(){

  //   return FutureBuilder(
  //     future: productosProvider.cargarProductos(),
      
  //     builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {

  //       if( snapshot.hasData ){

  //         final productos = snapshot.data;

  //         return ListView.builder(
  //           itemCount: productos.length,
  //           itemBuilder: ( context, i) => _crearItem( context, productos[i] )
  //           );


  //       }else{
  //         return Center( child: CircularProgressIndicator() );
  //       }

  //     },
  //   );

  // }

  Widget _crearItem( BuildContext context, ProductosBloc productosBloc,
  ProductoModel producto ){

    //Este widget hace que el hijo se pueda deslizar para eliminarlo
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: ( direccion ){
         // print('Se va a borrar el producto ${producto.titulo}');
          productosBloc.borrarProducto( producto.id );
        } ,
          child: Card(
            child: Column(
              children: <Widget>[

                ( producto.fotoUrl == null )?
                Image( image: AssetImage('assets/no-image.png'))
                : FadeInImage(
                  placeholder: AssetImage('assets/jar-loading.gif'),
                  image: NetworkImage( producto.fotoUrl ),
                  height: 300.0,
                  width: double.infinity,
                  fit: BoxFit.cover
                  ),

                  ListTile(
        title: Text('${ producto.titulo} - ${ producto.valor }'),
        subtitle: Text( producto.id),
        //De esta forma navegamos con argumentos para poder editar el producto con sus valores
        //Es necesario redibujar el widget para cargar los nuevos cambios desde el endpoint
        //Al hacer un pop retorna la info que nos sirve para mostrar una respuesta 
        onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto)
        .then((value) => _mostrarRespuesta(value))
        
        
      ),
    

              ],
            ),
          )

    );
          
          

          
          

  }

  Widget _crearBoton( BuildContext context ) {

    return FloatingActionButton(
      child: Icon( Icons.add ),
      backgroundColor: Colors.deepPurple,

      //Al hacer un pop retorna la info que nos sirve para mostrar una respuesta
      onPressed: ()=> Navigator.pushNamed(context, 'producto')
      .then((value) => _mostrarRespuesta(value)),
    );

  }


  void _mostrarRespuesta(String valor){

    print('SE CERRO CON EL VALOOOOOOOOOOOOOOOOR $valor');

      if( valor == null ) return;

      switch(valor){
        case 'creo': _mostrarSnackBar('Se guardo correctamente', Colors.green );
        break;
        
        default: print('Que pedo mierdota $valor');
        _mostrarSnackBar('Se actualizo correctamente', Colors.blue );

      }

        setState((){});

  }

  void _mostrarSnackBar(String mensaje, Color color){

    final snackBar = SnackBar(
      content: Text( mensaje ),
      duration: Duration( milliseconds: 1500),
      backgroundColor: color
      );

      scaffoldKey.currentState.showSnackBar( snackBar );

  }
}