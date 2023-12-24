import 'package:flutter/material.dart';
import 'package:tree_tracer/screens/view_species.dart';

import '../models/tracer_model.dart';
import '../services/database_helper.dart';

class ExtendInfo extends StatefulWidget {
  final int tracerId;
  final String category; // What category of TREE, ROOT, ETC.
  final String userType; //What type of User

    const ExtendInfo(
      {required this.tracerId,
      required this.category,
      required this.userType}
    ); 

  @override
  State<ExtendInfo> createState() => _ExtendInfoState();
}

  class _ExtendInfoState extends State<ExtendInfo> {
    TracerModel? tracerData;
    TracerDatabaseHelper dbHelper = TracerDatabaseHelper.instance;

    @override
    void initState() {
      super.initState();
      dbHelper = TracerDatabaseHelper.instance;
      fetchData();
    }
      
    _backtoViewSpecies() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ViewSpecies(tracerId: widget.tracerId, category: widget.category, userType: widget.userType)));
    }

    Future<void> fetchData() async {
      int tracerId = widget.tracerId;
      TracerModel? mangroveResultData = await dbHelper.getOneTracerData(tracerId);

      setState(() {
        tracerData = mangroveResultData;
      });
    }


  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              _backtoViewSpecies();
            }, 
            icon: const Icon(Icons.arrow_back)
          ),
        ),
        body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                Container(
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20.0),
                          const Text('Description', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(tracerData?.description ?? 'No Description'),
                          const SizedBox(height: 10.0),
                          Text(
                            tracerData?.benifits != '' ? 'Benifits' : '',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text: tracerData?.benifits ?? 'No Benifits'
                                )
                              ]
                            )
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            tracerData?.uses != '' ? 'Uses' : '',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: tracerData?.uses ?? 'No Uses'
                                )
                              ]
                            )
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}