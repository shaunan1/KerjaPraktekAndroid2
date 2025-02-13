import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timelines_plus/timelines_plus.dart';

class TimelinePelayananWidget extends StatelessWidget {
  final Map<String, dynamic> dataPelayanan;

  const TimelinePelayananWidget(
      {super.key, required this.dataPelayanan});

  @override
  Widget build(BuildContext context) {
    return Timeline.tileBuilder(
      theme: TimelineThemeData(
        nodePosition: 0,
        connectorTheme: ConnectorThemeData(
          thickness: 3.0,
          color: Color(0xffd3d3d3),
        ),
        indicatorTheme: IndicatorThemeData(
          size: 15.0,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 20.0),
      builder: TimelineTileBuilder.connected(
          contentsBuilder: (context, index) => Material(
                elevation: 0.1,
                borderRadius: BorderRadius.circular(10),
                child: ListTile(
                  title: Text(dataPelayanan['history'][index]['st']['name']),
                  subtitle: Text(DateFormat('dd MMM yyyy HH:mm')
                      .format(DateTime.parse(
                          dataPelayanan['history'][index]['created_at']).toLocal())
                      .toString()),
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
          connectorBuilder: (context, index, type) {
            if (index == (dataPelayanan['history'].length - 2)) {
              return SolidLineConnector(color: Color(0xff6ad192));
            } else {
              return SolidLineConnector();
            }
          },
          indicatorBuilder: (_, index) {
            switch (dataPelayanan['history'][index]['st']['name']) {
              case 'Disetujui':
                return DotIndicator(
                  color: Color(0xff6ad192),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 10.0,
                  ),
                );
              case 'Dinaikan':
                return OutlinedDotIndicator(
                  color: Color(0xffa7842a),
                  borderWidth: 2.0,
                  backgroundColor: Color(0xffebcb62),
                );
              case 'Pengajuan':
              default:
                return OutlinedDotIndicator(
                  color: Color(0xffbabdc0),
                  backgroundColor: Color(0xffe6e7e9),
                );
            }
          },
          itemExtentBuilder: (_, __) => 100,
          itemCount: dataPelayanan['history'].length),
    );
  }
}
