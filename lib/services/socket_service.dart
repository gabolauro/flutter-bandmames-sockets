

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier {


  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket; 

  ServerStatus get serverStatus => this._serverStatus; 
  IO.Socket get socket => this._socket;

  SocketService(){

    this._initConfig();

  }
  
  void _initConfig() {

    // Dart client
    this._socket = IO.io('http://192.168.1.133:3000/',
      OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .setExtraHeaders({'foo': 'bar'}) // optional
          .build());


    this._socket.onConnect((_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();

      // socket.emit('msg', 'test');
    });
    // socket.on('event', (data) => print(data));

    this._socket.onDisconnect((_) {
      print('disconnect');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();

    });


    // socket.on('nuevo-mensaje', (data) {
    //   print('nuevo-mensaje: $data');
    //   print('nombre: ${data['nombre']}');
    //   print('mensaje: ${data['mensaje']}');
    // });
  }


}