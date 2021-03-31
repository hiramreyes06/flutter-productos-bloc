import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/providers/usuario_provider.dart';


class RegistroPage extends StatelessWidget {

   final usuarioProvider = new UsuarioProvider();

   final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      //Es necesario el stack para sobre poner widgets como capas
      body: Stack(
        children: <Widget>[
          _crearFondo( context ),
          _loginForm( context )
        ],
      )
    );
  }

Widget _crearFondo( BuildContext context) {

  final size = MediaQuery.of(context).size;

  final fondoMorado = Container(
    height: size.height * 0.4,
    //De esta forma toma el ancho de toda la pantalla
    width: double.infinity,

    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: <Color>[
          Color.fromRGBO(63, 63, 156, 1.0),
          Color.fromRGBO(90,70, 178, 1.0)
        ]
      )
    ),
  );


  final circulo = Container(
    width: 100.0,
    height: 100.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100.0),
      color: Color.fromRGBO(255, 255, 255, 0.05)
    ),
  );

  return Stack(
    children: <Widget>[
      fondoMorado,
      Positioned( top: 90.0, left: 30.0, child: circulo),
      Positioned( top: 70, left: 90.0, child: circulo),
      Positioned( bottom: -50.0, right: -10.0, child: circulo),
      Positioned( bottom: 120.0, right: 20.0, child: circulo),
      _cabecera()
    
    ]
  );

  }

 Widget _cabecera() {
    return Container(
      //Eso sirve para dar un margin de arriba
      padding: EdgeInsets.only( top: 80.0),
      child: Column(
        children: <Widget>[
          Icon(Icons.person_pin_circle, color: Colors.white , size: 100.0 ),
          //Asi hacemos una separacion
          SizedBox( height: 10.0, width: double.infinity ),
          Text('Bienvenido', style: TextStyle( color: Colors.white, fontSize: 35.0 ) )
        ],
      )
    );
  }

  Widget _loginForm( BuildContext context) {

    //Asi obtenemos la referencia del provider ya creado 
    final bloc= Provider.of(context);

    final size = MediaQuery.of(context).size;




    return SingleChildScrollView(
      child: Column(
        children: <Widget>[

          SafeArea(
            child: Container(
              height: 180.0 ,
            ) 
            ),

          Container(
            width: size.width * 0.85,
            //Asi agregamos una separacion entre el cuadro y la cabecera
            margin: EdgeInsets.symmetric( vertical: 30.0 ),
            //Eso agrega auna separacion de los hijos
            padding: EdgeInsets.symmetric( vertical: 50.0 ),
            decoration: BoxDecoration(
              color: Colors.white,
              //Eso redondea los border del container
              borderRadius: BorderRadius.circular(5.0),
              //ASi agregamos una sobra redondeada al cuadro
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                Text('Registro en la plataforma', style: TextStyle( fontSize: 20.0 ) ),

                SizedBox( height: 40.0),

                _crearEmail( bloc ),

                SizedBox( height: 20.0),

                _crearPassword( bloc ),

                SizedBox( height: 20.0),

                _crearBoton( bloc )
                
              ],
            ),
          ),


          FlatButton(
          onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
          child: Text('Si ya tienes una cuenta, autenticate')
          ),

          SizedBox( height: 100.0 )

        ]
        
        ),
    );

  }

 Widget _crearEmail( LoginBloc bloc ) {

  return StreamBuilder(
    //De esta forma conectamos el stream del bloc con el widget
     stream: bloc.emailStream ,
     
     builder: (BuildContext context, AsyncSnapshot snapshot){
      
       return Container(
     //De esta forma le damos un margen a los lados del input de texto
     padding: EdgeInsets.symmetric( horizontal: 20.0),

     child: TextField(
       keyboardType:  TextInputType.emailAddress,
       decoration: InputDecoration(
         icon: Icon( Icons.alternate_email, color: Colors.deepPurple ),
         labelText: 'Correo electronico',
         hintText: 'Ejemplo@correo.com',

         //Esta propiedad hace que se vea a un lado el texto nuevo 
         counterText: snapshot.data,
         errorText: snapshot.error
       ),
       //Asi emitimos el valor del cambio por el stream del bloc
       onChanged: bloc.changeEmail,
     ),
   );

     },
   );


 }


 Widget _crearPassword( LoginBloc bloc) {

   return StreamBuilder(
     stream: bloc.passwordStream ,
     builder: (BuildContext context, AsyncSnapshot snapshot){
      return Container(
     //De esta forma le damos un margen a los lados del input de texto
     padding: EdgeInsets.symmetric( horizontal: 20.0),

     child: TextField(
       obscureText: true,
       keyboardType:  TextInputType.text,
       decoration: InputDecoration(
         icon: Icon( Icons.lock_outline, color: Colors.deepPurple ),
         labelText: 'Contraseña',
         hintText: '**********',
         counterText: snapshot.data,
         errorText: snapshot.error     
       ),
       onChanged: bloc.changePassword,
     ),
   );

     },
   );

   

 }

  Widget _crearBoton( LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.formValidStream ,
     
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return RaisedButton(
      child: Container( 
        //Con esto modificamos el tamaño del boton en base a los bordes
        padding: EdgeInsets.symmetric( horizontal: 80.0 , vertical: 15.0),
        child: Text('Ingresar'),
      ),
      shape: RoundedRectangleBorder( 
        borderRadius: BorderRadius.circular( 5.0 )
      ),
      //Con esto ajustamos los bordes de la sombra para removerlo
      elevation: 0.0,
      color: Colors.deepPurple,
      textColor: Colors.white,
      //De esta forma validamos con el stream del rx snapshot.hasData ? () => _login( context , bloc ) : null
      onPressed: () => _register(context, bloc) ,
    );

      }
    );

  }

  _register( BuildContext context, LoginBloc bloc ) async{
    print('=========');
    print('EL correo es: ${ bloc.emailValue }');
    print('EL correo es: ${ bloc.passwordValue }');

    final resp = await usuarioProvider.nuevoUsuaro(bloc.emailValue, bloc.passwordValue);

    if( resp['ok'] ){
      Navigator.pushReplacementNamed(context, 'login');
    }else{

      _mostrarSnackBar(resp['mensaje'], Colors.red);
    }

    //usuarioProvider.iniciarSesion( 3310728145 , '12345' );

  //Navigator.pushReplacementNamed(context, 'home');
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