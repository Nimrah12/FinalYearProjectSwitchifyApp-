import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:firebase_database/firebase_database.dart';

class Pointer extends StatefulWidget {
  const Pointer({super.key});

  @override
  State<Pointer> createState() => _PointerState();
}

class _PointerState extends State<Pointer> {
  late Future<double> d0time;
  late Future<double> d1time;
  late Future<double> d2time;
  late Future<double> d4time;
  late Future<double> d5time;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    d0time = fetchTime('D0');
    d1time = fetchTime('D1');
    d2time = fetchTime('D2');
    d4time = fetchTime('D4');
    d5time = fetchTime('D5');
  }

  Future<double> fetchTime(String device) async {
    DatabaseReference td0 =
        FirebaseDatabase.instance.ref().child(device).child('time');
    DatabaseEvent dataSnapshot = await td0.once();
    double td0data = double.parse(dataSnapshot.snapshot.value.toString());
    td0data = td0data / 60;
    print(td0data);
    return td0data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: const Text(
            "Switch Analysis",
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
        child: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          // Set background color
                          child: FutureBuilder<double>(
                            future: d0time,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Column(children: [
                                  const Text(
                                    '----------Analytics for all the buttons----------',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 241, 239, 234),
                                    ),
                                  ),
                                  Text(
                                    'D0 Analysis',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 232, 205, 141),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  SfRadialGauge(
                                    axes: <RadialAxis>[
                                      RadialAxis(
                                        minimum: 0,
                                        maximum: 24,
                                        ranges: <GaugeRange>[
                                          GaugeRange(
                                            startValue: 0,
                                            endValue: 8,
                                            gradient: SweepGradient(
                                              colors: [
                                                Colors.green,
                                                Colors.yellow
                                              ],
                                              stops: [0.0, 0.5],
                                            ),
                                            startWidth: 10.0,
                                            endWidth: 15.0,
                                          ),
                                          GaugeRange(
                                            startValue: 8,
                                            endValue: 16,
                                            gradient: SweepGradient(
                                              colors: [
                                                Colors.yellow,
                                                Colors.orange
                                              ],
                                              stops: [0.0, 0.5],
                                            ),
                                            startWidth: 15.0,
                                            endWidth: 20.0,
                                          ),
                                          GaugeRange(
                                            startValue: 16,
                                            endValue: 24,
                                            gradient: SweepGradient(
                                              colors: [
                                                Colors.orange,
                                                Colors.red
                                              ],
                                              stops: [0.0, 0.5],
                                            ),
                                            startWidth: 20.0,
                                            endWidth: 25.0,
                                          ),
                                        ],
                                        pointers: <GaugePointer>[
                                          MarkerPointer(
                                            value: snapshot.data!.toDouble(),
                                            color: Colors.yellow,
                                            borderWidth: 20.0,
                                            markerType:
                                                MarkerType.invertedTriangle,
                                            markerWidth: 20.0,
                                            markerHeight: 20.0,
                                            markerOffset: -20.0,
                                          ),
                                        ],
                                        annotations: <GaugeAnnotation>[
                                          GaugeAnnotation(
                                            widget: Container(
                                              child: Text(
                                                '${snapshot.data!.toStringAsFixed(2)}/24',
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 239, 218, 167),
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            angle: 90,
                                            positionFactor: 0.5,
                                          ),
                                        ],
                                        axisLineStyle: AxisLineStyle(
                                            thickness: 30.0,
                                            color: Colors.transparent),
                                        axisLabelStyle:
                                            GaugeTextStyle(color: Colors.white),
                                      ),
                                    ],
                                  )
                                ]);
                              }
                            },
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          child: FutureBuilder<double>(
                            future: d1time,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Column(children: [
                                  const Text(
                                    'D1 Analysis',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 232, 205, 141),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  SfRadialGauge(
                                    axes: <RadialAxis>[
                                      RadialAxis(
                                        minimum: 0,
                                        maximum: 24,
                                        ranges: <GaugeRange>[
                                          GaugeRange(
                                            startValue: 0,
                                            endValue: 8,
                                            gradient: const SweepGradient(
                                              colors: [
                                                Colors.green,
                                                Colors.yellow
                                              ],
                                              stops: [0.0, 0.5],
                                            ),
                                            startWidth: 10.0,
                                            endWidth: 15.0,
                                          ),
                                          GaugeRange(
                                            startValue: 8,
                                            endValue: 16,
                                            gradient: const SweepGradient(
                                              colors: [
                                                Colors.yellow,
                                                Colors.orange
                                              ],
                                              stops: [0.0, 0.5],
                                            ),
                                            startWidth: 15.0,
                                            endWidth: 20.0,
                                          ),
                                          GaugeRange(
                                            startValue: 16,
                                            endValue: 24,
                                            gradient: const SweepGradient(
                                              colors: [
                                                Colors.orange,
                                                Colors.red
                                              ],
                                              stops: [0.0, 0.5],
                                            ),
                                            startWidth: 20.0,
                                            endWidth: 25.0,
                                          ),
                                        ],
                                        pointers: <GaugePointer>[
                                          MarkerPointer(
                                            value: snapshot.data!.toDouble(),
                                            color: Colors.yellow,
                                            borderWidth: 20.0,
                                            markerType:
                                                MarkerType.invertedTriangle,
                                            markerWidth: 20.0,
                                            markerHeight: 20.0,
                                            markerOffset: -20.0,
                                          ),
                                        ],
                                        annotations: <GaugeAnnotation>[
                                          GaugeAnnotation(
                                            widget: Container(
                                              child: Text(
                                                '${snapshot.data!.toStringAsFixed(2)}/24',
                                                style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 233, 206, 142),
                                                ),
                                              ),
                                            ),
                                            angle: 90,
                                            positionFactor: 0.5,
                                          ),
                                        ],
                                        axisLineStyle: AxisLineStyle(
                                            thickness: 30.0,
                                            color: Colors.transparent),
                                        axisLabelStyle:
                                            GaugeTextStyle(color: Colors.white),
                                      )
                                    ],
                                  )
                                ]);
                              }
                            },
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FutureBuilder<double>(
                        future: d2time,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Column(children: [
                              Text(
                                'D2 Analysis',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 232, 205, 141),
                                ),
                              ),
                              SizedBox(height: 10),
                              SfRadialGauge(
                                axes: <RadialAxis>[
                                  RadialAxis(
                                    minimum: 0,
                                    maximum: 24,
                                    ranges: <GaugeRange>[
                                      GaugeRange(
                                        startValue: 0,
                                        endValue: 8,
                                        gradient: SweepGradient(
                                          colors: [Colors.green, Colors.yellow],
                                          stops: [0.0, 0.5],
                                        ),
                                        startWidth: 10.0,
                                        endWidth: 15.0,
                                      ),
                                      GaugeRange(
                                        startValue: 8,
                                        endValue: 16,
                                        gradient: SweepGradient(
                                          colors: [
                                            Colors.yellow,
                                            Colors.orange
                                          ],
                                          stops: [0.0, 0.5],
                                        ),
                                        startWidth: 15.0,
                                        endWidth: 20.0,
                                      ),
                                      GaugeRange(
                                        startValue: 16,
                                        endValue: 24,
                                        gradient: SweepGradient(
                                          colors: [Colors.orange, Colors.red],
                                          stops: [0.0, 0.5],
                                        ),
                                        startWidth: 20.0,
                                        endWidth: 25.0,
                                      ),
                                    ],
                                    pointers: <GaugePointer>[
                                      MarkerPointer(
                                        value: snapshot.data!.toDouble(),
                                        color: Colors.yellow,
                                        borderWidth: 20.0,
                                        markerType: MarkerType.invertedTriangle,
                                        markerWidth: 20.0,
                                        markerHeight: 20.0,
                                        markerOffset: -20.0,
                                      ),
                                    ],
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(
                                        widget: Container(
                                          child: Text(
                                            '${snapshot.data!.toStringAsFixed(2)}/24',
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 233, 206, 142)),
                                          ),
                                        ),
                                        angle: 90,
                                        positionFactor: 0.5,
                                      ),
                                    ],
                                    axisLineStyle: AxisLineStyle(
                                        thickness: 30.0,
                                        color: Colors.transparent),
                                    axisLabelStyle:
                                        GaugeTextStyle(color: Colors.white),
                                  )
                                ],
                              )
                            ]);
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FutureBuilder<double>(
                        future: d4time,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Column(children: [
                              Text(
                                'D4 Analysis',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 232, 205, 141),
                                ),
                              ),
                              SizedBox(height: 10),
                              SfRadialGauge(
                                axes: <RadialAxis>[
                                  RadialAxis(
                                    minimum: 0,
                                    maximum: 24,
                                    ranges: <GaugeRange>[
                                      GaugeRange(
                                        startValue: 0,
                                        endValue: 8,
                                        gradient: SweepGradient(
                                          colors: [Colors.green, Colors.yellow],
                                          stops: [0.0, 0.5],
                                        ),
                                        startWidth: 10.0,
                                        endWidth: 15.0,
                                      ),
                                      GaugeRange(
                                        startValue: 8,
                                        endValue: 16,
                                        gradient: SweepGradient(
                                          colors: [
                                            Colors.yellow,
                                            Colors.orange
                                          ],
                                          stops: [0.0, 0.5],
                                        ),
                                        startWidth: 15.0,
                                        endWidth: 20.0,
                                      ),
                                      GaugeRange(
                                        startValue: 16,
                                        endValue: 24,
                                        gradient: SweepGradient(
                                          colors: [Colors.orange, Colors.red],
                                          stops: [0.0, 0.5],
                                        ),
                                        startWidth: 20.0,
                                        endWidth: 25.0,
                                      ),
                                    ],
                                    pointers: <GaugePointer>[
                                      MarkerPointer(
                                        value: snapshot.data!.toDouble(),
                                        color: Colors.yellow,
                                        borderWidth: 20.0,
                                        markerType: MarkerType.invertedTriangle,
                                        markerWidth: 20.0,
                                        markerHeight: 20.0,
                                        markerOffset: -20.0,
                                      ),
                                    ],
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(
                                        widget: Container(
                                          child: Text(
                                            '${snapshot.data!.toStringAsFixed(2)}/24',
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 233, 206, 142)),
                                          ),
                                        ),
                                        angle: 90,
                                        positionFactor: 0.5,
                                      ),
                                    ],
                                    axisLineStyle: AxisLineStyle(
                                        thickness: 30.0,
                                        color: Colors.transparent),
                                    axisLabelStyle:
                                        GaugeTextStyle(color: Colors.white),
                                  )
                                ],
                              )
                            ]);
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FutureBuilder<double>(
                        future: d5time,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Column(children: [
                              Text(
                                'D5 Analysis',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 232, 205, 141),
                                ),
                              ),
                              SizedBox(height: 10),
                              SfRadialGauge(
                                axes: <RadialAxis>[
                                  RadialAxis(
                                    minimum: 0,
                                    maximum: 24,
                                    ranges: <GaugeRange>[
                                      GaugeRange(
                                        startValue: 0,
                                        endValue: 8,
                                        gradient: SweepGradient(
                                          colors: [Colors.green, Colors.yellow],
                                          stops: [0.0, 0.5],
                                        ),
                                        startWidth: 10.0,
                                        endWidth: 15.0,
                                      ),
                                      GaugeRange(
                                        startValue: 8,
                                        endValue: 16,
                                        gradient: SweepGradient(
                                          colors: [
                                            Colors.yellow,
                                            Colors.orange
                                          ],
                                          stops: [0.0, 0.5],
                                        ),
                                        startWidth: 15.0,
                                        endWidth: 20.0,
                                      ),
                                      GaugeRange(
                                        startValue: 16,
                                        endValue: 24,
                                        gradient: SweepGradient(
                                          colors: [Colors.orange, Colors.red],
                                          stops: [0.0, 0.5],
                                        ),
                                        startWidth: 20.0,
                                        endWidth: 25.0,
                                      ),
                                    ],
                                    pointers: <GaugePointer>[
                                      MarkerPointer(
                                        value: snapshot.data!.toDouble(),
                                        color: Colors.yellow,
                                        borderWidth: 20.0,
                                        markerType: MarkerType.invertedTriangle,
                                        markerWidth: 20.0,
                                        markerHeight: 20.0,
                                        markerOffset: -20.0,
                                      ),
                                    ],
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(
                                        widget: Container(
                                          child: Text(
                                            '${snapshot.data!.toStringAsFixed(2)}/24',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 233, 206, 142),
                                            ),
                                          ),
                                        ),
                                        angle: 90,
                                        positionFactor: 0.5,
                                      ),
                                    ],
                                    axisLineStyle: AxisLineStyle(
                                        thickness: 30.0,
                                        color: Colors.transparent),
                                    axisLabelStyle:
                                        GaugeTextStyle(color: Colors.white),
                                  )
                                ],
                              )
                            ]);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
