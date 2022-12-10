import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class StatusPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);
    // socketService.socket.emit(event)

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Server status: ${ socketService.serverStatus }')
          ],
        ),
     ),
     floatingActionButton:  FloatingActionButton(
      child: Icon(Icons.message),
      onPressed: (() {
        var payload = { 'nombre': 'Flutter', 'mensaje' : 'Hola desde Flutter'};
        // print(payload);
        socketService.socket.emit('emitir-mensaje', payload);
        
      })
      ),
   );
  }
}