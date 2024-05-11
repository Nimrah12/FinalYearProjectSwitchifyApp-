import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_database/firebase_database.dart';

int aab = 0;

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  // final DatabaseReference _databaseReference =
  //     FirebaseDatabase.instance.ref().child('firebasedatabase');

  // //final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  late TooltipBehavior _tooltipBehavior;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late Future<int> d0time;
  late Future<int> d1time;
  late Future<int> d2time;
  late Future<int> d4time;
  late Future<int> d5time;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
    d0time = fetchTime('D0');
    d1time = fetchTime('D1');
    d2time = fetchTime('D2');
    d4time = fetchTime('D4');
    d5time = fetchTime('D5');
  }

  Future<int> fetchTime(String device) async {
    DatabaseReference td0 =
        FirebaseDatabase.instance.ref().child(device).child('time');
    DatabaseEvent dataSnapshot = await td0.once();
    int td0data = int.parse(dataSnapshot.snapshot.value.toString());
    print(td0data);
    return td0data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
          title: const Text(
            "Grpah Analysis for buttons",
            style: TextStyle(
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 0, 0, 0)),
      backgroundColor:
          const Color.fromARGB(255, 32, 22, 22), // Set background color here

      body: Center(
        child: FutureBuilder<int>(
          future: d0time,
          builder: (context, d0Snapshot) {
            if (d0Snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (d0Snapshot.hasError) {
              return Center(child: Text('Error: ${d0Snapshot.error}' 'min'));
            } else {
              return FutureBuilder<int>(
                future: d1time,
                builder: (context, d1Snapshot) {
                  if (d1Snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (d1Snapshot.hasError) {
                    return Center(
                        child: Text('Error: ${d1Snapshot.error}' 'min'));
                  } else {
                    return FutureBuilder<int>(
                      future: d2time,
                      builder: (context, d2Snapshot) {
                        if (d2Snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (d2Snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${d2Snapshot.error}' 'min'));
                        } else {
                          return FutureBuilder<int>(
                            future: d4time,
                            builder: (context, d4Snapshot) {
                              if (d4Snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (d4Snapshot.hasError) {
                                return Center(
                                    child: Text(
                                        'Error: ${d4Snapshot.error}' 'min'));
                              } else {
                                return FutureBuilder<int>(
                                  future: d5time,
                                  builder: (context, d5Snapshot) {
                                    if (d5Snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (d5Snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${d5Snapshot.error}'
                                                  'min'));
                                    } else {
                                      return Center(
                                        child: Container(
                                          child: SfCartesianChart(
                                            primaryXAxis: CategoryAxis(),
                                            // Chart title
                                            title: ChartTitle(
                                              text:
                                                  '------Total time of the button ON status------',
                                              textStyle: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),

                                            // Enable legend
                                            legend: Legend(isVisible: true),
                                            // Enable tooltip
                                            tooltipBehavior: _tooltipBehavior,
                                            plotAreaBackgroundColor:
                                                Color.fromARGB(255, 0, 0, 0),

                                            series: <BarSeries<SalesData,
                                                String>>[
                                              BarSeries<SalesData, String>(
                                                dataSource: <SalesData>[
                                                  SalesData(
                                                      'D0', d0Snapshot.data!),
                                                  SalesData(
                                                      'D1', d1Snapshot.data!),
                                                  SalesData(
                                                      'D2', d2Snapshot.data!),
                                                  SalesData(
                                                      'D4', d4Snapshot.data!),
                                                  SalesData(
                                                      'D5', d5Snapshot.data!),
                                                ],
                                                xValueMapper:
                                                    (SalesData sales, _) =>
                                                        sales.year,
                                                yValueMapper:
                                                    (SalesData sales, _) =>
                                                        sales.sales,
                                                // Enable data label
                                                dataLabelSettings:
                                                    DataLabelSettings(
                                                        isVisible: true),
                                                color: Color.fromARGB(
                                                    116, 74, 48, 4),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.black,
                                                    Colors.black,
                                                    Colors.yellow,
                                                    Colors.yellow,
                                                    Colors.black,
                                                    Colors.black,
                                                  ], // Set your gradient colors
                                                  begin: Alignment
                                                      .topCenter, // Adjust the gradient begin point
                                                  end: Alignment
                                                      .bottomCenter, // Adjust the gradient end point
                                                ), // You can set any color here
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                );
                              }
                            },
                          );
                        }
                      },
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class SalesData {
  final String year;
  final int sales;

  SalesData(this.year, this.sales);
}
