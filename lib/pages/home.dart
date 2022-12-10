import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';


class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [];

  @override
  void initState() {

    final socketService = Provider.of<SocketService>(context, listen: false);
    _handleActiveBands(socketService);

    super.initState();
  }

  void _handleActiveBands(SocketService socketService) {
    socketService.socket.on('active-bands', (payload) {
        
      this.bands = (payload as List)
        .map((band) => Band.fromMap(band),)
        .toList();
    
      setState(() {
        
      });
    
    });
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

  final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bandas', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online
              ? Icon(Icons.check_circle, color: Colors.blue[300],)
              : Icon(Icons.offline_bolt, color: Colors.red,),
          )
        ],
      ),
      body: Column(
        children: [

          if (bands.isNotEmpty) _showGraph(),

          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, index) => _bandTile(bands[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand 
      ),
   );
  }

  Widget _bandTile(Band band) {

    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) => socketService.socket.emit('remove-band', { 'id': band.id }),
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
            onTap: (() => socketService.socket.emit('vote-band', { 'id': band.id})),
          ),
    );
  }

  addNewBand() {

    final textControler = new TextEditingController();

    // Android
    if ( Platform.isAndroid ) {
      showDialog(
        context: context,
        builder: ((_) => AlertDialog(
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
        )
      )
      );
    } else if ( Platform.isIOS ) {

      showCupertinoDialog(
        context: context,
        builder: ((_) => CupertinoAlertDialog(
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
          )
        )
      );

    }
    

  }

  void addBandToList( String name ) {

    if ( name.isNotEmpty ) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.emit('add-band', { 'name': name });
    }


    Navigator.pop(context);
  }
  
  Widget _showGraph() {

    Map<String, double> dataMap = new Map();

    bands.forEach((band) {
      dataMap.addAll({ band.name : band.votes.toDouble()});
    });

    return Padding(
        padding: const EdgeInsets.all(20),
        child: PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.of(context).size.width / 3.2,
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 32,
        legendOptions: LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          decimalPlaces: 1,
        ),
        // gradientList: ---To add gradient colors---
        // emptyColorGradient: ---Empty Color gradient---
      )
    );

  }

}