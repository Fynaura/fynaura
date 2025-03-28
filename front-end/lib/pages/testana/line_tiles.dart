import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineTitles {
  static FlTitlesData getTitleData() => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            getTitlesWidget: (value, meta) {
              switch (value.toInt()) {
                case 0:
                  return Text(
                    'JAN',
                    style: TextStyle(
                      color: Color(0xff68737d),
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                    ),
                  );
                case 1:
                  return Text(
                    'FEB',
                    style: TextStyle(
                      color: Color(0xff68737d),
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                    ),
                  );
                case 2:
                  return Text(
                    'MAR',
                    style: TextStyle(
                      color: Color(0xff68737d),
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                    ),
                  );
                case 3:
                  return Text(
                    'APR',
                    style: TextStyle(
                      color: Color(0xff68737d),
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                    ),
                  );
                case 4:
                  return Text(
                    'MAY',
                    style: TextStyle(
                      color: Color(0xff68737d),
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                    ),
                  );
                case 5:
                  return Text(
                    'JUN',
                    style: TextStyle(
                      color: Color(0xff68737d),
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                    ),
                  );
                case 6:
                  return Text(
                    'JUL',
                    style: TextStyle(
                      color: Color(0xff68737d),
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                    ),
                  );
                case 7:
                  return Text(
                    'AUG',
                    style: TextStyle(
                      color: Color(0xff68737d),
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                    ),
                  );
                case 8:
                  return Text(
                    'SEP',
                    style: TextStyle(
                      color: Color(0xff68737d),
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                    ),
                  );
                case 9:
                  return Text(
                    'OCT',
                    style: TextStyle(
                      color: Color(0xff68737d),
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                    ),
                  );
                case 10:
                  return Text(
                    'NOV',
                    style: TextStyle(
                      color: Color(0xff68737d),
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                    ),
                  );
                case 11:
                  return Text(
                    'DEC',
                    style: TextStyle(
                      color: Color(0xff68737d),
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                    ),
                  );
                default:
                  return Text('');
              }
            },
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            getTitlesWidget: (value, meta) {
              switch (value.toInt()) {
                case 1:
                  return Text(
                    '10k',
                    style: TextStyle(
                      color: Color(0xff67727d),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  );
                case 3:
                  return Text(
                    '30k',
                    style: TextStyle(
                      color: Color(0xff67727d),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  );
                case 5:
                  return Text(
                    '50k',
                    style: TextStyle(
                      color: Color(0xff67727d),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  );
                default:
                  return Text('');
              }
            },
            interval: 1,
          ),
        ),
      );
}