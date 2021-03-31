import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/productos_bloc.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/modelos/producto_model.dart';


//Asi apuntamos a las funciones que tenga ese archivo con util
import 'package:formvalidation/src/utils/utils.dart' as util;

//Con esto accedemos al plugin de la camara
import 'package:image_picker/image_picker.dart';

//Cuando trabajamos con formularios y TextFormField
//es necesario tener un StatefulWidget
class ProductoPage extends StatefulWidget {
 

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {

 //De esta forma creamos una referencia para poder apuntar a nuestro formulario
 //desde otras partes de mi widget
  final formKey = GlobalKey<FormState>();

 

  //Este key es necesario para poder mostrar un snackbar dependiendo del widget en
  //el que se necesite
  final scaffoldKey = GlobalKey<ScaffoldState>();

  File fotoSeleccionada;

  //Esta bandera nos sirve para bloquear el boton hasta que termine el proceso
  bool _cargando = false;

  ProductoModel producto = new ProductoModel();

  ProductosBloc _productosBloc;

  @override
  Widget build(BuildContext context) {

     //De esta forma centralizamos el tipo de data que manejamos como los productos y sus metodos

  _productosBloc = Provider.productosBloc(context);

    //De esta forma se puede saber si se navego con argumentos
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    if( prodData != null){
      //Si la navegacion viene con data inicializamos los valores 
      producto = prodData;

      print('Editando ${producto.fotoUrl}');
    }

    
    return Scaffold(
      //Esto es necesario para mostrar el snackbar en el widget necesario
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.photo_size_select_actual),
             onPressed: _seleccionarFoto
             ),
           IconButton(icon: Icon( Icons.camera_alt),
            onPressed: _tomarFoto
            )  
        ],
      ),

      body:SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          //El widget 
          child: Form(
            //De esta forma apuntamos a la propiedad de mi clase 
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton()
              ],
            ),
          ),
        ),
      ) ,


    );
    
  }

  Widget _crearNombre() {
    //Este widget trabaja de forma independiente como un formulario
    return TextFormField(

      //De esta forma si la clase tiene valores por defecto los asignamos al textformField
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration( 
        labelText: 'Producto'
      ),
      
      //De esta forma al pasar las validaciones actualizamos el valor de prpiedad de la clase
      onSaved: (valor) => producto.titulo = valor,
      //Con esta propiedad podemos validar la informacion
      //Si se retorna un string sera el error para mostrar
      //Para pasar la validacion se retorna null
      validator: (valor){

        if( valor.length < 5){
          return 'El nombre debe ser mas largo';
        }else{
         return null;
        }

      },
    );

  }

  Widget _crearPrecio(){

    return TextFormField(
      //Asi agregamos el valor inicializado de la clase
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions( decimal: true ),
      decoration: InputDecoration( 
        labelText: 'Producto'
      ),

      onSaved: (valor) => producto.valor = double.parse( valor ),

      validator: (valor){

        if ( util.isNumeric(valor) ){
          return null;
        }else{
          return 'Solo numeros son validos';
        }

      },
    );

  }

  Widget _crearDisponible(){

    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      //De esta forma al cambiar el switch, se actualiza el valor en pantalla
      onChanged: (valor) => setState( () {
        producto.disponible = valor;
      }),
    );

  }

  Widget _crearBoton(){

    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      label: Text('Guardar'),
      icon: Icon( Icons.save ),
      color:  Colors.deepPurple,
      textColor: Colors.white,
      onPressed: (_cargando ) ? null : _submit,
    );

  }

  void _submit() async{

    //De esta forma accedemos al estado del form key
    if(! formKey.currentState.validate() ) return;
    
    //Con esto guardamos los valores del formulario con las propiedades de la clase
    formKey.currentState.save();

    setState(() {
      //ASi bloqueamos el botn
      _cargando = true;
    });

    if( fotoSeleccionada != null){
    producto.fotoUrl = await _productosBloc.subirFoto( fotoSeleccionada );
    }


    if( producto.id ==null ){
   _productosBloc.agregarProducto(producto);
    //_mostrarSnackBar('Se guardo correctamente', Colors.green );
    Navigator.pop(context, 'creo');
    }else{
    _productosBloc.editarProducto(producto);
    Navigator.pop(context, 'actualizo');
   // _mostrarSnackBar('Se actualizo correctamente', Colors.blue );
    }

    // setState(() {
    //   //ASi bloqueamos el botn
    //   _cargando = false;
    // });

    

  }

  void _mostrarSnackBar(String mensaje, Color color){

    final snackBar = SnackBar(
      content: Text( mensaje ),
      duration: Duration( milliseconds: 1500),
      backgroundColor: color
      );

      scaffoldKey.currentState.showSnackBar( snackBar );

  }


Widget _mostrarFoto(){

//De esta forma prevenimos si se selecciono la imagen y se cancelo el guardar
  if( fotoSeleccionada != null ){
    return Image.file(
      fotoSeleccionada,
      fit: BoxFit.cover,
      height: 300.0,
    );
  }else{

    if( producto.fotoUrl != null ){
       return FadeInImage(
      placeholder: AssetImage('assets/jar-loading.gif'),
      image: NetworkImage(producto.fotoUrl),
      height: 300.0,
      width: double.infinity,
      fit: BoxFit.cover,
      );

    }
    return Image(
      image: AssetImage('assets/no-image.png'),
      height: 300.0,
      fit: BoxFit.cover
     );
  }

}

  void _seleccionarFoto() async{

   _procesarFoto( ImageSource.gallery );

  }

  void _tomarFoto() {

    _procesarFoto( ImageSource.camera );

  }

  void _procesarFoto( ImageSource origen) async{


     final imagen = await ImagePicker().getImage(source: origen );


    if( imagen != null ){
      //Si una imagen fue seleccionada cambia la que tiene cargada
      fotoSeleccionada = File( imagen.path );
      
    }
    setState(() {});
    
    //De esta forma si ya tenia una url de foto, se mostrara la ultima seleccionada
    

  }

}


