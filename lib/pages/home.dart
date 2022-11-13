import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(id: '1', name: 'Metalica', votes: 5),
    Band(id: '2', name: 'Queen', votes: 1),
    Band(id: '3', name: 'Heroes del Silencio', votes: 2),
    Band(id: '4', name: 'Bon Jovi', votes: 5),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bandas', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        elevation: 1
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) => _bandTile(bands[index]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand 
      ),
   );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print(direction);
        print(band.id);
        // Call delete method
      },
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete band', style: TextStyle( color: Colors.white ),)
        ),
      ),
      child: ListTile(
            leading: CircleAvatar(
              child: Text( band.name.toUpperCase().substring(0,2) ),
              backgroundColor: Colors.blue[100],
            ),
            title: Text(band.name),
            trailing: Text('${ band.votes }', style: TextStyle( fontSize: 20 ),),
            onTap: (() {
              print(band.name);
            }),
          ),
    );
  }

  addNewBand() {

    final textControler = new TextEditingController();

    // Android
    if ( Platform.isAndroid ) {
      showDialog(
        context: context,
        builder: ((context) {
        return AlertDialog(
          title: Text('New band name'),
          content: TextField(
            controller: textControler,
          ),
          actions: [
            MaterialButton(
              child: Text('Add'),
              elevation: 5,
              textColor: Colors.blue,
              onPressed: (() => addBandToList( textControler.text )
              ))
          ],
        ); 
        }
      )
      );
    } else if ( Platform.isIOS ) {

      showCupertinoDialog(
        context: context,
        builder: ((context) {
          return CupertinoAlertDialog(
            title: Text('New band name'),
            content: CupertinoTextField(
              controller: textControler,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Add'),
                onPressed: () => addBandToList(textControler.text),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('Dismiss'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        })
      );

    }
    

  }

  void addBandToList( String name ) {

    if ( name.isNotEmpty ) {
      this.bands.add( new Band(id: DateTime.now().toString(), name: name, votes: 0) );
      setState(() {
        
      });
    }


    Navigator.pop(context);
  }

}