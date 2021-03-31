// To parse this JSON data, do
//
//     final productoModel = productoModelFromJson(jsonString);

import 'dart:convert';

//De json a una instancea de la clase
ProductoModel productoModelFromJson(String str) => ProductoModel.fromJson(json.decode(str));

//De una instancea de la clase a json
String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {
  
    ProductoModel({
        this.id,
        this.titulo = '',
        this.valor = 0.0,
        this.disponible = true,
        this.fotoUrl,
    });

    String id;
    String titulo;
    double valor;
    bool disponible;
    String fotoUrl;

    factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
        id: json["id"],
        titulo: json["titulo"],
        valor: json["valor"].toDouble(),
        disponible: json["disponible"],
        fotoUrl: json["fotoUrl"],
    );

    //Al momento de actualizar debemos quitar el id, para que no se duplique la key en firebase
    Map<String, dynamic> toJson() => {
        //"id": id,
        "titulo": titulo,
        "valor": valor,
        "disponible": disponible,
        "fotoUrl": fotoUrl,
    };
}
